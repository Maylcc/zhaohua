//
//  LCYRenrenViewController.m
//  ArtSearching
//
//  Created by eagle on 14-4-16.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYRenrenViewController.h"

@interface LCYRenrenViewController ()
@property (strong, nonatomic) IBOutlet UIView *dataFerocious;
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
    // 修改按键
    UIBarButtonItem *leftNaviButton = [[UIBarButtonItem alloc] initWithCustomView:self.dataFerocious];
    self.navigationItem.leftBarButtonItem = leftNaviButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Actions
- (IBAction)renrenLeftNaviButtonPressed:(id)sender{
    // TODO: 跳转到数据凶猛
}

@end
