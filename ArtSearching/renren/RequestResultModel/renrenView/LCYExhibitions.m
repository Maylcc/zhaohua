//
//  LCYExhibitions.m
//
//  Created by   on 14-4-29
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYExhibitions.h"
#import "LCYImgs.h"


NSString *const kLCYExhibitionsOrganizerName = @"organizer_name";
NSString *const kLCYExhibitionsExhibitionid = @"exhibitionid";
NSString *const kLCYExhibitionsTitle = @"title";
NSString *const kLCYExhibitionsImgs = @"imgs";
NSString *const kLCYExhibitionsAttenderNames = @"attender_names";
NSString *const kLCYExhibitionsCreateTime = @"create_time";
NSString *const kLCYExhibitionsDescribinfo = @"describinfo";
NSString *const kLCYExhibitionsCommentNums = @"comment_nums";
NSString *const kLCYExhibitionsViewNum = @"view_num";
NSString *const kLCYExhibitionsOrganizerPic = @"organizer_pic";


@interface LCYExhibitions ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYExhibitions

@synthesize organizerName = _organizerName;
@synthesize exhibitionid = _exhibitionid;
@synthesize title = _title;
@synthesize imgs = _imgs;
@synthesize attenderNames = _attenderNames;
@synthesize createTime = _createTime;
@synthesize describinfo = _describinfo;
@synthesize commentNums = _commentNums;
@synthesize viewNum = _viewNum;
@synthesize organizerPic = _organizerPic;


+ (LCYExhibitions *)modelObjectWithDictionary:(NSDictionary *)dict
{
    LCYExhibitions *instance = [[LCYExhibitions alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.organizerName = [self objectOrNilForKey:kLCYExhibitionsOrganizerName fromDictionary:dict];
            self.exhibitionid = [self objectOrNilForKey:kLCYExhibitionsExhibitionid fromDictionary:dict];
            self.title = [self objectOrNilForKey:kLCYExhibitionsTitle fromDictionary:dict];
    NSObject *receivedLCYImgs = [dict objectForKey:kLCYExhibitionsImgs];
    NSMutableArray *parsedLCYImgs = [NSMutableArray array];
    if ([receivedLCYImgs isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedLCYImgs) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedLCYImgs addObject:[LCYImgs modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedLCYImgs isKindOfClass:[NSDictionary class]]) {
       [parsedLCYImgs addObject:[LCYImgs modelObjectWithDictionary:(NSDictionary *)receivedLCYImgs]];
    }

    self.imgs = [NSArray arrayWithArray:parsedLCYImgs];
            self.attenderNames = [self objectOrNilForKey:kLCYExhibitionsAttenderNames fromDictionary:dict];
            self.createTime = [self objectOrNilForKey:kLCYExhibitionsCreateTime fromDictionary:dict];
            self.describinfo = [self objectOrNilForKey:kLCYExhibitionsDescribinfo fromDictionary:dict];
            self.commentNums = [self objectOrNilForKey:kLCYExhibitionsCommentNums fromDictionary:dict];
            self.viewNum = [self objectOrNilForKey:kLCYExhibitionsViewNum fromDictionary:dict];
            self.organizerPic = [self objectOrNilForKey:kLCYExhibitionsOrganizerPic fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.organizerName forKey:kLCYExhibitionsOrganizerName];
    [mutableDict setValue:self.exhibitionid forKey:kLCYExhibitionsExhibitionid];
    [mutableDict setValue:self.title forKey:kLCYExhibitionsTitle];
NSMutableArray *tempArrayForImgs = [NSMutableArray array];
    for (NSObject *subArrayObject in self.imgs) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForImgs addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForImgs addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForImgs] forKey:@"kLCYExhibitionsImgs"];
    [mutableDict setValue:self.attenderNames forKey:kLCYExhibitionsAttenderNames];
    [mutableDict setValue:self.createTime forKey:kLCYExhibitionsCreateTime];
    [mutableDict setValue:self.describinfo forKey:kLCYExhibitionsDescribinfo];
    [mutableDict setValue:self.commentNums forKey:kLCYExhibitionsCommentNums];
    [mutableDict setValue:self.viewNum forKey:kLCYExhibitionsViewNum];
    [mutableDict setValue:self.organizerPic forKey:kLCYExhibitionsOrganizerPic];

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

    self.organizerName = [aDecoder decodeObjectForKey:kLCYExhibitionsOrganizerName];
    self.exhibitionid = [aDecoder decodeObjectForKey:kLCYExhibitionsExhibitionid];
    self.title = [aDecoder decodeObjectForKey:kLCYExhibitionsTitle];
    self.imgs = [aDecoder decodeObjectForKey:kLCYExhibitionsImgs];
    self.attenderNames = [aDecoder decodeObjectForKey:kLCYExhibitionsAttenderNames];
    self.createTime = [aDecoder decodeObjectForKey:kLCYExhibitionsCreateTime];
    self.describinfo = [aDecoder decodeObjectForKey:kLCYExhibitionsDescribinfo];
    self.commentNums = [aDecoder decodeObjectForKey:kLCYExhibitionsCommentNums];
    self.viewNum = [aDecoder decodeObjectForKey:kLCYExhibitionsViewNum];
    self.organizerPic = [aDecoder decodeObjectForKey:kLCYExhibitionsOrganizerPic];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_organizerName forKey:kLCYExhibitionsOrganizerName];
    [aCoder encodeObject:_exhibitionid forKey:kLCYExhibitionsExhibitionid];
    [aCoder encodeObject:_title forKey:kLCYExhibitionsTitle];
    [aCoder encodeObject:_imgs forKey:kLCYExhibitionsImgs];
    [aCoder encodeObject:_attenderNames forKey:kLCYExhibitionsAttenderNames];
    [aCoder encodeObject:_createTime forKey:kLCYExhibitionsCreateTime];
    [aCoder encodeObject:_describinfo forKey:kLCYExhibitionsDescribinfo];
    [aCoder encodeObject:_commentNums forKey:kLCYExhibitionsCommentNums];
    [aCoder encodeObject:_viewNum forKey:kLCYExhibitionsViewNum];
    [aCoder encodeObject:_organizerPic forKey:kLCYExhibitionsOrganizerPic];
}


@end
