//
//  LCYAddProfileViewController.m
//  ArtSearching
//
//  Created by Licy on 14-4-22.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYAddProfileViewController.h"
#import "LCYCommon.h"
#import "LCYRegisterGlobal.h"
#import "Base64.h"
#import "ASIFormDataRequest.h"
#import "LCYXDTools.h"
#import "SoapXmlParseHelper.h"
#import <AFNetworking/AFNetworking.h>
#import "LCYDataModels.h"

@interface LCYAddProfileViewController ()
<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,NSXMLParserDelegate>
{
    BOOL isAvatarUploaded;
}
@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (strong ,nonatomic) NSMutableString *xmlTempString;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;


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
    isAvatarUploaded = NO;
    
    // 设置返回按键
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(step3Back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    // 设置光标颜色
    self.nameTextField.tintColor = [UIColor whiteColor];
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
    if (!self.nameTextField.text ||
        self.nameTextField.text.length == 0) {
        UIAlertView *emptyTextAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入您的用户名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [emptyTextAlert show];
    } else {
        if ([LCYCommon networkAvailable]) {
            LCYLOG(@"uid:%@",[LCYRegisterGlobal sharedInstance].uid);
            LCYLOG(@"pwd:%@",[LCYRegisterGlobal sharedInstance].password);
            LCYLOG(@"phoneNumber:%@",[LCYRegisterGlobal sharedInstance].phoneNumber);
            NSMutableDictionary *tparameter = [NSMutableDictionary dictionaryWithDictionary:@{@"Uid":[LCYRegisterGlobal sharedInstance].uid,
                                                                                              @"pwd":[LCYRegisterGlobal sharedInstance].password,
                                                                                              @"phone":[LCYRegisterGlobal sharedInstance].phoneNumber,
                                                                                              @"username":self.nameTextField.text}];
            if (isAvatarUploaded) {
                [tparameter setObject:[LCYRegisterGlobal sharedInstance].avatarURL forKey:@"portal"];
            }
            NSDictionary *parameter = [NSDictionary dictionaryWithDictionary:tparameter];
            LCYLOG(@"%@",parameter);
            [LCYCommon postRequestWithAPI:RegisterThree parameters:parameter successDelegate:self failedBlock:^{
                LCYLOG(@"failed request");
            }];
        } else {
            UIAlertView *networkUnabailableAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"网络连接不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [networkUnabailableAlert show];
        }
    }
}
/**
 *  添加头像
 *
 *  @param sender 按钮
 */
- (IBAction)avatarButtonPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"上传照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照片",@"拍摄", nil];
    [actionSheet showInView:self.view];
}

/**
 *  显示头像上传失败提示框
 */
- (void)showFaultAlert{
    UIAlertView *faultAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"头像上传失败，请检查网络连接后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [faultAlert show];
}

#pragma mark - UIActionSheet Delegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self selectIncameraAction];
    } else if (buttonIndex == 0){
        [self selectInPhotoAlbumAction];
    }
}

//从本地相机选取图片
- (void)selectInPhotoAlbumAction
{
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.navigationBar.tintColor = [UIColor blackColor];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.imagePicker.allowsEditing = YES;
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

//照相选取图片
- (void)selectIncameraAction
{
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.navigationBar.tintColor = [UIColor blackColor];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.imagePicker.allowsEditing = YES;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerController Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    UIImage *avatarImage = [info objectForKey:UIImagePickerControllerEditedImage];
    self.avatarImageView.image = avatarImage;
    [self uploadAvatar:avatarImage];
}

- (void)uploadAvatar:(UIImage *)image{
    [LCYCommon showHUDTo:self.view withTips:@"正在压缩头像"];
    NSData *data = [LCYCommon compressImage:image];
    NSString *postImage = [data base64EncodedString];
    
    [LCYCommon hideHUDFrom:self.view];
    
    if ([LCYCommon networkAvailable]) {
        [LCYCommon showHUDTo:self.view withTips:@"正在上传头像"];
        
        NSString *body = [NSString stringWithFormat:@" <UploadFile xmlns=\"http://tempuri.org/\">"
                          "<fs>%@</fs>"
                          "<FileName>%@</FileName>"
                          "</UploadFile>",postImage,[NSString stringWithFormat:@"%@.jpg",[LCYRegisterGlobal sharedInstance].uid]];
        __weak ASIFormDataRequest *request = [LCYXDTools postRequestWithDict:body API:UploadFile];
        [request setCompletionBlock:^{
            [LCYCommon hideHUDFrom:self.view];
            NSString *responseString = [request responseString];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            int statusCode = [request responseStatusCode];
            NSString *soapAction = [[request requestHeaders] objectForKey:@"SOAPAction"];
            
            NSArray *arraySOAP =[soapAction componentsSeparatedByString:@"/"];
            int count = [arraySOAP count] - 1;
            NSString *methodName = [arraySOAP objectAtIndex:count];
            NSString *result = nil;
            if (statusCode == 200) {
                result = [SoapXmlParseHelper SoapMessageResultXml:responseString ServiceMethodName:methodName];
                NSDictionary  *responseDict = [LCYXDTools JSonFromString:result];
                if ([[responseDict objectForKey:@"code"] intValue]==0){
                    NSString *portal = [responseDict objectForKey:@"url"];
                    [LCYRegisterGlobal sharedInstance].avatarURL = portal;
                    isAvatarUploaded = YES;
                }else{
                    [self showFaultAlert];
                }
            }
        }];
        
        [request setFailedBlock:^{
            [LCYCommon hideHUDFrom:self.view];
            [self showFaultAlert];
        }];
        
        [request startAsynchronous];
    } else {
        UIAlertView *networkUnabailableAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"网络连接不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [networkUnabailableAlert show];
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
    LCYLOG(@"json:%@",jsonResponse);
    [LCYCommon hideHUDFrom:self.view];
    LCYRegisterOneResult *result_t = [LCYRegisterOneResult modelObjectWithDictionary:jsonResponse];
    if (result_t.code == 0) {
        // 验证成功
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:YES forKey:UserDefaultsIsLogin];
        [userDefaults setObject:[NSString stringWithFormat:@"%.f",result_t.uid] forKey:UserDefaultsUserId];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        // 验证失败
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"用户名已经被其他人注册，请您更换" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

@end
