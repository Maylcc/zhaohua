//
//  LCYArtistDetailViewController.m
//  ArtSearching
//
//  Created by eagle on 14-5-12.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYArtistDetailViewController.h"
#import "LCYCommon.h"
#import "LCYDataModels.h"
#import "LCYArtistDetailLine1TableViewCell.h"
#import "LCYArtistDetailLine2TableViewCell.h"

@interface LCYArtistDetailViewController ()<LCYArtistDetailViewControllerXMLParserDelegate,UITableViewDelegate,UITableViewDataSource>
{
    BOOL isNib1Registered;
    BOOL isNib2Registered;
    BOOL hasDownloadedAvatarImage;
}
/**
 *  艺术家信息
 */
@property (strong, nonatomic) LCYArtistDetailVCArtist *artistInfo;
/**
 *  艺术家信息列表
 */
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@end

@implementation LCYArtistDetailViewController

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
    
    isNib1Registered = NO;
    isNib2Registered = NO;
    hasDownloadedAvatarImage = NO;
    
    // 设置返回按键
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToParent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    // 加载玩数据前，隐藏整个table
    [self.infoTableView setHidden:YES];
    
    [self laodRemoteData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (void)backToParent{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)laodRemoteData{
    if ([LCYCommon networkAvailable]) {
        [LCYCommon showHUDTo:self.view withTips:nil];
        NSDictionary *parameter = @{@"artistId": self.artistID};
        LCYArtistDetailViewControllerXMLParser *parser = [[LCYArtistDetailViewControllerXMLParser alloc] init];
        parser.delegate = self;
        [LCYCommon postRequestWithAPI:GetArtistInforById parameters:parameter successDelegate:parser failedBlock:nil];
    } else {
        UIAlertView *networkUnabailableAlert = [[UIAlertView alloc] initWithTitle:@"无法找到网络" message:@"请检查您的网络连接状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [networkUnabailableAlert show];
    }
}
#pragma mark - LCYArtistDetailViewControllerXMLParserDelegate
- (void)didFinishGetXMLInfo:(id)info{
    self.artistInfo = info;
    // TODO:更新界面，将艺术家信息进行显示
    
    [self.infoTableView setHidden:NO];
    [self.infoTableView reloadData];
    [LCYCommon hideHUDFrom:self.view];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.artistInfo) {
        return 0;
    }else {
        return 3;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 141;
    }else if (indexPath.row == 1){
        return 44;
    } else {
        return 44;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString *identifier1 = @"LCYArtistDetailLine1TableViewCellIdentifier";
        if (!isNib1Registered) {
            UINib *nib = [UINib nibWithNibName:@"LCYArtistDetailLine1TableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:identifier1];
            isNib1Registered = YES;
        }
        LCYArtistDetailLine1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        cell.artistNameLabel.text = self.artistInfo.artistName;
        cell.artistEducationLabel.text = self.artistInfo.artistEducation;
        return cell;
    } else if (indexPath.row == 1){
        static NSString *identifier2 = @"LCYArtistDetailLine2TableViewCellIdentifier";
        if (!isNib2Registered) {
            UINib *nib = [UINib nibWithNibName:@"LCYArtistDetailLine2TableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:identifier2];
            isNib2Registered = YES;
        }
        LCYArtistDetailLine2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        return cell;
    } else {
        static NSString *identifier3= @"LCYArtistDetailLine3TableViewCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier3];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = [NSString stringWithFormat:@"作品（%.f）",self.artistInfo.artistWorkCount];
        return cell;
    }
}
@end

@interface LCYArtistDetailViewControllerXMLParser ()
@property (strong, nonatomic) NSMutableString *xmlTempString;
@end
@implementation LCYArtistDetailViewControllerXMLParser
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
    LCYArtistDetailVCArtist *result = [LCYArtistDetailVCArtist modelObjectWithDictionary:jsonResponse];
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(didFinishGetXMLInfo:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate didFinishGetXMLInfo:result];
        });
    }
}
@end