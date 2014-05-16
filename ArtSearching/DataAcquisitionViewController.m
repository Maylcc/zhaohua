//
//  DataAcquisitionViewController.m
//  ArtSearching
//
//  Created by developer on 14-4-28.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "DataAcquisitionViewController.h"
#import "PlotViewViewController.h"
#import "DrawPlotViewController.h"
@interface DataAcquisitionViewController ()
{
    NSInteger currentType;
    DrawPlotViewController *drawPlotViewTotal;
    DrawPlotViewController *drawPlotView1;
    DrawPlotViewController *drawPlotView2;
    DrawPlotViewController *drawPlotView3;
    DrawPlotViewController *drawPlotView4;
    DrawPlotViewController *drawPlotView5;
    DrawPlotViewController *drawPlotView6;
    DrawPlotViewController *drawPlotView7;
    NSInteger currentPage;
}
@property (nonatomic,strong)PlotViewViewController *plotView;
@end

@implementation DataAcquisitionViewController

- (id)initWithInitialDataDic:(NSDictionary *)dataDic
{
    if(self = [super initWithNibName:@"DataAcquisitionViewController" bundle:nil])
    {
        NSArray *marketArr = [dataDic objectForKey:@"marketIndex"];
        NSArray *confidentArr = [dataDic objectForKey:@"confidenceIndex"];
        currentType = 0;
        //self.plotView = [[PlotViewViewController alloc] initWithTotalMarketIndex:marketArr andConfidentIndex:confidentArr];
        [self initViewControllerS];
        }
    return self;
}

- (void)initViewControllerS
{
    // TODO:此处获取数据需要传递questionID服务器端没有完成
    drawPlotViewTotal = [[DrawPlotViewController alloc] initWithDataType:currentType andQuestionID:nil];
    drawPlotView1     = [[DrawPlotViewController alloc] initWithDataType:currentPage andQuestionID:nil];
    drawPlotView2     = [[DrawPlotViewController alloc] initWithDataType:currentType andQuestionID:nil];
    drawPlotView3     = [[DrawPlotViewController alloc] initWithDataType:currentPage andQuestionID:nil];
    drawPlotView4     = [[DrawPlotViewController alloc] initWithDataType:currentType andQuestionID:nil];
    drawPlotView5     = [[DrawPlotViewController alloc] initWithDataType:currentPage andQuestionID:nil];
    drawPlotView7     = [[DrawPlotViewController alloc] initWithDataType:currentType andQuestionID:nil];
    drawPlotView6     = [[DrawPlotViewController alloc] initWithDataType:currentType andQuestionID:nil];
}

- (void)addViewToScroller
{
    drawPlotView1.view.frame = CGRectMake(320, 0, 320, 156);
    drawPlotView2.view.frame = CGRectMake(320*2, 0, 320, 156);
    drawPlotView3.view.frame = CGRectMake(320*3, 0, 320, 156);
    drawPlotView4.view.frame = CGRectMake(320*4, 0, 320, 156);
    drawPlotView5.view.frame = CGRectMake(320*5, 0, 320, 156);
    drawPlotView6.view.frame = CGRectMake(320*6, 0, 320, 156);
    drawPlotView7.view.frame = CGRectMake(320*7, 0, 320, 156);
    [self.ploatScroll addSubview:drawPlotViewTotal.view];
    [self.ploatScroll addSubview:drawPlotView1.view];
    [self.ploatScroll addSubview:drawPlotView2.view];
    [self.ploatScroll addSubview:drawPlotView3.view];
    [self.ploatScroll addSubview:drawPlotView4.view];
    [self.ploatScroll addSubview:drawPlotView5.view];
    [self.ploatScroll addSubview:drawPlotView6.view];
    [self.ploatScroll addSubview:drawPlotView7.view];
}

- (void)removeViewFromScroller
{
    [drawPlotView1.view removeFromSuperview];
    [drawPlotView2.view removeFromSuperview];
    [drawPlotView3.view removeFromSuperview];
    [drawPlotView4.view removeFromSuperview];
    [drawPlotView5.view removeFromSuperview];
    [drawPlotView6.view removeFromSuperview];
    [drawPlotView7.view removeFromSuperview];
    [drawPlotViewTotal.view removeFromSuperview];
    drawPlotView7 = nil;
    drawPlotView6 = nil;
    drawPlotView5 = nil;
    drawPlotView4 = nil;
    drawPlotView3 = nil;
    drawPlotView2 = nil;
    drawPlotView1 = nil;
    drawPlotViewTotal = nil;

}

- (IBAction)selectDateType:(id)sender
{
    UIButton *selectBtn = (UIButton *)sender;
    NSLog(@"%@",selectBtn.titleLabel.text);
    //CGRect rect = drawPlotViewTotal.view.frame;
    if([selectBtn.titleLabel.text isEqualToString:@"每周"])
    {
        currentType = 0;
    }
    else if ([selectBtn.titleLabel.text isEqualToString:@"每月"])
    {
        currentType = 1;
    }
    else
    {
        currentType = 2;
    }
    for(UIButton *button in self.dateType)
    {
        if(selectBtn == button)
        {
            [button setSelected:YES];
        }
        else
        {
            [button setSelected:NO];
        }
    }
    [self removeViewFromScroller];
    [self initViewControllerS];
    [self addViewToScroller];
}

- (void)viewDidLoad
{
    //self.plotView.view.frame  = CGRectMake(0, 0, self.plotView.view.frame.size.width, self.plotView.view.frame.size.height);
    [self addViewToScroller];
    [self.ploatScroll setContentSize:CGSizeMake(self.ploatScroll.frame.size.width*8, self.ploatScroll.frame.size.height)];
    self.ploatScroll.delegate = self;
        //[self addSubPlotView];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x < 0)
    {
        return;
    }
    if(scrollView.contentOffset.x >= 320*8)
    {
        return;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"contentOffSet is %d",scrollView.contentOffset.x);
    currentPage = scrollView.contentOffset.x/scrollView.frame.size.width;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    self.scrollImage.frame = CGRectMake(currentPage*self.scrollImage.frame.size.width, self.scrollImage.frame.origin.y, self.scrollImage.frame.size.width, self.scrollImage.frame.size.height);
    [UIView commitAnimations];
    NSLog(@"hello world");
}
@end
