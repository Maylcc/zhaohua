//
//  GetArtworkListByGallryIdWorkList.h
//
//  Created by 超逸 李 on 14-5-22
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface GetArtworkListByGallryIdWorkList : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double workId;
@property (nonatomic, strong) NSString *workTitle;
@property (nonatomic, strong) NSString *imageUrlS;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, assign) double ratio;
@property (nonatomic, assign) double beScanTime;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
