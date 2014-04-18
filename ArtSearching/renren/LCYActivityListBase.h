//
//  LCYActivityListBase.h
//
//  Created by   on 14-4-18
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LCYActivityListBase : NSObject <NSCoding>

@property (nonatomic, strong) NSArray *activityList;
@property (nonatomic, assign) double code;

+ (LCYActivityListBase *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
