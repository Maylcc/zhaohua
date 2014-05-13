//
//  LCYShowsGalleryGalleryList.m
//
//  Created by 超逸 李 on 14-5-13
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYShowsGalleryGalleryList.h"
#import "LCYShowsGalleryGalleries.h"


NSString *const kLCYShowsGalleryGalleryListCode = @"code";
NSString *const kLCYShowsGalleryGalleryListGalleries = @"galleries";
NSString *const kLCYShowsGalleryGalleryListTotalCount = @"totalCount";


@interface LCYShowsGalleryGalleryList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYShowsGalleryGalleryList

@synthesize code = _code;
@synthesize galleries = _galleries;
@synthesize totalCount = _totalCount;


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
            self.code = [[self objectOrNilForKey:kLCYShowsGalleryGalleryListCode fromDictionary:dict] doubleValue];
    NSObject *receivedLCYShowsGalleryGalleries = [dict objectForKey:kLCYShowsGalleryGalleryListGalleries];
    NSMutableArray *parsedLCYShowsGalleryGalleries = [NSMutableArray array];
    if ([receivedLCYShowsGalleryGalleries isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedLCYShowsGalleryGalleries) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedLCYShowsGalleryGalleries addObject:[LCYShowsGalleryGalleries modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedLCYShowsGalleryGalleries isKindOfClass:[NSDictionary class]]) {
       [parsedLCYShowsGalleryGalleries addObject:[LCYShowsGalleryGalleries modelObjectWithDictionary:(NSDictionary *)receivedLCYShowsGalleryGalleries]];
    }

    self.galleries = [NSArray arrayWithArray:parsedLCYShowsGalleryGalleries];
            self.totalCount = [[self objectOrNilForKey:kLCYShowsGalleryGalleryListTotalCount fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kLCYShowsGalleryGalleryListCode];
    NSMutableArray *tempArrayForGalleries = [NSMutableArray array];
    for (NSObject *subArrayObject in self.galleries) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForGalleries addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForGalleries addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForGalleries] forKey:kLCYShowsGalleryGalleryListGalleries];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalCount] forKey:kLCYShowsGalleryGalleryListTotalCount];

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

    self.code = [aDecoder decodeDoubleForKey:kLCYShowsGalleryGalleryListCode];
    self.galleries = [aDecoder decodeObjectForKey:kLCYShowsGalleryGalleryListGalleries];
    self.totalCount = [aDecoder decodeDoubleForKey:kLCYShowsGalleryGalleryListTotalCount];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kLCYShowsGalleryGalleryListCode];
    [aCoder encodeObject:_galleries forKey:kLCYShowsGalleryGalleryListGalleries];
    [aCoder encodeDouble:_totalCount forKey:kLCYShowsGalleryGalleryListTotalCount];
}

- (id)copyWithZone:(NSZone *)zone
{
    LCYShowsGalleryGalleryList *copy = [[LCYShowsGalleryGalleryList alloc] init];
    
    if (copy) {

        copy.code = self.code;
        copy.galleries = [self.galleries copyWithZone:zone];
        copy.totalCount = self.totalCount;
    }
    
    return copy;
}


@end
