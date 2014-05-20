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


@interface LCYUserDetailInfoViewController ()<LCYXMLDictionaryParserDelegate>
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
    
    // 取得用户ID和用户手机号码
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
    if ([LCYCommon isFileExistsAt:[[LCYCommon renrenMainImagePath] stringByAppendingPathComponent:self.userInfo.uheadurl]]) {
        self.avatarImageView.image = [UIImage imageWithContentsOfFile:[[LCYCommon renrenMainImagePath] stringByAppendingPathComponent:self.userInfo.uheadurl]];
    } else {
        [self downloadAvatarImage];
    }
}

@end
