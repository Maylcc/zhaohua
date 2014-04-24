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
#import "LCYDataModels.h"
#import "LCYRenrenTableViewCell.h"
#import "LCYBuildExhibitionViewController.h"
#import "LCYRegisterViewController.h"
#import "LCYUserInformationViewController.h"

#define RenrenGreen colorWithRed:101.0/255 green:151.0/255 blue:49.0/255 alpha:1

@interface LCYRenrenViewController ()
<NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

typedef NS_ENUM(NSInteger, LCYRenrenSegStatus){
    LCYRenrenSegStatusAll,      /**< 所有展览 */
    LCYRenrenSegStatusMine      /**< 我的展览 */
};
/**
 *  用于解析XML时的缓存
 */
@property (strong, nonatomic) NSMutableString *xmlTempString;

/**
 *  XML解析结果
 */
@property (strong, nonatomic) LCYActivityListBase *activityListBase;

@end

@interface LCYRenrenViewController ()
{
    LCYRenrenSegStatus currentStatus;
    BOOL isRenrenTableViewCellRegistered;
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
    // Do any additional setup after loading the view from its nib.
    // 添加数据凶猛按钮
    UIBarButtonItem *leftNaviButton = [[UIBarButtonItem alloc] initWithCustomView:self.dataFerocious];
    self.navigationItem.leftBarButtonItem = leftNaviButton;
    
    currentStatus = LCYRenrenSegStatusAll;
    isRenrenTableViewCellRegistered = NO;
    
    [self loadExData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadExData{
    [LCYCommon postRequestWithAPI:ActivityList parameters:nil successDelegate:self failedBlock:^{
        // TODO:加载数据失败
    }];
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
            [self.navigationController pushViewController:userVC animated:YES];
        }
    }
}

/**
 *  我要策展
 *
 *  @param sender button
 */
- (IBAction)iWantButtonPressed:(id)sender {
    NSLog(@"我要策展");
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
    if (currentStatus == LCYRenrenSegStatusAll) {
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
    self.activityListBase = [LCYActivityListBase modelObjectWithDictionary:jsonResponse];
    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
}

#pragma mark - UITableView Data Source and Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (currentStatus == LCYRenrenSegStatusAll) {
        if (!self.activityListBase) {
            return 0;
        }
        return [self.activityListBase.activityList count];
    } else{
        return 1+0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"renrenTableViewIdentifier";         /**< 所有展览 */
    static NSString *identifier2 = @"renrenTableViewIdentifier2";       /**< 我的展览请求 */
    static NSString *identifier3 = @"renrenTableViewIdentifier3";       /**< 我的展览 */
    
    if (currentStatus == LCYRenrenSegStatusAll) {
        if (!isRenrenTableViewCellRegistered) {
            UINib *nib = [UINib nibWithNibName:@"LCYRenrenTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:identifier];
            isRenrenTableViewCellRegistered = YES;
        }
        LCYRenrenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        return cell;
    } else {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
            cell.textLabel.text = @"1231";
            return cell;
        }
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (currentStatus == LCYRenrenSegStatusMine) {
        if (indexPath.row == 0) {
            return 44;
        }
    }
    return 420.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"select row at row: %ld",(long)indexPath.row);
}

#pragma mark - UISearchBar Delegate Methods
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

@end
