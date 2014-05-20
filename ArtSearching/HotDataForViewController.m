//
//  HotDataForViewController.m
//  ArtSearching
//
//  Created by developer on 14-5-20.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "HotDataForViewController.h"
#import "LCYCommon.h"
#import "XDHeader.h"
#import "TouchXML.h"
#import "CorePlot-CocoaTouch.h"
@interface HotDataForViewController ()<CPTPlotDataSource>
{
    CurrentTypeForPlot currentType;
    NSArray *_firstPlotData;
    NSArray *_secondPlotData;
    CPTXYGraph * _graph;
    __weak IBOutlet CPTGraphHostingView *hostingView;
}
- (IBAction)closeThis:(id)sender;

@property (nonatomic,strong)NSArray *firstPlotData;
@property (nonatomic,strong)NSArray *secondPlotData;
@end

@implementation HotDataForViewController
@synthesize firstPlotData = _firstPlotData;
@synthesize secondPlotData = _secondPlotData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        
    }
    return self;
}

- (void)setPlotType:(CurrentTypeForPlot)plotType withID:(NSString *)typeID
{
    if(PlotTypeWork == plotType)
    {
        [self requetOnWorkPVInfo:typeID];
    }
    else if (plotType == PlotTypeArtist)
    {
        [self requetOnArtistPVInfo:typeID];
    }
    else
    {
        [self requetOnGalleryPVInfo:typeID];
    }
}

- (void)requetOnWorkPVInfo:(NSString *)typeID
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",hostForXM,GETStarWorkPVInfoById];
    NSDictionary *dicParam = [NSDictionary dictionaryWithObjectsAndKeys:typeID,@"id", nil];
    AFHTTPRequestOperationManager *request = [AFHTTPRequestOperationManager manager];
    request.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [request POST:urlString parameters:dicParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *responseData = [operation responseData];
        CXMLDocument *document = [[CXMLDocument alloc] initWithData:responseData encoding:NSUTF8StringEncoding options:0 error:nil];
        CXMLElement *root = [document rootElement];
        NSData *jsonData = [[root stringValue] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSArray *firstPlotArr = [responseDic objectForKey:@"firstLineChart"];
        NSArray *secondPlotArr = [responseDic objectForKey:@"secondLineChart"];
        self.firstPlotData = firstPlotArr;
        self.secondPlotData = secondPlotArr;
        [self begainDrawPlot];
        [self maxOfArr:firstPlotArr];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ;
    }];
}

- (void)requetOnArtistPVInfo:(NSString *)typeID
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",hostForXM,GETStarArtistPVInfoById];
    NSDictionary *dicParam = [NSDictionary dictionaryWithObjectsAndKeys:typeID,@"id", nil];
    AFHTTPRequestOperationManager *request = [AFHTTPRequestOperationManager manager];
    request.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [request POST:urlString parameters:dicParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *responseData = [operation responseData];
        CXMLDocument *document = [[CXMLDocument alloc] initWithData:responseData encoding:NSUTF8StringEncoding options:0 error:nil];
        CXMLElement *root = [document rootElement];
        NSData *jsonData = [[root stringValue] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSArray *firstPlotArr = [responseDic objectForKey:@"firstLineChart"];
        NSArray *secondPlotArr = [responseDic objectForKey:@"secondLineChart"];
        self.firstPlotData = firstPlotArr;
        self.secondPlotData = secondPlotArr;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ;
    }];

}

- (void)requetOnGalleryPVInfo:(NSString *)typeID
{
     NSString *urlString = [NSString stringWithFormat:@"%@%@",hostForXM,GETSTARGALLERYPVINFOBYID];
    NSDictionary *dicParam = [NSDictionary dictionaryWithObjectsAndKeys:typeID,@"id", nil];
    AFHTTPRequestOperationManager *request = [AFHTTPRequestOperationManager manager];
    request.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [request POST:urlString parameters:dicParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *responseData = [operation responseData];
        CXMLDocument *document = [[CXMLDocument alloc] initWithData:responseData encoding:NSUTF8StringEncoding options:0 error:nil];
        CXMLElement *root = [document rootElement];
        NSData *jsonData = [[root stringValue] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSArray *firstPlotArr = [responseDic objectForKey:@"firstLineChart"];
        NSArray *secondPlotArr = [responseDic objectForKey:@"secondLineChart"];
        self.firstPlotData = firstPlotArr;
        self.secondPlotData = secondPlotArr;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ;
    }];
}

