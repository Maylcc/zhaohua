//
//  GetArtworkListByArtistIdBase.m
//
//  Created by 超逸 李 on 14-5-21
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "GetArtworkListByArtistIdBase.h"
#import "GetArtworkListByArtistIdWorkList.h"


NSString *const kGetArtworkListByArtistIdBaseCode = @"code";
NSString *const kGetArtworkListByArtistIdBaseTotalCount = @"totalCount";
NSString *const kGetArtworkListByArtistIdBaseWorkList = @"workList";


@interface GetArtworkListByArtistIdBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation GetArtworkListByArtistIdBase

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
            self.code = [[self objectOrNilForKey:kGetArtworkListByArtistIdBaseCode fromDictionary:dict] doubleValue];
            self.totalCount = [[self objectOrNilForKey:kGetArtworkListByArtistIdBaseTotalCount fromDictionary:dict] doubleValue];
    NSObject *receivedGetArtworkListByArtistIdWorkList = [dict objectForKey:kGetArtworkListByArtistIdBaseWorkList];
    NSMutableArray *parsedGetArtworkListByArtistIdWorkList = [NSMutableArray array];
    if ([receivedGetArtworkListByArtistIdWorkList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedGetArtworkListByArtistIdWorkList) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedGetArtworkListByArtistIdWorkList addObject:[GetArtworkListByArtistIdWorkList modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedGetArtworkListByArtistIdWorkList isKindOfClass:[NSDictionary class]]) {
       [parsedGetArtworkListByArtistIdWorkList addObject:[GetArtworkListByArtistIdWorkList modelObjectWithDictionary:(NSDictionary *)receivedGetArtworkListByArtistIdWorkList]];
    }

    self.workList = [NSArray arrayWithArray:parsedGetArtworkListByArtistIdWorkList];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kGetArtworkListByArtistIdBaseCode];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalCount] forKey:kGetArtworkListByArtistIdBaseTotalCount];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForWorkList] forKey:kGetArtworkListByArtistIdBaseWorkList];

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

    self.code = [aDecoder decodeDoubleForKey:kGetArtworkListByArtistIdBaseCode];
    self.totalCount = [aDecoder decodeDoubleForKey:kGetArtworkListByArtistIdBaseTotalCount];
    self.workList = [aDecoder decodeObjectForKey:kGetArtworkListByArtistIdBaseWorkList];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kGetArtworkListByArtistIdBaseCode];
    [aCoder encodeDouble:_totalCount forKey:kGetArtworkListByArtistIdBaseTotalCount];
    [aCoder encodeObject:_workList forKey:kGetArtworkListByArtistIdBaseWorkList];
}

- (id)copyWithZone:(NSZone *)zone
{
    GetArtworkListByArtistIdBase *copy = [[GetArtworkListByArtistIdBase alloc] init];
    
    if (copy) {

        copy.code = self.code;
        copy.totalCount = self.totalCount;
        copy.workList = [self.workList copyWithZone:zone];
    }
    
    return copy;
}


@end
