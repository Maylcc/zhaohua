//
//  PlotViewViewController.h
//  ArtSearching
//
//  Created by developer on 14-4-28.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlotHeaders/CorePlot-CocoaTouch.h"
@interface PlotViewViewController : UIViewController<CPTPlotDataSource, CPTAxisDelegate>
{
    //CPTXYGraph *graph;
    CPTXYGraph * _graph;
    NSMutableArray * _dataForPlot;
}
- (void)setupCoreplotViews;

-(CPTPlotRange *)CPTPlotRangeFromFloat:(float)location length:(float)length;

@end
