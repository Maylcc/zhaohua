//
//  LCYRenrenViewController.m
//  ArtSearching
//
//  Created by eagle on 14-4-16.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYRenrenViewController.h"
#import "LCYCommon.h"
#import "DataListViewController.h"
@interface LCYRenrenViewController ()
/**
 *  数据凶猛按钮
 */
@property (strong, nonatomic) IBOutlet UIView *dataFerocious;
/**
 *  搜索栏
 */
@property (weak, nonatomic) IBOutlet UISearchBar *icySearchingBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarVerticalSpace;

@end

@implementation LCYRenrenViewController

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
    // 添加数据凶猛按钮
    UIBarButtonItem *leftNaviButton = [[UIBarButtonItem alloc] initWithCustomView:self.dataFerocious];
    self.navigationItem.leftBarButtonItem = leftNaviButton;
    
    NSLog(@"%@",hostURLPrefix);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -Actions
- (IBAction)renrenLeftNaviButtonPressed:(id)sender{
    // TODO: 跳转到数据凶猛
    DataListViewController *dataList = [[DataListViewController alloc] initWithNibName:NSStringFromClass([DataListViewController class]) bundle:nil];
    [self.navigationController pushViewController:dataList animated:YES];
    
}

- (IBAction)barButtonPressed:(id)sender {
    UIBarButtonItem *item = sender;
    NSLog(@"%ld",(long)item.tag);
}


- (IBAction)iWantButtonPressed:(id)sender {
    NSLog(@"我要策展");
}



@end
