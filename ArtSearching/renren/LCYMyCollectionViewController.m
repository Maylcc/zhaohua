//
//  LCYMyCollectionViewController.m
//  ArtSearching
//
//  Created by 李超逸 on 14-4-21.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYMyCollectionViewController.h"
#import <CHTCollectionViewWaterfallLayout.h>
#import "LCYMyCollectionCell.h"
#import "LCYCommon.h"
#import "LCYUserInformationViewController.h"
#import "LCYXMLDictionaryParser.h"
#import "LCYGetFavoriteArtWorksBase.h"
#import "LCYGetFavoriteArtWorksInfos.h"
#import "MJRefresh.h"
#import "LCYImageWithThumbDownloadOperation.h"


@interface LCYMyCollectionViewController ()<CHTCollectionViewDelegateWaterfallLayout,LCYXMLDictionaryParserDelegate,LCYImageWithThumbDownloadOperationDelegate,MJRefreshBaseViewDelegate,LCYUserInformationRefreshParserDelegate,LCYUserInformationLoadMoreParserDelegate>
{
    BOOL isNibRegistered;
    NSInteger checkCount;
    BOOL isRemoteDataLoading;
    NSUInteger worksPageNumber;
}
@property (weak, nonatomic) IBOutlet UICollectionView *icyCollectionView;
/**
 *  记录Cell是否选中
 */
@property (strong, nonatomic) NSMutableArray *cellStatus;
/**
 *  还可选x件作品
 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *checkCountButtonItem;
/**
 *  完成
 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButtonItem;

/**
 *  初次加载的解析器
 */
@property (strong, nonatomic) LCYXMLDictionaryParser *worksCollectionParser;
/**
 *  我的收藏数据
 */
@property (strong, nonatomic) NSArray *myFavouriteWorks;

/**
 *  所有加入过队列的图片（避免重复加入到下载线程）
 */
@property (strong, nonatomic) NSMutableArray *downloadedImageURL;

@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) LCYImageWithThumbDownloadOperation *myThumbOperation;

@property (strong, nonatomic) MJRefreshHeaderView *collectionHeader;
@property (strong, nonatomic) MJRefreshFooterView *collectionFooter;

@end

@implementation LCYMyCollectionViewController

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
    isNibRegistered = NO;
    isRemoteDataLoading = NO;
    worksPageNumber = 0;
    self.downloadedImageURL = [NSMutableArray array];
    
    // 设置返回按键
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToParent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    /**
     *  初始化状态为都没有选中
     */
    self.cellStatus = [NSMutableArray array];
    checkCount = 0;
    
    // 添加下拉刷新
    _collectionHeader = [[MJRefreshHeaderView alloc] init];
    _collectionHeader.delegate = self;
    _collectionHeader.scrollView = self.icyCollectionView;
    // 添加上拉加载更多
    _collectionFooter = [[MJRefreshFooterView alloc] init];
    _collectionFooter.delegate = self;
    _collectionFooter.scrollView = self.icyCollectionView;
    
    // 加载远程数据-我的收藏图片
    [self loadRemoteData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_collectionHeader free];
    [_collectionFooter free];
}