- (void)begainDrawPlot
{
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    _graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [_graph applyTheme:theme];
    hostingView.hostedGraph = _graph;
    _graph.paddingLeft = 10;
    _graph.paddingTop  = 10;
    
    CPTXYPlotSpace *spacePlot = (CPTXYPlotSpace *)_graph.defaultPlotSpace;
    spacePlot.allowsUserInteraction = YES;
    spacePlot.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(0.0f) length:CPTDecimalFromCGFloat(20.0)];
    NSNumber *maxNum = [self maxOfArr:self.firstPlotData];
    NSNumber *minNum = [self minOfArr:self.firstPlotData];
    spacePlot.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(minNum.floatValue-10) length:CPTDecimalFromCGFloat(maxNum.floatValue-minNum.floatValue)];
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)_graph.axisSet;
    lineStyle.miterLimit = 1;
    lineStyle.lineWidth  = 2;
    lineStyle.lineColor  = [CPTColor blackColor];
    CPTXYAxis *xAxis = axisSet.xAxis;
    CPTXYAxis *yAxis = axisSet.yAxis;
    xAxis.orthogonalCoordinateDecimal = CPTDecimalFromCGFloat(0);
    yAxis.orthogonalCoordinateDecimal = CPTDecimalFromCGFloat(0);
    
    xAxis.majorIntervalLength = CPTDecimalFromCGFloat(1);
    yAxis.majorIntervalLength = CPTDecimalFromCGFloat(1);
    
    xAxis.majorTickLength     = 1;
    yAxis.majorTickLength     = 1;
    
    xAxis.majorGridLineStyle  = lineStyle;
    yAxis.majorGridLineStyle  = lineStyle;
    
//    xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
//    yAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor redColor];
    lineStyle.lineWidth = 1;
    CPTScatterPlot *plotScatterOne = [[CPTScatterPlot alloc] init];
    plotScatterOne.dataLineStyle   = lineStyle;
    plotScatterOne.dataSource      = self;
    plotScatterOne.identifier      = @"plotScatterOne";
    [_graph addPlot:plotScatterOne];
    //float maxValue = [self.firstPlotData ]
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return self.firstPlotData.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    if(fieldEnum == CPTScatterPlotFieldX)
    {
        return [NSNumber numberWithInt:(idx)];
    }
    else
    {
        NSNumber *num = [self.firstPlotData objectAtIndex:idx];
        return num;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSNumber *)maxOfArr:(NSArray *)arr
{
    NSArray *tempArr = [NSArray arrayWithArray:arr];
    for(NSNumber *num in arr)
    {
        NSLog(@" num is %d ------",num.integerValue);
    }
    tempArr = [tempArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if([obj1 integerValue]>[obj2 integerValue])
        {
            return -1;
        }
        else if([obj1 integerValue]<[obj2 integerValue])
        {
            return 1;
        }
        else
        {
            return 0;
        }
            }];
    return [tempArr objectAtIndex:0];
}

-(NSNumber *)minOfArr:(NSArray *)arr
{
    NSArray *tempArr = [NSArray arrayWithArray:arr];
    tempArr = [tempArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if([obj1 integerValue]>[obj2 integerValue])
        {
            return -1;
        }
        else if([obj1 integerValue]<[obj2 integerValue])
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }];
    return [tempArr objectAtIndex:tempArr.count-1];
}

- (IBAction)closeThis:(id)sender
{
    [self.view removeFromSuperview];
}

@end
