//
//  ArtDetailCommentViewController.m
//  ArtSearching
//
//  Created by developer on 14-5-19.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ArtDetailCommentViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "LCYCommon.h"
#import "MBProgressHUD.h"
#import "InsertView.h"
#import "NetConnect.h"
@interface ArtDetailCommentViewController ()<InsertViewDoneDelegate>
{
    InsertView *insertView;
    NetConnect *netConnect;
}
@end

@implementation ArtDetailCommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        netConnect = [NetConnect sharedSelf];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    commentText.delegate = self;
    commentText.textColor = [UIColor blackColor];
    self.placeLabel.textColor = [UIColor grayColor];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 40)];
    self.title = @"数据凶猛";
    [backBtn setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(submitComment)];
    rightBtn.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    insertView = [[InsertView alloc] initWithMessage:@"提交成功" andSuperV:self.view withPoint:200];
    [insertView setAfterDoneSelector:@selector(backView)];
    insertView.delegate = self;
        // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length > 0)
    {
        self.placeLabel.text = @"";
    }
    else
    {
        self.placeLabel.text = @"感觉怎么样?留几句言吧";
    }
}

- (void)submitComment
{
    if(commentText.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",hostForXM,addCom];
    NSString *userid = [LCYCommon currentUserID];
    NSString *workID = self.workID;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userid,@"uid",workID,@"picid",commentText.text,@"comtxt", nil];
    AFHTTPRequestOperationManager *request = [AFHTTPRequestOperationManager manager];
    request.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [request POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [netConnect obtainStartArtDetailInfo:self.workID];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        InsertView *insert = [[InsertView alloc] initWithMessage:@"提交成功" andSuperV:self.view withPoint:150];
        insert.delegate = self;
        [insert setAfterDoneSelector:@selector(backView)];
        [insert showMessageViewWithTime:2];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
}

- (void)backView
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
