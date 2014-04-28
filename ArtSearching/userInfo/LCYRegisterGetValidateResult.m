//
//  LCYRegisterGetValidateResult.m
//
//  Created by   on 14-4-24
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYRegisterGetValidateResult.h"


NSString *const kLCYRegisterGetValidateResultVcode = @"Vcode";
NSString *const kLCYRegisterGetValidateResultCode = @"code";


@interface LCYRegisterGetValidateResult ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYRegisterGetValidateResult

@synthesize vcode = _vcode;
@synthesize code = _code;


+ (LCYRegisterGetValidateResult *)modelObjectWithDictionary:(NSDictionary *)dict
{
    LCYRegisterGetValidateResult *instance = [[LCYRegisterGetValidateResult alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.vcode = [self objectOrNilForKey:kLCYRegisterGetValidateResultVcode fromDictionary:dict];
            self.code = [[self objectOrNilForKey:kLCYRegisterGetValidateResultCode fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.vcode forKey:kLCYRegisterGetValidateResultVcode];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kLCYRegisterGetValidateResultCode];

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

    self.vcode = [aDecoder decodeObjectForKey:kLCYRegisterGetValidateResultVcode];
    self.code = [aDecoder decodeDoubleForKey:kLCYRegisterGetValidateResultCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_vcode forKey:kLCYRegisterGetValidateResultVcode];
    [aCoder encodeDouble:_code forKey:kLCYRegisterGetValidateResultCode];
}


@end
