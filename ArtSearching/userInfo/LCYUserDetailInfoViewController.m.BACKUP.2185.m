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
#import "TouchXML.h"
#import "InsertView.h"
#define NUMBERS @"0123456789\n"
@interface LCYUserDetailInfoViewController ()<LCYXMLDictionaryParserDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,InsertViewDoneDelegate>
{
    BOOL isLogoutBtnShow;/** <判断登出按钮是否显示 */
    CGPoint begainPoint;
    NSString *portal;
    UIImage  *selectImage;
    NSInteger changeUserInfoType;
    IBOutlet UIView *changeInfoView;
    __weak IBOutlet UILabel *changInfoViewTitle;
    __weak IBOutlet UILabel *changeInfoViewfirstItem;
    __weak IBOutlet UILabel *changInfoViewSecondItem;
    __weak IBOutlet UILabel *changeInfoViewThirdItem;
    __weak IBOutlet UITextField *firstText;
    __weak IBOutlet UITextField *secondText;
    __weak IBOutlet UITextField *thirdText;
    NSArray *allTextField;
}
@property (weak, nonatomic) IBOutlet UIButton *submitChangeInfo;
- (IBAction)hideChangeInfoView:(id)sender;
- (IBAction)changePhoneNum:(id)sender;
- (IBAction)changePassword:(id)sender;
- (IBAction)changePotal:(id)sender;
- (IBAction)hideKeyBoart:(id)sender;
/**
 *  用户头像
 */
- (IBAction)submitChang:(id)sender;
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
    allTextField = [NSArray arrayWithObjects:firstText,secondText,thirdText, nil];
    for(UITextField *text in allTextField)
    {
        text.delegate = self;
    }
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
    if ([LCYCommon isFileExistsAt:[[LCYCommon renrenMainImagePath] stringByAppendingPathComponent:self.userInfo.uheadurl]]) {
        self.avatarImageView.image = [UIImage imageWithContentsOfFile:[[LCYCommon renrenMainImagePath] stringByAppendingPathComponent:self.userInfo.uheadurl]];
    } else {
        [self downloadAvatarImage];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITextField *text in allTextField)
    {
        [text resignFirstResponder];
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    changeInfoView.frame = CGRectMake(0, self.view.frame.size.height-changeInfoView.frame.size.height, changeInfoView.frame.size.width, changeInfoView.frame.size.height);
    [UIView commitAnimations];
    UITouch *touch = [touches anyObject];
    
    begainPoint = [touch locationInView:self.view];
}

- (IBAction)hideKeyBoart:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    changeInfoView.frame = CGRectMake(0, self.view.frame.size.height-changeInfoView.frame.size.height, changeInfoView.frame.size.width, changeInfoView.frame.size.height);
    [UIView commitAnimations];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    if(currentPoint.y-10 > begainPoint.y)
    {
        isLogoutBtnShow = YES;
        [self showOrHideLogOutBtn];
    }
    else if(currentPoint.y < begainPoint.y-10)
    {
        isLogoutBtnShow = NO;
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
        
    }
    else
    {
        self.logoutButton.frame = CGRectMake(0, self.view.frame.size.height-self.logoutButton.frame.size.height, self.logoutButton.frame.size.width, self.logoutButton.frame.size.height);
        
    }
    [UIView commitAnimations];
}

/**
 * 修改电话号码
 */
- (IBAction)hideChangeInfoView:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeChangeInfoView)];
    changeInfoView.frame = CGRectMake(0, self.view.frame.size.height, changeInfoView.frame.size.width, changeInfoView.frame.size.height);
    [UIView commitAnimations];
}

- (void)removeChangeInfoView
{
    [changeInfoView removeFromSuperview];
}
#pragma mark - 修改密码、电话
- (IBAction)changePhoneNum:(id)sender
{
    [self changeUserInfoWithType:1];
}


/**
 * 修改密码
 */
- (IBAction)changePassword:(id)sender
{
    [self changeUserInfoWithType:0];
}

/**
 *修改个人信息
 *@param type 0代表修改密码，1代表修改电话.
 */
