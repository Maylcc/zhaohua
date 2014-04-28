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

@interface LCYAddProfileViewController ()
<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,NSXMLParserDelegate>

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (strong ,nonatomic) NSMutableString *xmlTempString;

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
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"上传照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照片",@"拍摄", nil];
    [actionSheet showInView:self.view];
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
    NSDate * date = [NSDate date];
    LCYLOG(@"date:%@",date);
    double time = [date timeIntervalSince1970];
    int timex = time/1;
    NSString * postTime = [NSString stringWithFormat:@"%d",timex];
    LCYLOG(@"postTime:%@",postTime);
    NSData *data = [LCYCommon compressImage:image];
//    NSString * postImage = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *postImage = [data base64EncodedString];
    self.myImageView.image = [UIImage imageWithData:data];
//    Byte *byte = (Byte *)[data bytes];
    
    
    [LCYCommon hideHUDFrom:self.view];
    
    if ([LCYCommon networkAvailable]) {
        [LCYCommon showHUDTo:self.view withTips:@"正在上传头像"];
        NSDictionary *parameter = @{@"fs":data,
                                    @"FileName":[[LCYRegisterGlobal sharedInstance].uid stringByAppendingPathExtension:@"jpg"]};
        LCYLOG(@"para:%@",parameter);
        [LCYCommon postRequestWithAPI:UploadFile parameters:parameter successDelegate:self failedBlock:^{
            LCYLOG(@"request failed!");
            [LCYCommon hideHUDFrom:self.view];
        }];
        
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
//    LCYSimpleCodeResult *result = [LCYSimpleCodeResult modelObjectWithDictionary:jsonResponse];
//    if (result.code == 0) {
//        // 验证成功
//        LCYAddProfileViewController *addVC = [[LCYAddProfileViewController alloc] init];
//        [self.navigationController pushViewController:addVC animated:YES];
//    } else {
//        // 验证失败
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"验证失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
//    }
}

@end
