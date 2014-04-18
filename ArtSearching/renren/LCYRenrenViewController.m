//
//  LCYRenrenViewController.m
//  ArtSearching
//
//  Created by eagle on 14-4-16.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYRenrenViewController.h"
#import "LCYCommon.h"
#import "DataListViewController.h"
#import "LCYDataModels.h"

#define RenrenGreen colorWithRed:101.0/255 green:151.0/255 blue:49.0/255 alpha:1

@interface LCYRenrenViewController ()
<NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource>

typedef NS_ENUM(NSInteger, LCYRenrenSegStatus){
    LCYRenrenSegStatusAll,      /**< 所有展览 */
    LCYRenrenSegStatusMine      /**< 我的展览 */
};
/**
 *  用于解析XML时的缓存
 */
@property (strong, nonatomic) NSMutableString *xmlTempString;

/**
 *  XML解析结果
 */
@property (strong, nonatomic) LCYActivityListBase *activityListBase;

@end

@interface LCYRenrenViewController ()
{
    LCYRenrenSegStatus currentStatus;
}

/**
 *  数据凶猛按钮
 */
@property (strong, nonatomic) IBOutlet UIView *dataFerocious;
/**
 *  搜索栏
 */
@property (weak, nonatomic) IBOutlet UISearchBar *icySearchingBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarVerticalSpace;
/**
 *  所有活动的列表
 */
@property (weak, nonatomic) IBOutlet UITableView *icyTableView;

/**
 *  所有展览
 */
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
/**
 *  我的展览
 */
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
/**
 *  所有展览
 */
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
/**
 *  我的展览
 */
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@end

@implementation LCYRenrenViewController

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
    // 添加数据凶猛按钮
    UIBarButtonItem *leftNaviButton = [[UIBarButtonItem alloc] initWithCustomView:self.dataFerocious];
    self.navigationItem.leftBarButtonItem = leftNaviButton;
    
    currentStatus = LCYRenrenSegStatusAll;
    
    [self loadExData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadExData{
    NSString *URLString = [NSString stringWithFormat:@"%@%@",hostURLPrefix,ActivityList];
    NSLog(@"%@",URLString);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [manager POST:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSXMLParser *XMLParser = (NSXMLParser *)responseObject;
        XMLParser.delegate = self;
        [XMLParser setShouldProcessNamespaces:NO];
        [XMLParser parse];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark -Actions
- (IBAction)renrenLeftNaviButtonPressed:(id)sender{
    // TODO: 跳转到数据凶猛
    DataListViewController *dataList = [[DataListViewController alloc] initWithNibName:NSStringFromClass([DataListViewController class]) bundle:nil];
    [self.navigationController pushViewController:dataList animated:YES];
    
}

- (IBAction)barButtonPressed:(id)sender {
    UIBarButtonItem *item = sender;
    NSLog(@"%ld",(long)item.tag);
}

/**
 *  我要策展
 *
 *  @param sender button
 */
- (IBAction)iWantButtonPressed:(id)sender {
    NSLog(@"我要策展");
}
/**
 *  所有展览
 *
 *  @param sender button
 */
- (IBAction)allExButtonPressed:(id)sender {
    NSLog(@"所有展览");
    if (currentStatus == LCYRenrenSegStatusMine) {
        self.leftImageView.image = [UIImage imageNamed:@"all_ex_left_filled.png"];
        [self.leftLabel setTextColor:[UIColor whiteColor]];
        self.rightImageView.image = [UIImage imageNamed:@"all_ex_right_blank.png"];
        [self.rightLabel setTextColor:[UIColor RenrenGreen]];
        currentStatus = LCYRenrenSegStatusAll;
    }
}
/**
 *  我的展览
 *
 *  @param sender button
 */
- (IBAction)myExButtonPressed:(id)sender {
    NSLog(@"我的展览");
    if (currentStatus == LCYRenrenSegStatusAll) {
        self.leftImageView.image = [UIImage imageNamed:@"all_ex_left_blank.png"];
        [self.leftLabel setTextColor:[UIColor RenrenGreen]];
        self.rightImageView.image = [UIImage imageNamed:@"all_ex_right_filled.png"];
        [self.rightLabel setTextColor:[UIColor whiteColor]];
        currentStatus = LCYRenrenSegStatusMine;
    }
}
#pragma mark - NSXMLParserDelegate

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
    self.activityListBase = [LCYActivityListBase modelObjectWithDictionary:jsonResponse];
}

#pragma mark - UITableView Data Source and Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

@end
