//
//  LCYUserInformationViewController.m
//  ArtSearching
//
//  Created by Licy on 14-4-22.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYUserInformationViewController.h"
#import "LCYUserDetailInfoViewController.h"
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import "LCYMyCollectionCell.h"
#import "LCYCommon.h"
#import "LCYXMLDictionaryParser.h"
#import "LCYGetFavoriteArtWorksInfos.h"
#import "LCYGetFavoriteArtWorksBase.h"
#import "LCYImageDownloadOperation.h"
#import "MJRefresh.h"
#import "ArtDetailViewController.h"

@interface LCYUserInformationViewController () <UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout,LCYXMLDictionaryParserDelegate,LCYImageDownloadOperationDelegate,MJRefreshBaseViewDelegate,LCYUserInformationRefreshParserDelegate,LCYUserInformationLoadMoreParserDelegate>
{
    BOOL isNibRegistered;   /**< collection cell */
    BOOL isNib2Registered;  /**< collection header */
    LCYUserInfoStatus currentStatus;
    NSInteger worksPageNumber;      /**< 作品收藏-下载页数 */
    BOOL isWorksLoading;    /**< 收藏作品正在加载中 */
    BOOL isOthersLoading;   /**< 艺术家和画廊正在加载中 */
}

/**
 *  画框
 */
@property (weak, nonatomic) IBOutlet UIView *collectionAndTableBackgroundView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegmentedControl;
/**
 *  艺术家和画廊
 */
@property (strong, nonatomic) IBOutlet UITableView *icyTableView;
/**
 *  作品收藏
 */
@property (strong, nonatomic) IBOutlet UICollectionView *icyCollectionView;

/**
 *  我的收藏-收藏作品数组
 */
@property (strong, nonatomic) NSArray *myFavouriteWorks;
/**
 *  作品收藏-XML解析器
 */
@property (strong, nonatomic) LCYXMLDictionaryParser *worksCollectionParser;

@property (strong, nonatomic) NSOperationQueue *queue;
/**
 *  各种图片下载的线程
 */
@property (strong, nonatomic) LCYImageDownloadOperation *myOperation;


@property (strong, nonatomic) MJRefreshHeaderView *collectionHeader;
@property (strong, nonatomic) MJRefreshFooterView *collectionFooter;

@end

