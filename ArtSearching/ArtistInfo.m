//
//  ArtistInfo.m
//
//  Created by 宇周  on 14-4-23
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "ArtistInfo.h"


NSString *const kArtistInfoArtistStoreCount = @"artistStoreCount";
NSString *const kArtistInfoArtistWorkCount = @"artistWorkCount";
NSString *const kArtistInfoArtistEducation = @"artistEducation";
NSString *const kArtistInfoArtistPortalS = @"artistPortal_s";
NSString *const kArtistInfoArtistPortal = @"artistPortal";
NSString *const kArtistInfoArtistName = @"artistName";
NSString *const kArtistInfoArtistIntroduction = @"artistIntroduction";
NSString *const kArtistInfoArtistScanCount = @"artistScanCount";
NSString *const kArtistInfoCode = @"code";


@interface ArtistInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ArtistInfo

@synthesize artistStoreCount = _artistStoreCount;
@synthesize artistWorkCount = _artistWorkCount;
@synthesize artistEducation = _artistEducation;
@synthesize artistPortalS = _artistPortalS;
@synthesize artistPortal = _artistPortal;
@synthesize artistName = _artistName;
@synthesize artistIntroduction = _artistIntroduction;
@synthesize artistScanCount = _artistScanCount;
@synthesize code = _code;


+ (ArtistInfo *)modelObjectWithDictionary:(NSDictionary *)dict
{
    ArtistInfo *instance = [[ArtistInfo alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.artistStoreCount = [[self objectOrNilForKey:kArtistInfoArtistStoreCount fromDictionary:dict] doubleValue];
            self.artistWorkCount = [[self objectOrNilForKey:kArtistInfoArtistWorkCount fromDictionary:dict] doubleValue];
            self.artistEducation = [self objectOrNilForKey:kArtistInfoArtistEducation fromDictionary:dict];
            self.artistPortalS = [self objectOrNilForKey:kArtistInfoArtistPortalS fromDictionary:dict];
            self.artistPortal = [self objectOrNilForKey:kArtistInfoArtistPortal fromDictionary:dict];
            self.artistName = [self objectOrNilForKey:kArtistInfoArtistName fromDictionary:dict];
            self.artistIntroduction = [self objectOrNilForKey:kArtistInfoArtistIntroduction fromDictionary:dict];
            self.artistScanCount = [[self objectOrNilForKey:kArtistInfoArtistScanCount fromDictionary:dict] doubleValue];
            self.code = [[self objectOrNilForKey:kArtistInfoCode fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.artistStoreCount] forKey:kArtistInfoArtistStoreCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.artistWorkCount] forKey:kArtistInfoArtistWorkCount];
    [mutableDict setValue:self.artistEducation forKey:kArtistInfoArtistEducation];
    [mutableDict setValue:self.artistPortalS forKey:kArtistInfoArtistPortalS];
    [mutableDict setValue:self.artistPortal forKey:kArtistInfoArtistPortal];
    [mutableDict setValue:self.artistName forKey:kArtistInfoArtistName];
    [mutableDict setValue:self.artistIntroduction forKey:kArtistInfoArtistIntroduction];
    [mutableDict setValue:[NSNumber numberWithDouble:self.artistScanCount] forKey:kArtistInfoArtistScanCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kArtistInfoCode];

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

    self.artistStoreCount = [aDecoder decodeDoubleForKey:kArtistInfoArtistStoreCount];
    self.artistWorkCount = [aDecoder decodeDoubleForKey:kArtistInfoArtistWorkCount];
    self.artistEducation = [aDecoder decodeObjectForKey:kArtistInfoArtistEducation];
    self.artistPortalS = [aDecoder decodeObjectForKey:kArtistInfoArtistPortalS];
    self.artistPortal = [aDecoder decodeObjectForKey:kArtistInfoArtistPortal];
    self.artistName = [aDecoder decodeObjectForKey:kArtistInfoArtistName];
    self.artistIntroduction = [aDecoder decodeObjectForKey:kArtistInfoArtistIntroduction];
    self.artistScanCount = [aDecoder decodeDoubleForKey:kArtistInfoArtistScanCount];
    self.code = [aDecoder decodeDoubleForKey:kArtistInfoCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_artistStoreCount forKey:kArtistInfoArtistStoreCount];
    [aCoder encodeDouble:_artistWorkCount forKey:kArtistInfoArtistWorkCount];
    [aCoder encodeObject:_artistEducation forKey:kArtistInfoArtistEducation];
    [aCoder encodeObject:_artistPortalS forKey:kArtistInfoArtistPortalS];
    [aCoder encodeObject:_artistPortal forKey:kArtistInfoArtistPortal];
    [aCoder encodeObject:_artistName forKey:kArtistInfoArtistName];
    [aCoder encodeObject:_artistIntroduction forKey:kArtistInfoArtistIntroduction];
    [aCoder encodeDouble:_artistScanCount forKey:kArtistInfoArtistScanCount];
    [aCoder encodeDouble:_code forKey:kArtistInfoCode];
}


@end
