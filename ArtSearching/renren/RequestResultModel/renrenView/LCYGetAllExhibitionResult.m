//
//  LCYGetAllExhibitionResult.m
//
//  Created by   on 14-4-29
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYGetAllExhibitionResult.h"
#import "LCYExhibitions.h"


NSString *const kLCYGetAllExhibitionResultNum = @"num";
NSString *const kLCYGetAllExhibitionResultPageno = @"pageno";
NSString *const kLCYGetAllExhibitionResultExhibitions = @"exhibitions";


@interface LCYGetAllExhibitionResult ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYGetAllExhibitionResult

@synthesize num = _num;
@synthesize pageno = _pageno;
@synthesize exhibitions = _exhibitions;


+ (LCYGetAllExhibitionResult *)modelObjectWithDictionary:(NSDictionary *)dict
{
    LCYGetAllExhibitionResult *instance = [[LCYGetAllExhibitionResult alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.num = [self objectOrNilForKey:kLCYGetAllExhibitionResultNum fromDictionary:dict];
            self.pageno = [self objectOrNilForKey:kLCYGetAllExhibitionResultPageno fromDictionary:dict];
    NSObject *receivedLCYExhibitions = [dict objectForKey:kLCYGetAllExhibitionResultExhibitions];
    NSMutableArray *parsedLCYExhibitions = [NSMutableArray array];
    if ([receivedLCYExhibitions isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedLCYExhibitions) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedLCYExhibitions addObject:[LCYExhibitions modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedLCYExhibitions isKindOfClass:[NSDictionary class]]) {
       [parsedLCYExhibitions addObject:[LCYExhibitions modelObjectWithDictionary:(NSDictionary *)receivedLCYExhibitions]];
    }

    self.exhibitions = [NSArray arrayWithArray:parsedLCYExhibitions];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.num forKey:kLCYGetAllExhibitionResultNum];
    [mutableDict setValue:self.pageno forKey:kLCYGetAllExhibitionResultPageno];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForExhibitions] forKey:@"kLCYGetAllExhibitionResultExhibitions"];

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

    self.num = [aDecoder decodeObjectForKey:kLCYGetAllExhibitionResultNum];
    self.pageno = [aDecoder decodeObjectForKey:kLCYGetAllExhibitionResultPageno];
    self.exhibitions = [aDecoder decodeObjectForKey:kLCYGetAllExhibitionResultExhibitions];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_num forKey:kLCYGetAllExhibitionResultNum];
    [aCoder encodeObject:_pageno forKey:kLCYGetAllExhibitionResultPageno];
    [aCoder encodeObject:_exhibitions forKey:kLCYGetAllExhibitionResultExhibitions];
}


@end