#pragma mark - Actions
- (void)backToParent{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)doneButtonPressed:(id)sender {
    // 获得所有选中的图片的信息，传递给代理进行处理
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<[self.cellStatus count]; i++) {
        if ([[self.cellStatus objectAtIndex:i] boolValue]) {
            LCYGetFavoriteArtWorksInfos *info = [self.myFavouriteWorks objectAtIndex:i];
            ImageInfo *imageInfo = [ImageInfo infoWithURL:info.url imageID:[NSString stringWithFormat:@"%.f",info.infosIdentifier]];
            [array addObject:imageInfo];
        }
    }
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(didGetImageInfoArray:)]) {
        [self.delegate didGetImageInfoArray:array];
    }
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)loadRemoteData{
    if ([LCYCommon networkAvailable]) {
        NSString *userID = [LCYCommon currentUserID];
        [LCYCommon showHUDTo:self.view withTips:nil];
        NSDictionary *parameter = @{@"UserId": userID,
                                    @"PageNo": @"0",
                                    @"PageNum": @"5"};
        self.worksCollectionParser = [[LCYXMLDictionaryParser alloc] init];
        self.worksCollectionParser.delegate = self;
        isRemoteDataLoading = YES;
        [LCYCommon postRequestWithAPI:GetFavoriteArtWorks parameters:parameter successDelegate:self.worksCollectionParser failedBlock:nil];
    } else {
        UIAlertView *networkUnabailableAlert = [[UIAlertView alloc] initWithTitle:@"无法找到网络" message:@"请检查您的网络连接状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [networkUnabailableAlert show];
    }
}

#pragma mark - UICollectionViewController Delegate And Delegate Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (!self.myFavouriteWorks) {
        return 0;
    } return [self.myFavouriteWorks count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"LCYMyCollectionCellIdentifier";
    if (!isNibRegistered) {
        UINib *nib = [UINib nibWithNibName:@"LCYMyCollectionCell" bundle:nil];
        [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
        isNibRegistered = YES;
    }
    LCYMyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    LCYGetFavoriteArtWorksInfos *info = [self.myFavouriteWorks objectAtIndex:indexPath.row];
    if ([LCYCommon isFileExistsAt:[LCYCommon thumbPathForImagePath:[[LCYCommon renrenMainImagePath] stringByAppendingPathComponent:info.url]]]) {
        cell.icyImageView.image = [UIImage imageWithContentsOfFile:[LCYCommon thumbPathForImagePath:[[LCYCommon renrenMainImagePath] stringByAppendingPathComponent:info.url]]];
    } else {
        cell.icyImageView.image = [UIImage imageNamed:@"placehold_image.png"];
        
        BOOL hasDownloaded = NO;
        for (NSString *url in self.downloadedImageURL) {
            if ([url isEqualToString:info.url]) {
                hasDownloaded = YES;
                break;
            }
        }
        if (!hasDownloaded) {
            // 开启线程或加入已有线程，下载图片
            if (!self.queue) {
                self.queue = [[NSOperationQueue alloc] init];
            }
            if (!self.myThumbOperation) {
                self.myThumbOperation = [[LCYImageWithThumbDownloadOperation alloc] init];
                self.myThumbOperation.delegate = self;
                [self.myThumbOperation initConfigure];
                [self.queue addOperation:self.myThumbOperation];
            }
            if (self.myThumbOperation.isCancelled) {
                self.myThumbOperation = [[LCYImageWithThumbDownloadOperation alloc] init];
                self.myThumbOperation.delegate = self;
                [self.myThumbOperation initConfigure];
                [self.queue addOperation:self.myThumbOperation];
            }
            [self.myThumbOperation addImageName:info.url ratio:info.imageRatio];
            [self.downloadedImageURL addObject:info.url];
        }
    }
    cell.titleLabel.text = info.title;
    cell.artistNameLabel.text = info.author;
    cell.viewerCountLabel.text = [NSString stringWithFormat:@"%.f",info.viewnum];
    if ([[self.cellStatus objectAtIndex:indexPath.row] boolValue]) {
        [cell checkOn];
    } else {
        [cell checkOff];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LCYMyCollectionCell *cell = (LCYMyCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([[self.cellStatus objectAtIndex:indexPath.row] boolValue]) {
        [self.cellStatus replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
        [cell checkOff];
        checkCount--;
        if (checkCount<self.minImageCount) {
            self.doneButtonItem.enabled = NO;
        }
    } else {
        // 检查是否超出15个选择的限制
        if (checkCount>=self.maxImageCount) {
            UIAlertView *outOfRangeAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"您不能选择超过15张图片参展" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [outOfRangeAlert show];
            return;
        }
        [self.cellStatus replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
        [cell checkOn];
        checkCount++;
        if (checkCount>=self.minImageCount) {
            self.doneButtonItem.enabled = YES;
        }
    }
    self.checkCountButtonItem.title = [NSString stringWithFormat:@"还可选%ld件作品",self.maxImageCount-(long)checkCount];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCYGetFavoriteArtWorksInfos *artWork = [self.myFavouriteWorks objectAtIndex:indexPath.row];
    return CGSizeMake(163, 163/artWork.imageRatio+37);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - LCYXMLDictionaryParserDelegate
- (void)parser:(LCYXMLDictionaryParser *)parser didFinishGetXMLInfo:(NSDictionary *)info{
    if (parser == self.worksCollectionParser) {
        LCYGetFavoriteArtWorksBase *baseInfo = [LCYGetFavoriteArtWorksBase modelObjectWithDictionary:info];
        if (baseInfo.infos.count == 0) {
            UIAlertView *noMoreDataAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"没有更多数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [noMoreDataAlert show];
        } else {
            if (!self.myFavouriteWorks) {
                self.myFavouriteWorks = baseInfo.infos;
            }else {
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.myFavouriteWorks];
                [tempArray addObjectsFromArray:baseInfo.infos];
                self.myFavouriteWorks = [NSArray arrayWithArray:tempArray];
            }
            NSInteger loadedCount = [baseInfo.infos count];
            for (int i = 0; i<loadedCount; i++) {
                [self.cellStatus addObject:[NSNumber numberWithBool:NO]];
            }
            worksPageNumber++;
            [self.icyCollectionView reloadData];
        }
        [LCYCommon hideHUDFrom:self.view];
        isRemoteDataLoading = NO;
    }
}

#pragma mark - MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if (_collectionHeader == refreshView) {
        LCYLOG(@"下拉刷新");
        [self pullDownToRefresh];
    } else if (_collectionFooter == refreshView){
        LCYLOG(@"上拉加载更多");
        [self pushUpToLoadMore];
    }
}

- (void)pullDownToRefresh{
    // Collection View 刷新
    if (!isRemoteDataLoading ) {
        if ([LCYCommon networkAvailable]) {
            worksPageNumber = 0;
            NSString *userID = [LCYCommon currentUserID];
            NSDictionary *parameter = @{@"UserId": userID,
                                        @"PageNo": @"0",
                                        @"PageNum": @"5"};
            isRemoteDataLoading = YES;
            LCYUserInformationRefreshParser *parser = [[LCYUserInformationRefreshParser alloc] init];
            parser.currentStatus = LCYUserInfoStatusCarePics;
            parser.delegate = self;
            [LCYCommon postRequestWithAPI:GetFavoriteArtWorks parameters:parameter successDelegate:parser failedBlock:nil];
        } else {
            UIAlertView *networkUnabailableAlert = [[UIAlertView alloc] initWithTitle:@"无法找到网络" message:@"请检查您的网络连接状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [networkUnabailableAlert show];
        }
    } else {
        [self.collectionHeader endRefreshing];
    }
    
    
}

- (void)pushUpToLoadMore{
    // 艺术家加载更多
    if (!isRemoteDataLoading ) {
        if ([LCYCommon networkAvailable]) {
            NSString *userID = [LCYCommon currentUserID];
            NSDictionary *parameter = @{@"UserId": userID,
                                        @"PageNo":[NSString stringWithFormat:@"%ld",(long)worksPageNumber],
                                        @"PageNum":@"5"};
            isRemoteDataLoading = YES;
            LCYUserInformationLoadMoreParser *parser = [[LCYUserInformationLoadMoreParser alloc] init];
            parser.currentStatus = LCYUserInfoStatusCarePics;
            parser.delegate = self;
            [LCYCommon postRequestWithAPI:GetFavoriteArtWorks parameters:parameter successDelegate:parser failedBlock:nil];
        } else {
            UIAlertView *networkUnabailableAlert = [[UIAlertView alloc] initWithTitle:@"无法找到网络" message:@"请检查您的网络连接状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [networkUnabailableAlert show];
        }
    } else {
        [self.collectionFooter endRefreshing];
    }
}

#pragma mark - 下拉刷新解析完毕
- (void)pullDownParserDidEnd:(LCYUserInformationRefreshParser *)parser withResultInfo:(NSDictionary *)info{
    if (parser.currentStatus == LCYUserInfoStatusCarePics) {
        LCYGetFavoriteArtWorksBase *baseInfo = [LCYGetFavoriteArtWorksBase modelObjectWithDictionary:info];
        self.myFavouriteWorks = [NSArray arrayWithArray:baseInfo.infos];
        self.cellStatus = [NSMutableArray array];
        checkCount = 0;
        self.checkCountButtonItem.title = [NSString stringWithFormat:@"还可选%ld件作品",self.maxImageCount-(long)checkCount];
        NSInteger loadedCount = [baseInfo.infos count];
        for (int i = 0; i<loadedCount; i++) {
            [self.cellStatus addObject:[NSNumber numberWithBool:NO]];
        }
        [self.icyCollectionView reloadData];
        [self.collectionHeader endRefreshing];
        isRemoteDataLoading = NO;
    }
}

#pragma mark - 上拉加载更多解析完毕
- (void)pushUpParserDidEnd:(LCYUserInformationLoadMoreParser *)parser withResultInfo:(NSDictionary *)info{
    if (parser.currentStatus == LCYUserInfoStatusCarePics) {
        LCYGetFavoriteArtWorksBase *baseInfo = [LCYGetFavoriteArtWorksBase modelObjectWithDictionary:info];
        if (baseInfo.infos.count == 0) {
            UIAlertView *noMoreDataAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"没有更多数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [noMoreDataAlert show];
        } else {
            if (!self.myFavouriteWorks) {
                self.myFavouriteWorks = baseInfo.infos;
            }else {
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.myFavouriteWorks];
                [tempArray addObjectsFromArray:baseInfo.infos];
                self.myFavouriteWorks = [NSArray arrayWithArray:tempArray];
            }
            NSInteger loadedCount = [baseInfo.infos count];
            for (int i = 0; i<loadedCount; i++) {
                [self.cellStatus addObject:[NSNumber numberWithBool:NO]];
            }
            worksPageNumber++;
            [self.icyCollectionView reloadData];
        }
        isRemoteDataLoading = NO;
        [self.collectionFooter endRefreshing];
    }
}
#pragma mark - LCYImageWithThumbDownloadOperationDelegate
- (void)imageWithThumbDownloadDidFinished{
    [self.icyCollectionView reloadData];
}
@end

@implementation ImageInfo
- (id)init{
    if (self = [super init]) {
    }
    return self;
}
+ (id)infoWithURL:(NSString *)URL name:(NSString *)name{
    ImageInfo *info = [[ImageInfo alloc] init];
    info.imageURL = URL;
    info.imageName = name;
    return info;
}
+ (id)infoWithURL:(NSString *)URL imageID:(NSString *)imageID{
    ImageInfo *info = [[ImageInfo alloc] init];
    info.imageURL = URL;
    info.imageID = imageID;
    return info;
}
@end
