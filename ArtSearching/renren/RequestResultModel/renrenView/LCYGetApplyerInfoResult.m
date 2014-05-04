//
//  LCYGetApplyerInfoResult.m
//
//  Created by 超逸 李 on 14-5-4
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYGetApplyerInfoResult.h"


NSString *const kLCYGetApplyerInfoResultApplyers = @"applyers";
NSString *const kLCYGetApplyerInfoResultId = @"id";
NSString *const kLCYGetApplyerInfoResultComment = @"comment";
NSString *const kLCYGetApplyerInfoResultImgs = @"imgs";
NSString *const kLCYGetApplyerInfoResultDate = @"date";


@interface LCYGetApplyerInfoResult ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYGetApplyerInfoResult

@synthesize applyers = _applyers;
@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize comment = _comment;
@synthesize imgs = _imgs;
@synthesize date = _date;


+ (LCYGetApplyerInfoResult *)modelObjectWithDictionary:(NSDictionary *)dict
{
    LCYGetApplyerInfoResult *instance = [[LCYGetApplyerInfoResult alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.applyers = [self objectOrNilForKey:kLCYGetApplyerInfoResultApplyers fromDictionary:dict];
            self.internalBaseClassIdentifier = [self objectOrNilForKey:kLCYGetApplyerInfoResultId fromDictionary:dict];
            self.comment = [self objectOrNilForKey:kLCYGetApplyerInfoResultComment fromDictionary:dict];
            self.imgs = [self objectOrNilForKey:kLCYGetApplyerInfoResultImgs fromDictionary:dict];
            self.date = [self objectOrNilForKey:kLCYGetApplyerInfoResultDate fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.applyers forKey:kLCYGetApplyerInfoResultApplyers];
    [mutableDict setValue:self.internalBaseClassIdentifier forKey:kLCYGetApplyerInfoResultId];
    [mutableDict setValue:self.comment forKey:kLCYGetApplyerInfoResultComment];
    [mutableDict setValue:self.imgs forKey:kLCYGetApplyerInfoResultImgs];
    [mutableDict setValue:self.date forKey:kLCYGetApplyerInfoResultDate];

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

    self.applyers = [aDecoder decodeObjectForKey:kLCYGetApplyerInfoResultApplyers];
    self.internalBaseClassIdentifier = [aDecoder decodeObjectForKey:kLCYGetApplyerInfoResultId];
    self.comment = [aDecoder decodeObjectForKey:kLCYGetApplyerInfoResultComment];
    self.imgs = [aDecoder decodeObjectForKey:kLCYGetApplyerInfoResultImgs];
    self.date = [aDecoder decodeObjectForKey:kLCYGetApplyerInfoResultDate];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_applyers forKey:kLCYGetApplyerInfoResultApplyers];
    [aCoder encodeObject:_internalBaseClassIdentifier forKey:kLCYGetApplyerInfoResultId];
    [aCoder encodeObject:_comment forKey:kLCYGetApplyerInfoResultComment];
    [aCoder encodeObject:_imgs forKey:kLCYGetApplyerInfoResultImgs];
    [aCoder encodeObject:_date forKey:kLCYGetApplyerInfoResultDate];
}


@end