@implementation LCYUserInformationViewController

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
    isNib2Registered = NO;
    currentStatus = LCYUserInfoStatusCarePics;
    worksPageNumber = 0;
    isWorksLoading = NO;
    isOthersLoading = NO;
    
    // 设置返回按键
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(userInfoBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    // 设置右侧“设置”键
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setFrame:CGRectMake(0, 0, 40, 40)];
    [settingButton setImage:[UIImage imageNamed:@"nav_setting.png"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(userInfoSetting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightSettingItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    self.navigationItem.rightBarButtonItem = rightSettingItem;
    
    // collection
    // 添加下拉刷新
    _collectionHeader = [[MJRefreshHeaderView alloc] init];
    _collectionHeader.delegate = self;
    _collectionHeader.scrollView = self.icyCollectionView;
    // 添加上拉加载更多
    _collectionFooter = [[MJRefreshFooterView alloc] init];
    _collectionFooter.delegate = self;
    _collectionFooter.scrollView = self.icyCollectionView;
    
    [self firstLoadRemoteData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [_collectionHeader free];
    [_collectionFooter free];
}


#pragma mark - Actions
- (void)userInfoBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)userInfoSetting{
    LCYUserDetailInfoViewController *udiVC = [[LCYUserDetailInfoViewController alloc] init];
    udiVC.title = @"个人设置";
    [self.navigationController pushViewController:udiVC animated:YES];
}
- (IBAction)mySegmentedControlValueChanged:(UISegmentedControl *)sender {
     NSInteger Index = sender.selectedSegmentIndex;
    switch (Index) {
        case 0:
            if (currentStatus == LCYUserInfoStatusOthers) {
                [self hideTableView];
                [self showCollectionView];
                currentStatus = LCYUserInfoStatusCarePics;
            }
            break;
        case 1:
            if (currentStatus == LCYUserInfoStatusCarePics) {
                [self hideCollectionView];
                [self showTableView];
                currentStatus = LCYUserInfoStatusOthers;
            }
            break;
        default:
            break;
    }
}

- (void)showCollectionView{
    CGRect frame = self.collectionAndTableBackgroundView.frame;
    self.icyCollectionView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    if (!self.icyCollectionView.superview) {
        [self.icyCollectionView reloadData];
        [self.collectionAndTableBackgroundView addSubview:self.icyCollectionView];
    }
}
- (void)hideCollectionView{
    [self.icyCollectionView removeFromSuperview];
}

- (void)showTableView{
    CGRect frame = self.collectionAndTableBackgroundView.frame;
    self.icyTableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    if (!self.icyTableView.superview) {
        [self.icyTableView reloadData];
        [self.collectionAndTableBackgroundView addSubview:self.icyTableView];
    }
}

- (void)hideTableView{
    [self.icyTableView removeFromSuperview];
}

- (void)firstLoadRemoteData{
    if ([LCYCommon networkAvailable]) {
        NSString *userID = [LCYCommon currentUserID];
        [LCYCommon showHUDTo:self.view withTips:nil];
        NSDictionary *parameter = @{@"UserId": userID,
                                    @"PageNo": @"0",
                                    @"PageNum": @"5"};
        self.worksCollectionParser = [[LCYXMLDictionaryParser alloc] init];
        self.worksCollectionParser.delegate = self;
        isWorksLoading = YES;
        [LCYCommon postRequestWithAPI:GetFavoriteArtWorks parameters:parameter successDelegate:self.worksCollectionParser failedBlock:nil];
    } else {
        UIAlertView *networkUnabailableAlert = [[UIAlertView alloc] initWithTitle:@"无法找到网络" message:@"请检查您的网络连接状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [networkUnabailableAlert show];
    }
}
#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger count = 0;
    return count;
}

#pragma mark - UICollectionView
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
    if ([LCYCommon isFileExistsAt:[[LCYCommon renrenMainImagePath] stringByAppendingPathComponent:info.url]]) {
        cell.icyImageView.image = [UIImage imageWithContentsOfFile:[[LCYCommon renrenMainImagePath] stringByAppendingPathComponent:info.url]];
    } else {
        cell.icyImageView.image = [UIImage imageNamed:@"placehold_image.png"];
        // 开启线程或加入已有线程，下载图片
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
            [self.myOperation initConfigure];
            self.myOperation.delegate = self;
            [self.queue addOperation:self.myOperation];
        }
        [self.myOperation addImageName:info.url];
    }
    cell.titleLabel.text = info.title;
    cell.artistNameLabel.text = info.author;
    cell.viewerCountLabel.text = [NSString stringWithFormat:@"%.f",info.viewnum];
    [cell checkOff];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"LCYUserInfoCollectionCellHeaderIdentifier";
    if (!isNib2Registered) {
        UINib *nib = [UINib nibWithNibName:@"LCYUserInfoCollectionCellHeader" bundle:nil];
        [collectionView registerNib:nib forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:identifier];
        isNib2Registered = YES;
    }
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        LCYUserInfomationCollectionCellHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];
        if (self.myFavouriteWorks) {
            header.icyLabel.text = [NSString stringWithFormat:@"收藏作品（%d）", self.myFavouriteWorks.count];
        }
        
        return header;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LCYGetFavoriteArtWorksInfos *info = [self.myFavouriteWorks objectAtIndex:indexPath.row];
    NSString *artID = [NSString stringWithFormat:@"%.f",info.infosIdentifier];
    NSString *artURL = info.url;
    ArtDetailViewController *artDetailViewController = [[ArtDetailViewController alloc] initWithWorkID:artID andWorkUrl:artURL withBundleName:@"ArtDetailViewController"];
    [self.navigationController pushViewController:artDetailViewController animated:YES];
}

