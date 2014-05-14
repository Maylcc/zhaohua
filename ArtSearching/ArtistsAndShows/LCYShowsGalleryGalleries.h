//
//  LCYShowsGalleryGalleries.h
//
//  Created by 超逸 李 on 14-5-13
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LCYShowsGalleryGalleries : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *brief;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *logoUrl;
@property (nonatomic, assign) double galleriesIdentifier;
@property (nonatomic, assign) double workCount;
@property (nonatomic, assign) id pic;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, assign) double openTimes;
@property (nonatomic, strong) NSString *name;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
