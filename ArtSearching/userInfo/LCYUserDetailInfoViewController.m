//
//  LCYUserDetailInfoViewController.m
//  ArtSearching
//
//  Created by eagle on 14-5-9.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYUserDetailInfoViewController.h"
#import "LCYCommon.h"
#import "LCYGetUserInfoResultUser.h"
#import "LCYXMLDictionaryParser.h"
#import "ASIFormDataRequest.h"
#import "LCYXDTools.h"
#import "SoapXmlParseHelper.h"
#import "XDTools.h"
#import "Base64.h"

@interface LCYUserDetailInfoViewController ()<LCYXMLDictionaryParserDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL isLogoutBtnShow;/** <判断登出按钮是否显示 */
    CGPoint begainPoint;
    NSString *portal;
}
- (IBAction)changePhoneNum:(id)sender;
- (IBAction)changePassword:(id)sender;
- (IBAction)changePotal:(id)sender;
/**
 *  用户头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
/**
 *  用户姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
/**
 *  用户电话号码
 */
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

/**
 *  退出登陆按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

/**
 *  用户ID
 */
@property (strong, nonatomic) NSString *userID;
/**
 *  手机号码
 */
@property (strong, nonatomic) NSString *userPhoneNumber;
/**
 *  用户详细信息
 */
@property (strong, nonatomic) LCYGetUserInfoResultUser *userInfo;
@end

@implementation LCYUserDetailInfoViewController

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
    // 设置返回按键
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(userSettingBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    self.logoutButton.frame = CGRectMake(0, self.view.frame.size.height, self.logoutButton.frame.size.width, self.logoutButton.frame.size.height);
    // 取得用户ID和用户手机号码
    isLogoutBtnShow = NO;
    self.userID = [LCYCommon currentUserID];
    self.userPhoneNumber = [LCYCommon currentUserPhoneNumber];
    self.phoneNumberLabel.text = [NSString stringWithFormat:@"绑定手机：%@",[LCYCommon currentUserPhoneNumber]];
    
    [self loadRemoteData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions
- (void)userSettingBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)logoutButtonPressed:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:UserDefaultsIsLogin];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)loadRemoteData{
    if ([LCYCommon networkAvailable]) {
        [LCYCommon showHUDTo:self.view withTips:nil];
        NSDictionary *parameter = @{@"uid": self.userID};
        LCYXMLDictionaryParser *parser = [[LCYXMLDictionaryParser alloc] init];
        parser.delegate = self;
        [LCYCommon postRequestWithAPI:GetUserInfo parameters:parameter successDelegate:parser failedBlock:nil];
    } else {
        UIAlertView *networkUnabailableAlert = [[UIAlertView alloc] initWithTitle:@"无法找到网络" message:@"请检查您的网络连接状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [networkUnabailableAlert show];
    }
}

- (void)downloadAvatarImage{
    NSString *imageURL = self.userInfo.uheadurl;
    NSString *urlString = [[NSString stringWithFormat:@"%@",imageURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *imageFileName = self.userInfo.uheadurl;
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIImage *downImg = (UIImage *)responseObject;
        NSData *imageData = UIImageJPEGRepresentation(downImg, 1.0);
        [LCYCommon writeData:imageData toFilePath:[[LCYCommon renrenMainImagePath
                                                    ] stringByAppendingPathComponent:imageFileName]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.avatarImageView.image = [UIImage imageWithContentsOfFile:[[LCYCommon renrenMainImagePath] stringByAppendingPathComponent:imageFileName]];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LCYLOG(@"下载图片失败 error is %@",error);
    }];
    [requestOperation start];
}

#pragma mark - LCYXMLParser Delegate
- (void)didFinishGetXMLInfo:(NSDictionary *)info{
    self.userInfo = [LCYGetUserInfoResultUser modelObjectWithDictionary:info];
    self.userNameLabel.text = [NSString stringWithFormat:@"姓名：%@", self.userInfo.uname];
    [LCYCommon hideHUDFrom:self.view];
//    if ([LCYCommon isFileExistsAt:[[LCYCommon renrenMainImagePath] stringByAppendingPathComponent:self.userInfo.uheadurl]]) {
//        self.avatarImageView.image = [UIImage imageWithContentsOfFile:[[LCYCommon renrenMainImagePath] stringByAppendingPathComponent:self.userInfo.uheadurl]];
//    } else {
        [self downloadAvatarImage];
   // }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    begainPoint = [touch locationInView:self.view];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    if(currentPoint.y-10 > begainPoint.y)
    {
        [self showOrHideLogOutBtn];
    }
    else if(currentPoint.y < begainPoint.y-10)
    {
        [self showOrHideLogOutBtn];
    }
}



- (void)showOrHideLogOutBtn
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    if(isLogoutBtnShow)
    {
       self.logoutButton.frame = CGRectMake(0, self.view.frame.size.height, self.logoutButton.frame.size.width, self.logoutButton.frame.size.height);
        isLogoutBtnShow = NO;
    }
    else
    {
        self.logoutButton.frame = CGRectMake(0, self.view.frame.size.height-self.logoutButton.frame.size.height, self.logoutButton.frame.size.width, self.logoutButton.frame.size.height);
        isLogoutBtnShow = YES;
    }
    [UIView commitAnimations];
}

/**
 * 修改电话号码
 */
- (IBAction)changePhoneNum:(id)sender {
}

/**
 * 修改密码
 */
- (IBAction)changePassword:(id)sender {
}

/**
 * 修改头像
 */
- (IBAction)changePotal:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"上传照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        NSLog(@"0");
        [self selectHeadPortraitISCameral:YES];
    }
    else if (buttonIndex == 1)
    {
        NSLog(@"1");
        [self selectHeadPortraitISCameral:NO];
    }
    else
    {
        NSLog(@"2");
    }
}

