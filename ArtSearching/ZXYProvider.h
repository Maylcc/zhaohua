//
//  ZXYProvider.h
//  ArtSearching
//
//  Created by developer on 14-4-18.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCYAppDelegate.h"
@interface ZXYProvider : NSObject
+(ZXYProvider *)sharedInstance;

-(BOOL)deleteCoreDataFromDB:(NSString *)stringName;

-(NSArray *)readCoreDataFromDB:(NSString *)stringName;
-(NSArray *)readCoreDataFromDB:(NSString *)stringName withContent:(NSString *)content andKey:(NSString *)key;
-(NSArray *)readCoreDataFromDB:(NSString *)stringName orderByKey:(NSString *)stringKey isDes:(BOOL)isDes;
-(BOOL)saveDataToCoreData:(NSDictionary *)dic withDBName:(NSString *)dbName;
-(BOOL)saveStartArtistsList:(NSArray *)artists;
-(BOOL)saveStartArtList:(NSArray *)artList;
-(BOOL)saveStartGalleryList:(NSArray *)galleryList;
@end
