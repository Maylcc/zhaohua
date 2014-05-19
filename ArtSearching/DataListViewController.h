//
//  DataListViewController.h
//  ArtSearching
//
//  Created by developer on 14-4-17.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "LCYCommon.h"
#import "NetConnect.h"
#import "ZXYProvider.h"
#import "NetHelperDelegate.h"
#import "LineChartViewDemo.h"
@class ZXYFileOperation;
@class UIFolderTableView;
@class DataAcquisitionViewController;
@class XMLParserHelper;
@class NetHelper ;
@interface DataListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NetHelperDelegate>
{
    IBOutlet UIFolderTableView *dataTableV;
    ZXYProvider *dataProvider; //数据库操作类
    XMLParserHelper *xmlParser;//无用
    NetConnect *netConnect;//用于网络下载等
    NSArray *arrArtList;   //星级作品
    NSArray *arrArtistsList; // 星级作家
    NSArray *arrGalleryList; // 星级画廊
    ZXYFileOperation *fileOperation; //处理图片下载路径的类
    DataAcquisitionViewController *dataAc; // 用来显示信心指数的视图控制器
    NetHelper *netHelper;    //下载数据帮助类
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
@end
