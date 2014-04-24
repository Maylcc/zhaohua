//
//  LCYRegisterStep1ViewController.m
//  ArtSearching
//
//  Created by 李超逸 on 14-4-22.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYRegisterStep1ViewController.h"
#import <CoreText/CoreText.h>

@interface LCYRegisterStep1ViewController ()
/**
 *  用已有账号登录
 */
@property (weak, nonatomic) IBOutlet UILabel *haveAccountLabel;

@end

@implementation LCYRegisterStep1ViewController

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
    [backBtn addTarget:self action:@selector(registerStepOneBackToParent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    // 设置新用户注册标签下划线
    NSMutableAttributedString *labelTextString = [[NSMutableAttributedString alloc] initWithString:@"用已有账号登录"];
    [labelTextString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:(NSRange){0,[labelTextString length]}];
    [self.haveAccountLabel setAttributedText:labelTextString];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (void)registerStepOneBackToParent{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  已有账号登录
 *
 *  @param sender 按钮
 */
- (IBAction)haveAccountButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  继续
 *
 *  @param sender 按钮
 */
- (IBAction)continueButtonPressed:(id)sender {
}

@end
