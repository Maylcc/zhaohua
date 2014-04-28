//
//  LCYRegisterStep1ViewController.m
//  ArtSearching
//
//  Created by 李超逸 on 14-4-22.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYRegisterStep1ViewController.h"
#import <CoreText/CoreText.h>
#import "LCYCommon.h"
#import "LCYDataModels.h"
#import "LCYRegisterStep2ViewController.h"
#import "LCYRegisterGlobal.h"

@interface LCYRegisterStep1ViewController ()
typedef NS_ENUM(NSInteger, StepOneStatus){
    StepOneGetValidationNumber,         /**< 发送请求，获取验证码 */
    StepOneSendValidationNumber         /**< 发送验证码 */
};
@end

@interface LCYRegisterStep1ViewController ()
<NSXMLParserDelegate, UITextFieldDelegate>
{
    BOOL isValidated;
    StepOneStatus currentStatus;        /**< 当前状态，用于区分解析的xml格式 */
}
/**
 *  用已有账号登录
 */
@property (weak, nonatomic) IBOutlet UILabel *haveAccountLabel;
/**
 *  手机号码
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
/**
 *  验证码
 */
@property (weak, nonatomic) IBOutlet UITextField *validationCodeTextField;
/**
 *  XML字符串缓存
 */
@property (strong, nonatomic) NSMutableString *xmlTempString;
/**
 *  验证码
 */
@property (strong, nonatomic) NSString *validationCodeString;
/**
 *  获取验证码按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *validationGetButton;
/**
 *  背景，用于界面上移和下移
 */
@property (weak, nonatomic) IBOutlet UIView *backgroundView;


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
    isValidated = NO;
    currentStatus = StepOneGetValidationNumber;
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
    
    // 设置光标颜色
    self.phoneNumber.tintColor = [UIColor whiteColor];
    self.validationCodeTextField.tintColor = [UIColor whiteColor];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  检查字符串是否为手机号码
 *
 *  @param str 字符串
 *
 *  @return 是或否
 */
- (BOOL)checkPhoneIsNum:(NSString *)str{
    [NSCharacterSet decimalDigitCharacterSet];
    
    if ([str stringByTrimmingCharactersInSet: [NSCharacterSet decimalDigitCharacterSet]].length >0) {
        // 不是纯数字
        return NO;
    }else{
        if ([str length] == 11) {
            return YES;
        }else{
            return NO;
        }
    }
}

- (void)cancelPan{
    CGRect frame = self.backgroundView.frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.backgroundView setFrame:frame];
    }];
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
    if (isValidated) {
        if ([self.validationCodeString isEqualToString:self.validationCodeTextField.text]) {
            currentStatus = StepOneSendValidationNumber;
            // 发送验证请求
            NSDictionary *parameter = @{@"phone": self.phoneNumber.text,
                                        @"validate":self.validationCodeTextField.text};
            if ([LCYCommon networkAvailable]) {
                [LCYCommon postRequestWithAPI:RegisterOne parameters:parameter successDelegate:self failedBlock:^{
                    LCYLOG(@"failed request");
                }];
            } else {
                UIAlertView *networkUnabailableAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"网络连接不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [networkUnabailableAlert show];
            }
        } else {
            UIAlertView *wrongValidation = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入正确的验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [wrongValidation show];
        }
    } else {
        UIAlertView *wrongValidation = [[UIAlertView alloc] initWithTitle:@"" message:@"请先获取验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [wrongValidation show];
    }
}
/**
 *  获取验证码
 *
 *  @param sender 按钮
 */
- (IBAction)getValidationCode:(id)sender {
    self.validationGetButton.enabled = NO;
    if (self.phoneNumber.text.length>0) {
        if ([self checkPhoneIsNum:self.phoneNumber.text]) {
            currentStatus = StepOneGetValidationNumber;
            NSDictionary *parameter = @{@"telno": self.phoneNumber.text};
            if ([LCYCommon networkAvailable]) {
                [LCYCommon postRequestWithAPI:RegisterGetValidate parameters:parameter successDelegate:self failedBlock:^{
                    LCYLOG(@"request failed");
                    self.validationGetButton.enabled = YES;
                }];
            } else {
                UIAlertView *networkUnabailableAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"网络连接不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [networkUnabailableAlert show];
            }
        } else {
            UIAlertView *faultPhoneNumber = [[UIAlertView alloc] initWithTitle:@"" message:@"请您输入正确的手机号码。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [faultPhoneNumber show];
        }
    } else {
        UIAlertView *noPhoneNumberAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"请您输入手机号码。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [noPhoneNumberAlert show];
    }
}

- (IBAction)textFieldDidEndOnExit:(id)sender{
    UITextField *textField = sender;
    if (textField == self.phoneNumber) {
        [self.phoneNumber resignFirstResponder];
    } else if(textField == self.validationCodeTextField){
        [self.validationCodeTextField resignFirstResponder];
        [self cancelPan];
    }
}

- (IBAction)backgroundTouched:(id)sender {
    [self.validationCodeTextField resignFirstResponder];
    [self.phoneNumber resignFirstResponder];
    [self cancelPan];
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
    if (currentStatus == StepOneGetValidationNumber) {
        LCYRegisterGetValidateResult *result = [LCYRegisterGetValidateResult modelObjectWithDictionary:jsonResponse];
        if (result.code!=0) {
            // 验证失败
            UIAlertView *faultAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"验证失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [faultAlert show];
        } else {
            isValidated = YES;
            self.validationCodeString = result.vcode;
            LCYLOG(@"validation:%@",result.vcode);
        }
        self.validationGetButton.enabled = YES;
    } else if (currentStatus == StepOneSendValidationNumber){
        LCYRegisterOneResult *stepOneResult = [LCYRegisterOneResult modelObjectWithDictionary:jsonResponse];
//        LCYLoginResult *loginResult = [LCYLoginResult modelObjectWithDictionary:jsonResponse];
        if (stepOneResult.code == 0) {
            [LCYRegisterGlobal sharedInstance].uid = [NSString stringWithFormat:@"%.f",stepOneResult.uid];
            [LCYRegisterGlobal sharedInstance].phoneNumber = self.phoneNumber.text;
            LCYRegisterStep2ViewController *step2VC = [[LCYRegisterStep2ViewController alloc] init];
            [self.navigationController pushViewController:step2VC animated:YES];
        } else {
            UIAlertView *faultAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"验证失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [faultAlert show];
        }
    }
    
}
#pragma mark - UITextField Delegate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGRect frame = self.backgroundView.frame;
    frame.origin.y = -50;
    [UIView animateWithDuration:0.3 animations:^{
        [self.backgroundView setFrame:frame];
    }];
    return YES;
}
@end
