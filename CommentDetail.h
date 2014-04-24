//
//  CommentDetail.h
//  ArtSearching
//
//  Created by developer on 14-4-22.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CommentDetail : NSManagedObject

@property (nonatomic, retain) NSDate * comdate;
@property (nonatomic, retain) NSNumber * comid;
@property (nonatomic, retain) NSString * comsnddur;
@property (nonatomic, retain) NSString * comtxt;
@property (nonatomic, retain) NSString * uheadurl;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * unick;
@property (nonatomic, retain) NSNumber * workid;

@end
