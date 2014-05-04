//
//  LCYExhibitions.m
//
//  Created by 超逸 李 on 14-5-4
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYMineExhibitions.h"
#import "LCYApplyers.h"
#import "LCYImgs.h"


NSString *const kLCYMineExhibitionsOrganizerPic = @"organizer_pic";
NSString *const kLCYMineExhibitionsExhibitionid = @"exhibitionid";
NSString *const kLCYMineExhibitionsApplyers = @"applyers";
NSString *const kLCYMineExhibitionsTitle = @"title";
NSString *const kLCYMineExhibitionsAttenderNames = @"attender_names";
NSString *const kLCYMineExhibitionsDescribinfo = @"describinfo";
NSString *const kLCYMineExhibitionsCreateTime = @"create_time";
NSString *const kLCYMineExhibitionsImgs = @"imgs";
NSString *const kLCYMineExhibitionsCommentNums = @"comment_nums";
NSString *const kLCYMineExhibitionsViewNum = @"view_num";
NSString *const kLCYMineExhibitionsOrganizerName = @"organizer_name";


@interface LCYMineExhibitions ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYMineExhibitions

@synthesize organizerPic = _organizerPic;
@synthesize exhibitionid = _exhibitionid;
@synthesize applyers = _applyers;
@synthesize title = _title;
@synthesize attenderNames = _attenderNames;
@synthesize describinfo = _describinfo;
@synthesize createTime = _createTime;
@synthesize imgs = _imgs;
@synthesize commentNums = _commentNums;
@synthesize viewNum = _viewNum;
@synthesize organizerName = _organizerName;


+ (LCYMineExhibitions *)modelObjectWithDictionary:(NSDictionary *)dict
{
    LCYMineExhibitions *instance = [[LCYMineExhibitions alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.organizerPic = [self objectOrNilForKey:kLCYMineExhibitionsOrganizerPic fromDictionary:dict];
            self.exhibitionid = [self objectOrNilForKey:kLCYMineExhibitionsExhibitionid fromDictionary:dict];
    NSObject *receivedLCYApplyers = [dict objectForKey:kLCYMineExhibitionsApplyers];
    NSMutableArray *parsedLCYApplyers = [NSMutableArray array];
    if ([receivedLCYApplyers isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedLCYApplyers) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedLCYApplyers addObject:[LCYApplyers modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedLCYApplyers isKindOfClass:[NSDictionary class]]) {
       [parsedLCYApplyers addObject:[LCYApplyers modelObjectWithDictionary:(NSDictionary *)receivedLCYApplyers]];
    }

    self.applyers = [NSArray arrayWithArray:parsedLCYApplyers];
            self.title = [self objectOrNilForKey:kLCYMineExhibitionsTitle fromDictionary:dict];
            self.attenderNames = [self objectOrNilForKey:kLCYMineExhibitionsAttenderNames fromDictionary:dict];
            self.describinfo = [self objectOrNilForKey:kLCYMineExhibitionsDescribinfo fromDictionary:dict];
            self.createTime = [self objectOrNilForKey:kLCYMineExhibitionsCreateTime fromDictionary:dict];
    NSObject *receivedLCYImgs = [dict objectForKey:kLCYMineExhibitionsImgs];
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
            self.commentNums = [self objectOrNilForKey:kLCYMineExhibitionsCommentNums fromDictionary:dict];
            self.viewNum = [self objectOrNilForKey:kLCYMineExhibitionsViewNum fromDictionary:dict];
            self.organizerName = [self objectOrNilForKey:kLCYMineExhibitionsOrganizerName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.organizerPic forKey:kLCYMineExhibitionsOrganizerPic];
    [mutableDict setValue:self.exhibitionid forKey:kLCYMineExhibitionsExhibitionid];
NSMutableArray *tempArrayForApplyers = [NSMutableArray array];
    for (NSObject *subArrayObject in self.applyers) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForApplyers addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForApplyers addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForApplyers] forKey:@"kLCYExhibitionsApplyers"];
    [mutableDict setValue:self.title forKey:kLCYMineExhibitionsTitle];
    [mutableDict setValue:self.attenderNames forKey:kLCYMineExhibitionsAttenderNames];
    [mutableDict setValue:self.describinfo forKey:kLCYMineExhibitionsDescribinfo];
    [mutableDict setValue:self.createTime forKey:kLCYMineExhibitionsCreateTime];
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
    [mutableDict setValue:self.commentNums forKey:kLCYMineExhibitionsCommentNums];
    [mutableDict setValue:self.viewNum forKey:kLCYMineExhibitionsViewNum];
    [mutableDict setValue:self.organizerName forKey:kLCYMineExhibitionsOrganizerName];

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

    self.organizerPic = [aDecoder decodeObjectForKey:kLCYMineExhibitionsOrganizerPic];
    self.exhibitionid = [aDecoder decodeObjectForKey:kLCYMineExhibitionsExhibitionid];
    self.applyers = [aDecoder decodeObjectForKey:kLCYMineExhibitionsApplyers];
    self.title = [aDecoder decodeObjectForKey:kLCYMineExhibitionsTitle];
    self.attenderNames = [aDecoder decodeObjectForKey:kLCYMineExhibitionsAttenderNames];
    self.describinfo = [aDecoder decodeObjectForKey:kLCYMineExhibitionsDescribinfo];
    self.createTime = [aDecoder decodeObjectForKey:kLCYMineExhibitionsCreateTime];
    self.imgs = [aDecoder decodeObjectForKey:kLCYMineExhibitionsImgs];
    self.commentNums = [aDecoder decodeObjectForKey:kLCYMineExhibitionsCommentNums];
    self.viewNum = [aDecoder decodeObjectForKey:kLCYMineExhibitionsViewNum];
    self.organizerName = [aDecoder decodeObjectForKey:kLCYMineExhibitionsOrganizerName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_organizerPic forKey:kLCYMineExhibitionsOrganizerPic];
    [aCoder encodeObject:_exhibitionid forKey:kLCYMineExhibitionsExhibitionid];
    [aCoder encodeObject:_applyers forKey:kLCYMineExhibitionsApplyers];
    [aCoder encodeObject:_title forKey:kLCYMineExhibitionsTitle];
    [aCoder encodeObject:_attenderNames forKey:kLCYMineExhibitionsAttenderNames];
    [aCoder encodeObject:_describinfo forKey:kLCYMineExhibitionsDescribinfo];
    [aCoder encodeObject:_createTime forKey:kLCYMineExhibitionsCreateTime];
    [aCoder encodeObject:_imgs forKey:kLCYMineExhibitionsImgs];
    [aCoder encodeObject:_commentNums forKey:kLCYMineExhibitionsCommentNums];
    [aCoder encodeObject:_viewNum forKey:kLCYMineExhibitionsViewNum];
    [aCoder encodeObject:_organizerName forKey:kLCYMineExhibitionsOrganizerName];
}


@end
