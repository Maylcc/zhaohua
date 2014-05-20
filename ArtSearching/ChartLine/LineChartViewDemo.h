//
//  LineChartViewDemo.h
//  趋势线Demo
//
//  Created by 杜甲 on 14-3-1.
//  Copyright (c) 2014年 杜甲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineChartViewDemo : UIView

{
    NSNumber* maxDataPoint;
   NSNumber* minDataPoint;
    
    NSMutableArray *dataArray;
}
//横竖轴距离间隔
@property (assign) NSInteger hInterval;
@property (assign) NSInteger vInterval;

//横竖轴显示标签
@property (nonatomic, strong) NSArray *hDesc;
@property (nonatomic, strong) NSArray *vDesc;

//点信息
@property (nonatomic, strong) NSArray *array;

@property (nonatomic, strong) NSArray* array1;


@end
