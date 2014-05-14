//
//  LCYShowsGalleryGalleryList.h
//
//  Created by 超逸 李 on 14-5-13
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LCYShowsGalleryGalleryList : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double code;
@property (nonatomic, strong) NSArray *galleries;
@property (nonatomic, assign) double totalCount;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
