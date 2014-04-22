//
//  LCYLoginResult.m
//
//  Created by   on 14-4-22
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYLoginResult.h"


NSString *const kLCYLoginResultUid = @"uid";
NSString *const kLCYLoginResultCode = @"code";


@interface LCYLoginResult ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYLoginResult

@synthesize uid = _uid;
@synthesize code = _code;


+ (LCYLoginResult *)modelObjectWithDictionary:(NSDictionary *)dict
{
    LCYLoginResult *instance = [[LCYLoginResult alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.uid = [[self objectOrNilForKey:kLCYLoginResultUid fromDictionary:dict] doubleValue];
            self.code = [[self objectOrNilForKey:kLCYLoginResultCode fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.uid] forKey:kLCYLoginResultUid];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kLCYLoginResultCode];

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

    self.uid = [aDecoder decodeDoubleForKey:kLCYLoginResultUid];
    self.code = [aDecoder decodeDoubleForKey:kLCYLoginResultCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_uid forKey:kLCYLoginResultUid];
    [aCoder encodeDouble:_code forKey:kLCYLoginResultCode];
}


@end
