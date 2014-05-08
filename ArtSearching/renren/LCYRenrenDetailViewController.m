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
    BOOL isNibRegistered;   /**< 策展人，参展人 */
    BOOL isNib2Registered;  /**< 展览介绍 */
    BOOL isNib3Registered;  /**< 画——瀑布流 */
    BOOL isNib4Registered;  /**< Collection View Header */
    CGFloat lastOffset;     /**< 上次滑动位置 */
}
@property (strong, nonatomic) NSMutableArray *cellSizes;

@property (weak, nonatomic) IBOutlet UICollectionView *icyCollectionView;
/**
 *  参展菜单（底部菜单，包括参展、评论、分享）
 */
@property (strong, nonatomic) IBOutlet UIView *footerToolBarView;

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
    lastOffset = 0;
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
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier4 = @"LCYRenrenDetailFirstHeaderIdentifier";
    if (!isNib4Registered) {
        UINib *nib = [UINib nibWithNibName:@"LCYRenrenDetailFirstHeader" bundle:nil];
        [collectionView registerNib:nib forSupplementaryViewOfKind:LCYCollectionElementKindSectionHeader withReuseIdentifier:identifier4];
        isNib4Registered = YES;
    }
    if ([kind isEqualToString:LCYCollectionElementKindSectionHeader]) {
        LCYRenrenDetailFirstHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:LCYCollectionElementKindSectionHeader withReuseIdentifier:identifier4 forIndexPath:indexPath];
        if (indexPath.section==1) {
            header.titleLabel.text = @"展览介绍";
        } else if (indexPath.section==2){
            header.titleLabel.text = @"参展作品(15)";
        }
        return header;
    }
    return nil;
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

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 2) {
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return UIEdgeInsetsZero;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.icyCollectionView) {
        CGFloat currentY = scrollView.contentOffset.y;
        if (currentY - lastOffset >= 25) {
            LCYLOG(@"up");
        } else if (lastOffset - currentY >= 25){
            LCYLOG(@"down");
        }
        lastOffset = currentY;
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

@implementation LCYRenrenDetailFirstHeader
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}
@end
