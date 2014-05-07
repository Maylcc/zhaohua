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

NSInteger numberOfArtistsPerPage = 12;

@interface LCYArtistsAndShowsViewController ()<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,LCYArtistsAvatarDownloadOperationDelegate>
typedef NS_ENUM(NSInteger, LCYArtistsAndShowsStatus){
    LCYArtistsAndShowsStatusArtists,    /**< 艺术家 */
    LCYArtistsAndShowsStatusShows       /**< 画廊 */
};
@end

@interface LCYArtistsAndShowsViewController ()
{
    LCYArtistsAndShowsStatus currentStatus;
    NSInteger artistPageNumber;
    NSInteger showsPageNumber;
    BOOL isArtistLoading;
    BOOL isShowsLoading;
    BOOL isArtistNibRegistered;
}

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
    
    [self loadArtist];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadArtist{
    isArtistLoading = YES;
    NSDictionary *parameter = @{ @"pageIndex":[NSString stringWithFormat:@"%ld",(long)artistPageNumber],
                                 @"limit":[NSString stringWithFormat:@"%ld",(long)numberOfArtistsPerPage]};
    if ([LCYCommon networkAvailable]) {
        [LCYCommon postRequestWithAPI:GetArtistList parameters:parameter successDelegate:self failedBlock:nil];
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
            // TODO:跳转到个人信息界面
            LCYUserInformationViewController *userVC = [[LCYUserInformationViewController alloc] init];
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
    }
}

#pragma mark - NSXMLParserDelegate Methods
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
//    NSLog(@"json:%@",jsonResponse);
    LCYGetArtistListResult *result = [LCYGetArtistListResult modelObjectWithDictionary:jsonResponse];
//    NSLog(@"get %ld artists",(long)[result.artists count]);
    NSMutableArray *tempArray;
    if (self.artistsArray) {
        tempArray = [NSMutableArray arrayWithArray:self.artistsArray];
    }else{
        tempArray = [NSMutableArray array];
    }
    [tempArray addObjectsFromArray:result.artists];
    self.artistsArray = [NSArray arrayWithArray:tempArray];
    numberOfArtistsPerPage++;
    isArtistLoading = NO;
    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
}

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
    }
    return nil;
}
#pragma mark - UISearchBar Delegate Methods
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
#pragma mark - LCYArtistsAvatarDownloadOperation Delegate
- (void)avatarDownloadDidFinished{
    [self reloadTableView];
}

@end

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
