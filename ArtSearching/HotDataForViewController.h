//
//  HotDataForViewController.h
//  ArtSearching
//
//  Created by developer on 14-5-20.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    PlotTypeWork = 0,
    PlotTypeArtist ,
    PlotTypeGallery,
}CurrentTypeForPlot;
@interface HotDataForViewController : UIViewController
- (void)setPlotType:(CurrentTypeForPlot)plotType withID:(NSString *)typeID;
@end
