//
//  LCYRegisterViewController.m
//  ArtSearching
//
//  Created by 李超逸 on 14-4-21.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYRegisterViewController.h"
#import <CoreText/CoreText.h>
#import "LCYRegisterStep1ViewController.h"
#import "LCYCommon.h"
#import "LCYDataModels.h"

@interface LCYRegisterViewController ()
<NSXMLParserDelegate>
{
    NSString *phoneNumber;
    NSString *password;
}

/**
 *  新用户注册
 */
@property (weak, nonatomic) IBOutlet UILabel *registerLabel;
/**
 *  忘记密码
 */
@property (weak, nonatomic) IBOutlet UILabel *forgetPWLabel;
/**
 *  账号
 */
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
/**
 *  密码
 */
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) NSMutableString *xmlTempString;

@end

@implementation LCYRegisterViewController

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
    [backBtn addTarget:self action:@selector(registerBackToParent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    // 设置新用户注册标签下划线
    NSMutableAttributedString *labelTextString = [[NSMutableAttributedString alloc] initWithString:@"新用户注册"];
    [labelTextString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:(NSRange){0,[labelTextString length]}];
    [self.registerLabel setAttributedText:labelTextString];
    // 设置忘记密码标签下划线
    NSMutableAttributedString *labelTextString2 = [[NSMutableAttributedString alloc] initWithString:@"忘记密码"];
    [labelTextString2 addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:(NSRange){0,[labelTextString2 length]}];
    [self.forgetPWLabel setAttributedText:labelTextString2];
    
    // 设置光标颜色
    self.userNameTextField.tintColor = [UIColor whiteColor];
    self.passwordTextField.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getLaunchData{
    NSDictionary *parameters = @{@"phone": self.userNameTextField.text,
                                 @"password": self.passwordTextField.text};
    phoneNumber = self.userNameTextField.text;
    password = self.passwordTextField.text;
    if ([LCYCommon networkAvailable]) {
        [LCYCommon postRequestWithAPI:Login parameters:parameters successDelegate:self failedBlock:^{
            // TODO:处理网络错误
        }];
    } else {
        UIAlertView *networkUnabailableAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"网络连接不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [networkUnabailableAlert show];
    }
    
}

#pragma mark - Actions
- (void)registerBackToParent{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  登录
 *
 *  @param sender 按钮
 */
- (IBAction)loginButtonPressed:(id)sender {
    NSLog(@"登录");
    if (self.userNameTextField.text.length == 0 || self.passwordTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"用户名和密码不能为空"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alert show];
    } else {
        [self getLaunchData];
    }
}
/**
 *  新用户注册
 *
 *  @param sender 按钮
 */
- (IBAction)registerButtonPressed:(id)sender {
    LCYRegisterStep1ViewController *vc = [[LCYRegisterStep1ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 *  忘记密码
 *
 *  @param sender 按钮
 */
- (IBAction)forgetPWButtonPressed:(id)sender {
}

- (IBAction)backgroundTouchDown:(id)sender {
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}


#pragma mark - UITextField Delegate Methods
- (IBAction)textFieldDidEndOnExit:(id)sender{
    UITextField *textField = sender;
    if (textField == self.userNameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [self.passwordTextField resignFirstResponder];
        [self performSelector:@selector(loginButtonPressed:) withObject:nil];
    }
}

#pragma mark - NSXMLParser Delegate Methods
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
    LCYLoginResult *loginResult = [LCYLoginResult modelObjectWithDictionary:jsonResponse];
    if (loginResult.code!=0) {
        UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"登录失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [failedAlert show];
    } else {
        NSString *userID = [NSString stringWithFormat:@"%.f",loginResult.uid];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:YES forKey:UserDefaultsIsLogin];
        [userDefaults setObject:userID forKey:UserDefaultsUserId];
        [userDefaults setObject:phoneNumber forKey:UserDefaultsUserPhone];
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end
