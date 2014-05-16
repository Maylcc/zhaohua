//
//  LCYXMLDictionaryParser.h
//  ArtSearching
//
//  Created by eagle on 14-5-16.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol LCYXMLDictionaryParserDelegate <NSObject>
@optional
- (void)didFinishGetXMLInfo:(NSDictionary *)info;
@end
@interface LCYXMLDictionaryParser : NSObject<NSXMLParserDelegate>
@property (weak, nonatomic) id<LCYXMLDictionaryParserDelegate>delegate;
@end
