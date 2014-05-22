//
//  GetArtworkListByGallryIdWorkList.m
//
//  Created by 超逸 李 on 14-5-22
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "GetArtworkListByGallryIdWorkList.h"


NSString *const kGetArtworkListByGallryIdWorkListWorkId = @"workId";
NSString *const kGetArtworkListByGallryIdWorkListWorkTitle = @"workTitle";
NSString *const kGetArtworkListByGallryIdWorkListImageUrlS = @"imageUrl_s";
NSString *const kGetArtworkListByGallryIdWorkListImageUrl = @"imageUrl";
NSString *const kGetArtworkListByGallryIdWorkListArtistName = @"artistName";
NSString *const kGetArtworkListByGallryIdWorkListRatio = @"ratio";
NSString *const kGetArtworkListByGallryIdWorkListBeScanTime = @"beScanTime";


@interface GetArtworkListByGallryIdWorkList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation GetArtworkListByGallryIdWorkList

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
            self.workId = [[self objectOrNilForKey:kGetArtworkListByGallryIdWorkListWorkId fromDictionary:dict] doubleValue];
            self.workTitle = [self objectOrNilForKey:kGetArtworkListByGallryIdWorkListWorkTitle fromDictionary:dict];
            self.imageUrlS = [self objectOrNilForKey:kGetArtworkListByGallryIdWorkListImageUrlS fromDictionary:dict];
            self.imageUrl = [self objectOrNilForKey:kGetArtworkListByGallryIdWorkListImageUrl fromDictionary:dict];
            self.artistName = [self objectOrNilForKey:kGetArtworkListByGallryIdWorkListArtistName fromDictionary:dict];
            self.ratio = [[self objectOrNilForKey:kGetArtworkListByGallryIdWorkListRatio fromDictionary:dict] doubleValue];
            self.beScanTime = [[self objectOrNilForKey:kGetArtworkListByGallryIdWorkListBeScanTime fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.workId] forKey:kGetArtworkListByGallryIdWorkListWorkId];
    [mutableDict setValue:self.workTitle forKey:kGetArtworkListByGallryIdWorkListWorkTitle];
    [mutableDict setValue:self.imageUrlS forKey:kGetArtworkListByGallryIdWorkListImageUrlS];
    [mutableDict setValue:self.imageUrl forKey:kGetArtworkListByGallryIdWorkListImageUrl];
    [mutableDict setValue:self.artistName forKey:kGetArtworkListByGallryIdWorkListArtistName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.ratio] forKey:kGetArtworkListByGallryIdWorkListRatio];
    [mutableDict setValue:[NSNumber numberWithDouble:self.beScanTime] forKey:kGetArtworkListByGallryIdWorkListBeScanTime];

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

    self.workId = [aDecoder decodeDoubleForKey:kGetArtworkListByGallryIdWorkListWorkId];
    self.workTitle = [aDecoder decodeObjectForKey:kGetArtworkListByGallryIdWorkListWorkTitle];
    self.imageUrlS = [aDecoder decodeObjectForKey:kGetArtworkListByGallryIdWorkListImageUrlS];
    self.imageUrl = [aDecoder decodeObjectForKey:kGetArtworkListByGallryIdWorkListImageUrl];
    self.artistName = [aDecoder decodeObjectForKey:kGetArtworkListByGallryIdWorkListArtistName];
    self.ratio = [aDecoder decodeDoubleForKey:kGetArtworkListByGallryIdWorkListRatio];
    self.beScanTime = [aDecoder decodeDoubleForKey:kGetArtworkListByGallryIdWorkListBeScanTime];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_workId forKey:kGetArtworkListByGallryIdWorkListWorkId];
    [aCoder encodeObject:_workTitle forKey:kGetArtworkListByGallryIdWorkListWorkTitle];
    [aCoder encodeObject:_imageUrlS forKey:kGetArtworkListByGallryIdWorkListImageUrlS];
    [aCoder encodeObject:_imageUrl forKey:kGetArtworkListByGallryIdWorkListImageUrl];
    [aCoder encodeObject:_artistName forKey:kGetArtworkListByGallryIdWorkListArtistName];
    [aCoder encodeDouble:_ratio forKey:kGetArtworkListByGallryIdWorkListRatio];
    [aCoder encodeDouble:_beScanTime forKey:kGetArtworkListByGallryIdWorkListBeScanTime];
}

- (id)copyWithZone:(NSZone *)zone
{
    GetArtworkListByGallryIdWorkList *copy = [[GetArtworkListByGallryIdWorkList alloc] init];
    
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
