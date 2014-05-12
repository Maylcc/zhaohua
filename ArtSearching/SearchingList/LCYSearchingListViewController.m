//
//  LCYSearchingListViewController.m
//  ArtSearching
//
//  Created by eagle on 14-5-9.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYSearchingListViewController.h"
#import "LCYCommon.h"
#import "LCYRegisterViewController.h"
#import "LCYUserInformationViewController.h"
#import "LCYAppDelegate.h"
#import "LCYRenrenViewController.h"
#import "LCYArtistsAndShowsViewController.h"
#import "LCYDataModels.h"
#import "LCYSearchingListLv2ViewController.h"

@interface LCYSearchingListViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,LCYSearchingListMainParserDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *icySearchBar;
/**
 *  从服务器获取的列表
 */
@property (strong, nonatomic) NSArray *categoryListArray;
/**
 *  主列表
 */
@property (weak, nonatomic) IBOutlet UITableView *icyTableView;
@end

@implementation LCYSearchingListViewController

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
    [self getDataFromRemote];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)barButtonPressed:(id)sender {
    UIBarButtonItem *item = sender;
    if (item.tag == 4) {
        // 注册、登陆、显示用户收藏等
        BOOL isLogin = [LCYCommon isUserLogin];
        if (!isLogin) {
            // 跳转到注册界面
            LCYRegisterViewController *registerVC = [[LCYRegisterViewController alloc] init];
            [self.navigationController pushViewController:registerVC animated:YES];
        } else{
            // TODO:跳转到个人信息界面
            LCYUserInformationViewController *userVC = [[LCYUserInformationViewController alloc] init];
            userVC.title = @"个人信息";
            [self.navigationController setNavigationBarHidden:NO];
            [self.navigationController pushViewController:userVC animated:YES];
        }
    }
    if (item.tag == 1) {
        // 人人策画
        LCYAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        LCYRenrenViewController *oneVC = [[LCYRenrenViewController alloc] init];
        oneVC.title = @"人人策画";
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:oneVC];
        [appDelegate.window setRootViewController:nav];
    }
    if (item.tag == 2) {
        // 艺术家、画廊
        LCYAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        LCYArtistsAndShowsViewController *twoVC = [[LCYArtistsAndShowsViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:twoVC];
        [appDelegate.window setRootViewController:nav];
    }
}

- (void)getDataFromRemote{
    if ([LCYCommon networkAvailable]) {
        LCYSearchingListMainParser *parser = [[LCYSearchingListMainParser alloc] init];
        parser.delegate = self;
        [LCYCommon postRequestWithAPI:WorkListCategory parameters:nil successDelegate:parser failedBlock:nil];
    } else {
        UIAlertView *networkUnabailableAlert = [[UIAlertView alloc] initWithTitle:@"无法找到网络" message:@"请检查您的网络连接状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [networkUnabailableAlert show];
    }
}

- (void)reloadTableView{
    [self.icyTableView reloadData];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.icySearchBar resignFirstResponder];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.categoryListArray) {
        return [self.categoryListArray count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"SearchingListViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    LCYSearchingListMainCategoryList *categoryInRow = [self.categoryListArray objectAtIndex:indexPath.row];
    cell.textLabel.text = categoryInRow.categoryName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // TODO: 跳转到二级列表界面
    LCYSearchingListMainCategoryList *categoryInRow = [self.categoryListArray objectAtIndex:indexPath.row];
    NSString *categoryID = categoryInRow.categoryId;
    LCYSearchingListLv2ViewController *lv2VC= [[LCYSearchingListLv2ViewController alloc] init];
    lv2VC.categoryID = categoryID;
    lv2VC.title = categoryID;
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:lv2VC animated:YES];
}

#pragma mark - LCYSearchingListMainParserDelegate
- (void)resultParserDidFinish:(LCYSearchingListMainParser *)parser withInfo:(id)resultInfo{
    LCYSearchingListMainWorkListCategory *resultList = resultInfo;
    self.categoryListArray = [NSArray arrayWithArray:resultList.categoryList];
    [self reloadTableView];
}

@end


@interface LCYSearchingListMainParser ()
@property (strong, nonatomic) NSMutableString *xmlTempString;
@end
@implementation LCYSearchingListMainParser
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
    LCYSearchingListMainWorkListCategory *categoryResult = [LCYSearchingListMainWorkListCategory modelObjectWithDictionary:jsonResponse];
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(resultParserDidFinish:withInfo:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate resultParserDidFinish:self withInfo:categoryResult];
        });
    }
}

@end
