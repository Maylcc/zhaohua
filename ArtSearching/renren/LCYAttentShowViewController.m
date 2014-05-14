//
//  LCYAttentShowViewController.m
//  ArtSearching
//
//  Created by eagle on 14-5-13.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYAttentShowViewController.h"
#import "LCYBuildCollectionViewCell.h"

@interface LCYAttentShowViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    BOOL isNibRegistered;
}
@property (weak, nonatomic) IBOutlet UICollectionView *icyCollectionView;
@property (weak, nonatomic) IBOutlet UITextView *icyTextView;
@property (strong, nonatomic) NSArray *imageArray;
@end

@implementation LCYAttentShowViewController

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

#pragma mark - Action
- (void)backToParent{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backgroundTouchDown:(id)sender {
    [self.icyTextView resignFirstResponder];
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"BuildCollectionViewCellIdentifier";
    if (!isNibRegistered) {
        UINib *nib = [UINib nibWithNibName:@"LCYBuildCollectionViewCell" bundle:nil];
        [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
        isNibRegistered = YES;
    }
    LCYBuildCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (!self.imageArray) {
        if (indexPath.row == 0) {
            cell.icyImage.image = [UIImage imageNamed:@"build_plus.png"];
        } else {
            cell.icyImage.image = [UIImage imageNamed:@"build_dot.png"];
        }
    }
    return cell;
}

@end
