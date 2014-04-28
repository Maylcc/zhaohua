//
//  LCYBuildExhibitionViewController.m
//  ArtSearching
//
//  Created by 李超逸 on 14-4-21.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYBuildExhibitionViewController.h"
#import "LCYBuildCollectionViewCell.h"
#import "LCYMyCollectionViewController.h"
#import "LCYCommon.h"
@interface LCYBuildExhibitionViewController ()
<UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
{
    BOOL isNibRegistered;
}
/**
 *  展览主题
 */
@property (weak, nonatomic) IBOutlet UITextView *subjectTextView;
/**
 *  文字介绍
 */
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
/**
 *  还可输入x个字
 */
@property (weak, nonatomic) IBOutlet UILabel *charactorLeft;
/**
 *  背景滚动
 */
@property (weak, nonatomic) IBOutlet UIScrollView *icyScrollView;
/**
 *  主视图
 */
@property (strong, nonatomic) IBOutlet UIView *mainView;

/**
 *  所有已经添加的作品
 */
@property (strong, nonatomic) NSArray *worksArray;
/**
 *  我的收藏页面
 *  减少多次打开的时间
 *  记录选中状态
 */
@property (strong, nonatomic) LCYMyCollectionViewController *myCollectionVC;

@end

@implementation LCYBuildExhibitionViewController

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
    
    // 将主视图加载到滚动视图
    [self.icyScrollView setContentSize:self.mainView.frame.size];
    [self.icyScrollView addSubview:self.mainView];
    
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
/**
 *  确认发布
 *
 *  @param sender 按钮
 */
- (IBAction)confirmButtonPressed:(id)sender {
    LCYLOG(@"确认发布");
}
- (IBAction)backgroundTouched:(id)sender {
    if ([self.subjectTextView isFirstResponder]) {
        if (self.subjectTextView.text.length <= 90) {
            [self.subjectTextView resignFirstResponder];
        }
    }
    if ([self.descriptionTextView isFirstResponder]) {
        [self.descriptionTextView resignFirstResponder];
    }
}

#pragma mark - UITextView Delegate Methods
- (void)textViewDidChange:(UITextView *)textView{
    if (textView == self.subjectTextView) {
        if (textView.text.length <= 90) {
            self.charactorLeft.textColor = [UIColor blackColor];
            self.charactorLeft.text = [NSString stringWithFormat:@"还可以输入%ld个字",(long)(45-(textView.text.length+1)/2)];
        } else {
            self.charactorLeft.textColor = [UIColor redColor];
            self.charactorLeft.text = @"超出字数限制";
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        if (textView == self.subjectTextView
            && textView.text.length > 90) {
            return NO;
        }
        [textView resignFirstResponder];
    }
    return YES;
}

#pragma mark - UICollectionView Data Source and Delegate Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 15;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"BuildCollectionViewCellIdentifier";
    if (!isNibRegistered) {
        UINib *nib = [UINib nibWithNibName:@"LCYBuildCollectionViewCell" bundle:nil];
        [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
        isNibRegistered = YES;
    }
    LCYBuildCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (!self.worksArray) {
        if (indexPath.row == 0) {
            cell.icyImage.image = [UIImage imageNamed:@"build_plus.png"];
        } else {
            cell.icyImage.image = [UIImage imageNamed:@"build_dot.png"];
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.worksArray) {
        if (indexPath.row == 0) {
            // 添加我收藏的作品
            if (!self.myCollectionVC) {
                self.myCollectionVC = [[LCYMyCollectionViewController alloc] init];
                self.myCollectionVC.title = @"我的收藏";
            }
            [self.navigationController pushViewController:self.myCollectionVC animated:YES];
        }
    }
}

@end
