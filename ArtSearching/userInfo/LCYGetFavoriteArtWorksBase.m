//
//  LCYGetFavoriteArtWorksBase.m
//
//  Created by 超逸 李 on 14-5-19
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYGetFavoriteArtWorksBase.h"
#import "LCYGetFavoriteArtWorksInfos.h"


NSString *const kLCYGetFavoriteArtWorksBaseNum = @"num";
NSString *const kLCYGetFavoriteArtWorksBaseUserId = @"userId";
NSString *const kLCYGetFavoriteArtWorksBaseInfos = @"infos";
NSString *const kLCYGetFavoriteArtWorksBasePageNo = @"pageNo";


@interface LCYGetFavoriteArtWorksBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYGetFavoriteArtWorksBase

@synthesize num = _num;
@synthesize userId = _userId;
@synthesize infos = _infos;
@synthesize pageNo = _pageNo;


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
            self.num = [[self objectOrNilForKey:kLCYGetFavoriteArtWorksBaseNum fromDictionary:dict] doubleValue];
            self.userId = [[self objectOrNilForKey:kLCYGetFavoriteArtWorksBaseUserId fromDictionary:dict] doubleValue];
    NSObject *receivedLCYGetFavoriteArtWorksInfos = [dict objectForKey:kLCYGetFavoriteArtWorksBaseInfos];
    NSMutableArray *parsedLCYGetFavoriteArtWorksInfos = [NSMutableArray array];
    if ([receivedLCYGetFavoriteArtWorksInfos isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedLCYGetFavoriteArtWorksInfos) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedLCYGetFavoriteArtWorksInfos addObject:[LCYGetFavoriteArtWorksInfos modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedLCYGetFavoriteArtWorksInfos isKindOfClass:[NSDictionary class]]) {
       [parsedLCYGetFavoriteArtWorksInfos addObject:[LCYGetFavoriteArtWorksInfos modelObjectWithDictionary:(NSDictionary *)receivedLCYGetFavoriteArtWorksInfos]];
    }

    self.infos = [NSArray arrayWithArray:parsedLCYGetFavoriteArtWorksInfos];
            self.pageNo = [[self objectOrNilForKey:kLCYGetFavoriteArtWorksBasePageNo fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.num] forKey:kLCYGetFavoriteArtWorksBaseNum];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userId] forKey:kLCYGetFavoriteArtWorksBaseUserId];
    NSMutableArray *tempArrayForInfos = [NSMutableArray array];
    for (NSObject *subArrayObject in self.infos) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForInfos addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForInfos addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForInfos] forKey:kLCYGetFavoriteArtWorksBaseInfos];
    [mutableDict setValue:[NSNumber numberWithDouble:self.pageNo] forKey:kLCYGetFavoriteArtWorksBasePageNo];

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

    self.num = [aDecoder decodeDoubleForKey:kLCYGetFavoriteArtWorksBaseNum];
    self.userId = [aDecoder decodeDoubleForKey:kLCYGetFavoriteArtWorksBaseUserId];
    self.infos = [aDecoder decodeObjectForKey:kLCYGetFavoriteArtWorksBaseInfos];
    self.pageNo = [aDecoder decodeDoubleForKey:kLCYGetFavoriteArtWorksBasePageNo];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_num forKey:kLCYGetFavoriteArtWorksBaseNum];
    [aCoder encodeDouble:_userId forKey:kLCYGetFavoriteArtWorksBaseUserId];
    [aCoder encodeObject:_infos forKey:kLCYGetFavoriteArtWorksBaseInfos];
    [aCoder encodeDouble:_pageNo forKey:kLCYGetFavoriteArtWorksBasePageNo];
}

- (id)copyWithZone:(NSZone *)zone
{
    LCYGetFavoriteArtWorksBase *copy = [[LCYGetFavoriteArtWorksBase alloc] init];
    
    if (copy) {

        copy.num = self.num;
        copy.userId = self.userId;
        copy.infos = [self.infos copyWithZone:zone];
        copy.pageNo = self.pageNo;
    }
    
    return copy;
}


@end
