//
//  LCYAllImagesForGalleryViewController.m
//  ArtSearching
//
//  Created by eagle on 14-5-22.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYAllImagesForGalleryViewController.h"
#import "GetArtworkListByGallryIdWorkList.h"
#import "GetArtworkListByGallryIdBase.h"
#import "LCYCommon.h"
#import "LCYXMLDictionaryParser.h"
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import "LCYMyCollectionCell.h"
#import "LCYImageDownloadOperation.h"
#import "MJRefresh.h"
#import "ArtDetailViewController.h"

#define LIMIT_PER_PAGE @"10"

@interface LCYAllImagesForGalleryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,LCYXMLDictionaryParserDelegate,CHTCollectionViewDelegateWaterfallLayout,LCYImageDownloadOperationDelegate,MJRefreshBaseViewDelegate>
{
    NSInteger pageIndex;
    BOOL isDataLoading;
    BOOL isNibRegistered;
}
@property (weak, nonatomic) IBOutlet UICollectionView *icyCollectionView;
/**
 *  首次加载解析器
 */
@property (strong, nonatomic) LCYXMLDictionaryParser *firstLoadParser;
@property (strong, nonatomic) LCYXMLDictionaryParser *pullDownParser;
@property (strong, nonatomic) LCYXMLDictionaryParser *pushUpParser;

@property (strong, nonatomic) NSArray *workListArray;
@property (strong, nonatomic) NSMutableArray *downloadListArray;

@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) LCYImageDownloadOperation *myOperation;

@property (strong, nonatomic) MJRefreshHeaderView *headerView;
@property (strong, nonatomic) MJRefreshFooterView *footerView;

@end

@implementation LCYAllImagesForGalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    pageIndex = 0;
    isDataLoading = NO;
    isNibRegistered = NO;
    
    // 设置返回按键
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToParent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    // 添加下拉和上拉
    self.headerView = [[MJRefreshHeaderView alloc] init];
    self.headerView.delegate = self;
    self.headerView.scrollView = self.icyCollectionView;
    self.footerView = [[MJRefreshFooterView alloc] init];
    self.footerView.delegate = self;
    self.footerView.scrollView = self.icyCollectionView;
    
    [self loadRemoteData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [_headerView free];
    [_footerView free];
}

