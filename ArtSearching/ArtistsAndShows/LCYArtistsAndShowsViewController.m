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

@interface LCYArtistsAndShowsViewController ()

/**
 *  艺术家按钮
 */
@property (strong, nonatomic) IBOutlet UIControl *artistNavigationButton;
/**
 *  画廊按钮
 */
@property (strong, nonatomic) IBOutlet UIControl *showsNavigationButton;

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
    // 添加导航栏按钮（艺术家、画廊）
    UIBarButtonItem *leftNaviButton = [[UIBarButtonItem alloc] initWithCustomView:self.artistNavigationButton];
    UIBarButtonItem *rightNaviButton = [[UIBarButtonItem alloc] initWithCustomView:self.showsNavigationButton];
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
    if (item.tag == 1) {
        // 人人策画
        LCYAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        LCYRenrenViewController *oneVC = [[LCYRenrenViewController alloc] init];
        oneVC.title = @"人人策画";
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:oneVC];
        [appDelegate.window setRootViewController:nav];
    }
}

@end
