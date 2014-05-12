//
//  LCYSearchingListLv2ViewController.m
//  ArtSearching
//
//  Created by eagle on 14-5-12.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYSearchingListLv2ViewController.h"
#import "LCYCommon.h"
#import "LCYSearchingListViewController.h"
#import "LCYDataModels.h"

@interface LCYSearchingListLv2ViewController ()<LCYSearchingListMainParserDelegate,UITableViewDelegate,UITableViewDataSource>

/**
 *  由服务器取得的分类数据
 */
@property (strong, nonatomic) NSArray *categoryListArray;
/**
 *  主表
 */
@property (weak, nonatomic) IBOutlet UITableView *icyTableView;

@end

@implementation LCYSearchingListLv2ViewController

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
    [backBtn addTarget:self action:@selector(backToParent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    [self getRemoteData];
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

- (void)getRemoteData{
    if ([LCYCommon networkAvailable]) {
        NSDictionary *parameter = @{@"id": self.categoryID};
        LCYSearchingListMainParser *parser = [[LCYSearchingListMainParser alloc] init];
        parser.delegate = self;
        [LCYCommon postRequestWithAPI:WorkListCategoryById parameters:parameter successDelegate:parser failedBlock:nil];
    } else {
        UIAlertView *networkUnabailableAlert = [[UIAlertView alloc] initWithTitle:@"无法找到网络" message:@"请检查您的网络连接状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [networkUnabailableAlert show];
    }
}
- (void)reloadTableView{
    [self.icyTableView reloadData];
}

#pragma mark - LCYSearchingListMainParserDelegate
- (void)resultParserDidFinish:(LCYSearchingListMainParser *)parser withInfo:(id)resultInfo{
    LCYSearchingListMainWorkListCategory *resultList = resultInfo;
    self.categoryListArray = [NSArray arrayWithArray:resultList.categoryList];
    [self reloadTableView];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.categoryListArray) {
        return [self.categoryListArray count]+1;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"SearchingListViewLv2CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row==0) {
        cell.textLabel.text = @"全部";
    } else {
        LCYSearchingListMainCategoryList *categoryInRow = [self.categoryListArray objectAtIndex:(indexPath.row-1)];
        cell.textLabel.text = categoryInRow.categoryName;
    }

    return cell;
}
@end
