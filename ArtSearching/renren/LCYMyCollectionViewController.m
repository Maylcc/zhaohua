//
//  LCYMyCollectionViewController.m
//  ArtSearching
//
//  Created by 李超逸 on 14-4-21.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYMyCollectionViewController.h"
#import <CHTCollectionViewWaterfallLayout.h>
#import "LCYMyCollectionCell.h"

#define CELL_COUNT 20

@interface LCYMyCollectionViewController ()<CHTCollectionViewDelegateWaterfallLayout>
{
    BOOL isNibRegistered;
    NSInteger checkCount;
}
@property (weak, nonatomic) IBOutlet UICollectionView *icyCollectionView;
@property (strong, nonatomic) NSMutableArray *cellSizes;
/**
 *  记录Cell是否选中
 */
@property (strong, nonatomic) NSMutableArray *cellStatus;
/**
 *  还可选x件作品
 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *checkCountButtonItem;
/**
 *  完成
 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButtonItem;

@end

@implementation LCYMyCollectionViewController

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
    isNibRegistered = NO;
    
    // 设置返回按键
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToParent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    /**
     *  初始化状态为都没有选中
     */
    self.cellStatus = [NSMutableArray array];
    for (int i = 0; i<CELL_COUNT; i++) {
        [self.cellStatus addObject:[NSNumber numberWithBool:NO]];
    }
    checkCount = 0;
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
- (IBAction)doneButtonPressed:(id)sender {
    // 获得所有选中的图片的信息，传递给代理进行处理
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<checkCount; i++) {
        ImageInfo *info = [ImageInfo infoWithURL:@"http://www.artwow.net/uploads/a.jpg" name:@"tester.jpg"];
        [array addObject:info];
    }
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(didGetImageInfoArray:)]) {
        [self.delegate didGetImageInfoArray:array];
    }
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


#pragma mark - UICollectionViewController Delegate And Delegate Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return CELL_COUNT;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"LCYMyCollectionCellIdentifier";
    if (!isNibRegistered) {
        UINib *nib = [UINib nibWithNibName:@"LCYMyCollectionCell" bundle:nil];
        [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
        isNibRegistered = YES;
    }
    LCYMyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.icyImageView.image = [UIImage imageNamed:@"tester.jpg"];
    cell.titleLabel.text = @"鲸鱼背上的世界";
    cell.artistNameLabel.text = @"潘晓刚";
    cell.viewerCountLabel.text = @"324";
    if ([[self.cellStatus objectAtIndex:indexPath.row] boolValue]) {
        [cell checkOn];
    } else {
        [cell checkOff];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LCYMyCollectionCell *cell = (LCYMyCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([[self.cellStatus objectAtIndex:indexPath.row] boolValue]) {
        [self.cellStatus replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
        [cell checkOff];
        checkCount--;
        if (checkCount<10) {
            self.doneButtonItem.enabled = NO;
        }
    } else {
        // 检查是否超出15个选择的限制
        if (checkCount>=15) {
            UIAlertView *outOfRangeAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"您不能选择超过15张图片参展" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [outOfRangeAlert show];
            return;
        }
        [self.cellStatus replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
        [cell checkOn];
        checkCount++;
        if (checkCount>=10) {
            self.doneButtonItem.enabled = YES;
        }
    }
    self.checkCountButtonItem.title = [NSString stringWithFormat:@"还可选%ld件作品",15-(long)checkCount];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellSizes[indexPath.item] CGSizeValue];
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

@end

@implementation ImageInfo
- (id)init{
    if (self = [super init]) {
    }
    return self;
}
+ (id)infoWithURL:(NSString *)URL name:(NSString *)name{
    ImageInfo *info = [[ImageInfo alloc] init];
    info.imageURL = URL;
    info.imageName = name;
    return info;
}
@end