#pragma mark - Layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCYGetFavoriteArtWorksInfos *artWork = [self.myFavouriteWorks objectAtIndex:indexPath.row];
    return CGSizeMake(163, 163/artWork.imageRatio+37);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section{
    if (!self.myFavouriteWorks) {
        return 0;
    }
    return 20;
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
            worksPageNumber++;
            [self.icyCollectionView reloadData];
        }
        [LCYCommon hideHUDFrom:self.view];
        isWorksLoading = NO;
        if (self.mySegmentedControl.selectedSegmentIndex == 0) {
            [self showCollectionView];
        }
    }
}

#pragma mark - LCYImageDownloadOperationDelegate
- (void)imageDownloadDidFinished{
    if (self.mySegmentedControl.selectedSegmentIndex == 0) {
        [self.icyCollectionView reloadData];
    } else {
        [self.icyTableView reloadData];
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
    if (currentStatus == LCYUserInfoStatusCarePics) {
        if (!isWorksLoading && !isOthersLoading) {
            if ([LCYCommon networkAvailable]) {
                worksPageNumber = 0;
                NSString *userID = [LCYCommon currentUserID];
                NSDictionary *parameter = @{@"UserId": userID,
                                             @"PageNo": @"0",
                                             @"PageNum": @"5"};
                isWorksLoading = YES;
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
    // Table View 刷新
//    else {
//        if (!isArtistLoading && !isShowsLoading) {
//            if ([LCYCommon networkAvailable]) {
//                showsPageNumber = 0;
//                NSDictionary *parameter = @{ @"pageIndex":[NSString stringWithFormat:@"%ld",(long)showsPageNumber],
//                                             @"limit":[NSString stringWithFormat:@"%ld",(long)numberOfShowsPerPage]};
//                isShowsLoading = YES;
//                LCYArtistsAndShowsPullDownRefreshParser *parser = [[LCYArtistsAndShowsPullDownRefreshParser alloc] init];
//                parser.currentStatus = LCYArtistsAndShowsStatusShows;
//                parser.delegate = self;
//                [LCYCommon postRequestWithAPI:GetGalleryList parameters:parameter successDelegate:parser failedBlock:nil];
//            } else {
//                UIAlertView *networkUnabailableAlert = [[UIAlertView alloc] initWithTitle:@"无法找到网络" message:@"请检查您的网络连接状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                [networkUnabailableAlert show];
//            }
//        } else {
//            [self.headerView endRefreshing];
//        }
//    }
}

- (void)pushUpToLoadMore{
    // 艺术家加载更多
    if (currentStatus == LCYUserInfoStatusCarePics) {
        if (!isWorksLoading && !isOthersLoading) {
            if ([LCYCommon networkAvailable]) {
                NSString *userID = [LCYCommon currentUserID];
                NSDictionary *parameter = @{@"UserId": userID,
                                            @"PageNo":[NSString stringWithFormat:@"%ld",(long)worksPageNumber],
                                             @"PageNum":@"5"};
                isWorksLoading = YES;
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
    } else if (currentStatus == LCYUserInfoStatusOthers){
//        if (!isArtistLoading && !isShowsLoading) {
//            if ([LCYCommon networkAvailable]) {
//                // 加载更多
//                NSDictionary *parameter = @{ @"pageIndex":[NSString stringWithFormat:@"%ld",(long)showsPageNumber],
//                                             @"limit":[NSString stringWithFormat:@"%ld",(long)numberOfShowsPerPage]};
//                isShowsLoading = YES;
//                LCYArtistsAndShowsPushUpRefreshParser *parser = [[LCYArtistsAndShowsPushUpRefreshParser alloc] init];
//                parser.currentStatus = LCYArtistsAndShowsStatusShows;
//                parser.delegate = self;
//                [LCYCommon postRequestWithAPI:GetGalleryList parameters:parameter successDelegate:parser failedBlock:nil];
//            } else {
//                UIAlertView *networkUnabailableAlert = [[UIAlertView alloc] initWithTitle:@"无法找到网络" message:@"请检查您的网络连接状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                [networkUnabailableAlert show];
//            }
//        } else {
//            [self.footerView endRefreshing];
//        }
    }
    
}

#pragma mark - 下拉刷新解析完毕
- (void)pullDownParserDidEnd:(LCYUserInformationRefreshParser *)parser withResultInfo:(NSDictionary *)info{
    if (parser.currentStatus == LCYUserInfoStatusCarePics) {
        LCYGetFavoriteArtWorksBase *baseInfo = [LCYGetFavoriteArtWorksBase modelObjectWithDictionary:info];
        self.myFavouriteWorks = [NSArray arrayWithArray:baseInfo.infos];
        [self.icyCollectionView reloadData];
        [self.collectionHeader endRefreshing];
        isWorksLoading = NO;
        if (self.mySegmentedControl.selectedSegmentIndex == 0) {
            [self showCollectionView];
        }
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
            worksPageNumber++;
            [self.icyCollectionView reloadData];
        }
        isWorksLoading = NO;
        if (self.mySegmentedControl.selectedSegmentIndex == 0) {
            [self showCollectionView];
        }
        [self.collectionFooter endRefreshing];
    }
}

@end


@implementation LCYUserInfomationCollectionCellHeader
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}
@end

@interface LCYUserInformationRefreshParser ()
@property (strong, nonatomic) NSMutableString *xmlTempString;
@end
@implementation LCYUserInformationRefreshParser
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    self.xmlTempString = [[NSMutableString alloc] init];
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    [self.xmlTempString appendString:string];
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    NSData *data = [self.xmlTempString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&error];
    NSAssert(self.currentStatus==LCYUserInfoStatusCarePics||self.currentStatus==LCYUserInfoStatusOthers, @"需设置当前加载内容类型");
    if (self.currentStatus == LCYUserInfoStatusCarePics) {
//        LCYGetArtistListResult *result = [LCYGetArtistListResult modelObjectWithDictionary:jsonResponse];
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(pullDownParserDidEnd:withResultInfo:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate pullDownParserDidEnd:self withResultInfo:jsonResponse];
            });
        }
    } else if (self.currentStatus == LCYUserInfoStatusOthers) {
//        LCYShowsGalleryGalleryList *result = [LCYShowsGalleryGalleryList modelObjectWithDictionary:jsonResponse];
//        if (self.delegate &&
//            [self.delegate respondsToSelector:@selector(pullDownParserDidEnd:withResultInfo:)]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.delegate pullDownParserDidEnd:self withResultInfo:result];
//            });
//        }
    }
}
@end


@interface LCYUserInformationLoadMoreParser ()
@property (strong, nonatomic) NSMutableString *xmlTempString;
@end
@implementation LCYUserInformationLoadMoreParser
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    self.xmlTempString = [[NSMutableString alloc] init];
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    [self.xmlTempString appendString:string];
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    NSData *data = [self.xmlTempString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&error];
    NSAssert(self.currentStatus==LCYUserInfoStatusCarePics||self.currentStatus==LCYUserInfoStatusOthers, @"需设置当前加载内容类型");
    if (self.currentStatus == LCYUserInfoStatusCarePics) {
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(pushUpParserDidEnd:withResultInfo:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate pushUpParserDidEnd:self withResultInfo:jsonResponse];
            });
        }
    } else if(self.currentStatus == LCYUserInfoStatusOthers) {
//        LCYShowsGalleryGalleryList *result = [LCYShowsGalleryGalleryList modelObjectWithDictionary:jsonResponse];
//        if (self.delegate &&
//            [self.delegate respondsToSelector:@selector(pushUpParserDidEnd:withResultInfo:)]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.delegate pushUpParserDidEnd:self withResultInfo:result];
//            });
//        }
    }
}

@end