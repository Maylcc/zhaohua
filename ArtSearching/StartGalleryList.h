//
//  StartGalleryList.h
//  ArtSearching
//
//  Created by developer on 14-4-18.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StartGalleryList : NSManagedObject

@property (nonatomic, retain) NSString * beScanTime;
@property (nonatomic, retain) NSString * beStoreTime;
@property (nonatomic, retain) NSString * id_Art;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * workCount;

@end
