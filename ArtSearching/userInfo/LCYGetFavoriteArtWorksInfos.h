//
//  LCYGetFavoriteArtWorksInfos.h
//
//  Created by 超逸 李 on 14-5-19
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LCYGetFavoriteArtWorksInfos : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *author;
@property (nonatomic, assign) double imageRatio;
@property (nonatomic, assign) double infosIdentifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) double commentnum;
@property (nonatomic, assign) double viewnum;
@property (nonatomic, strong) NSString *url;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