#pragma mark - Actions
- (void)backToParent{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loadRemoteData{
    if ([LCYCommon networkAvailable]) {
        [LCYCommon showHUDTo:self.view withTips:nil];
        NSDictionary *parameter = @{@"id": self.galleryID,
                                    @"pageidx":[NSString stringWithFormat:@"%ld",(long)pageIndex],
                                    @"limit": LIMIT_PER_PAGE};
        self.firstLoadParser = [[LCYXMLDictionaryParser alloc] init];
        self.firstLoadParser.delegate = self;
        isDataLoading = YES;
        [LCYCommon postRequestWithAPI:GetArtworkListByGallryId parameters:parameter successDelegate:self.firstLoadParser failedBlock:^{
            [LCYCommon hideHUDFrom:self.view];
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"网络连接错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [errorAlert show];
        }];
    } else {
        UIAlertView *networkUnabailableAlert = [[UIAlertView alloc] initWithTitle:@"无法找到网络" message:@"请检查您的网络连接状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [networkUnabailableAlert show];
    }
}

#pragma mark - 远程数据解析完毕
- (void)parser:(LCYXMLDictionaryParser *)parser didFinishGetXMLInfo:(NSDictionary *)info{
    if (parser == self.firstLoadParser) {
        GetArtworkListByGallryIdBase *baseInfo = [GetArtworkListByGallryIdBase modelObjectWithDictionary:info];
        self.workListArray = [NSArray arrayWithArray:baseInfo.workList];
        pageIndex++;
        isDataLoading = NO;
        [self.icyCollectionView reloadData];
        [LCYCommon hideHUDFrom:self.view];
    }else if (parser == self.pullDownParser) {
        GetArtworkListByGallryIdBase *baseInfo = [GetArtworkListByGallryIdBase modelObjectWithDictionary:info];
        self.workListArray = [NSArray arrayWithArray:baseInfo.workList];
        pageIndex++;
        isDataLoading = NO;
        [self.icyCollectionView reloadData];
        [self.headerView endRefreshing];
    } else if (parser == self.pushUpParser) {
        GetArtworkListByGallryIdBase *baseInfo = [GetArtworkListByGallryIdBase modelObjectWithDictionary:info];
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.workListArray];
        [tempArray addObjectsFromArray:baseInfo.workList];
        self.workListArray = [NSArray arrayWithArray:tempArray];
        pageIndex++;
        isDataLoading = NO;
        [self.icyCollectionView reloadData];
        [self.footerView endRefreshing];
        if (baseInfo.workList.count == 0) {
            UIAlertView *noMoreDataAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"没有更多数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [noMoreDataAlert show];
        }
    }
}

#pragma mark - UICollection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (!self.workListArray) {
        return 0;
    } else {
        return [self.workListArray count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"LCYMyCollectionCellIdentifier";
    if (!isNibRegistered) {
        UINib *nib = [UINib nibWithNibName:@"LCYMyCollectionCell" bundle:nil];
        [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
        isNibRegistered = YES;
    }
    LCYMyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    GetArtworkListByGallryIdWorkList *info = [self.workListArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = info.workTitle;
    cell.artistNameLabel.text = info.artistName;
    cell.viewerCountLabel.text = [NSString stringWithFormat:@"%.f",info.beScanTime];
    
    NSString *imageURL = [info.imageUrlS stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    if ([LCYCommon isFileExistsAt:[[LCYCommon renrenMainImagePath] stringByAppendingPathComponent:imageURL]]) {
        cell.icyImageView.image = [UIImage imageWithContentsOfFile:[[LCYCommon renrenMainImagePath] stringByAppendingPathComponent:imageURL]];
    } else {
        cell.icyImageView.image = [UIImage imageNamed:@"placehold_image.png"];
        if (!self.downloadListArray) {
            self.downloadListArray = [NSMutableArray array];
        }
        BOOL hasDownloaded = NO;
        for (NSString *oneString in self.downloadListArray) {
            if ([oneString isEqualToString:imageURL]) {
                hasDownloaded = YES;
                break;
            }
        }
        if (!hasDownloaded) {
            // 开启下载线程
            [self.downloadListArray addObject:imageURL];
            if (!self.queue) {
                self.queue = [[NSOperationQueue alloc] init];
            }
            if (!self.myOperation) {
                self.myOperation = [[LCYImageDownloadOperation alloc] init];
                self.myOperation.delegate = self;
                [self.myOperation initConfigure];
                [self.queue addOperation:self.myOperation];
            }
            if (self.myOperation.isCancelled) {
                self.myOperation = [[LCYImageDownloadOperation alloc] init];
                self.myOperation.delegate = self;
                [self.queue addOperation:self.myOperation];
            }
            [self.myOperation addImageName:imageURL];
        }
    }
    [cell checkOff];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GetArtworkListByGallryIdWorkList *info = [self.workListArray objectAtIndex:indexPath.row];
    NSString *workID = [NSString stringWithFormat:@"%.f",info.workId];
    ArtDetailViewController *artDetailViewController = [[ArtDetailViewController alloc] initWithWorkID:workID andWorkUrl:info.imageUrl withBundleName:@"ArtDetailViewController"];
    [self.navigationController pushViewController:artDetailViewController animated:YES];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    GetArtworkListByGallryIdWorkList *artWork = [self.workListArray objectAtIndex:indexPath.row];
    return CGSizeMake(163.0, 163.0/artWork.ratio+37);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - MJRefreshBase
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (self.headerView == refreshView) {
        LCYLOG(@"下拉刷新");
        [self pullDownToRefresh];
    } else {
        LCYLOG(@"上拉刷新");
        [self pushUpToLoadMore];
    }
}
- (void)pushUpToLoadMore{
    if (!isDataLoading) {
        if ([LCYCommon networkAvailable]) {
            NSDictionary *parameter = @{@"id": self.galleryID,
                                        @"pageidx":[NSString stringWithFormat:@"%ld",(long)pageIndex],
                                        @"limit": LIMIT_PER_PAGE};
            isDataLoading = YES;
            self.pushUpParser = [[LCYXMLDictionaryParser alloc] init];
            self.pushUpParser.delegate = self;
            [LCYCommon postRequestWithAPI:GetArtworkListByGallryId parameters:parameter successDelegate:self.pushUpParser failedBlock:nil];
        } else {
            UIAlertView *networkUnabailableAlert = [[UIAlertView alloc] initWithTitle:@"无法找到网络" message:@"请检查您的网络连接状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [networkUnabailableAlert show];
        }
    } else {
        [self.footerView endRefreshing];
    }
}

- (void)pullDownToRefresh{
    if (!isDataLoading) {
        if ([LCYCommon networkAvailable]) {
            pageIndex = 0;
            NSDictionary *parameter = @{@"id": self.galleryID,
                                        @"pageidx":[NSString stringWithFormat:@"%ld",(long)pageIndex],
                                        @"limit": LIMIT_PER_PAGE};
            isDataLoading = YES;
            self.pullDownParser = [[LCYXMLDictionaryParser alloc] init];
            self.pullDownParser.delegate = self;
            [LCYCommon postRequestWithAPI:GetArtworkListByGallryId parameters:parameter successDelegate:self.pullDownParser failedBlock:nil];
        } else {
            UIAlertView *networkUnabailableAlert = [[UIAlertView alloc] initWithTitle:@"无法找到网络" message:@"请检查您的网络连接状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [networkUnabailableAlert show];
        }
    } else {
        [self.headerView endRefreshing];
    }
}

#pragma mark - ImageDownloadOperation
- (void)imageDownloadDidFinished{
    [self.icyCollectionView reloadData];
}
@end
