//
//  LCYSearchingListViewController.m
//  ArtSearching
//
//  Created by eagle on 14-5-9.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYSearchingListViewController.h"
#import "LCYCommon.h"
#import "LCYRegisterViewController.h"
#import "LCYUserInformationViewController.h"
#import "LCYAppDelegate.h"
#import "LCYRenrenViewController.h"
#import "LCYArtistsAndShowsViewController.h"

@interface LCYSearchingListViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *icySearchBar;

@end

@implementation LCYSearchingListViewController

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
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            userVC.title = @"个人信息";
            [self.navigationController setNavigationBarHidden:NO];
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
    if (item.tag == 2) {
        // 艺术家、画廊
        LCYAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        LCYArtistsAndShowsViewController *twoVC = [[LCYArtistsAndShowsViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:twoVC];
        [appDelegate.window setRootViewController:nav];
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.icySearchBar resignFirstResponder];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

@end
