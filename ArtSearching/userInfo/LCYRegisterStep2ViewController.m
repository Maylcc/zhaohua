//
//  LCYRegisterStep2ViewController.m
//  ArtSearching
//
//  Created by Licy on 14-4-22.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYRegisterStep2ViewController.h"

@interface LCYRegisterStep2ViewController ()
/**
 *  请输入密码
 */
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
/**
 *  再次输入密码
 */
@property (weak, nonatomic) IBOutlet UITextField *checkPasswordTextField;
@end

@implementation LCYRegisterStep2ViewController

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
    [backBtn addTarget:self action:@selector(step2Back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (void)step2Back{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  完成
 *
 *  @param sender 按钮
 */
- (IBAction)doneButtonPressed:(id)sender {
}

@end
