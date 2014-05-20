//
//  XDPopUpView.m
//  XDCommonApp
//
//  Created by XD-XY on 3/11/14.
//  Copyright (c) 2014 XD-XY. All rights reserved.
//

#import "XDPopUpView.h"
#import "XDTools.h"
#import "XDHeader.h"


#define CC_DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * 0.01745329252f)
#define KlineHeight 10
#define KlineWidth 15

#define dColorBottemText RGBA(166, 166, 166, 1)
#define dFontBottomText9  [UIFont systemFontOfSize:9]
#define dFontBottomText12  [UIFont systemFontOfSize:12]
#define dColorLine      RGBA(144, 179, 111, 1)
@implementation XDPopUpView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self makeView];
    }
    return self;
}

-(void)makeView
{
    self.frame  = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    
    UIView * vview = [[UIView alloc] initWithFrame:CGRectMake(0, 0+64, 320, 360/2)];
    vview.backgroundColor = [UIColor blackColor];
    [self addSubview:vview];
    
    UIView * ddView = [[UIView alloc] initWithFrame:CGRectMake(0, 360/2+64, 320,self.frame.size.height-360/2)];
    ddView.backgroundColor = [UIColor blackColor];
    [ddView setAlpha:0.8];
    [self addSubview:ddView];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,64+15,300,360/2)];
    imageView.backgroundColor = RGBA(163, 199, 127, 1);
