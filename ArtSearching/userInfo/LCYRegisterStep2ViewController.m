//
//  LCYRegisterStep2ViewController.m
//  ArtSearching
//
//  Created by Licy on 14-4-22.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYRegisterStep2ViewController.h"
#import "LCYDataModels.h"
#import "LCYRegisterGlobal.h"
#import "LCYCommon.h"
#import "LCYAddProfileViewController.h"

@interface LCYRegisterStep2ViewController ()
<NSXMLParserDelegate>
/**
 *  请输入密码
 */
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
/**
 *  再次输入密码
 */
@property (weak, nonatomic) IBOutlet UITextField *checkPasswordTextField;
/**
 *  背景，用于上下移动
 */
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

/**
 *  xml解析结果
 */
@property (strong, nonatomic) NSMutableString *xmlTempString;
/**
 *  密码
 */
@property (strong, nonatomic) NSString *password;

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
    
    // 设置光标颜色
    self.passwordTextField.tintColor = [UIColor whiteColor];
    self.checkPasswordTextField.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)checkPassword{
    if (self.passwordTextField.text.length == 0 ||
        self.checkPasswordTextField.text.length == 0) {
        UIAlertView *noneBlankAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [noneBlankAlert show];
        return NO;
    }
    if ([self.passwordTextField.text isEqualToString:self.checkPasswordTextField.text]) {
        return YES;
    }
    UIAlertView *differentPWAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"两次密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [differentPWAlert show];
    return NO;
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
    if ([self checkPassword]){
        self.password = self.passwordTextField.text;
        // 发送验证码
        NSString *uid = [LCYRegisterGlobal sharedInstance].uid;
        NSString *phone = [LCYRegisterGlobal sharedInstance].phoneNumber;
        NSDictionary *parameter = @{@"Uid": uid,
                                    @"phone": phone,
                                    @"pwd": self.passwordTextField.text};
        if ([LCYCommon networkAvailable]) {
            [LCYCommon postRequestWithAPI:RegisterTwo parameters:parameter successDelegate:self failedBlock:^{
                LCYLOG(@"failed request");
            }];
        } else {
            UIAlertView *networkUnabailableAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"网络连接不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [networkUnabailableAlert show];
        }
    }
}
- (IBAction)backgroundTouchDown:(id)sender {
    [self.passwordTextField resignFirstResponder];
    [self.checkPasswordTextField resignFirstResponder];
}

- (IBAction)textFieldDidEndOnExit:(id)sender{
    UITextField *textField = sender;
    if (textField == self.passwordTextField) {
        [self.passwordTextField resignFirstResponder];
        [self.checkPasswordTextField becomeFirstResponder];
    } else if (textField == self.checkPasswordTextField) {
        [self.checkPasswordTextField resignFirstResponder];
    }
}

#pragma mark - NSXMLParserDelegate Methods
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
    LCYSimpleCodeResult *result = [LCYSimpleCodeResult modelObjectWithDictionary:jsonResponse];
    if (result.code == 0) {
        // 验证成功
        [LCYRegisterGlobal sharedInstance].password = self.password;
        LCYAddProfileViewController *addVC = [[LCYAddProfileViewController alloc] init];
        [self.navigationController pushViewController:addVC animated:YES];
    } else {
        // 验证失败
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"验证失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

@end
