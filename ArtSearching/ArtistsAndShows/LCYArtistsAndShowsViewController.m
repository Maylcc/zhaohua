//
//  LCYArtistsAndShowsViewController.m
//  ArtSearching
//
//  Created by Licy on 14-4-30.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYArtistsAndShowsViewController.h"
#import "LCYCommon.h"
#import "LCYRegisterViewController.h"
#import "LCYUserInformationViewController.h"
#import "LCYAppDelegate.h"
#import "LCYRenrenViewController.h"
#import "LCYDataModels.h"
#import "LCYArtistsTableViewCell.h"
#import "LCYSearchingListViewController.h"
#import "LCYArtistDetailViewController.h"
#import "MJRefresh.h"
#import "LCYShowsTableViewCell.h"


@interface LCYArtistsAndShowsViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,LCYArtistsAvatarDownloadOperationDelegate,MJRefreshBaseViewDelegate,LCYArtistsAndShowsPullDownRefreshParserDelegate,LCYArtistsAndShowsPushUpRefreshParserDelegate,LCYArtistsAndShowsFirstLoadParserDelegate>

@end

@interface LCYArtistsAndShowsViewController ()
{
    LCYArtistsAndShowsStatus currentStatus;
    NSInteger artistPageNumber;
    NSInteger showsPageNumber;
    BOOL isArtistLoading;
    BOOL isShowsLoading;
    BOOL isArtistNibRegistered;
    BOOL isShowsNibRegistered;
    NSInteger numberOfArtistsPerPage;
    NSInteger numberOfShowsPerPage;
    BOOL isShowsButtonClicked;  /**< 标记画廊内容是否经过首次加载 */
}

@property (strong, nonatomic) MJRefreshHeaderView *headerView;
@property (strong, nonatomic) MJRefreshFooterView *footerView;

/**
 *  艺术家按钮
 */
@property (strong, nonatomic) IBOutlet UIControl *artistNavigationButton;
/**
 *  艺术家按钮
 */
@property (weak, nonatomic) IBOutlet UILabel *artistNavigationLabel;

/**
 *  画廊按钮
 */
@property (strong, nonatomic) IBOutlet UIControl *showsNavigationButton;
/**
 *  画廊按钮
 */
@property (weak, nonatomic) IBOutlet UILabel *showsNabigatinLabel;


@property (strong, nonatomic) NSMutableString *xmlTempString;
/**
 *  艺术家和画廊的列表
 */
@property (weak, nonatomic) IBOutlet UITableView *icyTableView;

/**
 *  所有艺术家
 */
@property (strong, nonatomic) NSArray *artistsArray;
/**
 *  所有画廊
 */
@property (strong, nonatomic) NSArray *showsArray;

/**
 *  头像下载线程
 */
@property (strong, nonatomic) LCYArtistsAvatarDownloadOperation *operation;
/**
 *  下载队列
 */
@property (strong, nonatomic) NSOperationQueue *queue;

/**
 *  保证艺术家头像只被下载一次
 */
@property (strong, nonatomic) NSMutableArray *artistAvatarAddedToQueue;

@end

@implementation LCYArtistsAndShowsViewController

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
    currentStatus = LCYArtistsAndShowsStatusArtists;
    artistPageNumber = 0;
    showsPageNumber = 0;
    isArtistNibRegistered = NO;
    isShowsNibRegistered = NO;
    numberOfArtistsPerPage = 12;
    numberOfShowsPerPage = 12;
    isShowsButtonClicked = NO;
    isArtistLoading = NO;
    isShowsLoading = NO;
    self.artistAvatarAddedToQueue = [NSMutableArray array];
    
    // 添加导航栏按钮（艺术家、画廊）
    UIBarButtonItem *ph1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    ph1.width = 20;
    UIBarButtonItem *ph2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    ph2.width = 20;
    UIBarButtonItem *leftNaviButton = [[UIBarButtonItem alloc] initWithCustomView:self.artistNavigationButton];
    UIBarButtonItem *rightNaviButton = [[UIBarButtonItem alloc] initWithCustomView:self.showsNavigationButton];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:ph1,leftNaviButton, nil]];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:ph2,rightNaviButton, nil]];
    
    
    // 添加上拉刷新与下拉刷新
    self.headerView = [[MJRefreshHeaderView alloc] init];
    self.headerView.delegate = self;
    self.headerView.scrollView = self.icyTableView;
    self.footerView = [[MJRefreshFooterView alloc] init];
    self.footerView.delegate = self;
    self.footerView.scrollView = self.icyTableView;
    
    [self loadArtist];
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

