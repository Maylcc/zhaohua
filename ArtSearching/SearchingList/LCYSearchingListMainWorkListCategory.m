//
//  LCYSearchingListMainWorkListCategory.m
//
//  Created by 超逸 李 on 14-5-12
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYSearchingListMainWorkListCategory.h"
#import "LCYSearchingListMainCategoryList.h"


NSString *const kLCYSearchingListMainWorkListCategoryCategoryList = @"categoryList";
NSString *const kLCYSearchingListMainWorkListCategoryCode = @"code";


@interface LCYSearchingListMainWorkListCategory ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYSearchingListMainWorkListCategory

@synthesize categoryList = _categoryList;
@synthesize code = _code;


+ (LCYSearchingListMainWorkListCategory *)modelObjectWithDictionary:(NSDictionary *)dict
{
    LCYSearchingListMainWorkListCategory *instance = [[LCYSearchingListMainWorkListCategory alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
    NSObject *receivedLCYSearchingListMainCategoryList = [dict objectForKey:kLCYSearchingListMainWorkListCategoryCategoryList];
    NSMutableArray *parsedLCYSearchingListMainCategoryList = [NSMutableArray array];
    if ([receivedLCYSearchingListMainCategoryList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedLCYSearchingListMainCategoryList) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedLCYSearchingListMainCategoryList addObject:[LCYSearchingListMainCategoryList modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedLCYSearchingListMainCategoryList isKindOfClass:[NSDictionary class]]) {
       [parsedLCYSearchingListMainCategoryList addObject:[LCYSearchingListMainCategoryList modelObjectWithDictionary:(NSDictionary *)receivedLCYSearchingListMainCategoryList]];
    }

    self.categoryList = [NSArray arrayWithArray:parsedLCYSearchingListMainCategoryList];
            self.code = [[self objectOrNilForKey:kLCYSearchingListMainWorkListCategoryCode fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
NSMutableArray *tempArrayForCategoryList = [NSMutableArray array];
    for (NSObject *subArrayObject in self.categoryList) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForCategoryList addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForCategoryList addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForCategoryList] forKey:@"kLCYSearchingListMainWorkListCategoryCategoryList"];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kLCYSearchingListMainWorkListCategoryCode];

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

    self.categoryList = [aDecoder decodeObjectForKey:kLCYSearchingListMainWorkListCategoryCategoryList];
    self.code = [aDecoder decodeDoubleForKey:kLCYSearchingListMainWorkListCategoryCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_categoryList forKey:kLCYSearchingListMainWorkListCategoryCategoryList];
    [aCoder encodeDouble:_code forKey:kLCYSearchingListMainWorkListCategoryCode];
}


@end
