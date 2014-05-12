//
//  XMLParserHelper.m
//  ArtSearching
//
//  Created by developer on 14-5-12.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "XMLParserHelper.h"
@interface XMLParserHelper()
{
    NSMutableString *stringForContent;
}
@end


@implementation XMLParserHelper
static XMLParserHelper *parserHelper;
+ (XMLParserHelper *)sharedSelf
{
    @synchronized(self)
    {
        if(parserHelper == nil)
        {
           return [[self alloc] init];
        }
    }
    return parserHelper;
}

+ (id)alloc
{
    @synchronized(self)
    {
        parserHelper = [super alloc];
        
        return parserHelper;
    }
    return nil;
}

- (id)init
{
    if(self = [super init])
    {
        stringForContent = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:self.elementString])
    {
        _currentElementString = elementName;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([_currentElementString isEqualToString:self.elementString])
    {
        [stringForContent appendString:string];
    }
}

//发现元素结束符的处理函数，保存元素各项目数据（即报告元素的结束标记）
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([_currentElementString isEqualToString:self.elementString])
    {
        self.elementContent = [NSString stringWithFormat:@"%@",stringForContent];
        [stringForContent setString:@""];
    }
}

//报告解析的结束
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    _currentElementString = nil;
}

@end
