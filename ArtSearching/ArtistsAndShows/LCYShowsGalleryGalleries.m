//
//  LCYShowsGalleryGalleries.m
//
//  Created by 超逸 李 on 14-5-13
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYShowsGalleryGalleries.h"


NSString *const kLCYShowsGalleryGalleriesBrief = @"brief";
NSString *const kLCYShowsGalleryGalleriesCity = @"city";
NSString *const kLCYShowsGalleryGalleriesLogoUrl = @"logoUrl";
NSString *const kLCYShowsGalleryGalleriesId = @"id";
NSString *const kLCYShowsGalleryGalleriesWorkCount = @"workCount";
NSString *const kLCYShowsGalleryGalleriesPic = @"pic";
NSString *const kLCYShowsGalleryGalleriesEmail = @"email";
NSString *const kLCYShowsGalleryGalleriesTel = @"tel";
NSString *const kLCYShowsGalleryGalleriesOpenTimes = @"openTimes";
NSString *const kLCYShowsGalleryGalleriesName = @"name";


@interface LCYShowsGalleryGalleries ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYShowsGalleryGalleries

@synthesize brief = _brief;
@synthesize city = _city;
@synthesize logoUrl = _logoUrl;
@synthesize galleriesIdentifier = _galleriesIdentifier;
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
            self.brief = [self objectOrNilForKey:kLCYShowsGalleryGalleriesBrief fromDictionary:dict];
            self.city = [self objectOrNilForKey:kLCYShowsGalleryGalleriesCity fromDictionary:dict];
            self.logoUrl = [self objectOrNilForKey:kLCYShowsGalleryGalleriesLogoUrl fromDictionary:dict];
            self.galleriesIdentifier = [[self objectOrNilForKey:kLCYShowsGalleryGalleriesId fromDictionary:dict] doubleValue];
            self.workCount = [[self objectOrNilForKey:kLCYShowsGalleryGalleriesWorkCount fromDictionary:dict] doubleValue];
            self.pic = [self objectOrNilForKey:kLCYShowsGalleryGalleriesPic fromDictionary:dict];
            self.email = [self objectOrNilForKey:kLCYShowsGalleryGalleriesEmail fromDictionary:dict];
            self.tel = [self objectOrNilForKey:kLCYShowsGalleryGalleriesTel fromDictionary:dict];
            self.openTimes = [[self objectOrNilForKey:kLCYShowsGalleryGalleriesOpenTimes fromDictionary:dict] doubleValue];
            self.name = [self objectOrNilForKey:kLCYShowsGalleryGalleriesName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.brief forKey:kLCYShowsGalleryGalleriesBrief];
    [mutableDict setValue:self.city forKey:kLCYShowsGalleryGalleriesCity];
    [mutableDict setValue:self.logoUrl forKey:kLCYShowsGalleryGalleriesLogoUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.galleriesIdentifier] forKey:kLCYShowsGalleryGalleriesId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.workCount] forKey:kLCYShowsGalleryGalleriesWorkCount];
    [mutableDict setValue:self.pic forKey:kLCYShowsGalleryGalleriesPic];
    [mutableDict setValue:self.email forKey:kLCYShowsGalleryGalleriesEmail];
    [mutableDict setValue:self.tel forKey:kLCYShowsGalleryGalleriesTel];
    [mutableDict setValue:[NSNumber numberWithDouble:self.openTimes] forKey:kLCYShowsGalleryGalleriesOpenTimes];
    [mutableDict setValue:self.name forKey:kLCYShowsGalleryGalleriesName];

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

    self.brief = [aDecoder decodeObjectForKey:kLCYShowsGalleryGalleriesBrief];
    self.city = [aDecoder decodeObjectForKey:kLCYShowsGalleryGalleriesCity];
    self.logoUrl = [aDecoder decodeObjectForKey:kLCYShowsGalleryGalleriesLogoUrl];
    self.galleriesIdentifier = [aDecoder decodeDoubleForKey:kLCYShowsGalleryGalleriesId];
    self.workCount = [aDecoder decodeDoubleForKey:kLCYShowsGalleryGalleriesWorkCount];
    self.pic = [aDecoder decodeObjectForKey:kLCYShowsGalleryGalleriesPic];
    self.email = [aDecoder decodeObjectForKey:kLCYShowsGalleryGalleriesEmail];
    self.tel = [aDecoder decodeObjectForKey:kLCYShowsGalleryGalleriesTel];
    self.openTimes = [aDecoder decodeDoubleForKey:kLCYShowsGalleryGalleriesOpenTimes];
    self.name = [aDecoder decodeObjectForKey:kLCYShowsGalleryGalleriesName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_brief forKey:kLCYShowsGalleryGalleriesBrief];
    [aCoder encodeObject:_city forKey:kLCYShowsGalleryGalleriesCity];
    [aCoder encodeObject:_logoUrl forKey:kLCYShowsGalleryGalleriesLogoUrl];
    [aCoder encodeDouble:_galleriesIdentifier forKey:kLCYShowsGalleryGalleriesId];
    [aCoder encodeDouble:_workCount forKey:kLCYShowsGalleryGalleriesWorkCount];
    [aCoder encodeObject:_pic forKey:kLCYShowsGalleryGalleriesPic];
    [aCoder encodeObject:_email forKey:kLCYShowsGalleryGalleriesEmail];
    [aCoder encodeObject:_tel forKey:kLCYShowsGalleryGalleriesTel];
    [aCoder encodeDouble:_openTimes forKey:kLCYShowsGalleryGalleriesOpenTimes];
    [aCoder encodeObject:_name forKey:kLCYShowsGalleryGalleriesName];
}

- (id)copyWithZone:(NSZone *)zone
{
    LCYShowsGalleryGalleries *copy = [[LCYShowsGalleryGalleries alloc] init];
    
    if (copy) {

        copy.brief = [self.brief copyWithZone:zone];
        copy.city = [self.city copyWithZone:zone];
        copy.logoUrl = [self.logoUrl copyWithZone:zone];
        copy.galleriesIdentifier = self.galleriesIdentifier;
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
