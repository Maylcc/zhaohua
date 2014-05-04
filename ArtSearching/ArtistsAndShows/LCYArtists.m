//
//  LCYArtists.m
//
//  Created by 超逸 李 on 14-5-1
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYArtists.h"


NSString *const kLCYArtistsArtistPortalS = @"artistPortal_s";
NSString *const kLCYArtistsArtistId = @"artistId";
NSString *const kLCYArtistsArtistWorkCount = @"artistWorkCount";
NSString *const kLCYArtistsArtistOpenTime = @"artistOpenTime";
NSString *const kLCYArtistsArtistPortal = @"artistPortal";
NSString *const kLCYArtistsArtistName = @"artistName";


@interface LCYArtists ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYArtists

@synthesize artistPortalS = _artistPortalS;
@synthesize artistId = _artistId;
@synthesize artistWorkCount = _artistWorkCount;
@synthesize artistOpenTime = _artistOpenTime;
@synthesize artistPortal = _artistPortal;
@synthesize artistName = _artistName;


+ (LCYArtists *)modelObjectWithDictionary:(NSDictionary *)dict
{
    LCYArtists *instance = [[LCYArtists alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.artistPortalS = [self objectOrNilForKey:kLCYArtistsArtistPortalS fromDictionary:dict];
            self.artistId = [[self objectOrNilForKey:kLCYArtistsArtistId fromDictionary:dict] doubleValue];
            self.artistWorkCount = [[self objectOrNilForKey:kLCYArtistsArtistWorkCount fromDictionary:dict] doubleValue];
            self.artistOpenTime = [[self objectOrNilForKey:kLCYArtistsArtistOpenTime fromDictionary:dict] doubleValue];
            self.artistPortal = [self objectOrNilForKey:kLCYArtistsArtistPortal fromDictionary:dict];
            self.artistName = [self objectOrNilForKey:kLCYArtistsArtistName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.artistPortalS forKey:kLCYArtistsArtistPortalS];
    [mutableDict setValue:[NSNumber numberWithDouble:self.artistId] forKey:kLCYArtistsArtistId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.artistWorkCount] forKey:kLCYArtistsArtistWorkCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.artistOpenTime] forKey:kLCYArtistsArtistOpenTime];
    [mutableDict setValue:self.artistPortal forKey:kLCYArtistsArtistPortal];
    [mutableDict setValue:self.artistName forKey:kLCYArtistsArtistName];

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

    self.artistPortalS = [aDecoder decodeObjectForKey:kLCYArtistsArtistPortalS];
    self.artistId = [aDecoder decodeDoubleForKey:kLCYArtistsArtistId];
    self.artistWorkCount = [aDecoder decodeDoubleForKey:kLCYArtistsArtistWorkCount];
    self.artistOpenTime = [aDecoder decodeDoubleForKey:kLCYArtistsArtistOpenTime];
    self.artistPortal = [aDecoder decodeObjectForKey:kLCYArtistsArtistPortal];
    self.artistName = [aDecoder decodeObjectForKey:kLCYArtistsArtistName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_artistPortalS forKey:kLCYArtistsArtistPortalS];
    [aCoder encodeDouble:_artistId forKey:kLCYArtistsArtistId];
    [aCoder encodeDouble:_artistWorkCount forKey:kLCYArtistsArtistWorkCount];
    [aCoder encodeDouble:_artistOpenTime forKey:kLCYArtistsArtistOpenTime];
    [aCoder encodeObject:_artistPortal forKey:kLCYArtistsArtistPortal];
    [aCoder encodeObject:_artistName forKey:kLCYArtistsArtistName];
}


@end
