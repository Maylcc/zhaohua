//
//  LCYAllImagesForArtistViewController.m
//  ArtSearching
//
//  Created by eagle on 14-5-21.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYAllImagesForArtistViewController.h"
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import "LCYCommon.h"
#import "LCYXMLDictionaryParser.h"
#import "LCYMyCollectionCell.h"
#import "GetArtworkListByArtistIdBase.h"
#import "GetArtworkListByArtistIdWorkList.h"

#define LIMIT_PER_PAGE @"10"

@interface LCYAllImagesForArtistViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout,LCYXMLDictionaryParserDelegate>
{
    NSInteger pageIndex;
    BOOL isDataLoading;
    BOOL isNibRegistered;
}
@property (weak, nonatomic) IBOutlet UICollectionView *icyCollectionView;
/**
 *  所有作品列表
 */
@property (strong, nonatomic) NSArray *workListArray;
@end

@implementation LCYAllImagesForArtistViewController

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
    pageIndex = 0;
    isDataLoading = YES;
    isNibRegistered = NO;
    
    // 设置返回按键
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToParent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    [self loadRemoteData];
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

- (void)loadRemoteData{
    if ([LCYCommon networkAvailable]) {
        [LCYCommon showHUDTo:self.view withTips:nil];
        NSDictionary *parameter = @{@"id": self.artistID,
                                    @"pageidx":[NSString stringWithFormat:@"%ld",(long)pageIndex],
                                    @"limit": LIMIT_PER_PAGE};
        LCYXMLDictionaryParser *parser = [[LCYXMLDictionaryParser alloc] init];
        parser.delegate = self;
        isDataLoading = YES;
        [LCYCommon postRequestWithAPI:GetArtworkListByArtistId parameters:parameter successDelegate:parser failedBlock:nil];
    } else {
        UIAlertView *networkUnabailableAlert = [[UIAlertView alloc] initWithTitle:@"无法找到网络" message:@"请检查您的网络连接状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [networkUnabailableAlert show];
    }
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (!self.workListArray) {
        return 0;
    } else {
        return [self.workListArray count];
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"LCYMyCollectionCellIdentifier";
    if (!isNibRegistered) {
        UINib *nib = [UINib nibWithNibName:@"LCYMyCollectionCell" bundle:nil];
        [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
        isNibRegistered = YES;
    }
    LCYMyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    GetArtworkListByArtistIdWorkList *artWork = [self.workListArray objectAtIndex:indexPath.row];
    return CGSizeMake(163.0, 163.0/artWork.ratio+37);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - LCYXMLDictionaryParserDelegate
- (void)parser:(LCYXMLDictionaryParser *)parser didFinishGetXMLInfo:(NSDictionary *)info{
    GetArtworkListByArtistIdBase *baseInfo = [GetArtworkListByArtistIdBase modelObjectWithDictionary:info];
    self.workListArray = [NSArray arrayWithArray:baseInfo.workList];
    [self.icyCollectionView reloadData];
    [LCYCommon hideHUDFrom:self.view];
}


@end
