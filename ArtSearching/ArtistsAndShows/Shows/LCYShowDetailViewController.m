//
//  LCYShowDetailViewController.m
//  ArtSearching
//
//  Created by eagle on 14-5-16.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYShowDetailViewController.h"
#import "LCYGetGalleryInfoByID.h"
#import "LCYCommon.h"
#import "LCYXMLDictionaryParser.h"
#import "LCYShowDetailLine1TableViewCell.h"
#import "LCYShowDetailLine2TableViewCell.h"
#import "LCYShowDetailLine3TableViewCell.h"

@interface LCYShowDetailViewController ()<UITableViewDelegate,UITableViewDataSource,LCYXMLDictionaryParserDelegate>
{
    BOOL isLine1NibRegistered;
    BOOL isLine2NibRegistered;
    BOOL isLine3NibRegistered;
}
/**
 *  主界面数据列表
 */
@property (weak, nonatomic) IBOutlet UITableView *icyTableView;
/**
 *  画廊详细信息，由服务器加载
 */
@property (strong, nonatomic) LCYGetGalleryInfoByIDGalleryInfo *galleryInfo;

@end

@implementation LCYShowDetailViewController

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
    isLine1NibRegistered = NO;
    isLine2NibRegistered = NO;
    isLine3NibRegistered = NO;
    
    // 设置返回按键
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToParent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    // 加载完数据前，隐藏主界面
    [self.icyTableView setHidden:YES];
    [self loadRemoteData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (void)reloadTableView{
    [self.icyTableView reloadData];
}

- (void)loadRemoteData{
    if ([LCYCommon networkAvailable]) {
        [LCYCommon showHUDTo:self.view withTips:nil];
        NSDictionary *parameter = @{@"id": [NSNumber numberWithInteger:[self.galleryID integerValue]]};
        LCYXMLDictionaryParser *parser = [[LCYXMLDictionaryParser alloc] init];
        parser.delegate = self;
        [LCYCommon postRequestWithAPI:GetGalleryInfoById parameters:parameter successDelegate:parser failedBlock:^{
            [LCYCommon hideHUDFrom:self.view];
            UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"数据加载失败，请检查网络状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [failAlert show];
        }];
    } else {
        UIAlertView *networkUnabailableAlert = [[UIAlertView alloc] initWithTitle:@"无法找到网络" message:@"请检查您的网络连接状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [networkUnabailableAlert show];
    }
}

- (void)backToParent{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - LCYXMLDictionaryParser Delegate
- (void)didFinishGetXMLInfo:(NSDictionary *)info{
    self.galleryInfo = [LCYGetGalleryInfoByIDGalleryInfo modelObjectWithDictionary:info];
    [self.icyTableView setHidden:NO];
    [self reloadTableView];
    [LCYCommon hideHUDFrom:self.view];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.galleryInfo) {
        return 0;
    } else {
        return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 141;
    }
    if (indexPath.row == 1) {
        return 44;
    }
    if (indexPath.row == 2) {
        return 100;
    }
    if (indexPath.row == 3) {
        return 44;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        // 第一行，显示展会LOGO，名称和地点
        static NSString *identifier0 = @"LCYShowDetailLine1TableViewCellIdentifier";
        if (!isLine1NibRegistered) {
            UINib *nib = [UINib nibWithNibName:@"LCYShowDetailLine1TableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:identifier0];
            isLine1NibRegistered = YES;
        }
        LCYShowDetailLine1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier0];
        cell.galleryNameLabel.text = self.galleryInfo.gallery.name;
        cell.galleryPlaceLabel.text = self.galleryInfo.gallery.city;
        return cell;
    } else if (indexPath.row == 1) {
        // 第二行，显示关注和分享按钮
        static NSString *identifier1 = @"LCYShowDetailLine2TableViewCellIdentifier";
        if (!isLine2NibRegistered) {
            UINib *nib = [UINib nibWithNibName:@"LCYShowDetailLine2TableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:identifier1];
            isLine2NibRegistered = YES;
        }
        LCYShowDetailLine2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        return cell;
    } else if (indexPath.row == 2) {
        // 第三行，显示详细信息
        static NSString *identifier2 = @"LCYShowDetailLine3TableViewCellIdentifier";
        if (!isLine3NibRegistered) {
            UINib *nib = [UINib nibWithNibName:@"LCYShowDetailLine3TableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:identifier2];
            isLine3NibRegistered = YES;
        }
        LCYShowDetailLine3TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        cell.icyTextView.text = self.galleryInfo.gallery.brief;
        return cell;
    } else if (indexPath.row == 3) {
        // 第四行，显示作品个数
        static NSString *identifier3 = @"LCYShowDetailLine4TableViewCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier3];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = [NSString stringWithFormat:@"作品(%.f)", self.galleryInfo.gallery.workCount];
        return cell;
    }
    return nil;
}

@end
