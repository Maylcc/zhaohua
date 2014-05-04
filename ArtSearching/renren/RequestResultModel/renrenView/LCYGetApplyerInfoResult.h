//
//  LCYGetApplyerInfoResult.h
//
//  Created by 超逸 李 on 14-5-4
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LCYGetApplyerInfoResult : NSObject <NSCoding>

@property (nonatomic, strong) NSString *applyers;
@property (nonatomic, strong) NSString *internalBaseClassIdentifier; /**< 申请id */
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *imgs;
@property (nonatomic, strong) NSString *date;

+ (LCYGetApplyerInfoResult *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