- (void)loadArtist{
    NSDictionary *parameter = @{ @"pageIndex":[NSString stringWithFormat:@"%ld",(long)artistPageNumber],
                                 @"limit":[NSString stringWithFormat:@"%ld",(long)numberOfArtistsPerPage]};
    if ([LCYCommon networkAvailable]) {
        isArtistLoading = YES;
        LCYArtistsAndShowsFirstLoadParser *parser = [[LCYArtistsAndShowsFirstLoadParser alloc] init];
        parser.currentStatus = LCYArtistsAndShowsStatusArtists;
        parser.delegate = self;
        [LCYCommon postRequestWithAPI:GetArtistList parameters:parameter successDelegate:parser failedBlock:nil];
    } else {
        UIAlertView *networkUnabailableAlert = [[UIAlertView alloc] initWithTitle:@"无法找到网络" message:@"请检查您的网络连接状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [networkUnabailableAlert show];
    }
}

- (void)loadShows{
    isShowsButtonClicked = YES;
    if ([LCYCommon networkAvailable]) {
        isShowsLoading = YES;
        NSDictionary *parameter = @{@"pageIndex": [NSString stringWithFormat:@"%ld",(long)showsPageNumber],
                                    @"limit":[NSString stringWithFormat:@"%ld",(long)numberOfShowsPerPage]};
        LCYArtistsAndShowsFirstLoadParser *parser = [[LCYArtistsAndShowsFirstLoadParser alloc] init];
        parser.delegate = self;
        parser.currentStatus = LCYArtistsAndShowsStatusShows;
        [LCYCommon postRequestWithAPI:GetGalleryList parameters:parameter successDelegate:parser failedBlock:nil];
    } else {
        UIAlertView *networkUnabailableAlert = [[UIAlertView alloc] initWithTitle:@"无法找到网络" message:@"请检查您的网络连接状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [networkUnabailableAlert show];
    }
}


- (void)reloadTableView{
    [self.icyTableView reloadData];
}

#pragma mark - Actions
- (IBAction)barButtonPressed:(id)sender {
    UIBarButtonItem *item = sender;
    if (item.tag == 4) {
        // 注册、登陆、显示用户收藏等
        BOOL isLogin = [LCYCommon isUserLogin];
        if (!isLogin) {
            // 跳转到注册界面
            LCYRegisterViewController *registerVC = [[LCYRegisterViewController alloc] init];
            [self.navigationController pushViewController:registerVC animated:YES];
        } else{
            // 跳转到个人信息界面
            LCYUserInformationViewController *userVC = [[LCYUserInformationViewController alloc] init];
            userVC.title = @"个人信息";
            [self.navigationController pushViewController:userVC animated:YES];
        }
    }
    if (item.tag == 1) {
        // 人人策画
        LCYAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        LCYRenrenViewController *oneVC = [[LCYRenrenViewController alloc] init];
        oneVC.title = @"人人策画";
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:oneVC];
        [appDelegate.window setRootViewController:nav];
    }
    if (item.tag == 3) {
        // 列表
        LCYAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        LCYSearchingListViewController *searchVC = [[LCYSearchingListViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchVC];
        [appDelegate.window setRootViewController:nav];
    }
}

- (IBAction)artistsButtonTouchDown:(id)sender {
    if (currentStatus!=LCYArtistsAndShowsStatusArtists) {
        self.artistNavigationLabel.textColor = [UIColor blackColor];
        self.showsNabigatinLabel.textColor = [UIColor lightGrayColor];
        currentStatus = LCYArtistsAndShowsStatusArtists;
        [self reloadTableView];
    }
}

- (IBAction)showsButtonTouchDown:(id)sender {
    if (currentStatus!=LCYArtistsAndShowsStatusShows) {
        self.artistNavigationLabel.textColor = [UIColor lightGrayColor];
        self.showsNabigatinLabel.textColor = [UIColor blackColor];
        currentStatus = LCYArtistsAndShowsStatusShows;
        [self reloadTableView];
        if (!isShowsButtonClicked) {
            [self loadShows];
        }
    }
}

#pragma mark - 首次加载解析完成，更新界面
- (void)firstLoadDidEnd:(LCYArtistsAndShowsFirstLoadParser *)parser withResultInfo:(id)info{
    // 首次加载所有艺术家
    if (parser.currentStatus == LCYArtistsAndShowsStatusArtists) {
        LCYGetArtistListResult *result = info;
        self.artistsArray = [NSArray arrayWithArray:result.artists];
        artistPageNumber++;
        isArtistLoading = NO;
        [self reloadTableView];
    }
    // 首次加载所有画廊
    else if (parser.currentStatus == LCYArtistsAndShowsStatusShows) {
        LCYShowsGalleryGalleryList *result = info;
        self.showsArray = [NSArray arrayWithArray:result.galleries];
        showsPageNumber++;
        isShowsLoading = NO;
        [self reloadTableView];
    }
}

//#pragma mark - NSXMLParserDelegate Methods
//- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
//    self.xmlTempString = [[NSMutableString alloc] init];
//}
//- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
//    [self.xmlTempString appendString:string];
//}
//
//- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
//    NSData *data = [self.xmlTempString dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *error;
//    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
//                                                                 options:kNilOptions
//                                                                   error:&error];
//    LCYGetArtistListResult *result = [LCYGetArtistListResult modelObjectWithDictionary:jsonResponse];
//    NSMutableArray *tempArray;
//    if (self.artistsArray) {
//        tempArray = [NSMutableArray arrayWithArray:self.artistsArray];
//    }else{
//        tempArray = [NSMutableArray array];
//    }
//    [tempArray addObjectsFromArray:result.artists];
//    self.artistsArray = [NSArray arrayWithArray:tempArray];
//    artistPageNumber++;
//    isArtistLoading = NO;
//    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
//}

#pragma mark - UITableView DataSource And Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (currentStatus == LCYArtistsAndShowsStatusArtists) {
        if (!self.artistsArray) {
            return 0;
        }
        return [self.artistsArray count];
    } else if( currentStatus == LCYArtistsAndShowsStatusShows){
        if (!self.showsArray) {
            return 0;
        }
        return [self.showsArray count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *artistIdentifier = @"LCYArtistsTableViewCellIdentifier";
    static NSString *showsIdentifier = @"LCYShowsTableViewCellIdentifier";
    if (currentStatus == LCYArtistsAndShowsStatusArtists) {
        if (!isArtistNibRegistered) {
            UINib *nib = [UINib nibWithNibName:@"LCYArtistsTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:artistIdentifier];
            isArtistNibRegistered = YES;
        }
        LCYArtistsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:artistIdentifier];
        LCYArtists *artist = [self.artistsArray objectAtIndex:indexPath.row];
        cell.artistNameLabel.text = artist.artistName;
        cell.artistWorksLabel.text = [NSString stringWithFormat:@"(%.f件作品)",artist.artistWorkCount];
        // 检查图片是否已经存在
        NSString *originalPath = artist.artistPortalS;
        NSString *replaceSlash = [originalPath stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        NSString *fileName = [replaceSlash lastPathComponent];
        if ([LCYCommon isFileExistsAt:[[LCYCommon artistAvatarImagePath] stringByAppendingPathComponent:fileName]]) {
            UIImage *avatarImage = [UIImage imageWithContentsOfFile:[[LCYCommon artistAvatarImagePath] stringByAppendingPathComponent:fileName]];
            cell.icyImage.image = avatarImage;
        } else {
            cell.icyImage.image = [UIImage imageNamed:@"akalin.jpg"];
            NSString *fileURL = [NSString stringWithFormat:@"%@%@",hostIMGPrefix,replaceSlash];
            // 检查是否已经下载过一次，避免重复下载不存在的文件
            BOOL hasDownloaded = NO;
            for (NSString *oneFileName in self.artistAvatarAddedToQueue) {
                if ([oneFileName isEqualToString:fileURL]) {
                    hasDownloaded = YES;
                    break;
                }
            }
            if (!hasDownloaded) {
                // 启动下载线程
                [self.artistAvatarAddedToQueue addObject:fileURL];
                if (!self.queue) {
                    self.queue = [[NSOperationQueue alloc] init];
                }
                if (!self.operation) {
                    self.operation = [[LCYArtistsAvatarDownloadOperation alloc] init];
                    self.operation.delegate = self;
                    [self.operation initConfigure];
                    [self.queue addOperation:self.operation];
                }
                if (self.operation.isCancelled) {
                    self.operation = [[LCYArtistsAvatarDownloadOperation alloc] init];
                    self.operation.delegate = self;
                    [self.queue addOperation:self.operation];
                }
                [self.operation addAvartarURL:fileURL];
                LCYLOG(@"add:%@",fileURL);
            }
        }
        return cell;
    } else if (currentStatus == LCYArtistsAndShowsStatusShows) {
        if (!isShowsNibRegistered) {
            UINib *nib = [UINib nibWithNibName:@"LCYShowsTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:showsIdentifier];
            isShowsNibRegistered = YES;
        }
        LCYShowsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:showsIdentifier];
        LCYShowsGalleryGalleries *galleryInRow = [self.showsArray objectAtIndex:indexPath.row];
        cell.showsNameLabel.text = galleryInRow.name;
        cell.visitorNumberLabel.text = [NSString stringWithFormat:@"%.f",galleryInRow.openTimes];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (currentStatus == LCYArtistsAndShowsStatusArtists) {
        LCYArtists *artist = [self.artistsArray objectAtIndex:indexPath.row];
        NSString *artistID = [NSString stringWithFormat:@"%.f",artist.artistId];
        // 跳转到作者详细
        LCYArtistDetailViewController *artistDVC = [[LCYArtistDetailViewController alloc] init];
        artistDVC.artistID = artistID;
        [self.navigationController pushViewController:artistDVC animated:YES];
    }
}
#pragma mark - UISearchBar Delegate Methods
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
#pragma mark - LCYArtistsAvatarDownloadOperation Delegate
- (void)avatarDownloadDidFinished{
    [self reloadTableView];
}

#pragma mark - MJRefreshBase
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH : mm : ss.SSS";
    if (self.headerView == refreshView) {
        LCYLOG(@"下拉刷新");
        [self pullDownToRefresh];
    } else {
        LCYLOG(@"上拉刷新");
        [self pushUpToLoadMore];
    }
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.icyTableView reloadData];
    isArtistLoading = NO;
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

- (void)pullDownToRefresh{
    // 艺术家刷新
    if (currentStatus == LCYArtistsAndShowsStatusArtists) {
        if (!isArtistLoading) {
            if ([LCYCommon networkAvailable]) {
                artistPageNumber = 0;
                NSDictionary *parameter = @{ @"pageIndex":[NSString stringWithFormat:@"%ld",(long)artistPageNumber],
                                             @"limit":[NSString stringWithFormat:@"%ld",(long)numberOfArtistsPerPage]};
                isArtistLoading = YES;
                LCYArtistsAndShowsPullDownRefreshParser *parser = [[LCYArtistsAndShowsPullDownRefreshParser alloc] init];
                parser.currentStatus = LCYArtistsAndShowsStatusArtists;
                parser.delegate = self;
                [LCYCommon postRequestWithAPI:GetArtistList parameters:parameter successDelegate:parser failedBlock:nil];
            } else {
                UIAlertView *networkUnabailableAlert = [[UIAlertView alloc] initWithTitle:@"无法找到网络" message:@"请检查您的网络连接状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [networkUnabailableAlert show];
            }
        } else {
            [self.headerView endRefreshing];
        }
    }
    // 画廊刷新
    else {
        
    }
}

- (void)pushUpToLoadMore{
    // 艺术家家在更多
    if (currentStatus == LCYArtistsAndShowsStatusArtists) {
        if (!isArtistLoading) {
            if ([LCYCommon networkAvailable]) {
                NSDictionary *parameter = @{ @"pageIndex":[NSString stringWithFormat:@"%ld",(long)artistPageNumber],
                                             @"limit":[NSString stringWithFormat:@"%ld",(long)numberOfArtistsPerPage]};
                isArtistLoading = YES;
                LCYArtistsAndShowsPushUpRefreshParser *parser = [[LCYArtistsAndShowsPushUpRefreshParser alloc] init];
                parser.currentStatus = LCYArtistsAndShowsStatusArtists;
                parser.delegate = self;
                [LCYCommon postRequestWithAPI:GetArtistList parameters:parameter successDelegate:parser failedBlock:nil];
            } else {
                UIAlertView *networkUnabailableAlert = [[UIAlertView alloc] initWithTitle:@"无法找到网络" message:@"请检查您的网络连接状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [networkUnabailableAlert show];
            }
        } else {
            [self.footerView endRefreshing];
        }
    }
    
}

#pragma mark - LCY Pull Down And Push Up Delegate
- (void)pullDownParserDidEnd:(LCYArtistsAndShowsPullDownRefreshParser *)parser withResultInfo:(id)info{
    if (currentStatus == LCYArtistsAndShowsStatusArtists) {
        LCYGetArtistListResult *result = info;
        self.artistsArray = [NSArray arrayWithArray:result.artists];
        artistPageNumber = 1;
        [self reloadTableView];
        [self doneWithView:self.headerView];
    }
}

- (void)pushUpParserDidEnd:(LCYArtistsAndShowsPushUpRefreshParser *)parser withResultInfo:(id)info{
    if (currentStatus == LCYArtistsAndShowsStatusArtists) {
        LCYGetArtistListResult *result = info;
        NSMutableArray *tempArray;
        if (self.artistsArray) {
            tempArray = [NSMutableArray arrayWithArray:self.artistsArray];
        } else {
            tempArray = [NSMutableArray array];
        }
        [tempArray addObjectsFromArray:result.artists];
        self.artistsArray = [NSArray arrayWithArray:tempArray];
        artistPageNumber++;
        [self reloadTableView];
        [self doneWithView:self.footerView];
    }
}

@end

#pragma mark - 首次加载完毕解析

@interface LCYArtistsAndShowsFirstLoadParser ()
@property (strong, nonatomic) NSMutableString *xmlTempString;
@end
@implementation LCYArtistsAndShowsFirstLoadParser
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
    NSAssert(self.currentStatus==LCYArtistsAndShowsStatusArtists||self.currentStatus==LCYArtistsAndShowsStatusShows, @"需设置当前加载内容类型");
    if (self.currentStatus == LCYArtistsAndShowsStatusArtists) {
        LCYGetArtistListResult *result = [LCYGetArtistListResult modelObjectWithDictionary:jsonResponse];
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(firstLoadDidEnd:withResultInfo:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate firstLoadDidEnd:self withResultInfo:result];
            });
        }
    } else {
        LCYShowsGalleryGalleryList *result = [LCYShowsGalleryGalleryList modelObjectWithDictionary:jsonResponse];
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(firstLoadDidEnd:withResultInfo:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate firstLoadDidEnd:self withResultInfo:result];
            });
        }
    }
}
@end