//    imageView.image = [UIImage imageNamed:@"55"];
    UILabel *scanLabel = [[UILabel alloc]init];
    [scanLabel setFrame:CGRectMake(10, 10, 60, 18)];
    [scanLabel setText:@"浏览数据"];
    [scanLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [scanLabel setTextColor:RGBA(246, 249, 243, 1)];
    [scanLabel setBackgroundColor:[UIColor clearColor]];
    
    UILabel *latestLabel = [[UILabel alloc]init];
    [latestLabel setTextColor:RGBA(213, 237, 181, 1)];
    [latestLabel setFont:[UIFont systemFontOfSize:11]];
    latestLabel.frame = CGRectMake(10, height_y(scanLabel), 60, 18);
    latestLabel.text = @"最近12周";
    latestLabel.backgroundColor  = [UIColor clearColor];
    
    [imageView addSubview:latestLabel];
    [imageView addSubview:scanLabel];
   
    ///// 画虚线
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 70, 200, 2)];
//    [self.view addSubview:imageView1];
    [imageView addSubview:imageView1];
    
    UIGraphicsBeginImageContext(imageView1.frame.size);   //开始画线
    [imageView1.image drawInRect:CGRectMake(0, 70, imageView1.frame.size.width, imageView1.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    
    float lengths[] = {2,1};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, dColorLine.CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 1);  //画虚线
    CGContextMoveToPoint(line, 0.0, 2.0);    //开始画线
    CGContextAddLineToPoint(line, 200.0, 2.0);
    CGContextStrokePath(line);
    
    imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
    ///////折线图
    
    // line.layer.transform =  CATransform3DMakeRotation(CC_DEGREES_TO_RADIANS(90), 0, 0, 1);
  
    
    //生成随机点   1
//    //[pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(KlineWidth*0, 0)]];
//    for (int i = 5; i < 12; i++) {
////        [pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(KlineWidth* (i+1), 15 * i)]];
//        
//    }
    
   
    //生成随机点   2
    
//    for (int i = 5; i < 12; i++) {
////        [pointArr2 addObject:[NSValue valueWithCGPoint:CGPointMake(KlineWidth* (i + 1), 10 * i)]];
//    }
    
    
    
    
    //竖轴

//    NSMutableArray *vArr = [[NSMutableArray alloc]initWithCapacity:6];
//    for (int i=2; i<9; i++) {
//        [vArr addObject:[NSString stringWithFormat:@"%d",i*20]];
//    }
    


    
    
    
    
    
    //横轴

//    NSMutableArray *hArr = [[NSMutableArray alloc]initWithCapacity:6];
//    
//    for (int i = 1; i <= 12; i++) {
//        [hArr addObject:[NSString stringWithFormat:@"%d",i]];
//    }


    
    
//    [Chartline setHDesc:hArr];
//    [Chartline setVDesc:vArr];
//    [Chartline setArray:pointArr];
//    [Chartline setArray1:pointArr2];
    
//    [imageView addSubview:Chartline];
    

    
    ///// 右侧
    
    UIImageView *sanIV = [[UIImageView alloc]init];
    sanIV.frame = CGRectMake(width_x(scanLabel)+145, 13, 10, 10);
//    sanIV.backgroundColor = [UIColor redColor];
    sanIV.image = [UIImage imageNamed:@"whitess@2x"];
    
    [imageView addSubview:sanIV];
    
    scanNum = [[UILabel alloc]init];
    [scanNum setFrame:CGRectMake(width_x(sanIV)+5, 10, 60, 15)];
    scanNum.text = @"浏览:  22";
    scanNum.backgroundColor = [UIColor clearColor];
    scanNum.font = [UIFont boldSystemFontOfSize:10];
    [scanNum setTextColor:RGBA(248, 249, 244, 1)];
    
    [imageView addSubview:scanNum];
    
    
    /////关注
    UIImageView *occrIV = [[UIImageView alloc]init];
    occrIV.frame = CGRectMake(width_x(scanLabel)+145, height_y(sanIV)+5, 10, 10);
//    occrIV.backgroundColor = [UIColor redColor];
    occrIV.image = [UIImage imageNamed:@"whitesd@2x"];
    
    [imageView addSubview:occrIV];
    
    occNum = [[UILabel alloc]init];
    [occNum setFrame:CGRectMake(width_x(occrIV)+5, height_y(scanNum), 60, 15)];
    occNum.text = @"关注:  2";
    occNum.backgroundColor = [UIColor clearColor];
    occNum.font = [UIFont boldSystemFontOfSize:10];
    [occNum setTextColor:RGBA(248, 249, 244, 1)];
    
    [imageView addSubview:occNum];
    //////关注率
    
    UIImageView *rateIV = [[UIImageView alloc]init];
    rateIV.frame = CGRectMake(width_x(scanLabel)+130, height_y(occrIV)+3, 10, 10);
//    rateIV.backgroundColor = [UIColor redColor];
    rateIV.image = [UIImage imageNamed:@"greensan@2x"];
    
    [imageView addSubview:rateIV];
    
    rateNum = [[UILabel alloc]init];
    [rateNum setFrame:CGRectMake(width_x(rateIV)+5, height_y(occNum), 70, 12)];
    rateNum.text = @"关注率: 12.2%";
    rateNum.backgroundColor = [UIColor clearColor];
    rateNum.font = [UIFont boldSystemFontOfSize:8];
    [rateNum setTextColor:RGBA(221, 243, 187, 1)];
    
    [imageView addSubview:rateNum];

    ////
//    图示
    UIImageView *picIntroIV = [[UIImageView alloc]init];
    picIntroIV.frame = CGRectMake(230, 90, 20, 10);
//    picIntroIV.backgroundColor = [UIColor redColor];
    picIntroIV.image = [UIImage imageNamed:@"whiteline@2x"];
    [imageView addSubview:picIntroIV];
    UILabel *picIntroLb = [[UILabel alloc]init];
    picIntroLb.backgroundColor = [UIColor clearColor];
    picIntroLb.text = @"浏览量";
    picIntroLb.frame = CGRectMake(width_x(picIntroIV)+10, picIntroIV.frame.origin.y-5, 50, 20);
    picIntroLb.font = [UIFont systemFontOfSize:10.5];
    picIntroLb.textColor = [UIColor whiteColor];
    [imageView addSubview:picIntroLb];
    //////
    
    UIImageView *picGreenIV = [[UIImageView alloc]init];
    picGreenIV.frame = CGRectMake(230, height_y(picIntroLb)+5, 20, 10);
//    picGreenIV.backgroundColor = [UIColor greenColor];
    picGreenIV.image = [UIImage imageNamed:@"greenline@2x"];
    [imageView addSubview:picGreenIV];
    UILabel *picGreenIntroLb = [[UILabel alloc]init];
    picGreenIntroLb.backgroundColor = [UIColor clearColor];
    picGreenIntroLb.text = @"收藏量";
    picGreenIntroLb.frame = CGRectMake(width_x(picGreenIV)+10, picGreenIV.frame.origin.y-5, 50, 20);
    picGreenIntroLb.font = [UIFont systemFontOfSize:10.5];
    picGreenIntroLb.textColor = [UIColor whiteColor];
    [imageView addSubview:picGreenIntroLb];
    //////////
//    统计文字
    
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.frame = CGRectMake(0, 130, 300, 44);
    
    UILabel *hline1 = [[UILabel alloc]init];
    hline1.backgroundColor = RGBA(225, 237, 212, 1);
    hline1.frame = CGRectMake(74, 5, 1, 34);
    [bgView addSubview:hline1];
    
    UILabel *hline2 = [[UILabel alloc]init];
    hline2.backgroundColor = RGBA(225, 237, 212, 1);
    hline2.frame = CGRectMake(width_x(hline1)+74, 5, 1, 34);
    [bgView addSubview:hline2];
    
    UILabel *hline3 = [[UILabel alloc]init];
    hline3.backgroundColor = RGBA(225, 237, 212, 1);
    hline3.frame = CGRectMake(width_x(hline2)+74, 5, 1, 34);
    [bgView addSubview:hline3];
    
    topLabel1 = [[UILabel alloc]init];
    topLabel1.frame = CGRectMake(0, 4, 74, 20);
    topLabel1.text = @"21次";
    topLabel1.textColor = RGBA(82, 124, 31, 1);
    topLabel1.textAlignment = NSTextAlignmentCenter;
    topLabel1.font = dFontBottomText12;
    [bgView addSubview:topLabel1];
    
    topLabel2 = [[UILabel alloc]init];
    topLabel2.frame = CGRectMake(width_x(hline1), 4, 74, 20);
    topLabel2.text = @"12次";
    topLabel2.textColor = RGBA(82, 124, 31, 1);
    topLabel2.textAlignment = NSTextAlignmentCenter;
      topLabel2.font = dFontBottomText12;
    [bgView addSubview:topLabel2];
    
    topLabel3 = [[UILabel alloc]init];
    topLabel3.frame = CGRectMake(width_x(hline2), 4, 74, 20);
    topLabel3.text = @"2次";
    topLabel3.textColor = RGBA(82, 124, 31, 1);
    topLabel3.textAlignment = NSTextAlignmentCenter;
      topLabel3.font = dFontBottomText12;
    [bgView addSubview:topLabel3];
    
    topLabel4 = [[UILabel alloc]init];
    topLabel4.frame = CGRectMake(width_x(hline3), 4, 74, 20);
    topLabel4.text = @"2次";
    topLabel4.textColor = RGBA(82, 124, 31, 1);
    topLabel4.textAlignment = NSTextAlignmentCenter;
      topLabel4.font = dFontBottomText12;
    [bgView addSubview:topLabel4];

    //    、、、 底部描述
    UILabel *bottomLabel1 = [[UILabel alloc]init];
    bottomLabel1.frame = CGRectMake(0, 24, 74, 20);
    bottomLabel1.text = @"历史最高浏览量";
    bottomLabel1.textColor = dColorBottemText;
    bottomLabel1.textAlignment = NSTextAlignmentCenter;
    bottomLabel1.font = dFontBottomText9;
    [bgView addSubview:bottomLabel1];
    
    UILabel *bottomLabel2 = [[UILabel alloc]init];
    bottomLabel2.frame = CGRectMake(width_x(hline1), 24, 74, 20);
    bottomLabel2.text = @"历史最高关注量";
    bottomLabel2.textColor =dColorBottemText;
    bottomLabel2.textAlignment = NSTextAlignmentCenter;
    bottomLabel2.font = dFontBottomText9;
    [bgView addSubview:bottomLabel2];
    
    UILabel *bottomLabel3 = [[UILabel alloc]init];
    bottomLabel3.frame = CGRectMake(width_x(hline2), 24, 74, 20);
    bottomLabel3.text = @"12周最高浏览量";
    bottomLabel3.textColor = dColorBottemText;
    bottomLabel3.textAlignment = NSTextAlignmentCenter;
    bottomLabel3.font = dFontBottomText9;
    [bgView addSubview:bottomLabel3];
    
    UILabel *bottomLabel4 = [[UILabel alloc]init];
    bottomLabel4.frame = CGRectMake(width_x(hline3), 24, 74, 20);
    bottomLabel4.text = @"12周最高关注量";
    bottomLabel4.textColor = dColorBottemText;
    bottomLabel4.textAlignment = NSTextAlignmentCenter;
    bottomLabel4.font = dFontBottomText9;
    [bgView addSubview:bottomLabel4];
    
    [imageView addSubview:bgView];
    
    
    
    
    [self addSubview:imageView];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font  = [UIFont systemFontOfSize:15];
    button.frame = CGRectMake(220/2, self.frame.size.height-50-34/2.0f, 100, 50);
    [self addSubview:button];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];

    self.hidden =YES;
}

