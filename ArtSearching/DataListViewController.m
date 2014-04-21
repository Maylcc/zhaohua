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
#import "ZXYFileOperation.h"
#import "StartArtList.h"
#import "StartArtistsList.h"
#import "StartGalleryList.h"
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UI_SCREEN_WIDTH                 ([[UIScreen mainScreen] bounds].size.width)
#define UI_SCREEN_HEIGHT                ([[UIScreen mainScreen] bounds].size.height)
#define TEXTBLACKCOLORE [UIColor colorWithRed:((float)((0x3a3a3a & 0xFF0000) >> 16))/255.0 \
green:((float)((0x3a3a3a & 0xFF00) >> 8))/255.0 \
blue:((float)(0x3a3a3a & 0xFF))/255.0 alpha:1.0]

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
        arrArtistsList = [NSArray arrayWithArray:[dataProvider readCoreDataFromDB:@"StartArtistsList" orderByKey:@"beScanTime" isDes:NO]];
        arrArtList     = [NSArray arrayWithArray:[dataProvider readCoreDataFromDB:@"StartArtList" orderByKey:@"beScanTime" isDes:NO]];
        arrGalleryList     = [NSArray arrayWithArray:[dataProvider readCoreDataFromDB:@"StartGalleryList" orderByKey:@"beScanTime" isDes:NO]];
        fileOperation = [ZXYFileOperation sharedSelf];
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
//    [NSThread detachNewThreadSelector:@selector(obtainStartList) toTarget:netConnect withObject:nil];
    [netConnect obtainStartList];
}

#pragma mark - table代理以及数据源
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerViewIdentifier = @"headerViewIdentifier";
    UIView *headerView = [tableView dequeueReusableCellWithIdentifier:headerViewIdentifier];
    if(headerView == nil)
    {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 22)];
        headerView.backgroundColor = RGBA(217, 217, 217, 1);
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, UI_SCREEN_WIDTH-15, 22)];
        titleLbl.textColor = TEXTBLACKCOLORE;
        titleLbl.font = [UIFont systemFontOfSize:13.5];
        titleLbl.backgroundColor = [UIColor clearColor];
        if(section == 0)
        {
            titleLbl.text = @"  明星作品 (10)";
        }
        else if(section == 1)
        {
            titleLbl.text = @"  明星艺术家 (10)";
        }
        else
        {
            titleLbl.text = @"  明星画廊 (10)";
        }
        [headerView addSubview:titleLbl];
    }
    return headerView;
   
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
        DataArtListCellTableViewCell *cellArt = [tableView dequeueReusableCellWithIdentifier:artListCellIdentifier];
        if(cellArt == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DataArtListCellTableViewCell" owner:self options:nil];
            for(id oneObject in nib)
            {
                if([oneObject isKindOfClass:[DataArtListCellTableViewCell class]])
                {
                    cellArt = (DataArtListCellTableViewCell *)oneObject;
                }
            }
        }
        StartArtList *artList = [arrArtList objectAtIndex:indexPath.row];
        cellArt.authodLbl.text = artList.author;
        cellArt.artNameLbl.text = artList.title;
        cellArt.cellIndex = [NSString stringWithFormat:@"%d",artList.id_Art.intValue ];
        cellArt.lookNums.text   = [NSString stringWithFormat:@"%d",artList.beScanTime.intValue ];
        cellArt.collectNum.text = [NSString stringWithFormat:@"%d", artList.beStoreTime.intValue ];
        cellArt.indexLbl.text   = [NSString stringWithFormat:@"%d",indexPath.row+1];
        NSString *pathString = [fileOperation findArtOfStartByID:artList.id_Art];
        if([fileOperation fileExistsAtPath:pathString])
        {
            cellArt.artImage.image = [UIImage imageWithContentsOfFile:pathString];
        }
        else
        {
            NSLog(@"没有内容");
        }
        //cellArt.artImage.image  =
        cell = cellArt;
    }
    else
    {
        static NSString *artGalleryAndArtistIdentifier = @"artGalleryAndArtistIdentifier";
        DataStartGallertyCell *galleryCell = [tableView dequeueReusableCellWithIdentifier:artGalleryAndArtistIdentifier];
        if(galleryCell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DataStartGallertyCell" owner:self options:nil];
            for(id oneObject in nib)
            {
                if([oneObject isKindOfClass:[DataStartGallertyCell class]])
                {
                    galleryCell = (DataStartGallertyCell *)oneObject;
                }
            }
        }
        if(indexPath.section == 1)
        {
            StartArtistsList *artist = [arrArtistsList objectAtIndex:indexPath.row];
            galleryCell.authordName.text = artist.author;
            galleryCell.lookNums.text    = [NSString stringWithFormat:@"%d", artist.beScanTime.intValue ];
            galleryCell.collectionNums.text = [NSString stringWithFormat:@"%d", artist.beStoreTime.intValue ];
            galleryCell.indexLbl.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        }
        else
        {
            StartGalleryList *artist = [arrGalleryList objectAtIndex:indexPath.row];
            galleryCell.authordName.text = artist.name;
            galleryCell.lookNums.text    = [NSString stringWithFormat:@"%d", artist.beScanTime.intValue ];
            galleryCell.collectionNums.text = [NSString stringWithFormat:@"%d", artist.beStoreTime.intValue ];
            galleryCell.indexLbl.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        }
        cell = galleryCell;
    }
    if(cell == nil)
    {
        NSLog(@"section is %d and row is %d",indexPath.section,indexPath.row);
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
    arrArtistsList = [NSArray arrayWithArray:[dataProvider readCoreDataFromDB:@"StartArtistsList" orderByKey:@"beScanTime" isDes:NO]];
    arrArtList     = [NSArray arrayWithArray:[dataProvider readCoreDataFromDB:@"StartArtList" orderByKey:@"beScanTime" isDes:NO]];
    arrGalleryList     = [NSArray arrayWithArray:[dataProvider readCoreDataFromDB:@"StartGalleryList" orderByKey:@"beScanTime" isDes:NO]];
    [dataTableV reloadData];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DataListViewFresh" object:nil];
}

@end
