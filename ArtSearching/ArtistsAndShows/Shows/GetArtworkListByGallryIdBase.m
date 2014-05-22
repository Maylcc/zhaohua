//
//  GetArtworkListByGallryIdBase.m
//
//  Created by 超逸 李 on 14-5-22
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "GetArtworkListByGallryIdBase.h"
#import "GetArtworkListByGallryIdWorkList.h"


NSString *const kGetArtworkListByGallryIdBaseCode = @"code";
NSString *const kGetArtworkListByGallryIdBaseTotalCount = @"totalCount";
NSString *const kGetArtworkListByGallryIdBaseWorkList = @"workList";


@interface GetArtworkListByGallryIdBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation GetArtworkListByGallryIdBase

@synthesize code = _code;
@synthesize totalCount = _totalCount;
@synthesize workList = _workList;


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
            self.code = [[self objectOrNilForKey:kGetArtworkListByGallryIdBaseCode fromDictionary:dict] doubleValue];
            self.totalCount = [[self objectOrNilForKey:kGetArtworkListByGallryIdBaseTotalCount fromDictionary:dict] doubleValue];
    NSObject *receivedGetArtworkListByGallryIdWorkList = [dict objectForKey:kGetArtworkListByGallryIdBaseWorkList];
    NSMutableArray *parsedGetArtworkListByGallryIdWorkList = [NSMutableArray array];
    if ([receivedGetArtworkListByGallryIdWorkList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedGetArtworkListByGallryIdWorkList) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedGetArtworkListByGallryIdWorkList addObject:[GetArtworkListByGallryIdWorkList modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedGetArtworkListByGallryIdWorkList isKindOfClass:[NSDictionary class]]) {
       [parsedGetArtworkListByGallryIdWorkList addObject:[GetArtworkListByGallryIdWorkList modelObjectWithDictionary:(NSDictionary *)receivedGetArtworkListByGallryIdWorkList]];
    }

    self.workList = [NSArray arrayWithArray:parsedGetArtworkListByGallryIdWorkList];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kGetArtworkListByGallryIdBaseCode];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalCount] forKey:kGetArtworkListByGallryIdBaseTotalCount];
    NSMutableArray *tempArrayForWorkList = [NSMutableArray array];
    for (NSObject *subArrayObject in self.workList) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForWorkList addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForWorkList addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForWorkList] forKey:kGetArtworkListByGallryIdBaseWorkList];

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

    self.code = [aDecoder decodeDoubleForKey:kGetArtworkListByGallryIdBaseCode];
    self.totalCount = [aDecoder decodeDoubleForKey:kGetArtworkListByGallryIdBaseTotalCount];
    self.workList = [aDecoder decodeObjectForKey:kGetArtworkListByGallryIdBaseWorkList];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kGetArtworkListByGallryIdBaseCode];
    [aCoder encodeDouble:_totalCount forKey:kGetArtworkListByGallryIdBaseTotalCount];
    [aCoder encodeObject:_workList forKey:kGetArtworkListByGallryIdBaseWorkList];
}

- (id)copyWithZone:(NSZone *)zone
{
    GetArtworkListByGallryIdBase *copy = [[GetArtworkListByGallryIdBase alloc] init];
    
    if (copy) {

        copy.code = self.code;
        copy.totalCount = self.totalCount;
        copy.workList = [self.workList copyWithZone:zone];
    }
    
    return copy;
}


@end