-(void)btnClick
{
    [self setpopupviewshow:NO];
}

-(void)setpopupviewshow:(BOOL)isshow
{
    if(!isshow){
        self.hidden =YES;
    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        self.hidden =NO;
    }
}
/**/
- (void)GetStarWorkPVInfoById:(NSString*)workID// 明星作品查看折线图
{

    if ([XDTools NetworkReachable]){
        NSString *body = [NSString stringWithFormat:@"<GetStarWorkPVInfoById xmlns=\"http://tempuri.org/\">"
                          "<workId>%@</workId>"
                          "</GetStarWorkPVInfoById>",workID];
        __weak ASIFormDataRequest *request = [XDTools postRequestWithDict:body API:GETStarWorkPVInfoById];
        [request setCompletionBlock:^{
            [XDTools hideProgress:self];
            //[XDTools hideProgress:self.contentView];
            NSString *responseString = [request responseString];
            // NSDictionary *tempDic = [XDTools  JSonFromString:responseString];
            DDLOG(@"responseString:%@", responseString);
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            int statusCode = [request responseStatusCode];
            NSString *soapAction = [[request requestHeaders] objectForKey:@"SOAPAction"];
            
            NSArray *arraySOAP =[soapAction componentsSeparatedByString:@"/"];
            int count = [arraySOAP count] - 1;
            NSString *methodName = [arraySOAP objectAtIndex:count];
            
            // Use when fetching text data
            NSString *result = nil;
            if (statusCode == 200) {
                //表示正常请求
                result = [SoapXmlParseHelper SoapMessageResultXml:responseString ServiceMethodName:methodName];
                NSDictionary  *responseDict = [XDTools JSonFromString:result];
                if ([[responseDict objectForKey:@"code"] intValue]==0){
                    DDLOG(@"res = %@",responseDict);
                    
                    pointArr = [[NSMutableArray alloc]init];
                    pointArr2 = [[NSMutableArray alloc]init];
                    NSArray * arr1 = [[NSArray alloc]init];
                    NSArray *arr2 = [[NSArray alloc]init];
                    
                    arr1 = [responseDict valueForKey:@"firstLineChart"];
                    arr2 = [responseDict valueForKey:@"secondLineChart"];
                    int arrcount1 = arr1.count;
                    if (arrcount1>12) {
                        arrcount1=12;
                    }
                    
                    for (int i = 0; i < arrcount1; i++) {
                        
                        [pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(i*15, [[arr1 objectAtIndex:i] intValue]/10)]];
                        
                    }
                    
                    int arrcount = arr2.count;
                    if (arrcount>12) {
                        arrcount=12;
                    }
                    for (int i = 0; i < arrcount; i++) {
                        
                        [pointArr2 addObject:[NSValue valueWithCGPoint:CGPointMake(i*15, [[arr2 objectAtIndex:i] intValue]/10)]];
                        
                    }
                    
                    
                    historyHighAttention = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"historyHighAttention"]];
                    
                    if (![historyHighAttention isKindOfClass:[NSNull class]]&&![historyHighAttention isEqualToString:@"<null>"]) {
                        
                        topLabel2.text =[NSString stringWithFormat:@"%@次", historyHighAttention];//
                    }
                    
                    historyHighScan = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"historyHighScan"]];
                    
                    if (![historyHighScan isKindOfClass:[NSNull class]]&&![historyHighScan isEqualToString:@"<null>"]) {
                        
                        topLabel1.text = [NSString stringWithFormat:@"%@次", historyHighScan];//
                    }
                    
                    threeMonthHighAttention = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"threeMonthHighAttention"]];
                   
                    if (![threeMonthHighAttention isKindOfClass:[NSNull class]]&&![threeMonthHighAttention isEqualToString:@"<null>"]) {
                        
                        topLabel4.text = [NSString stringWithFormat:@"%@次", threeMonthHighAttention];//
                    }
                    
                    threeMonthHighScan = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"threeMonthHighScan"]];
                    
                    if (![threeMonthHighScan isKindOfClass:[NSNull class]]&&![threeMonthHighScan isEqualToString:@"<null>"]) {
                        
                        topLabel3.text = [NSString stringWithFormat:@"%@次", threeMonthHighScan];//
                    }
                    
                    todayAttentionData = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"todayAttentionData"]];
                    
                    if (![todayAttentionData isKindOfClass:[NSNull class]]&&![todayAttentionData isEqualToString:@"<null>"]) {
                        
                        occNum.text = [NSString stringWithFormat:@"关注: %@", todayAttentionData];//
                    }
                    
                    todayScanData = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"todayScanData"]];
                    
                    if (![todayScanData isKindOfClass:[NSNull class]]&&![todayScanData isEqualToString:@"<null>"]) {
                        
                        scanNum.text = [NSString stringWithFormat:@"浏览: %@", todayScanData];//
                    }
                    float ratefloat=0.0;
                    if ([todayScanData intValue]==!0) {
                        
                        ratefloat = [todayAttentionData floatValue]/[todayScanData floatValue];
                    }
                    
                    rateNum.text =[NSString stringWithFormat:@"关注率: %.1f %%",ratefloat];
                    
                    if (Chartline!=nil) {
                        [Chartline removeFromSuperview];
                    }
                    
                    Chartline = [[LineChartViewDemo alloc] initWithFrame:CGRectMake(0, 50, 200, 90)];
                    Chartline.backgroundColor = [UIColor clearColor];
                    
                    //横轴
                    NSMutableArray *hArr = [[NSMutableArray alloc]init ];//WithCapacity:arrcount-1];
                    
                    for (int i = 0; i < 12; i++) {
                        [hArr addObject:[NSString stringWithFormat:@"%d",i]];
                    }
                    
                    
