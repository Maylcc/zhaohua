//
//  DataListViewController.m
//  ArtSearching
//
//  Created by developer on 14-4-17.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "DataListViewController.h"
#import "DataArtListCellTableViewCell.h"
#import "DataStartGallertyCell.h"
@interface DataListViewController ()

@end

@implementation DataListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        netConnect = [NetConnect sharedSelf];
        dataProvider = [ZXYProvider sharedInstance];
        arrArtistsList = [NSArray arrayWithArray:[dataProvider readCoreDataFromDB:@"StartArtistsList"]];
        arrArtList     = [NSArray arrayWithArray:[dataProvider readCoreDataFromDB:@"StartArtList"]];
        arrGalleryList     = [NSArray arrayWithArray:[dataProvider readCoreDataFromDB:@"StartGaleryList"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSNotificationCenter *refreshNoti = [NSNotificationCenter defaultCenter];
    [refreshNoti addObserver:self selector:@selector(refreshCurrentTable:) name:@"DataListViewFresh" object:nil];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 40)];
    self.title = @"数据凶猛";
    [backBtn setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    [self obtainAllStartData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources txvhat can be recreated.
}

- (void)obtainAllStartData
{
    [netConnect obtainStartList];
}

#pragma mark - table代理以及数据源
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3 ;
}
//
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return arrArtList.count;
    }
    else if(section == 1)
    {
        return arrArtistsList.count;
    }
    else
    {
        return arrGalleryList.count;
    }
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell ;
    if(indexPath.section == 0)
    {
       static NSString *artListCellIdentifier = @"artListCellIdentifier";
        DataArtListCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:artListCellIdentifier];
    }
    return cell;
}
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 210;
    }
    else
    {
        return 51;
    }
}
//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}

#pragma mark - 返回函数
- (void)backView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshCurrentTable:(NSNotification *)noti
{
    arrArtistsList = [NSArray arrayWithArray:[dataProvider readCoreDataFromDB:@"StartArtistsList"]];
    arrArtList     = [NSArray arrayWithArray:[dataProvider readCoreDataFromDB:@"StartArtList"]];
    arrGalleryList     = [NSArray arrayWithArray:[dataProvider readCoreDataFromDB:@"StartGaleryList"]];
    [dataTableV reloadData];
}

@end
