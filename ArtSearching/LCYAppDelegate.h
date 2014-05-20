//
//  LCYAppDelegate.h
//  ArtSearching
//
//  Created by eagle on 14-4-16.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WeiboSDK.h"
@interface LCYAppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSString *wbtoken;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
