//
//  LCYGetGalleryInfoByIDGalleryInfo.h
//
//  Created by 超逸 李 on 14-5-16
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LCYGetGalleryInfoByIDGallery;

@interface LCYGetGalleryInfoByIDGalleryInfo : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) LCYGetGalleryInfoByIDGallery *gallery;
@property (nonatomic, assign) double code;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
