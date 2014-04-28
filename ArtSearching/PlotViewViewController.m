//
//  PlotViewViewController.m
//  ArtSearching
//
//  Created by developer on 14-4-28.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//
#define GREEN_PLOT_IDENTIFIER @"hello"
#import "PlotViewViewController.h"

@interface PlotViewViewController ()
{
    NSMutableArray *dataArray;
}
@end

@implementation PlotViewViewController

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
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {

    [self setupCoreplotViews];
    [super viewDidAppear:animated];
}

- (void)setupCoreplotViews
{
    _dataForPlot = [NSMutableArray arrayWithCapacity:100];
    NSUInteger i;
    for ( i = 0; i < 100; i++ ) {
        id x = [NSNumber numberWithFloat:0 + i * 0.05];
        id y = [NSNumber numberWithFloat:1.2 * rand() / (float)RAND_MAX + 1.2];
        [_dataForPlot addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
    }
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    
    // Create graph from theme: 设置主题
    //
    _graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme * theme = [CPTTheme themeNamed:kCPTSlateTheme];
    [_graph applyTheme:theme];
    
    CPTGraphHostingView * hostingView = (CPTGraphHostingView *)self.view;
    hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    hostingView.hostedGraph = _graph;
    
    _graph.paddingLeft = _graph.paddingRight = 10.0;
    _graph.paddingTop = _graph.paddingBottom = 10.0;
    CPTXYPlotSpace * plotSpace = (CPTXYPlotSpace *)_graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(1.0) length:CPTDecimalFromFloat(2.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(1.0) length:CPTDecimalFromFloat(3.0)];
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)_graph.axisSet;
    
    lineStyle.miterLimit = 1.0f;
    lineStyle.lineWidth = 2.0;
    lineStyle.lineColor = [CPTColor whiteColor];
    
    CPTXYAxis * x = axisSet.xAxis;
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"2"); // 原点的 x 位置
    x.majorIntervalLength = CPTDecimalFromString(@"0.5");   // x轴主刻度：显示数字标签的量度间隔
    x.minorTicksPerInterval = 2;    // x轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    x.minorTickLineStyle = lineStyle;
    
    // 需要排除的不显示数字的主刻度
    NSArray * exclusionRanges = [NSArray arrayWithObjects:
                                 [self CPTPlotRangeFromFloat:0.99 length:0.02],
                                 [self CPTPlotRangeFromFloat:2.99 length:0.02],
                                 nil];
    x.labelExclusionRanges = exclusionRanges;
    
    CPTXYAxis * y = axisSet.yAxis;
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"2"); // 原点的 y 位置
    y.majorIntervalLength = CPTDecimalFromString(@"0.5");   // y轴主刻度：显示数字标签的量度间隔
    y.minorTicksPerInterval = 4;    // y轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    y.minorTickLineStyle = lineStyle;
    exclusionRanges = [NSArray arrayWithObjects:
                       [self CPTPlotRangeFromFloat:1.99 length:0.02],
                       [self CPTPlotRangeFromFloat:2.99 length:0.02],
                       nil];
    y.labelExclusionRanges = exclusionRanges;
    y.delegate = self;
    lineStyle                = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth      = 3.f;
    lineStyle.lineColor      = [CPTColor greenColor];
    lineStyle.dashPattern    = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:5.0f],
                                [NSNumber numberWithFloat:5.0f], nil];
    
    CPTScatterPlot * dataSourceLinePlot = [[CPTScatterPlot alloc] init];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    dataSourceLinePlot.identifier = GREEN_PLOT_IDENTIFIER;
    dataSourceLinePlot.dataSource = self;
    
    // Put an area gradient under the plot above
    //
    CPTColor * areaColor            = [CPTColor colorWithComponentRed:0.3 green:1.0 blue:0.3 alpha:0.8];
    CPTGradient * areaGradient      = [CPTGradient gradientWithBeginningColor:areaColor
                                                                  endingColor:[CPTColor clearColor]];
    CPTFill * areaGradientFill  = [CPTFill fillWithGradient:areaGradient];
    areaGradient.angle              = -90.0f;
    areaGradientFill                = [CPTFill fillWithGradient:areaGradient];
    dataSourceLinePlot.areaFill     = areaGradientFill;
    dataSourceLinePlot.areaBaseValue= CPTDecimalFromString(@"1.75");
    
    // Animate in the new plot: 淡入动画
    dataSourceLinePlot.opacity = 0.0f;
    
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.duration            = 3.0f;
    fadeInAnimation.removedOnCompletion = NO;
    fadeInAnimation.fillMode            = kCAFillModeForwards;
    fadeInAnimation.toValue             = [NSNumber numberWithFloat:1.0];
    [dataSourceLinePlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
    
    [_graph addPlot:dataSourceLinePlot];
    
}

-(BOOL)axis:(CPTAxis *)axis shouldUpdateAxisLabelsAtLocations:(NSSet *)locations
{
    static CPTTextStyle * positiveStyle = nil;
    static CPTTextStyle * negativeStyle = nil;
    
    NSNumberFormatter * formatter   = axis.labelFormatter;
    CGFloat labelOffset             = axis.labelOffset;
    NSDecimalNumber * zero          = [NSDecimalNumber zero];
    
    NSMutableSet * newLabels        = [NSMutableSet set];
    
    for (NSDecimalNumber * tickLocation in locations) {
        CPTTextStyle *theLabelTextStyle;
        
        if ([tickLocation isGreaterThanOrEqualTo:zero]) {
            if (!positiveStyle) {
                CPTMutableTextStyle * newStyle = [axis.labelTextStyle mutableCopy];
                newStyle.color = [CPTColor greenColor];
                positiveStyle  = newStyle;
            }
            
            theLabelTextStyle = positiveStyle;
        }
        else {
            if (!negativeStyle) {
                CPTMutableTextStyle * newStyle = [axis.labelTextStyle mutableCopy];
                newStyle.color = [CPTColor redColor];
                negativeStyle  = newStyle;
            }
            
            theLabelTextStyle = negativeStyle;
        }
        
        NSString * labelString      = [formatter stringForObjectValue:tickLocation];
        CPTTextLayer * newLabelLayer= [[CPTTextLayer alloc] initWithText:labelString style:theLabelTextStyle];
        
        CPTAxisLabel * newLabel     = [[CPTAxisLabel alloc] initWithContentLayer:newLabelLayer];
        newLabel.tickLocation       = tickLocation.decimalValue;
        newLabel.offset             = labelOffset;
        
        [newLabels addObject:newLabel];
    }
    
    axis.axisLabels = newLabels;
    
    return NO;
}

#pragma mark -
#pragma mark Plot Data Source Methods
-(CPTPlotRange *)CPTPlotRangeFromFloat:(float)location length:(float)length
{
    return [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(location) length:CPTDecimalFromFloat(length)];
}

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [_dataForPlot count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSString * key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
    NSNumber * num = [[_dataForPlot objectAtIndex:index] valueForKey:key];
    
    // Green plot gets shifted above the blue
    if ([(NSString *)plot.identifier isEqualToString:GREEN_PLOT_IDENTIFIER]) {
        if (fieldEnum == CPTScatterPlotFieldY) {
            num = [NSNumber numberWithDouble:[num doubleValue] + 1.0];
        }
    }
    
    return num;
}

@end