//                    [Chartline setHDesc:hArr];
//                    [line setVDesc:vArr];
                    
                    [Chartline setArray:pointArr];
                    [Chartline setArray1:pointArr2];
                    
                    [imageView addSubview:Chartline];
                }
            }
        }];
        
        [request setFailedBlock:^{
            [XDTools hideProgress:self];
        }];
        
        [request startAsynchronous];
        [XDTools showProgress:self];
    }else{
        [XDTools showTips:brokenNetwork toView:self];
    }

}

/**/
- (void)GetStarArtistPVInfoById:(NSString*)workID// 明星艺术家
{

    if ([XDTools NetworkReachable]){
        NSString *body = [NSString stringWithFormat:@"<GetStarArtistPVInfoById xmlns=\"http://tempuri.org/\">"
                          "<artistId>%@</artistId>"
                          "</GetStarArtistPVInfoById>",workID];
        __weak ASIFormDataRequest *request = [XDTools postRequestWithDict:body API:GETStarArtistPVInfoById];
        [request setCompletionBlock:^{
            [XDTools hideProgress:self];
            //[XDTools hideProgress:self.contentView];
            NSString *responseString = [request responseString];
            // NSDictionary *tempDic = [XDTools  JSonFromString:responseString];
            DDLOG(@"responseString:%@", responseString);
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            int statusCode = [request responseStatusCode];
            NSString *soapAction = [[request requestHeaders] objectForKey:@"SOAPAction"];
            
            NSArray *arraySOAP =[soapAction componentsSeparatedByString:@"/"];
            int count = [arraySOAP count] - 1;
            NSString *methodName = [arraySOAP objectAtIndex:count];
            
            // Use when fetching text data
            NSString *result = nil;
            if (statusCode == 200) {
                //表示正常请求
                result = [SoapXmlParseHelper SoapMessageResultXml:responseString ServiceMethodName:methodName];
                NSDictionary  *responseDict = [XDTools JSonFromString:result];
                if ([[responseDict objectForKey:@"code"] intValue]==0){
                    DDLOG(@"res = %@",responseDict);
                    
                    pointArr = [[NSMutableArray alloc]init];
                    pointArr2 = [[NSMutableArray alloc]init];
                    NSArray * arr1 = [[NSArray alloc]init];
                    NSArray *arr2 = [[NSArray alloc]init];
                    
                    arr1 = [responseDict valueForKey:@"firstLineChart"];
                    arr2 = [responseDict valueForKey:@"secondLineChart"];
                    
                    //                    for (int i = 0; i < arr1.count; i++) {
                    //
                    //                        [pointArr addObject:[NSValue valueWithCGPoint:CGPointMake([[arr1 objectAtIndex:i] intValue], 1 * i)]];
                    //
                    //                    }
                    //
                    //                    for (int i = 0; i < arr2.count; i++) {
                    //
                    //                        [pointArr2 addObject:[NSValue valueWithCGPoint:CGPointMake([[arr2 objectAtIndex:i] intValue], 1 * i)]];
                    //
                    //                    }
                    
                    for (int i = 0; i < arr1.count; i++) {
                        
                        [pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(i*10, [[arr1 objectAtIndex:i] intValue]/10)]];
                        
                    }
                    
                    for (int i = 0; i < arr2.count; i++) {
                        
                        [pointArr2 addObject:[NSValue valueWithCGPoint:CGPointMake(i*10, [[arr2 objectAtIndex:i] intValue]/10)]];
                        
                    }
                    
                    
                    historyHighAttention = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"historyHighAttention"]];
                    
                    if (![historyHighAttention isKindOfClass:[NSNull class]]&&![historyHighAttention isEqualToString:@"<null>"]) {
                        
                        topLabel2.text =[NSString stringWithFormat:@"%@次", historyHighAttention];//
                    }
                    
                    historyHighScan = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"historyHighScan"]];
                    
                    if (![historyHighScan isKindOfClass:[NSNull class]]&&![historyHighScan isEqualToString:@"<null>"]) {
                        
                        topLabel1.text = [NSString stringWithFormat:@"%@次", historyHighScan];//
                    }
                    
                    threeMonthHighAttention = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"threeMonthHighAttention"]];
                    
                    if (![threeMonthHighAttention isKindOfClass:[NSNull class]]&&![threeMonthHighAttention isEqualToString:@"<null>"]) {
                        
                        topLabel4.text = [NSString stringWithFormat:@"%@次", threeMonthHighAttention];//
                    }
                    
                    threeMonthHighScan = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"threeMonthHighScan"]];
                    
                    if (![threeMonthHighScan isKindOfClass:[NSNull class]]&&![threeMonthHighScan isEqualToString:@"<null>"]) {
                        
                        topLabel3.text = [NSString stringWithFormat:@"%@次", threeMonthHighScan];//
                    }
                    
                    todayAttentionData = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"todayAttentionData"]];
                    
                    if (![todayAttentionData isKindOfClass:[NSNull class]]&&![todayAttentionData isEqualToString:@"<null>"]) {
                        
                        occNum.text = [NSString stringWithFormat:@"关注: %@", todayAttentionData];//
                    }
                    
                    todayScanData = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"todayScanData"]];
                    
                    if (![todayScanData isKindOfClass:[NSNull class]]&&![todayScanData isEqualToString:@"<null>"]) {
                        
                        scanNum.text = [NSString stringWithFormat:@"浏览: %@", todayScanData];//
                    }
                    float ratefloat=0.0;
                    if ([todayScanData intValue]==!0) {
                        
                        ratefloat = [todayAttentionData floatValue]/[todayScanData floatValue];
                    }
                    
                    rateNum.text =[NSString stringWithFormat:@"关注率: %.1f %%",ratefloat];
                    
                    if (Chartline!=nil) {
                        [Chartline removeFromSuperview];
                    }
                    
                    Chartline = [[LineChartViewDemo alloc] initWithFrame:CGRectMake(0, 50, 200, 90)];
                    Chartline.backgroundColor = [UIColor clearColor];
                    
                    [Chartline setArray:pointArr];
                    [Chartline setArray1:pointArr2];
                    
                    [imageView addSubview:Chartline];
                }
            }
        }];
        
        [request setFailedBlock:^{
            [XDTools hideProgress:self];
        }];
        
        [request startAsynchronous];
        [XDTools showProgress:self];
    }else{
        [XDTools showTips:brokenNetwork toView:self];
    }

}

