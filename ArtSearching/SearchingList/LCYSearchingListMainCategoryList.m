//
//  LCYSearchingListMainCategoryList.m
//
//  Created by 超逸 李 on 14-5-12
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYSearchingListMainCategoryList.h"


NSString *const kLCYSearchingListMainCategoryListCategoryId = @"categoryId";
NSString *const kLCYSearchingListMainCategoryListCategoryName = @"categoryName";


@interface LCYSearchingListMainCategoryList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYSearchingListMainCategoryList

@synthesize categoryId = _categoryId;
@synthesize categoryName = _categoryName;


+ (LCYSearchingListMainCategoryList *)modelObjectWithDictionary:(NSDictionary *)dict
{
    LCYSearchingListMainCategoryList *instance = [[LCYSearchingListMainCategoryList alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.categoryId = [self objectOrNilForKey:kLCYSearchingListMainCategoryListCategoryId fromDictionary:dict];
            self.categoryName = [self objectOrNilForKey:kLCYSearchingListMainCategoryListCategoryName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.categoryId forKey:kLCYSearchingListMainCategoryListCategoryId];
    [mutableDict setValue:self.categoryName forKey:kLCYSearchingListMainCategoryListCategoryName];

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

    self.categoryId = [aDecoder decodeObjectForKey:kLCYSearchingListMainCategoryListCategoryId];
    self.categoryName = [aDecoder decodeObjectForKey:kLCYSearchingListMainCategoryListCategoryName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_categoryId forKey:kLCYSearchingListMainCategoryListCategoryId];
    [aCoder encodeObject:_categoryName forKey:kLCYSearchingListMainCategoryListCategoryName];
}


@end
