//
//  LCYGetArtistListResult.m
//
//  Created by 超逸 李 on 14-5-1
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYGetArtistListResult.h"
#import "LCYArtists.h"


NSString *const kLCYGetArtistListResultArtists = @"artists";
NSString *const kLCYGetArtistListResultTotalCount = @"totalCount";
NSString *const kLCYGetArtistListResultCode = @"code";


@interface LCYGetArtistListResult ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYGetArtistListResult

@synthesize artists = _artists;
@synthesize totalCount = _totalCount;
@synthesize code = _code;


+ (LCYGetArtistListResult *)modelObjectWithDictionary:(NSDictionary *)dict
{
    LCYGetArtistListResult *instance = [[LCYGetArtistListResult alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
    NSObject *receivedLCYArtists = [dict objectForKey:kLCYGetArtistListResultArtists];
    NSMutableArray *parsedLCYArtists = [NSMutableArray array];
    if ([receivedLCYArtists isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedLCYArtists) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedLCYArtists addObject:[LCYArtists modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedLCYArtists isKindOfClass:[NSDictionary class]]) {
       [parsedLCYArtists addObject:[LCYArtists modelObjectWithDictionary:(NSDictionary *)receivedLCYArtists]];
    }

    self.artists = [NSArray arrayWithArray:parsedLCYArtists];
            self.totalCount = [[self objectOrNilForKey:kLCYGetArtistListResultTotalCount fromDictionary:dict] doubleValue];
            self.code = [[self objectOrNilForKey:kLCYGetArtistListResultCode fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
NSMutableArray *tempArrayForArtists = [NSMutableArray array];
    for (NSObject *subArrayObject in self.artists) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForArtists addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForArtists addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForArtists] forKey:@"kLCYGetArtistListResultArtists"];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalCount] forKey:kLCYGetArtistListResultTotalCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kLCYGetArtistListResultCode];

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

    self.artists = [aDecoder decodeObjectForKey:kLCYGetArtistListResultArtists];
    self.totalCount = [aDecoder decodeDoubleForKey:kLCYGetArtistListResultTotalCount];
    self.code = [aDecoder decodeDoubleForKey:kLCYGetArtistListResultCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_artists forKey:kLCYGetArtistListResultArtists];
    [aCoder encodeDouble:_totalCount forKey:kLCYGetArtistListResultTotalCount];
    [aCoder encodeDouble:_code forKey:kLCYGetArtistListResultCode];
}


@end
