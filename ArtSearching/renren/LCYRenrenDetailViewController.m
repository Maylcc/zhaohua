//
//  LCYRenrenDetailViewController.m
//  ArtSearching
//
//  Created by eagle on 14-5-8.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYRenrenDetailViewController.h"
#import "LCYWaterFlowLayout.h"
#import "LCYMyCollectionCell.h"

#define CELL_COUNT 15
@interface LCYRenrenDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,LCYWaterFlowLayoutDelegate>
{
    BOOL isNibRegistered;
    BOOL isNib2Registered;
    BOOL isNib3Registered;
}
@property (strong, nonatomic) NSMutableArray *cellSizes;
@end

@implementation LCYRenrenDetailViewController

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
    isNibRegistered = NO;
    isNib2Registered = NO;
    isNib3Registered = NO;
    // 设置返回按键
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToParent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToParent{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)cellSizes {
    if (!_cellSizes) {
        _cellSizes = [NSMutableArray array];
        for (NSInteger i = 0; i < CELL_COUNT; i++) {
            CGSize size = CGSizeMake(arc4random() % 50 + 50, arc4random() % 50 + 50);
            _cellSizes[i] = [NSValue valueWithCGSize:size];
        }
    }
    return _cellSizes;
}
#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section!=2) {
        return 1;
    } else {
        return CELL_COUNT;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *identifier = @"LCYRenrenDetailFirstLineCellIdentifier";
        if (!isNibRegistered) {
            UINib *nib = [UINib nibWithNibName:@"LCYRenrenDetailFirstLineCell" bundle:nil];
            [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
            isNibRegistered = YES;
        }
        LCYRenrenDetailFirstLineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.nameLabel.text = self.exhibitionInfo.organizerName;
        cell.dateLabel.text = self.exhibitionInfo.createTime;
        cell.attenderLabel.text = self.exhibitionInfo.attenderNames;
        cell.icyImageView.image = [UIImage imageNamed:@"akalin.jpg"];
        return cell;
    }else if(indexPath.section == 1){
        static NSString *identifier2 = @"LCYRenrenDetailSecondLineCellIdentifier";
        if (!isNib2Registered) {
            UINib *nib = [UINib nibWithNibName:@"LCYRenrenDetailSecondLineCell" bundle:nil];
            [collectionView registerNib:nib forCellWithReuseIdentifier:identifier2];
            isNib2Registered = YES;
        }
        LCYRenrenDetailSecondLineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier2 forIndexPath:indexPath];
        cell.icyTextView.text = self.exhibitionInfo.describinfo;
        return cell;
    } else {
        static NSString *identifier3 = @"LCYMyCollectionCellIdentifier";
        if (!isNib3Registered) {
            UINib *nib = [UINib nibWithNibName:@"LCYMyCollectionCell" bundle:nil];
            [collectionView registerNib:nib forCellWithReuseIdentifier:identifier3];
            isNib3Registered = YES;
        }
        LCYMyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier3 forIndexPath:indexPath];
        [cell checkOff];
        cell.icyImageView.image = [UIImage imageNamed:@"tester.jpg"];
        cell.titleLabel.text = @"鲸鱼背上的世界";
        cell.artistNameLabel.text = @"潘晓刚";
        cell.viewerCountLabel.text = @"324";
        return cell;
    }
    return nil;
}
#pragma mark - Layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section!=2) {
        return CGSizeMake(320, 100);
    }
    return [self.cellSizes[indexPath.item] CGSizeValue];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 20;
    }
}
@end

@implementation LCYRenrenDetailFirstLineCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
@end

@implementation LCYRenrenDetailSecondLineCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
@end