- (void)selectHeadPortraitISCameral:(BOOL)isCamer
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = YES;
    if(isCamer)
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.delegate = self;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *data = UIImageJPEGRepresentation(image, 0.1);
    NSString *stringData = [data base64EncodedStringWithOptions:0];
    [self upLoadImage:image];
    NSLog(@"hello worl");
}

- (void)upLoadImage:(UIImage*)image
{
    //    [MobClick event:@"upload_image"];
    
    if (image ==nil) {
        return;
    }
    NSDate * date = [NSDate date];
    DDLOG(@"date:%@",date);
    double time = [date timeIntervalSince1970];
    int timex = time/1;
    NSString * postTime = [NSString stringWithFormat:@"%d",timex];
    DDLOG(@"postTime:%@",postTime);
    NSData *data = [XDTools compressImage:image];
    NSString * postImage = [data base64EncodedString];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:kMY_USER_ID];
    NSString * dataLength = [NSString stringWithFormat:@"%d",[data length]];
    DDLOG(@"dataLength:%@", dataLength);
    if ([XDTools NetworkReachable]){
        NSString *body = [NSString stringWithFormat:@" <UploadFile xmlns=\"http://tempuri.org/\">"
                          "<fs>%@</fs>"
                          "<FileName>%@</FileName>"
                          "</UploadFile>",postImage,[NSString stringWithFormat:@"%@.jpg",uid]];
        
        __weak ASIFormDataRequest *request = [XDTools postRequestWithDict:body API:UPLOADFILE];
        [request setCompletionBlock:^{
            [XDTools hideProgress:self.view];
            //[XDTools hideProgress:self.contentView];
            NSString *responseString = [request responseString];
            // NSDictionary *tempDic = [XDTools  JSonFromString:responseString];
            DDLOG(@"responseString:%@", responseString);
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            int statusCode = [request responseStatusCode];
            NSString *soapAction = [[request requestHeaders] objectForKey:@"SOAPAction"];
            
            NSArray *arraySOAP =[soapAction componentsSeparatedByString:@"/"];
            int count = [arraySOAP count] - 1;
            NSString *methodName = [arraySOAP objectAtIndex:count];
            
            // Use when fetching text data
            NSString *result = nil;
            if (statusCode == 200) {
                //表示正常请求
                result = [SoapXmlParseHelper SoapMessageResultXml:responseString ServiceMethodName:methodName];
                NSDictionary  *responseDict = [XDTools JSonFromString:result];
                DDLOG(@"respodic = %@",responseDict);
                if ([[responseDict objectForKey:@"code"] intValue]==0){
                    portal = [responseDict objectForKey:@"url"];
                    [self changeHeaderPic];
                }else{
                    [XDTools showTips:@"头像上传失败" toView:self.view];
                }
            }
        }];
        
        [request setFailedBlock:^{
            [XDTools hideProgress:self.view];
        }];
        
        [request startAsynchronous];
        [XDTools showProgress:self.view];
    }else{
        [XDTools showTips:brokenNetwork toView:self.view];
    }
    
    
    
}


-(void)changeHeaderPic{
    if ([XDTools NetworkReachable]){
        NSString *body = [NSString stringWithFormat:@" <ChangePortal xmlns=\"http://tempuri.org/\">"
                          "<uid>%@</uid>"
                          "<password>%@</password>"
                          "<portal>%@</portal>"
                          "</ChangePortal>",self.userID,[LCYCommon userPassword],portal];
        
        __weak ASIFormDataRequest *request = [XDTools postRequestWithDict:body API:CHANGEPORTAL];
        [request setCompletionBlock:^{
            [XDTools hideProgress:self.view];
            //[XDTools hideProgress:self.contentView];
            NSString *responseString = [request responseString];
            // NSDictionary *tempDic = [XDTools  JSonFromString:responseString];
            DDLOG(@"responseString:%@", responseString);
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            int statusCode = [request responseStatusCode];
            NSString *soapAction = [[request requestHeaders] objectForKey:@"SOAPAction"];
            
            NSArray *arraySOAP =[soapAction componentsSeparatedByString:@"/"];
            int count = [arraySOAP count] - 1;
            NSString *methodName = [arraySOAP objectAtIndex:count];
            
            // Use when fetching text data
            NSString *result = nil;
            if (statusCode == 200) {
                //表示正常请求
                result = [SoapXmlParseHelper SoapMessageResultXml:responseString ServiceMethodName:methodName];
                NSDictionary  *responseDict = [XDTools JSonFromString:result];
                DDLOG(@"respodic = %@",responseDict);
                if ([[responseDict objectForKey:@"code"] intValue]==0){
                    
                    [XDTools showTips:@"修改成功" toView:self.view];
                    
                }else{
                    [XDTools showTips:@"修改头像失败" toView:self.view];
                }
            }
        }];
        
        [request setFailedBlock:^{
            [XDTools hideProgress:self.view];
        }];
        
        [request startAsynchronous];
        [XDTools showProgress:self.view];
    }else{
        [XDTools showTips:brokenNetwork toView:self.view];
    }
    
}
@end
