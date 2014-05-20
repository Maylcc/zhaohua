//
//  LCYGetFavoriteArtWorksInfos.m
//
//  Created by 超逸 李 on 14-5-19
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYGetFavoriteArtWorksInfos.h"


NSString *const kLCYGetFavoriteArtWorksInfosAuthor = @"author";
NSString *const kLCYGetFavoriteArtWorksInfosImageRatio = @"image_ratio";
NSString *const kLCYGetFavoriteArtWorksInfosId = @"id";
NSString *const kLCYGetFavoriteArtWorksInfosTitle = @"title";
NSString *const kLCYGetFavoriteArtWorksInfosCommentnum = @"commentnum";
NSString *const kLCYGetFavoriteArtWorksInfosViewnum = @"viewnum";
NSString *const kLCYGetFavoriteArtWorksInfosUrl = @"url";


@interface LCYGetFavoriteArtWorksInfos ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYGetFavoriteArtWorksInfos

@synthesize author = _author;
@synthesize imageRatio = _imageRatio;
@synthesize infosIdentifier = _infosIdentifier;
@synthesize title = _title;
@synthesize commentnum = _commentnum;
@synthesize viewnum = _viewnum;
@synthesize url = _url;


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
            self.author = [self objectOrNilForKey:kLCYGetFavoriteArtWorksInfosAuthor fromDictionary:dict];
            self.imageRatio = [[self objectOrNilForKey:kLCYGetFavoriteArtWorksInfosImageRatio fromDictionary:dict] doubleValue];
            self.infosIdentifier = [[self objectOrNilForKey:kLCYGetFavoriteArtWorksInfosId fromDictionary:dict] doubleValue];
            self.title = [self objectOrNilForKey:kLCYGetFavoriteArtWorksInfosTitle fromDictionary:dict];
            self.commentnum = [[self objectOrNilForKey:kLCYGetFavoriteArtWorksInfosCommentnum fromDictionary:dict] doubleValue];
            self.viewnum = [[self objectOrNilForKey:kLCYGetFavoriteArtWorksInfosViewnum fromDictionary:dict] doubleValue];
            self.url = [self objectOrNilForKey:kLCYGetFavoriteArtWorksInfosUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.author forKey:kLCYGetFavoriteArtWorksInfosAuthor];
    [mutableDict setValue:[NSNumber numberWithDouble:self.imageRatio] forKey:kLCYGetFavoriteArtWorksInfosImageRatio];
    [mutableDict setValue:[NSNumber numberWithDouble:self.infosIdentifier] forKey:kLCYGetFavoriteArtWorksInfosId];
    [mutableDict setValue:self.title forKey:kLCYGetFavoriteArtWorksInfosTitle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.commentnum] forKey:kLCYGetFavoriteArtWorksInfosCommentnum];
    [mutableDict setValue:[NSNumber numberWithDouble:self.viewnum] forKey:kLCYGetFavoriteArtWorksInfosViewnum];
    [mutableDict setValue:self.url forKey:kLCYGetFavoriteArtWorksInfosUrl];

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

    self.author = [aDecoder decodeObjectForKey:kLCYGetFavoriteArtWorksInfosAuthor];
    self.imageRatio = [aDecoder decodeDoubleForKey:kLCYGetFavoriteArtWorksInfosImageRatio];
    self.infosIdentifier = [aDecoder decodeDoubleForKey:kLCYGetFavoriteArtWorksInfosId];
    self.title = [aDecoder decodeObjectForKey:kLCYGetFavoriteArtWorksInfosTitle];
    self.commentnum = [aDecoder decodeDoubleForKey:kLCYGetFavoriteArtWorksInfosCommentnum];
    self.viewnum = [aDecoder decodeDoubleForKey:kLCYGetFavoriteArtWorksInfosViewnum];
    self.url = [aDecoder decodeObjectForKey:kLCYGetFavoriteArtWorksInfosUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_author forKey:kLCYGetFavoriteArtWorksInfosAuthor];
    [aCoder encodeDouble:_imageRatio forKey:kLCYGetFavoriteArtWorksInfosImageRatio];
    [aCoder encodeDouble:_infosIdentifier forKey:kLCYGetFavoriteArtWorksInfosId];
    [aCoder encodeObject:_title forKey:kLCYGetFavoriteArtWorksInfosTitle];
    [aCoder encodeDouble:_commentnum forKey:kLCYGetFavoriteArtWorksInfosCommentnum];
    [aCoder encodeDouble:_viewnum forKey:kLCYGetFavoriteArtWorksInfosViewnum];
    [aCoder encodeObject:_url forKey:kLCYGetFavoriteArtWorksInfosUrl];
}

- (id)copyWithZone:(NSZone *)zone
{
    LCYGetFavoriteArtWorksInfos *copy = [[LCYGetFavoriteArtWorksInfos alloc] init];
    
    if (copy) {

        copy.author = [self.author copyWithZone:zone];
        copy.imageRatio = self.imageRatio;
        copy.infosIdentifier = self.infosIdentifier;
        copy.title = [self.title copyWithZone:zone];
        copy.commentnum = self.commentnum;
        copy.viewnum = self.viewnum;
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