#pragma mark - 下载头像
@interface LCYArtistsAvatarDownloadOperation ()
@property (strong, atomic) NSMutableArray *urlArray;
@property (strong, atomic) NSCondition *arrayCondition;
@end
@implementation LCYArtistsAvatarDownloadOperation
- (void)initConfigure{
    self.urlArray = [NSMutableArray array];
    self.arrayCondition = [[NSCondition alloc] init];
}
- (void)main{
    while (YES) {
        // 检查线程是否已经结束
        if (self.isCancelled) {
            break;
        }
        // 检查需要下载的列表
        [self.arrayCondition lock];
        if (self.urlArray.count == 0) {
            [self.arrayCondition wait];
            [self.arrayCondition unlock];
        } else {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            NSString *avatarURL = [self.urlArray lastObject];
            [self.urlArray removeObject:avatarURL];
            LCYLOG(@"pop object:%@",avatarURL);
            LCYLOG(@"current object count = %ld",(long)self.urlArray.count);
            [self.arrayCondition unlock];
            // 开启异步下载，完成后发送signal
            NSString *urlString = [[NSString stringWithFormat:@"%@",avatarURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *imageFileName = [urlString lastPathComponent];
            NSURL *url = [NSURL URLWithString:urlString];
            NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
            AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
            requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
            [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                UIImage *downImg = (UIImage *)responseObject;
                NSData *imageData = UIImageJPEGRepresentation(downImg, 1.0);
                LCYLOG(@"success");
                [imageData writeToFile:[[LCYCommon artistAvatarImagePath] stringByAppendingPathComponent:imageFileName] atomically:YES];
                LCYLOG(@"write to file:%@",[[LCYCommon artistAvatarImagePath] stringByAppendingPathComponent:imageFileName]);
                if (self.delegate &&
                    [self.delegate respondsToSelector:@selector(avatarDownloadDidFinished)]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate avatarDownloadDidFinished];
                    });
                }
                dispatch_semaphore_signal(sema);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                LCYLOG(@"下载图片失败 error is %@",error);
                dispatch_semaphore_signal(sema);
            }];
            [requestOperation start];
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
    }
}
- (void)addAvartarURL:(NSString *)URL{
    [self.arrayCondition lock];
    BOOL gotOne = NO;
    for (NSString *oneURL in self.urlArray) {
        if ([oneURL isEqualToString:URL]) {
            gotOne = YES;
            break;
        }
    }
    if (!gotOne) {
        [self.urlArray addObject:URL];
        [self.arrayCondition signal];
    }
    [self.arrayCondition unlock];
}
@end

