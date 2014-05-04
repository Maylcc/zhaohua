//
//  LCYGetOwnExhibitionResult.m
//
//  Created by 超逸 李 on 14-5-4
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYGetOwnExhibitionResult.h"
#import "LCYMineExhibitions.h"


NSString *const kLCYGetOwnExhibitionResultNum = @"num";
NSString *const kLCYGetOwnExhibitionResultUserid = @"userid";
NSString *const kLCYGetOwnExhibitionResultPageno = @"pageno";
NSString *const kLCYGetOwnExhibitionResultExhibitions = @"exhibitions";


@interface LCYGetOwnExhibitionResult ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYGetOwnExhibitionResult

@synthesize num = _num;
@synthesize userid = _userid;
@synthesize pageno = _pageno;
@synthesize exhibitions = _exhibitions;


+ (LCYGetOwnExhibitionResult *)modelObjectWithDictionary:(NSDictionary *)dict
{
    LCYGetOwnExhibitionResult *instance = [[LCYGetOwnExhibitionResult alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.num = [self objectOrNilForKey:kLCYGetOwnExhibitionResultNum fromDictionary:dict];
            self.userid = [self objectOrNilForKey:kLCYGetOwnExhibitionResultUserid fromDictionary:dict];
            self.pageno = [self objectOrNilForKey:kLCYGetOwnExhibitionResultPageno fromDictionary:dict];
    NSObject *receivedLCYExhibitions = [dict objectForKey:kLCYGetOwnExhibitionResultExhibitions];
    NSMutableArray *parsedLCYExhibitions = [NSMutableArray array];
    if ([receivedLCYExhibitions isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedLCYExhibitions) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedLCYExhibitions addObject:[LCYMineExhibitions modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedLCYExhibitions isKindOfClass:[NSDictionary class]]) {
       [parsedLCYExhibitions addObject:[LCYMineExhibitions modelObjectWithDictionary:(NSDictionary *)receivedLCYExhibitions]];
    }

    self.exhibitions = [NSArray arrayWithArray:parsedLCYExhibitions];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.num forKey:kLCYGetOwnExhibitionResultNum];
    [mutableDict setValue:self.userid forKey:kLCYGetOwnExhibitionResultUserid];
    [mutableDict setValue:self.pageno forKey:kLCYGetOwnExhibitionResultPageno];
NSMutableArray *tempArrayForExhibitions = [NSMutableArray array];
    for (NSObject *subArrayObject in self.exhibitions) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForExhibitions addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForExhibitions addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForExhibitions] forKey:@"kLCYGetOwnExhibitionResultExhibitions"];

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

    self.num = [aDecoder decodeObjectForKey:kLCYGetOwnExhibitionResultNum];
    self.userid = [aDecoder decodeObjectForKey:kLCYGetOwnExhibitionResultUserid];
    self.pageno = [aDecoder decodeObjectForKey:kLCYGetOwnExhibitionResultPageno];
    self.exhibitions = [aDecoder decodeObjectForKey:kLCYGetOwnExhibitionResultExhibitions];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_num forKey:kLCYGetOwnExhibitionResultNum];
    [aCoder encodeObject:_userid forKey:kLCYGetOwnExhibitionResultUserid];
    [aCoder encodeObject:_pageno forKey:kLCYGetOwnExhibitionResultPageno];
    [aCoder encodeObject:_exhibitions forKey:kLCYGetOwnExhibitionResultExhibitions];
}


@end
