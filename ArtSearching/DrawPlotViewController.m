//
//  DrawPlotViewController.m
//  ArtSearching
//
//  Created by developer on 14-5-15.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "DrawPlotViewController.h"
#import <AFNetworking.h>
#import "LCYCommon.h"
#import "TouchXML.h"
#import "CPTPlot.h"
#define GREEN_PLOT_IDENTIFIER @"hello"
#define GREEN_PLOT_IDENTIFIER2 @"hello2"
@interface DrawPlotViewController ()
{
    NSInteger _dataType;
    NSString *_questionID;
    NSArray *_currentMarketIndexArr;
    NSArray *_currentConfidentIndexArr;
    NSString *fromString ;
    NSInteger fromValue;
    BOOL   isTotal;
}
@property (nonatomic,assign)NSInteger dataType;
@property (nonatomic,strong)NSString *questionID;
@end

@implementation DrawPlotViewController
@synthesize dataType = _dataType;
@synthesize questionID = _questionID;
- (id)initWithDataType:(NSInteger)dataType andQuestionID:(NSString *)questionID
{
    if(self = [super initWithNibName:@"DrawPlotViewController" bundle:nil])
    {
        self.dataType = dataType;
        self.questionID = questionID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.waitProgress startAnimating];
    AFHTTPRequestOperationManager *request = [AFHTTPRequestOperationManager manager];
    request.responseSerializer = [AFXMLParserResponseSerializer serializer];
    NSDate *dataPram = [NSDate date];
    NSInteger typePram = self.dataType;
    NSDictionary *dicPram = [NSDictionary dictionaryWithObjectsAndKeys:dataPram,@"Date",[NSNumber numberWithInteger:typePram],@"Type", nil];
    NSString *postURLString;
    if(_questionID == nil || _questionID.length == 0)
    {
        postURLString = [NSString stringWithFormat:@"%@%@",hostForXM,getMarketTotalIndex];
        isTotal = YES;
    }
    else
    {
        postURLString = [NSString stringWithFormat:@"%@%@",hostForXM,getQuestionlIndex];
        isTotal = NO;
    }
    [request POST:postURLString parameters:dicPram success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CXMLDocument *document = [[CXMLDocument alloc] initWithData:[operation responseData] options:0 error:nil];
        CXMLElement *rootElement = [document rootElement];
        NSString *stringForJSON = [rootElement stringValue];
        NSDictionary *dicJSON = [NSJSONSerialization JSONObjectWithData:[stringForJSON dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        NSArray *confidence;
        NSArray *market;
        if(isTotal)
        {
            confidence = [dicJSON objectForKey:@"confidenceIndex"];
            market     = [dicJSON objectForKey:@"marketIndex"];
        }
        else
        {
            confidence = [dicJSON objectForKey:@"answerIndex"];
            market     = [dicJSON objectForKey:@"marketIndex"];
        }
        [self.waitProgress stopAnimating];
        [self begainDrawPlotWithTotalMarketIndex:market andConfidentIndex:confidence];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请链接网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)begainDrawPlotWithTotalMarketIndex:(NSArray *)indexMArr andConfidentIndex:(NSArray *)indexCArr
{
    _currentConfidentIndexArr = indexCArr;
    _currentMarketIndexArr    = indexMArr;
    fromString = [[[_currentMarketIndexArr objectAtIndex:0] allKeys]objectAtIndex:0];
    fromValue  = [fromString integerValue];
    [self setupCoreplotViews];
}

- (void)setupCoreplotViews
{
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    
    // Create graph from theme: 设置主题
    //
    _graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme * theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [_graph applyTheme:theme];
    
    CPTGraphHostingView * hostingView = (CPTGraphHostingView *)self.view;
    hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    hostingView.hostedGraph = _graph;
    
    _graph.paddingLeft = _graph.paddingRight = 10.0;
    _graph.paddingTop = _graph.paddingBottom = 10.0;
    CPTXYPlotSpace * plotSpace = (CPTXYPlotSpace *)_graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = NO;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(fromValue-20120400-2) length:CPTDecimalFromFloat(8)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-10) length:CPTDecimalFromFloat(70)];
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)_graph.axisSet;
    
    lineStyle.miterLimit = 1.0f;
    lineStyle.lineWidth  = 3.0;
    lineStyle.lineColor  = [CPTColor redColor];
    
    CPTXYAxis * x = axisSet.xAxis;
    x.orthogonalCoordinateDecimal = CPTDecimalFromString([NSString stringWithFormat:@"%f",0.0]); // 原点的 x 位置
    x.majorIntervalLength = CPTDecimalFromString(@"2");   // x轴主刻度：显示数字标签的量度间隔
    x.minorTicksPerInterval = 1;    // x轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    x.minorTickLineStyle = lineStyle;
    //x.labelingPolicy = CPTAxisLabelingPolicyNone;
    // 需要排除的不显示数字的主刻度
    NSArray * exclusionRanges = [NSArray arrayWithObjects:
                                 [self CPTPlotRangeFromFloat:9.99 length:0.02],
                                 [self CPTPlotRangeFromFloat:2.99 length:0.02],
                                 nil];
    x.labelExclusionRanges = exclusionRanges;
    
    CPTXYAxis * y = axisSet.yAxis;
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"11"); // 原点的 y 位置
    y.majorIntervalLength = CPTDecimalFromString(@"10");   // y轴主刻度：显示数字标签的量度间隔
    y.minorTicksPerInterval = 0;    // y轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    y.minorTickLineStyle = lineStyle;
    NSNumberFormatter *labelFormatter = [[NSNumberFormatter alloc] init];
    labelFormatter.numberStyle = NSNumberFormatterNoStyle;
    y.labelFormatter = labelFormatter;
    exclusionRanges = [NSArray arrayWithObjects:
                       [self CPTPlotRangeFromFloat:-0.01 length:0.02],
                       [self CPTPlotRangeFromFloat:-10.0 length:0.02],
                       nil];
    //
    y.labelExclusionRanges = exclusionRanges;
    //y.delegate = self;
    
    //    lineStyle.dashPattern    = [NSArray arrayWithObjects:
    //                                [NSNumber numberWithFloat:5.0f],
    //                                [NSNumber numberWithFloat:5.0f], nil];
    
    CPTScatterPlot * dataSourceLinePlot = [[CPTScatterPlot alloc] init];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    dataSourceLinePlot.identifier = GREEN_PLOT_IDENTIFIER;
    dataSourceLinePlot.dataSource = self;
    
    dataSourceLinePlot.opacity = 0.0f;
    
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.duration            = 3.0f;
    fadeInAnimation.removedOnCompletion = NO;
    fadeInAnimation.fillMode            = kCAFillModeForwards;
    fadeInAnimation.toValue             = [NSNumber numberWithFloat:1.0];
    [dataSourceLinePlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
    
    lineStyle                = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth      = 1.f;
    lineStyle.lineColor      = [CPTColor greenColor];
    //**********
    CPTScatterPlot * dataSourceLinePlot2 = [[CPTScatterPlot alloc] init];
    dataSourceLinePlot2.dataLineStyle = lineStyle;
    dataSourceLinePlot2.identifier = GREEN_PLOT_IDENTIFIER2;
    dataSourceLinePlot2.dataSource = self;
    
    // Put an area gradient under the plot above
    //
    CPTColor * areaColor2            = [CPTColor colorWithComponentRed:0.3 green:0.3 blue:0.3 alpha:0.8];
    CPTGradient * areaGradient2      = [CPTGradient gradientWithBeginningColor:areaColor2
                                                                   endingColor:[CPTColor clearColor]];
    CPTFill * areaGradientFill2  = [CPTFill fillWithGradient:areaGradient2];
    areaGradient2.angle              = -90.0f;
    areaGradientFill2                = [CPTFill fillWithGradient:areaGradient2];
    dataSourceLinePlot2.areaFill2    = areaGradientFill2;
    dataSourceLinePlot2.areaBaseValue= CPTDecimalFromString(@"1.75");
    
    // Animate in the new plot: 淡入动画
    dataSourceLinePlot2.opacity = 0.0f;
    
    CABasicAnimation *fadeInAnimation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation2.duration            = 3.0f;
    fadeInAnimation2.removedOnCompletion = NO;
    fadeInAnimation2.fillMode            = kCAFillModeForwards;
    fadeInAnimation2.toValue             = [NSNumber numberWithFloat:1.0];
    [dataSourceLinePlot2 addAnimation:fadeInAnimation2 forKey:@"animateOpacity"];
    [_graph addPlot:dataSourceLinePlot];
    [_graph addPlot:dataSourceLinePlot2];
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
    return [_currentMarketIndexArr count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSDictionary *dicM = [_currentMarketIndexArr objectAtIndex:index];
    NSString *xKeyM = [dicM.allKeys objectAtIndex:0];
    NSNumber *xNumM = [NSNumber numberWithInt:xKeyM.intValue-20120400];
    NSString *yKeyM = [dicM objectForKey:xKeyM];
    NSNumber *yNumM = [NSNumber numberWithInt:yKeyM.intValue];
    
    NSDictionary *dicC = [_currentConfidentIndexArr objectAtIndex:index];
    NSString *xKeyC = [dicC.allKeys objectAtIndex:0];
    NSNumber *xNumC = [NSNumber numberWithInt:xKeyC.intValue-20120400];
    NSString *yKeyC = [dicC objectForKey:xKeyC];
    NSNumber *yNumC = [NSNumber numberWithInt:yKeyC.intValue];
    if(fieldEnum == CPTScatterPlotFieldY)
    {
        //        if ([(NSString *)plot.identifier isEqualToString:GREEN_PLOT_IDENTIFIER])
        //        {
        //
        //            return yNumM;
        //        }
        //        else
        //        {
        //            return yNumC;
        //        }
        return yNumC;
        
    }
    else
    {
        return xNumC;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
