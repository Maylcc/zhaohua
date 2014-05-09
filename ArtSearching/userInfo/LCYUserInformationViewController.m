//
//  LCYUserInformationViewController.m
//  ArtSearching
//
//  Created by Licy on 14-4-22.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYUserInformationViewController.h"
#import "LCYUserDetailInfoViewController.h"

@interface LCYUserInformationViewController ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
@end
