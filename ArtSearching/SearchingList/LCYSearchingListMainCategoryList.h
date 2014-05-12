//
//  LCYSearchingListMainCategoryList.h
//
//  Created by 超逸 李 on 14-5-12
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LCYSearchingListMainCategoryList : NSObject <NSCoding>

@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *categoryName;

+ (LCYSearchingListMainCategoryList *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
