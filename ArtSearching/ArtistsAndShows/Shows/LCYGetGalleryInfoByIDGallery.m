//
//  LCYGetGalleryInfoByIDGallery.m
//
//  Created by 超逸 李 on 14-5-16
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYGetGalleryInfoByIDGallery.h"


NSString *const kLCYGetGalleryInfoByIDGalleryBrief = @"brief";
NSString *const kLCYGetGalleryInfoByIDGalleryCity = @"city";
NSString *const kLCYGetGalleryInfoByIDGalleryLogoUrl = @"logoUrl";
NSString *const kLCYGetGalleryInfoByIDGalleryId = @"id";
NSString *const kLCYGetGalleryInfoByIDGalleryWorkCount = @"workCount";
NSString *const kLCYGetGalleryInfoByIDGalleryPic = @"pic";
NSString *const kLCYGetGalleryInfoByIDGalleryEmail = @"email";
NSString *const kLCYGetGalleryInfoByIDGalleryTel = @"tel";
NSString *const kLCYGetGalleryInfoByIDGalleryOpenTimes = @"openTimes";
NSString *const kLCYGetGalleryInfoByIDGalleryName = @"name";


@interface LCYGetGalleryInfoByIDGallery ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYGetGalleryInfoByIDGallery

@synthesize brief = _brief;
@synthesize city = _city;
@synthesize logoUrl = _logoUrl;
@synthesize galleryIdentifier = _galleryIdentifier;
@synthesize workCount = _workCount;
@synthesize pic = _pic;
@synthesize email = _email;
@synthesize tel = _tel;
@synthesize openTimes = _openTimes;
@synthesize name = _name;


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
            self.brief = [self objectOrNilForKey:kLCYGetGalleryInfoByIDGalleryBrief fromDictionary:dict];
            self.city = [self objectOrNilForKey:kLCYGetGalleryInfoByIDGalleryCity fromDictionary:dict];
            self.logoUrl = [self objectOrNilForKey:kLCYGetGalleryInfoByIDGalleryLogoUrl fromDictionary:dict];
            self.galleryIdentifier = [[self objectOrNilForKey:kLCYGetGalleryInfoByIDGalleryId fromDictionary:dict] doubleValue];
            self.workCount = [[self objectOrNilForKey:kLCYGetGalleryInfoByIDGalleryWorkCount fromDictionary:dict] doubleValue];
            self.pic = [self objectOrNilForKey:kLCYGetGalleryInfoByIDGalleryPic fromDictionary:dict];
            self.email = [self objectOrNilForKey:kLCYGetGalleryInfoByIDGalleryEmail fromDictionary:dict];
            self.tel = [self objectOrNilForKey:kLCYGetGalleryInfoByIDGalleryTel fromDictionary:dict];
            self.openTimes = [[self objectOrNilForKey:kLCYGetGalleryInfoByIDGalleryOpenTimes fromDictionary:dict] doubleValue];
            self.name = [self objectOrNilForKey:kLCYGetGalleryInfoByIDGalleryName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.brief forKey:kLCYGetGalleryInfoByIDGalleryBrief];
    [mutableDict setValue:self.city forKey:kLCYGetGalleryInfoByIDGalleryCity];
    [mutableDict setValue:self.logoUrl forKey:kLCYGetGalleryInfoByIDGalleryLogoUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.galleryIdentifier] forKey:kLCYGetGalleryInfoByIDGalleryId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.workCount] forKey:kLCYGetGalleryInfoByIDGalleryWorkCount];
    [mutableDict setValue:self.pic forKey:kLCYGetGalleryInfoByIDGalleryPic];
    [mutableDict setValue:self.email forKey:kLCYGetGalleryInfoByIDGalleryEmail];
    [mutableDict setValue:self.tel forKey:kLCYGetGalleryInfoByIDGalleryTel];
    [mutableDict setValue:[NSNumber numberWithDouble:self.openTimes] forKey:kLCYGetGalleryInfoByIDGalleryOpenTimes];
    [mutableDict setValue:self.name forKey:kLCYGetGalleryInfoByIDGalleryName];

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

    self.brief = [aDecoder decodeObjectForKey:kLCYGetGalleryInfoByIDGalleryBrief];
    self.city = [aDecoder decodeObjectForKey:kLCYGetGalleryInfoByIDGalleryCity];
    self.logoUrl = [aDecoder decodeObjectForKey:kLCYGetGalleryInfoByIDGalleryLogoUrl];
    self.galleryIdentifier = [aDecoder decodeDoubleForKey:kLCYGetGalleryInfoByIDGalleryId];
    self.workCount = [aDecoder decodeDoubleForKey:kLCYGetGalleryInfoByIDGalleryWorkCount];
    self.pic = [aDecoder decodeObjectForKey:kLCYGetGalleryInfoByIDGalleryPic];
    self.email = [aDecoder decodeObjectForKey:kLCYGetGalleryInfoByIDGalleryEmail];
    self.tel = [aDecoder decodeObjectForKey:kLCYGetGalleryInfoByIDGalleryTel];
    self.openTimes = [aDecoder decodeDoubleForKey:kLCYGetGalleryInfoByIDGalleryOpenTimes];
    self.name = [aDecoder decodeObjectForKey:kLCYGetGalleryInfoByIDGalleryName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_brief forKey:kLCYGetGalleryInfoByIDGalleryBrief];
    [aCoder encodeObject:_city forKey:kLCYGetGalleryInfoByIDGalleryCity];
    [aCoder encodeObject:_logoUrl forKey:kLCYGetGalleryInfoByIDGalleryLogoUrl];
    [aCoder encodeDouble:_galleryIdentifier forKey:kLCYGetGalleryInfoByIDGalleryId];
    [aCoder encodeDouble:_workCount forKey:kLCYGetGalleryInfoByIDGalleryWorkCount];
    [aCoder encodeObject:_pic forKey:kLCYGetGalleryInfoByIDGalleryPic];
    [aCoder encodeObject:_email forKey:kLCYGetGalleryInfoByIDGalleryEmail];
    [aCoder encodeObject:_tel forKey:kLCYGetGalleryInfoByIDGalleryTel];
    [aCoder encodeDouble:_openTimes forKey:kLCYGetGalleryInfoByIDGalleryOpenTimes];
    [aCoder encodeObject:_name forKey:kLCYGetGalleryInfoByIDGalleryName];
}

- (id)copyWithZone:(NSZone *)zone
{
    LCYGetGalleryInfoByIDGallery *copy = [[LCYGetGalleryInfoByIDGallery alloc] init];
    
    if (copy) {

        copy.brief = [self.brief copyWithZone:zone];
        copy.city = [self.city copyWithZone:zone];
        copy.logoUrl = [self.logoUrl copyWithZone:zone];
        copy.galleryIdentifier = self.galleryIdentifier;
        copy.workCount = self.workCount;
        copy.pic = [self.pic copyWithZone:zone];
        copy.email = [self.email copyWithZone:zone];
        copy.tel = [self.tel copyWithZone:zone];
        copy.openTimes = self.openTimes;
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
