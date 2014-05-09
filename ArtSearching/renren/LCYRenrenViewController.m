//
//  LCYRenrenViewController.m
//  ArtSearching
//
//  Created by eagle on 14-4-16.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYRenrenViewController.h"
#import "LCYCommon.h"
#import "DataListViewController.h"
#import "LCYRenrenTableViewCell.h"
#import "LCYBuildExhibitionViewController.h"
#import "LCYRegisterViewController.h"
#import "LCYUserInformationViewController.h"
#import "LCYAppDelegate.h"
#import "LCYArtistsAndShowsViewController.h"
#import "LCYRenrenMineApplyTableViewCell.h"
#import "LCYApplyAccAndRejViewController.h"
#import "LCYRenrenDetailViewController.h"
#import "LCYSearchingListViewController.h"

#define RenrenGreen colorWithRed:101.0/255 green:151.0/255 blue:49.0/255 alpha:1

@interface LCYRenrenViewController ()
<NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,LCYApplyerResultParserDelegate>

typedef NS_ENUM(NSInteger, LCYRenrenSegStatus){
    LCYRenrenSegStatusAll,      /**< 所有展览 */
    LCYRenrenSegStatusMine      /**< 我的展览 */
};

typedef NS_ENUM(NSInteger, LCYRenrenDownloadStatus){
    LCYRenrenDownloadingAll,    /**< 下载的数据是所有展览 */
    LCYRenrenDownloadingMine    /**< 下载的数据是我的展览 */
};
/**
 *  用于解析XML时的缓存
 */
@property (strong, nonatomic) NSMutableString *xmlTempString;

/**
 *  XML解析结果
 */
@property (strong, nonatomic) LCYActivityListBase *activityListBase;

@property (strong, nonatomic) LCYGetAllExhibitionResult *allExhibitionResult;
@property (strong, nonatomic) LCYGetOwnExhibitionResult *mineExhibitionResult;
@property (strong, nonatomic) NSArray *applyerInfoResult;

@end

@interface LCYRenrenViewController ()
{
    LCYRenrenSegStatus currentStatus;
    LCYRenrenDownloadStatus currentDownloadingStatus;
    BOOL isRenrenTableViewCellRegistered;
    BOOL isRenrenMineApplyCellRegistered;
    BOOL isAllDownloading;      /**< 所有展览的数据正在下载中 */
    BOOL isMineDownloading;     /**< 我的展览的数据正在下载中 */
}

/**
 *  数据凶猛按钮
 */
@property (strong, nonatomic) IBOutlet UIView *dataFerocious;
/**
 *  搜索栏
 */
@property (weak, nonatomic) IBOutlet UISearchBar *icySearchingBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarVerticalSpace;
/**
 *  所有活动的列表
 */
@property (weak, nonatomic) IBOutlet UITableView *icyTableView;

/**
 *  所有展览
 */
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
/**
 *  我的展览
 */
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
/**
 *  所有展览
 */
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
/**
 *  我的展览
 */
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
/**
 *  展览申请数字背景图片（红点）
 */
@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView;
/**
 *  展览申请数字
 */
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;


@end

