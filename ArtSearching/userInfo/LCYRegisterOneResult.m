//
//  LCYRegisterOneResult.m
//
//  Created by   on 14-4-28
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYRegisterOneResult.h"


NSString *const kLCYRegisterOneResultUid = @"Uid";
NSString *const kLCYRegisterOneResultCode = @"code";


@interface LCYRegisterOneResult ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYRegisterOneResult

@synthesize uid = _uid;
@synthesize code = _code;


+ (LCYRegisterOneResult *)modelObjectWithDictionary:(NSDictionary *)dict
{
    LCYRegisterOneResult *instance = [[LCYRegisterOneResult alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.uid = [[self objectOrNilForKey:kLCYRegisterOneResultUid fromDictionary:dict] doubleValue];
            self.code = [[self objectOrNilForKey:kLCYRegisterOneResultCode fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.uid] forKey:kLCYRegisterOneResultUid];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kLCYRegisterOneResultCode];

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

    self.uid = [aDecoder decodeDoubleForKey:kLCYRegisterOneResultUid];
    self.code = [aDecoder decodeDoubleForKey:kLCYRegisterOneResultCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_uid forKey:kLCYRegisterOneResultUid];
    [aCoder encodeDouble:_code forKey:kLCYRegisterOneResultCode];
}


@end
