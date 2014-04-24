//
//  ArtDetail.h
//  ArtSearching
//
//  Created by developer on 14-4-22.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ArtDetail : NSManagedObject

@property (nonatomic, retain) NSNumber * artistID;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSNumber * beCommentTime;
@property (nonatomic, retain) NSNumber * beScanTime;
@property (nonatomic, retain) NSNumber * beStoreTime;
@property (nonatomic, retain) NSNumber * bigImageExists;
@property (nonatomic, retain) NSString * recentlySales;
@property (nonatomic, retain) NSString * signGallery;
@property (nonatomic, retain) NSString * workCategory;
@property (nonatomic, retain) NSString * workDate;
@property (nonatomic, retain) NSString * workDescription;
@property (nonatomic, retain) NSString * workName;
@property (nonatomic, retain) NSString * workRecord;
@property (nonatomic, retain) NSString * workSize;
@property (nonatomic, retain) NSString * id_Art;

@end
