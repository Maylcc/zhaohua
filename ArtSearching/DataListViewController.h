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
@class ZXYFileOperation;
@class UIFolderTableView;
@class DataAcquisitionViewController;
@class XMLParserHelper;
@class NetHelper ;
@interface DataListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NetHelperDelegate>
{
    IBOutlet UIFolderTableView *dataTableV;
    ZXYProvider *dataProvider;
    XMLParserHelper *xmlParser;
    NetConnect *netConnect;
    NSArray *arrArtList;
    NSArray *arrArtistsList;
    NSArray *arrGalleryList;
    ZXYFileOperation *fileOperation;
    DataAcquisitionViewController *dataAc;
    NetHelper *netHelper;
}
@end
