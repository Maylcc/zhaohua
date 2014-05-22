//
//  GetArtworkListByArtistIdWorkList.m
//
//  Created by 超逸 李 on 14-5-21
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "GetArtworkListByArtistIdWorkList.h"


NSString *const kGetArtworkListByArtistIdWorkListWorkId = @"workId";
NSString *const kGetArtworkListByArtistIdWorkListWorkTitle = @"workTitle";
NSString *const kGetArtworkListByArtistIdWorkListImageUrlS = @"imageUrl_s";
NSString *const kGetArtworkListByArtistIdWorkListImageUrl = @"imageUrl";
NSString *const kGetArtworkListByArtistIdWorkListArtistName = @"artistName";
NSString *const kGetArtworkListByArtistIdWorkListRatio = @"ratio";
NSString *const kGetArtworkListByArtistIdWorkListBeScanTime = @"beScanTime";


@interface GetArtworkListByArtistIdWorkList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation GetArtworkListByArtistIdWorkList

@synthesize workId = _workId;
@synthesize workTitle = _workTitle;
@synthesize imageUrlS = _imageUrlS;
@synthesize imageUrl = _imageUrl;
@synthesize artistName = _artistName;
@synthesize ratio = _ratio;
@synthesize beScanTime = _beScanTime;


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
            self.workId = [[self objectOrNilForKey:kGetArtworkListByArtistIdWorkListWorkId fromDictionary:dict] doubleValue];
            self.workTitle = [self objectOrNilForKey:kGetArtworkListByArtistIdWorkListWorkTitle fromDictionary:dict];
            self.imageUrlS = [self objectOrNilForKey:kGetArtworkListByArtistIdWorkListImageUrlS fromDictionary:dict];
            self.imageUrl = [self objectOrNilForKey:kGetArtworkListByArtistIdWorkListImageUrl fromDictionary:dict];
            self.artistName = [self objectOrNilForKey:kGetArtworkListByArtistIdWorkListArtistName fromDictionary:dict];
            self.ratio = [[self objectOrNilForKey:kGetArtworkListByArtistIdWorkListRatio fromDictionary:dict] doubleValue];
            self.beScanTime = [[self objectOrNilForKey:kGetArtworkListByArtistIdWorkListBeScanTime fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.workId] forKey:kGetArtworkListByArtistIdWorkListWorkId];
    [mutableDict setValue:self.workTitle forKey:kGetArtworkListByArtistIdWorkListWorkTitle];
    [mutableDict setValue:self.imageUrlS forKey:kGetArtworkListByArtistIdWorkListImageUrlS];
    [mutableDict setValue:self.imageUrl forKey:kGetArtworkListByArtistIdWorkListImageUrl];
    [mutableDict setValue:self.artistName forKey:kGetArtworkListByArtistIdWorkListArtistName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.ratio] forKey:kGetArtworkListByArtistIdWorkListRatio];
    [mutableDict setValue:[NSNumber numberWithDouble:self.beScanTime] forKey:kGetArtworkListByArtistIdWorkListBeScanTime];

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

    self.workId = [aDecoder decodeDoubleForKey:kGetArtworkListByArtistIdWorkListWorkId];
    self.workTitle = [aDecoder decodeObjectForKey:kGetArtworkListByArtistIdWorkListWorkTitle];
    self.imageUrlS = [aDecoder decodeObjectForKey:kGetArtworkListByArtistIdWorkListImageUrlS];
    self.imageUrl = [aDecoder decodeObjectForKey:kGetArtworkListByArtistIdWorkListImageUrl];
    self.artistName = [aDecoder decodeObjectForKey:kGetArtworkListByArtistIdWorkListArtistName];
    self.ratio = [aDecoder decodeDoubleForKey:kGetArtworkListByArtistIdWorkListRatio];
    self.beScanTime = [aDecoder decodeDoubleForKey:kGetArtworkListByArtistIdWorkListBeScanTime];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_workId forKey:kGetArtworkListByArtistIdWorkListWorkId];
    [aCoder encodeObject:_workTitle forKey:kGetArtworkListByArtistIdWorkListWorkTitle];
    [aCoder encodeObject:_imageUrlS forKey:kGetArtworkListByArtistIdWorkListImageUrlS];
    [aCoder encodeObject:_imageUrl forKey:kGetArtworkListByArtistIdWorkListImageUrl];
    [aCoder encodeObject:_artistName forKey:kGetArtworkListByArtistIdWorkListArtistName];
    [aCoder encodeDouble:_ratio forKey:kGetArtworkListByArtistIdWorkListRatio];
    [aCoder encodeDouble:_beScanTime forKey:kGetArtworkListByArtistIdWorkListBeScanTime];
}

- (id)copyWithZone:(NSZone *)zone
{
    GetArtworkListByArtistIdWorkList *copy = [[GetArtworkListByArtistIdWorkList alloc] init];
    
    if (copy) {

        copy.workId = self.workId;
        copy.workTitle = [self.workTitle copyWithZone:zone];
        copy.imageUrlS = [self.imageUrlS copyWithZone:zone];
        copy.imageUrl = [self.imageUrl copyWithZone:zone];
        copy.artistName = [self.artistName copyWithZone:zone];
        copy.ratio = self.ratio;
        copy.beScanTime = self.beScanTime;
    }
    
    return copy;
}


@end
