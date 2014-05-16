//
//  LCYGetGalleryInfoByIDGalleryInfo.m
//
//  Created by 超逸 李 on 14-5-16
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYGetGalleryInfoByIDGalleryInfo.h"
#import "LCYGetGalleryInfoByIDGallery.h"


NSString *const kLCYGetGalleryInfoByIDGalleryInfoGallery = @"_Gallery";
NSString *const kLCYGetGalleryInfoByIDGalleryInfoCode = @"code";


@interface LCYGetGalleryInfoByIDGalleryInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYGetGalleryInfoByIDGalleryInfo

@synthesize gallery = _gallery;
@synthesize code = _code;


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
            self.gallery = [LCYGetGalleryInfoByIDGallery modelObjectWithDictionary:[dict objectForKey:kLCYGetGalleryInfoByIDGalleryInfoGallery]];
            self.code = [[self objectOrNilForKey:kLCYGetGalleryInfoByIDGalleryInfoCode fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.gallery dictionaryRepresentation] forKey:kLCYGetGalleryInfoByIDGalleryInfoGallery];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kLCYGetGalleryInfoByIDGalleryInfoCode];

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

    self.gallery = [aDecoder decodeObjectForKey:kLCYGetGalleryInfoByIDGalleryInfoGallery];
    self.code = [aDecoder decodeDoubleForKey:kLCYGetGalleryInfoByIDGalleryInfoCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_gallery forKey:kLCYGetGalleryInfoByIDGalleryInfoGallery];
    [aCoder encodeDouble:_code forKey:kLCYGetGalleryInfoByIDGalleryInfoCode];
}

- (id)copyWithZone:(NSZone *)zone
{
    LCYGetGalleryInfoByIDGalleryInfo *copy = [[LCYGetGalleryInfoByIDGalleryInfo alloc] init];
    
    if (copy) {

        copy.gallery = [self.gallery copyWithZone:zone];
        copy.code = self.code;
    }
    
    return copy;
}


@end
