//
//  LCYGetUserInfoResultUser.m
//
//  Created by 超逸 李 on 14-5-19
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYGetUserInfoResultUser.h"


NSString *const kLCYGetUserInfoResultUserCode = @"code";
NSString *const kLCYGetUserInfoResultUserUnike = @"unike";
NSString *const kLCYGetUserInfoResultUserUheadurl = @"uheadurl";
NSString *const kLCYGetUserInfoResultUserUbrief = @"ubrief";
NSString *const kLCYGetUserInfoResultUserUid = @"uid";
NSString *const kLCYGetUserInfoResultUserUname = @"uname";


@interface LCYGetUserInfoResultUser ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYGetUserInfoResultUser

@synthesize code = _code;
@synthesize unike = _unike;
@synthesize uheadurl = _uheadurl;
@synthesize ubrief = _ubrief;
@synthesize uid = _uid;
@synthesize uname = _uname;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.code = [[self objectOrNilForKey:kLCYGetUserInfoResultUserCode fromDictionary:dict] doubleValue];
            self.unike = [self objectOrNilForKey:kLCYGetUserInfoResultUserUnike fromDictionary:dict];
            self.uheadurl = [self objectOrNilForKey:kLCYGetUserInfoResultUserUheadurl fromDictionary:dict];
            self.ubrief = [self objectOrNilForKey:kLCYGetUserInfoResultUserUbrief fromDictionary:dict];
            self.uid = [[self objectOrNilForKey:kLCYGetUserInfoResultUserUid fromDictionary:dict] doubleValue];
            self.uname = [self objectOrNilForKey:kLCYGetUserInfoResultUserUname fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kLCYGetUserInfoResultUserCode];
    [mutableDict setValue:self.unike forKey:kLCYGetUserInfoResultUserUnike];
    [mutableDict setValue:self.uheadurl forKey:kLCYGetUserInfoResultUserUheadurl];
    [mutableDict setValue:self.ubrief forKey:kLCYGetUserInfoResultUserUbrief];
    [mutableDict setValue:[NSNumber numberWithDouble:self.uid] forKey:kLCYGetUserInfoResultUserUid];
    [mutableDict setValue:self.uname forKey:kLCYGetUserInfoResultUserUname];

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

    self.code = [aDecoder decodeDoubleForKey:kLCYGetUserInfoResultUserCode];
    self.unike = [aDecoder decodeObjectForKey:kLCYGetUserInfoResultUserUnike];
    self.uheadurl = [aDecoder decodeObjectForKey:kLCYGetUserInfoResultUserUheadurl];
    self.ubrief = [aDecoder decodeObjectForKey:kLCYGetUserInfoResultUserUbrief];
    self.uid = [aDecoder decodeDoubleForKey:kLCYGetUserInfoResultUserUid];
    self.uname = [aDecoder decodeObjectForKey:kLCYGetUserInfoResultUserUname];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kLCYGetUserInfoResultUserCode];
    [aCoder encodeObject:_unike forKey:kLCYGetUserInfoResultUserUnike];
    [aCoder encodeObject:_uheadurl forKey:kLCYGetUserInfoResultUserUheadurl];
    [aCoder encodeObject:_ubrief forKey:kLCYGetUserInfoResultUserUbrief];
    [aCoder encodeDouble:_uid forKey:kLCYGetUserInfoResultUserUid];
    [aCoder encodeObject:_uname forKey:kLCYGetUserInfoResultUserUname];
}

- (id)copyWithZone:(NSZone *)zone
{
    LCYGetUserInfoResultUser *copy = [[LCYGetUserInfoResultUser alloc] init];
    
    if (copy) {

        copy.code = self.code;
        copy.unike = [self.unike copyWithZone:zone];
        copy.uheadurl = [self.uheadurl copyWithZone:zone];
        copy.ubrief = [self.ubrief copyWithZone:zone];
        copy.uid = self.uid;
        copy.uname = [self.uname copyWithZone:zone];
    }
    
    return copy;
}


@end