#pragma mark - 下拉刷新

@interface LCYArtistsAndShowsPullDownRefreshParser ()
@property (strong, nonatomic) NSMutableString *xmlTempString;
@end
@implementation LCYArtistsAndShowsPullDownRefreshParser
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
    NSAssert(self.currentStatus==LCYArtistsAndShowsStatusArtists||self.currentStatus==LCYArtistsAndShowsStatusShows, @"需设置当前加载内容类型");
    if (self.currentStatus == LCYArtistsAndShowsStatusArtists) {
        LCYGetArtistListResult *result = [LCYGetArtistListResult modelObjectWithDictionary:jsonResponse];
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(pullDownParserDidEnd:withResultInfo:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate pullDownParserDidEnd:self withResultInfo:result];
            });
        }
    }
}
@end

#pragma mark - 上拉加载更多

@interface LCYArtistsAndShowsPushUpRefreshParser ()
@property (strong, nonatomic) NSMutableString *xmlTempString;
@end
@implementation LCYArtistsAndShowsPushUpRefreshParser
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
    NSAssert(self.currentStatus==LCYArtistsAndShowsStatusArtists||self.currentStatus==LCYArtistsAndShowsStatusShows, @"需设置当前加载内容类型");
    if (self.currentStatus == LCYArtistsAndShowsStatusArtists) {
        LCYGetArtistListResult *result = [LCYGetArtistListResult modelObjectWithDictionary:jsonResponse];
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(pushUpParserDidEnd:withResultInfo:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate pushUpParserDidEnd:self withResultInfo:result];
            });
        }
    }
}
@end
