//
//  StartArtistsList.h
//  ArtSearching
//
//  Created by developer on 14-4-20.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StartArtistsList : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSNumber * beScanTime;
@property (nonatomic, retain) NSNumber * beStoreTime;
@property (nonatomic, retain) NSNumber * id_Art;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * url_small;
@property (nonatomic, retain) NSNumber * workCount;

@end