/**/
- (void)GetStarGalleryPVInfoById:(NSString*)workID// 明星画廊
{

    if ([XDTools NetworkReachable]){
        NSString *body = [NSString stringWithFormat:@"<GetStarGalleryPVInfoById xmlns=\"http://tempuri.org/\">"
                          "<galleryId>%@</galleryId>"
                          "</GetStarGalleryPVInfoById>",workID];
        __weak ASIFormDataRequest *request = [XDTools postRequestWithDict:body API:GETStarGalleryPVInfoById];
        [request setCompletionBlock:^{
            [XDTools hideProgress:self];
            //[XDTools hideProgress:self.contentView];
            NSString *responseString = [request responseString];
            // NSDictionary *tempDic = [XDTools  JSonFromString:responseString];
            DDLOG(@"responseString:%@", responseString);
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            int statusCode = [request responseStatusCode];
            NSString *soapAction = [[request requestHeaders] objectForKey:@"SOAPAction"];
            
            NSArray *arraySOAP =[soapAction componentsSeparatedByString:@"/"];
            int count = [arraySOAP count] - 1;
            NSString *methodName = [arraySOAP objectAtIndex:count];
            
            // Use when fetching text data
            NSString *result = nil;
            if (statusCode == 200) {
                //表示正常请求
                result = [SoapXmlParseHelper SoapMessageResultXml:responseString ServiceMethodName:methodName];
                NSDictionary  *responseDict = [XDTools JSonFromString:result];
                if ([[responseDict objectForKey:@"code"] intValue]==0){
                    DDLOG(@"res = %@",responseDict);
                    
                    pointArr = [[NSMutableArray alloc]init];
                    pointArr2 = [[NSMutableArray alloc]init];
                    NSArray * arr1 = [[NSArray alloc]init];
                    NSArray *arr2 = [[NSArray alloc]init];
                    
                    arr1 = [responseDict valueForKey:@"firstLineChart"];
                    arr2 = [responseDict valueForKey:@"secondLineChart"];
                    
                    //                    for (int i = 0; i < arr1.count; i++) {
                    //
                    //                        [pointArr addObject:[NSValue valueWithCGPoint:CGPointMake([[arr1 objectAtIndex:i] intValue], 1 * i)]];
                    //
                    //                    }
                    //
                    //                    for (int i = 0; i < arr2.count; i++) {
                    //
                    //                        [pointArr2 addObject:[NSValue valueWithCGPoint:CGPointMake([[arr2 objectAtIndex:i] intValue], 1 * i)]];
                    //
                    //                    }
                    
                    for (int i = 0; i < arr1.count; i++) {
                        
                        [pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(i*10, [[arr1 objectAtIndex:i] intValue]/10)]];
                        
                    }
                    
                    for (int i = 0; i < arr2.count; i++) {
                        
                        [pointArr2 addObject:[NSValue valueWithCGPoint:CGPointMake(i*10, [[arr2 objectAtIndex:i] intValue]/10)]];
                        
                    }
                    
                    
                    historyHighAttention = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"historyHighAttention"]];
                    
                    if (![historyHighAttention isKindOfClass:[NSNull class]]&&![historyHighAttention isEqualToString:@"<null>"]) {
                        
                        topLabel2.text =[NSString stringWithFormat:@"%@次", historyHighAttention];//
                    }
                    
                    historyHighScan = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"historyHighScan"]];
                    
                    if (![historyHighScan isKindOfClass:[NSNull class]]&&![historyHighScan isEqualToString:@"<null>"]) {
                        
                        topLabel1.text = [NSString stringWithFormat:@"%@次", historyHighScan];//
                    }
                    
                    threeMonthHighAttention = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"threeMonthHighAttention"]];
                    
                    if (![threeMonthHighAttention isKindOfClass:[NSNull class]]&&![threeMonthHighAttention isEqualToString:@"<null>"]) {
                        
                        topLabel4.text = [NSString stringWithFormat:@"%@次", threeMonthHighAttention];//
                    }
                    
                    threeMonthHighScan = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"threeMonthHighScan"]];
                    
                    if (![threeMonthHighScan isKindOfClass:[NSNull class]]&&![threeMonthHighScan isEqualToString:@"<null>"]) {
                        
                        topLabel3.text = [NSString stringWithFormat:@"%@次", threeMonthHighScan];//
                    }
                    
                    todayAttentionData = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"todayAttentionData"]];
                    
                    if (![todayAttentionData isKindOfClass:[NSNull class]]&&![todayAttentionData isEqualToString:@"<null>"]) {
                        
                        occNum.text = [NSString stringWithFormat:@"关注: %@", todayAttentionData];//
                    }
                    
                    todayScanData = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"todayScanData"]];
                    
                    if (![todayScanData isKindOfClass:[NSNull class]]&&![todayScanData isEqualToString:@"<null>"]) {
                        
                        scanNum.text = [NSString stringWithFormat:@"浏览: %@", todayScanData];//
                    }
                    float ratefloat=0.0;
                    if ([todayScanData intValue]==!0) {
                        
                        ratefloat = [todayAttentionData floatValue]/[todayScanData floatValue];
                    }
                    
                    rateNum.text =[NSString stringWithFormat:@"关注率: %.1f %%",ratefloat];
                    if (Chartline!=nil) {
                        [Chartline removeFromSuperview];
                    }
                    Chartline = [[LineChartViewDemo alloc] initWithFrame:CGRectMake(0, 50, 200, 90)];
                    Chartline.backgroundColor = [UIColor clearColor];
                    
                    [Chartline setArray:pointArr];
                    [Chartline setArray1:pointArr2];
                    
                    [imageView addSubview:Chartline];
                }
            }
        }];
        
        [request setFailedBlock:^{
            [XDTools hideProgress:self];
        }];
        
        [request startAsynchronous];
        [XDTools showProgress:self];
    }else{
        [XDTools showTips:brokenNetwork toView:self];
    }


}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
