//
//  LCYArtistDetailVCArtist.m
//
//  Created by 超逸 李 on 14-5-12
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYArtistDetailVCArtist.h"


NSString *const kLCYArtistDetailVCArtistArtistStoreCount = @"artistStoreCount";
NSString *const kLCYArtistDetailVCArtistArtistWorkCount = @"artistWorkCount";
NSString *const kLCYArtistDetailVCArtistArtistEducation = @"artistEducation";
NSString *const kLCYArtistDetailVCArtistArtistPortalS = @"artistPortal_s";
NSString *const kLCYArtistDetailVCArtistArtistPortal = @"artistPortal";
NSString *const kLCYArtistDetailVCArtistArtistName = @"artistName";
NSString *const kLCYArtistDetailVCArtistArtistIntroduction = @"artistIntroduction";
NSString *const kLCYArtistDetailVCArtistArtistScanCount = @"artistScanCount";
NSString *const kLCYArtistDetailVCArtistCode = @"code";


@interface LCYArtistDetailVCArtist ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYArtistDetailVCArtist

@synthesize artistStoreCount = _artistStoreCount;
@synthesize artistWorkCount = _artistWorkCount;
@synthesize artistEducation = _artistEducation;
@synthesize artistPortalS = _artistPortalS;
@synthesize artistPortal = _artistPortal;
@synthesize artistName = _artistName;
@synthesize artistIntroduction = _artistIntroduction;
@synthesize artistScanCount = _artistScanCount;
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
            self.artistStoreCount = [[self objectOrNilForKey:kLCYArtistDetailVCArtistArtistStoreCount fromDictionary:dict] doubleValue];
            self.artistWorkCount = [[self objectOrNilForKey:kLCYArtistDetailVCArtistArtistWorkCount fromDictionary:dict] doubleValue];
            self.artistEducation = [self objectOrNilForKey:kLCYArtistDetailVCArtistArtistEducation fromDictionary:dict];
            self.artistPortalS = [self objectOrNilForKey:kLCYArtistDetailVCArtistArtistPortalS fromDictionary:dict];
            self.artistPortal = [self objectOrNilForKey:kLCYArtistDetailVCArtistArtistPortal fromDictionary:dict];
            self.artistName = [self objectOrNilForKey:kLCYArtistDetailVCArtistArtistName fromDictionary:dict];
            self.artistIntroduction = [self objectOrNilForKey:kLCYArtistDetailVCArtistArtistIntroduction fromDictionary:dict];
            self.artistScanCount = [[self objectOrNilForKey:kLCYArtistDetailVCArtistArtistScanCount fromDictionary:dict] doubleValue];
            self.code = [[self objectOrNilForKey:kLCYArtistDetailVCArtistCode fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.artistStoreCount] forKey:kLCYArtistDetailVCArtistArtistStoreCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.artistWorkCount] forKey:kLCYArtistDetailVCArtistArtistWorkCount];
    [mutableDict setValue:self.artistEducation forKey:kLCYArtistDetailVCArtistArtistEducation];
    [mutableDict setValue:self.artistPortalS forKey:kLCYArtistDetailVCArtistArtistPortalS];
    [mutableDict setValue:self.artistPortal forKey:kLCYArtistDetailVCArtistArtistPortal];
    [mutableDict setValue:self.artistName forKey:kLCYArtistDetailVCArtistArtistName];
    [mutableDict setValue:self.artistIntroduction forKey:kLCYArtistDetailVCArtistArtistIntroduction];
    [mutableDict setValue:[NSNumber numberWithDouble:self.artistScanCount] forKey:kLCYArtistDetailVCArtistArtistScanCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kLCYArtistDetailVCArtistCode];

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

    self.artistStoreCount = [aDecoder decodeDoubleForKey:kLCYArtistDetailVCArtistArtistStoreCount];
    self.artistWorkCount = [aDecoder decodeDoubleForKey:kLCYArtistDetailVCArtistArtistWorkCount];
    self.artistEducation = [aDecoder decodeObjectForKey:kLCYArtistDetailVCArtistArtistEducation];
    self.artistPortalS = [aDecoder decodeObjectForKey:kLCYArtistDetailVCArtistArtistPortalS];
    self.artistPortal = [aDecoder decodeObjectForKey:kLCYArtistDetailVCArtistArtistPortal];
    self.artistName = [aDecoder decodeObjectForKey:kLCYArtistDetailVCArtistArtistName];
    self.artistIntroduction = [aDecoder decodeObjectForKey:kLCYArtistDetailVCArtistArtistIntroduction];
    self.artistScanCount = [aDecoder decodeDoubleForKey:kLCYArtistDetailVCArtistArtistScanCount];
    self.code = [aDecoder decodeDoubleForKey:kLCYArtistDetailVCArtistCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_artistStoreCount forKey:kLCYArtistDetailVCArtistArtistStoreCount];
    [aCoder encodeDouble:_artistWorkCount forKey:kLCYArtistDetailVCArtistArtistWorkCount];
    [aCoder encodeObject:_artistEducation forKey:kLCYArtistDetailVCArtistArtistEducation];
    [aCoder encodeObject:_artistPortalS forKey:kLCYArtistDetailVCArtistArtistPortalS];
    [aCoder encodeObject:_artistPortal forKey:kLCYArtistDetailVCArtistArtistPortal];
    [aCoder encodeObject:_artistName forKey:kLCYArtistDetailVCArtistArtistName];
    [aCoder encodeObject:_artistIntroduction forKey:kLCYArtistDetailVCArtistArtistIntroduction];
    [aCoder encodeDouble:_artistScanCount forKey:kLCYArtistDetailVCArtistArtistScanCount];
    [aCoder encodeDouble:_code forKey:kLCYArtistDetailVCArtistCode];
}

- (id)copyWithZone:(NSZone *)zone
{
    LCYArtistDetailVCArtist *copy = [[LCYArtistDetailVCArtist alloc] init];
    
    if (copy) {

        copy.artistStoreCount = self.artistStoreCount;
        copy.artistWorkCount = self.artistWorkCount;
        copy.artistEducation = [self.artistEducation copyWithZone:zone];
        copy.artistPortalS = [self.artistPortalS copyWithZone:zone];
        copy.artistPortal = [self.artistPortal copyWithZone:zone];
        copy.artistName = [self.artistName copyWithZone:zone];
        copy.artistIntroduction = [self.artistIntroduction copyWithZone:zone];
        copy.artistScanCount = self.artistScanCount;
        copy.code = self.code;
    }
    
    return copy;
}


@end
