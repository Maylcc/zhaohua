//
//  LCYAddProfileViewController.m
//  ArtSearching
//
//  Created by Licy on 14-4-22.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYAddProfileViewController.h"

@interface LCYAddProfileViewController ()

@end

@implementation LCYAddProfileViewController

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
    [backBtn addTarget:self action:@selector(step3Back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (void)step3Back{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  开始使用
 *
 *  @param sender 按钮
 */
- (IBAction)startUsingAppButtonPressed:(id)sender {
    
}
/**
 *  添加头像
 *
 *  @param sender 按钮
 */
- (IBAction)avatarButtonPressed:(id)sender {
}

@end
