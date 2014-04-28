//
//  LCYSimpleCodeResult.m
//
//  Created by   on 14-4-24
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYSimpleCodeResult.h"


NSString *const kLCYSimpleCodeResultCode = @"code";


@interface LCYSimpleCodeResult ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYSimpleCodeResult

@synthesize code = _code;


+ (LCYSimpleCodeResult *)modelObjectWithDictionary:(NSDictionary *)dict
{
    LCYSimpleCodeResult *instance = [[LCYSimpleCodeResult alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.code = [[self objectOrNilForKey:kLCYSimpleCodeResultCode fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kLCYSimpleCodeResultCode];

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

    self.code = [aDecoder decodeDoubleForKey:kLCYSimpleCodeResultCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kLCYSimpleCodeResultCode];
}


@end
