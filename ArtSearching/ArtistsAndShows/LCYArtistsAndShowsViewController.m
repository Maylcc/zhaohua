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

@interface LCYArtistsAndShowsViewController ()<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
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
//    self.
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
    NSLog(@"json:%@",jsonResponse);
    if (currentStatus == LCYArtistsAndShowsStatusArtists) {
        LCYGetArtistListResult *result = [LCYGetArtistListResult modelObjectWithDictionary:jsonResponse];
        NSLog(@"get %ld artists",(long)[result.artists count]);
        numberOfArtistsPerPage++;
        isArtistLoading = NO;
    } else {
        
    }
    
//    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
}

#pragma mark - UITableView DataSource And Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (currentStatus == LCYArtistsAndShowsStatusArtists) {
        if (!self.showsArray) {
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
        cell.artistNameLabel.text = @"123123";
        return cell;
    }
    
    return nil;
}
#pragma mark - UISearchBar Delegate Methods
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

@end
