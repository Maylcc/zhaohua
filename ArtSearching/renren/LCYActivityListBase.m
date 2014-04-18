//
//  LCYActivityListBase.m
//
//  Created by   on 14-4-18
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYActivityListBase.h"
#import "LCYActivityList.h"


NSString *const kLCYActivityListBaseActivityList = @"activityList";
NSString *const kLCYActivityListBaseCode = @"code";


@interface LCYActivityListBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYActivityListBase

@synthesize activityList = _activityList;
@synthesize code = _code;


+ (LCYActivityListBase *)modelObjectWithDictionary:(NSDictionary *)dict
{
    LCYActivityListBase *instance = [[LCYActivityListBase alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
    NSObject *receivedLCYActivityList = [dict objectForKey:kLCYActivityListBaseActivityList];
    NSMutableArray *parsedLCYActivityList = [NSMutableArray array];
    if ([receivedLCYActivityList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedLCYActivityList) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedLCYActivityList addObject:[LCYActivityList modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedLCYActivityList isKindOfClass:[NSDictionary class]]) {
       [parsedLCYActivityList addObject:[LCYActivityList modelObjectWithDictionary:(NSDictionary *)receivedLCYActivityList]];
    }

    self.activityList = [NSArray arrayWithArray:parsedLCYActivityList];
            self.code = [[self objectOrNilForKey:kLCYActivityListBaseCode fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
NSMutableArray *tempArrayForActivityList = [NSMutableArray array];
    for (NSObject *subArrayObject in self.activityList) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForActivityList addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForActivityList addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForActivityList] forKey:@"kLCYActivityListBaseActivityList"];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kLCYActivityListBaseCode];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.activityList = [aDecoder decodeObjectForKey:kLCYActivityListBaseActivityList];
    self.code = [aDecoder decodeDoubleForKey:kLCYActivityListBaseCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_activityList forKey:kLCYActivityListBaseActivityList];
    [aCoder encodeDouble:_code forKey:kLCYActivityListBaseCode];
}


@end
