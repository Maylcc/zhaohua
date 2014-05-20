//
//  XDPopUpView.h
//  XDCommonApp
//
//  Created by XD-XY on 3/11/14.
//  Copyright (c) 2014 XD-XY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineChartViewDemo.h"

@interface XDPopUpView : UIView
{
    NSString *historyHighAttention;
    NSString *historyHighScan;
    NSString *threeMonthHighAttention;
    NSString *threeMonthHighScan;
    NSString *todayAttentionData;
    NSString *todayScanData;
    
    NSMutableArray *pointArr;
    NSMutableArray  *pointArr2;
    
    UILabel *scanNum;
    UIImageView * imageView;// 背景
    UILabel *occNum;//关注
    UILabel *rateNum;
    
    UILabel *topLabel1;
    UILabel *topLabel2;
    UILabel *topLabel3;
    UILabel *topLabel4;
    
    LineChartViewDemo* Chartline;
    
}
-(void)setpopupviewshow:(BOOL)isshow;

- (void)GetStarWorkPVInfoById:(NSString*)workID;

- (void)GetStarArtistPVInfoById:(NSString*)workID;

- (void)GetStarGalleryPVInfoById:(NSString*)workID;

@end
