//
//  LCYActivityList.h
//
//  Created by   on 14-4-18
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LCYActivityList : NSObject <NSCoding>

@property (nonatomic, strong) NSString *organizer;
@property (nonatomic, strong) NSString *activityDesign;
@property (nonatomic, strong) NSString *activityTitle;
@property (nonatomic, assign) double activityListIdentifier;
@property (nonatomic, strong) NSString *activitySponsor;
@property (nonatomic, strong) NSString *coorganizer;
@property (nonatomic, strong) NSString *activityWeekTime;
@property (nonatomic, assign) double beScanTime;
@property (nonatomic, assign) double type;
@property (nonatomic, strong) NSString *activityStartTime;

+ (LCYActivityList *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
