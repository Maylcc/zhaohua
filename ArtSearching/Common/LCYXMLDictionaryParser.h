//
//  LCYXMLDictionaryParser.h
//  ArtSearching
//
//  Created by eagle on 14-5-16.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LCYXMLDictionaryParser;
@protocol LCYXMLDictionaryParserDelegate <NSObject>
@optional
/**
 *  当前控制器只需要一个XML解析器时，调用此回调函数
 *
 *  @param info 解析结果
 */
- (void)didFinishGetXMLInfo:(NSDictionary *)info;
/**
 *  当前控制器需要两个或更多XML解析器时，调用此回调函数
 *
 *  @param parser XML解析器
 *  @param info   解析结果
 */
- (void)parser:(LCYXMLDictionaryParser *)parser didFinishGetXMLInfo:(NSDictionary *)info;
@end
@interface LCYXMLDictionaryParser : NSObject<NSXMLParserDelegate>
@property (weak, nonatomic) id<LCYXMLDictionaryParserDelegate>delegate;
@end
