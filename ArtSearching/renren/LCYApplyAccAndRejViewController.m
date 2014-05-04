//
//  LCYApplyAccAndRejViewController.m
//  ArtSearching
//
//  Created by eagle on 14-5-4.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYApplyAccAndRejViewController.h"
#import "LCYApplyAccAndRegTableViewCell.h"
#import "LCYDataModels.h"

@interface LCYApplyAccAndRejViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isNibRegistered;
}

@end

@implementation LCYApplyAccAndRejViewController

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
    // 设置返回按键
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(AARVCBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    isNibRegistered = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (void)AARVCBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView DataSource And Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 205;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.applyArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"LCYApplyAccAndRegTableViewCellIdentifier";
    if (!isNibRegistered) {
        UINib *nib = [UINib nibWithNibName:@"LCYApplyAccAndRegTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        isNibRegistered = YES;
    }
    LCYApplyAccAndRegTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    LCYGetApplyerInfoResult *info = [self.applyArray objectAtIndex:indexPath.row];
    cell.applyerNameLabel.text = info.applyers;
    cell.reasonLabel.text = info.comment;
    cell.timeLabel.text = info.date;
    return cell;
}

@end
