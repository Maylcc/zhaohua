//
//  DrawPlotViewController.h
//  ArtSearching
//
//  Created by developer on 14-5-15.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlotHeaders/CorePlot-CocoaTouch.h"
@interface DrawPlotViewController : UIViewController<CPTPlotDataSource, CPTAxisDelegate>
{
    CPTXYGraph *_graph;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *waitProgress;
- (id)initWithDataType:(NSInteger)dataType andQuestionID:(NSString *)questionID;
@end