@implementation LCYRenrenViewController

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
    isAllDownloading = NO;
    isMineDownloading = NO;
    // Do any additional setup after loading the view from its nib.
    // 添加数据凶猛按钮
    UIBarButtonItem *leftNaviButton = [[UIBarButtonItem alloc] initWithCustomView:self.dataFerocious];
    self.navigationItem.leftBarButtonItem = leftNaviButton;
    
    currentStatus = LCYRenrenSegStatusAll;
    isRenrenTableViewCellRegistered = NO;
    isRenrenMineApplyCellRegistered = NO;
    
    [self loadExData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadExData{
    if ([LCYCommon networkAvailable]) {
        currentDownloadingStatus = LCYRenrenDownloadingAll;
        isAllDownloading = YES;
        NSDictionary *parameter = @{@"NowDate":@"12/21/2012 18:00:00",
                                    @"PageNo":@"1",
                                    @"PageNum":@"1"};
        [LCYCommon postRequestWithAPI:GetAllExhibition parameters:parameter successDelegate:self failedBlock:nil];
        
        // 开启下载我的展览申请者信息
        if ([LCYCommon isUserLogin]) {
            NSDictionary *parameter2 = @{@"UserId": @"123"};
            LCYApplyersResultParser *parser = [[LCYApplyersResultParser alloc] init];
            parser.delegate = self;
            [LCYCommon postRequestWithAPI:GetApplyerInfo parameters:parameter2 successDelegate:parser failedBlock:nil];
        }
        
    } else {
        UIAlertView *networkUnabailableAlert = [[UIAlertView alloc] initWithTitle:@"无法找到网络" message:@"请检查您的网络连接状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [networkUnabailableAlert show];
    }
}

#pragma mark -Actions
- (IBAction)renrenLeftNaviButtonPressed:(id)sender{
    // 跳转到数据凶猛
    DataListViewController *dataList = [[DataListViewController alloc] initWithNibName:NSStringFromClass([DataListViewController class]) bundle:nil];
    [self.navigationController pushViewController:dataList animated:YES];
    
}

- (IBAction)barButtonPressed:(id)sender {
    UIBarButtonItem *item = sender;
    if (item.tag == 4) {
        // 注册、登陆、显示用户收藏等
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        BOOL isLogin = [[userDefaults objectForKey:UserDefaultsIsLogin] boolValue];
        if (!isLogin) {
            // 跳转到注册界面
            LCYRegisterViewController *registerVC = [[LCYRegisterViewController alloc] init];
            [self.navigationController pushViewController:registerVC animated:YES];
        } else{
            // TODO:跳转到个人信息界面
            LCYUserInformationViewController *userVC = [[LCYUserInformationViewController alloc] init];
            userVC.title = @"个人信息";
            [self.navigationController pushViewController:userVC animated:YES];
        }
    }
    if (item.tag == 2) {
        // 艺术家、画廊
        LCYAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        LCYArtistsAndShowsViewController *twoVC = [[LCYArtistsAndShowsViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:twoVC];
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

/**
 *  我要策展
 *
 *  @param sender button
 */
- (IBAction)iWantButtonPressed:(id)sender {
    NSLog(@"我要策展");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![[userDefaults objectForKey:UserDefaultsIsLogin] boolValue]) {
        UIAlertView *notLoginAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"请您先登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [notLoginAlert show];
        return;
    }
    LCYBuildExhibitionViewController *buildVC = [[LCYBuildExhibitionViewController alloc] init];
    buildVC.title = @"我要策展";
    [self.navigationController pushViewController:buildVC animated:YES];
}
/**
 *  所有展览
 *
 *  @param sender button
 */
- (IBAction)allExButtonPressed:(id)sender {
    NSLog(@"所有展览");
    if (currentStatus == LCYRenrenSegStatusMine) {
        self.leftImageView.image = [UIImage imageNamed:@"all_ex_left_filled.png"];
        [self.leftLabel setTextColor:[UIColor whiteColor]];
        self.rightImageView.image = [UIImage imageNamed:@"all_ex_right_blank.png"];
        [self.rightLabel setTextColor:[UIColor RenrenGreen]];
        currentStatus = LCYRenrenSegStatusAll;
        [self reloadTableView];
    }
}
/**
 *  我的展览
 *
 *  @param sender button
 */
- (IBAction)myExButtonPressed:(id)sender {
    NSLog(@"我的展览");
    if (![LCYCommon isUserLogin]) {
        UIAlertView *noneLoginAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"请您先登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [noneLoginAlert show];
        return;
    }
    if (currentStatus == LCYRenrenSegStatusAll) {
        if (!self.mineExhibitionResult) {
            if (!isMineDownloading) {
                // 如果用户已经登录，则开启我的展览数据读取
                if ([LCYCommon isUserLogin]) {
                    currentDownloadingStatus = LCYRenrenDownloadingMine;
                    isMineDownloading = YES;
                    NSDictionary *parameter = @{@"NowDate": @"12/21/2012 18:00:00",
                                                @"PageNo": @"1",
                                                @"PageNum": @"2",
                                                @"UserID": @"3333"};
                    [LCYCommon postRequestWithAPI:GetOwnExhibition parameters:parameter successDelegate:self failedBlock:nil];
                }
            }
        }
        self.leftImageView.image = [UIImage imageNamed:@"all_ex_left_blank.png"];
        [self.leftLabel setTextColor:[UIColor RenrenGreen]];
        self.rightImageView.image = [UIImage imageNamed:@"all_ex_right_filled.png"];
        [self.rightLabel setTextColor:[UIColor whiteColor]];
        currentStatus = LCYRenrenSegStatusMine;
        [self reloadTableView];
    }
}

- (void)reloadTableView{
    [self.icyTableView reloadData];
}
#pragma mark - NSXMLParserDelegate

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
    // 根据下载的数据不同，进行不同种类的解析
    if (currentDownloadingStatus == LCYRenrenDownloadingAll) {
        self.allExhibitionResult = [LCYGetAllExhibitionResult modelObjectWithDictionary:jsonResponse];
        [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
        isAllDownloading = NO;
    } else if (currentDownloadingStatus == LCYRenrenDownloadingMine) {
        self.mineExhibitionResult = [LCYGetOwnExhibitionResult modelObjectWithDictionary:jsonResponse];
        [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
        isMineDownloading = NO;
    }
}

#pragma mark - UITableView Data Source and Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (currentStatus == LCYRenrenSegStatusAll) {
        if (!self.allExhibitionResult) {
            return 0;
        } else {
            return [self.allExhibitionResult.exhibitions count];
        }
    } else if( currentStatus == LCYRenrenSegStatusMine ){
        if (!self.mineExhibitionResult) {
            return 0;
        } else {
            if (self.applyerInfoResult &&
                self.applyerInfoResult.count!=0) {
                return 1+[self.mineExhibitionResult.exhibitions count];
            } else {
                return [self.mineExhibitionResult.exhibitions count];
            }
            
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"renrenTableViewIdentifier";         /**< 所有展览 */
    static NSString *identifier2 = @"renrenTableViewIdentifier2";       /**< 我的展览请求 */
    //    static NSString *identifier3 = @"renrenTableViewIdentifier3";       /**< 我的展览 */
    
    if (currentStatus == LCYRenrenSegStatusAll) {
        if (!isRenrenTableViewCellRegistered) {
            UINib *nib = [UINib nibWithNibName:@"LCYRenrenTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:identifier];
            isRenrenTableViewCellRegistered = YES;
        }
        LCYRenrenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        LCYExhibitions *exhibition = [self.allExhibitionResult.exhibitions objectAtIndex:indexPath.row];
        cell.titleLabel.text = exhibition.title;
        cell.host.text = exhibition.organizerName;
        cell.participant.text = exhibition.attenderNames;
        cell.timeLabel.text = exhibition.createTime;
        cell.descriptionLabel.text = exhibition.describinfo;
        cell.commentCount.text = [NSString stringWithFormat:@"%@次评论",exhibition.commentNums];
        cell.admireCount.text = [NSString stringWithFormat:@"被欣赏%@次",exhibition.viewNum];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        
        if ([exhibition.imgs count]>=1) {
            LCYImgs *img = [exhibition.imgs objectAtIndex:0];
            NSString *imageName = [img.url lastPathComponent];
            if (![fileManager fileExistsAtPath:[[LCYCommon renrenMainImagePath] stringByAppendingPathComponent:imageName]]) {
                // TODO:启动多线程下载
            } else {
                
            }
        }
        
        return cell;
    } else {
        if (self.applyerInfoResult &&
            self.applyerInfoResult.count!=0){
            if (indexPath.row == 0) {
                if (!isRenrenMineApplyCellRegistered) {
                    UINib *nib = [UINib nibWithNibName:@"LCYRenrenMineApplyTableViewCell" bundle:nil];
                    [tableView registerNib:nib forCellReuseIdentifier:identifier2];
                    isRenrenMineApplyCellRegistered = YES;
                }
                LCYRenrenMineApplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
                if (self.applyerInfoResult.count==1) {
                    LCYGetApplyerInfoResult *result = [self.applyerInfoResult firstObject];
                    NSString *icyLabelString = [NSString stringWithFormat:@"%@提交了参展请求",result.applyers];
                    cell.icyLabel.text = icyLabelString;
                } else {
                    LCYGetApplyerInfoResult *result = [self.applyerInfoResult firstObject];
                    NSString *icyLabelString = [NSString stringWithFormat:@"%@等人提交了参展请求",result.applyers];
                    cell.icyLabel.text = icyLabelString;
                }
                cell.icyBadgeLabel.text = [NSString stringWithFormat:@"%ld",(long)self.applyerInfoResult.count];
                return cell;
            } else {
                if (!isRenrenTableViewCellRegistered) {
                    UINib *nib = [UINib nibWithNibName:@"LCYRenrenTableViewCell" bundle:nil];
                    [tableView registerNib:nib forCellReuseIdentifier:identifier];
                    isRenrenTableViewCellRegistered = YES;
                }
                LCYRenrenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                
                LCYMineExhibitions *exhibition = [self.mineExhibitionResult.exhibitions objectAtIndex:(indexPath.row-1)];
                cell.titleLabel.text = exhibition.title;
                cell.host.text = exhibition.organizerName;
                cell.participant.text = exhibition.attenderNames;
                cell.timeLabel.text = exhibition.createTime;
                cell.descriptionLabel.text = exhibition.describinfo;
                cell.commentCount.text = [NSString stringWithFormat:@"%@次评论",exhibition.commentNums];
                cell.admireCount.text = [NSString stringWithFormat:@"被欣赏%@次",exhibition.viewNum];
                
                return cell;
            }
        } else {
            if (!isRenrenTableViewCellRegistered) {
                UINib *nib = [UINib nibWithNibName:@"LCYRenrenTableViewCell" bundle:nil];
                [tableView registerNib:nib forCellReuseIdentifier:identifier];
                isRenrenTableViewCellRegistered = YES;
            }
            LCYRenrenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            LCYMineExhibitions *exhibition = [self.mineExhibitionResult.exhibitions objectAtIndex:indexPath.row];
            cell.titleLabel.text = exhibition.title;
            cell.host.text = exhibition.organizerName;
            cell.participant.text = exhibition.attenderNames;
            cell.timeLabel.text = exhibition.createTime;
            cell.descriptionLabel.text = exhibition.describinfo;
            cell.commentCount.text = [NSString stringWithFormat:@"%@次评论",exhibition.commentNums];
            cell.admireCount.text = [NSString stringWithFormat:@"被欣赏%@次",exhibition.viewNum];
            
            return cell;
        }
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (currentStatus == LCYRenrenSegStatusMine) {
        if (indexPath.row == 0) {
            return 50;
        }
    }
    return 420.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"select row at row: %ld",(long)indexPath.row);
    if (currentStatus == LCYRenrenSegStatusMine) {
        if (self.applyerInfoResult &&
            self.applyerInfoResult.count!=0) {
            if (indexPath.row==0) {
                // 进入我的展览，申请批准、拒绝页
                LCYApplyAccAndRejViewController *aarvc = [[LCYApplyAccAndRejViewController alloc] init];
                aarvc.title = [NSString stringWithFormat:@"%ld个参展申请",(long)self.applyerInfoResult.count];
                aarvc.applyArray = self.applyerInfoResult;
                [self.navigationController pushViewController:aarvc animated:YES];
            }
        }
    } else if (currentStatus == LCYRenrenSegStatusAll){
        LCYRenrenDetailViewController *dvc = [[LCYRenrenDetailViewController alloc] init];
        dvc.exhibitionInfo = [self.allExhibitionResult.exhibitions objectAtIndex:indexPath.row];
        dvc.title = dvc.exhibitionInfo.title;
        [self.navigationController pushViewController:dvc animated:YES];
    }
}

#pragma mark - UISearchBar Delegate Methods
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

#pragma mark - LCYApplyerResultParserDelegate Methods
- (void)resultParserDidFinish:(LCYApplyersResultParser *)parser{
    self.applyerInfoResult = parser.result;
    if (self.applyerInfoResult.count!=0) {
        self.badgeImageView.image = [UIImage imageNamed:@"all_ex_right_badge.png"];
        self.badgeLabel.text = [NSString stringWithFormat:@"%ld",(long)self.applyerInfoResult.count];
        [self.badgeImageView setHidden:NO];
        [self.badgeLabel setHidden:NO];
        [self reloadTableView];
    }
}

@end


@interface LCYApplyersResultParser ()
@property (strong, nonatomic) NSMutableString *xmlTempString;
@end
@implementation LCYApplyersResultParser
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    self.xmlTempString = [[NSMutableString alloc] init];
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    [self.xmlTempString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    NSData *data = [self.xmlTempString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                            options:kNilOptions
                                                              error:&error];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (id tDic in jsonResponse) {
        LCYGetApplyerInfoResult *oneResult = [LCYGetApplyerInfoResult modelObjectWithDictionary:tDic];
        [tempArray addObject:oneResult];
    }
    self.result = [NSArray arrayWithArray:tempArray];
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(resultParserDidFinish:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate resultParserDidFinish:self];
        });
    }
}
@end
