//
//  DataAcquisitionViewController.m
//  ArtSearching
//
//  Created by developer on 14-4-28.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "DataAcquisitionViewController.h"
#import "PlotViewViewController.h"
@interface DataAcquisitionViewController ()
{
    
}
@property (nonatomic,strong)PlotViewViewController *plotView;
@end

@implementation DataAcquisitionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.plotView = [[PlotViewViewController alloc] initWithNibName:@"PlotViewViewController" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    self.plotView.view.frame  = CGRectMake(0, 0, self.plotView.view.frame.size.width, self.plotView.view.frame.size.height);
    [self.ploatScroll addSubview:self.plotView.view];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