- (void)changeUserInfoWithType:(NSInteger)type
{
    changeInfoView.frame = CGRectMake(0, self.view.frame.size.height, changeInfoView.frame.size.width, changeInfoView.frame.size.height);
    if(type == 0)
    {
        changeUserInfoType = 0;
        firstText.secureTextEntry = YES;
        secondText.secureTextEntry = YES;
        thirdText.secureTextEntry  = YES;
        changInfoViewTitle.text      = @"修改密码";
        changeInfoViewfirstItem.text = @"请输入旧密码";
        changInfoViewSecondItem.text = @"请输入新密码";
        changeInfoViewThirdItem.text = @"在此输入新密码";
    }
    else
    {
        changeUserInfoType = 1;
        firstText.secureTextEntry = NO;
        thirdText.secureTextEntry = NO;
        secondText.secureTextEntry   = YES;
        changInfoViewTitle.text      = @"修改手机号";
        changeInfoViewfirstItem.text = @"请输入旧手机号";
        changInfoViewSecondItem.text = @"请输入密码";
        changeInfoViewThirdItem.text = @"在此输入新手机号";
    }
    [self.view addSubview:changeInfoView];
    for(UITextField *text in allTextField)
    {
        text.text = @"";
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    changeInfoView.frame = CGRectMake(0, self.view.frame.size.height-changeInfoView.frame.size.height, changeInfoView.frame.size.width, changeInfoView.frame.size.height);
    [UIView commitAnimations];
}

/*
    提交修改的内容
 */
- (IBAction)submitChang:(id)sender
{
    if(![LCYCommon networkAvailable])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有连接网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    for(UITextField *text in allTextField)
    {
        if(text.text.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息填写不完整" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    if(changeUserInfoType == 0)
    {
        if(![self checkValidate])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次密码输入的不一样" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
            
        }
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *request = [AFHTTPRequestOperationManager manager];
    request.responseSerializer = [AFXMLParserResponseSerializer serializer];
    NSString *urlString;
    NSDictionary *paramDic;
    if(changeUserInfoType == 0)
    {
        urlString = [NSString stringWithFormat:@"%@%@",hostForXM,changePassword];
        paramDic = [NSDictionary dictionaryWithObjectsAndKeys:[LCYCommon currentUserID],@"Uid",firstText.text,@"oldpw",thirdText.text,@"newpw", nil];
    }
    else
    {
        urlString = [NSString stringWithFormat:@"%@%@",hostForXM,changePhone];
        paramDic = [NSDictionary dictionaryWithObjectsAndKeys:self.userID,@"Uid",secondText.text,@"password",thirdText.text,@"newPhone",secondText.text,@"oldPhone", nil];
        
    }
    [request POST:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",[operation responseString]);
        CXMLDocument *document = [[CXMLDocument alloc] initWithData:[operation responseData] encoding:NSUTF8StringEncoding options:0 error:nil];
        CXMLElement *root = [document rootElement];
        NSString *jsonString = [root stringValue];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        if([(NSNumber *)[jsonDic objectForKey:@"code"] intValue] == 0)
        {
            NSLog(@"success");
            if(changeUserInfoType == 0)
            {
                [LCYCommon changeUserPassword:secondText.text];
            }
            else
            {
                
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            InsertView *insert = [[InsertView alloc] initWithMessage:@"修改成功" andSuperV:self.view withPoint:150];
            [insert setDelegate:self];
            [insert showMessageViewWithTime:2];
            [insert setAfterDoneSelector:@selector(hideChangeInfoView:)];
        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            InsertView *insert = [[InsertView alloc] initWithMessage:@"修改失败" andSuperV:self.view withPoint:150];
            [insert showMessageViewWithTime:1];
            NSLog(@"error");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}


/*
    检查修改的内容是不是合法
 */
- (BOOL)checkValidate
{
    if([secondText.text isEqualToString:thirdText.text])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/*
    用来键盘不挡住view的

 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if(IS_IPHONE5)
    {
        changeInfoView.frame = CGRectMake(0, self.view.frame.size.height-changeInfoView.frame.size.height-100, changeInfoView.frame.size.width, changeInfoView.frame.size.height);
    }
    else
    {
        if(textField == firstText)
        {
        
        }
        else
        {
            changeInfoView.frame = CGRectMake(0, self.view.frame.size.height-changeInfoView.frame.size.height-100, changeInfoView.frame.size.width, changeInfoView.frame.size.height);
        }
    }
    [UIView commitAnimations];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(changeUserInfoType == 1)
    {
        if(textField == secondText)
        {
            return YES;
        }
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            //当用户输入的不是数字时，提示用户要输入数字
            return NO;
        }
        else
        {
            return YES;
        }

    }
    else
    {
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

#pragma mark - 修改头像
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
    selectImage = image;
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
    
    NSString *uid = [LCYCommon currentUserID];
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
                    self.avatarImageView.image = selectImage;
                    NSString *imageFileName = self.userInfo.uheadurl;
                    [LCYCommon writeData:UIImageJPEGRepresentation(selectImage, 0.1) toFilePath:[[LCYCommon renrenMainImagePath] stringByAppendingPathComponent:imageFileName]];
                    
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
