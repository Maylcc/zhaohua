//
//  DataCMICTableViewCell.m
//  ArtSearching
//
//  Created by developer on 14-4-28.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "DataCMICTableViewCell.h"
#import "NetHelper.h"
#import "NetHelperDelegate.h"
#import "LCYCommon.h"
#import <AFNetworking.h>
@interface DataCMICTableViewCell()
{
    BOOL isStringElement;
    NSMutableString *stringFormatter;
}
@end

@implementation DataCMICTableViewCell

- (void)awakeFromNib
{
    netHelper = [NetHelper sharedSelf];
    netHelper.netHelperDelegate = self;
    stringFormatter = [[NSMutableString alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    NSDate *date = [NSDate date];
    NSDictionary *requestParams = [NSDictionary dictionaryWithObjectsAndKeys:date,@"Date",[NSNumber numberWithInt:0],@"Type", nil];
    NSString *getTotalMarketURL = [NSString stringWithFormat:@"%@%@",hostForXM,getMarketTotalIndex];
    [self.waitProgress setHidden:NO];
    [self.waitProgress startAnimating];
    AFXMLParserResponseSerializer *serializer = [AFXMLParserResponseSerializer serializer];
    [netHelper requestStart:getTotalMarketURL withParams:requestParams bySerialize:serializer];
}

- (void)requestCompleteDelegateWithFlag:(requestCompleteFlag)flag withOperation:(AFHTTPRequestOperation *)opertation withObject:(id)object
{
    [self.waitProgress stopAnimating];
    if(flag == requestCompleteSuccess)
    {
        if([self.delegate respondsToSelector:@selector(completeDownCMICData:)])
        {
            NSLog(@"response is %@",opertation.responseString);
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[opertation responseData]];
            parser.delegate = self;
            [parser parse];
            [self.delegate completeDownCMICData:YES];
        }
        else
        {
            NSAssert(![self.delegate respondsToSelector:@selector(completeDownCMICData:)], @"isCMICDown 的代理没有实现必须的方法");
        }
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(completeDownCMICData:)])
        {
            [self.delegate completeDownCMICData:NO];
        }
        else
        {
            NSAssert(![self.delegate respondsToSelector:@selector(completeDownCMICData:)], @"isCMICDown 的代理没有实现必须的方法");
        }
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"string"])
    {
        isStringElement = YES;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(isStringElement)
    {
        [stringFormatter appendString:string];
    }
}

//发现元素结束符的处理函数，保存元素各项目数据（即报告元素的结束标记）
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"string"])
    {
        isStringElement = NO;
        [self changeInde];
    }
}

//报告解析的结束
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    
}

- (void)changeInde
{
    NSLog(@"xml parser result is %@",stringFormatter);
    NSDictionary *parserDic = [NSJSONSerialization JSONObjectWithData:[stringFormatter dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    NSString *cmaicString = [parserDic objectForKey:@"camci"];
    self.indexNum.text = cmaicString;
}

@end
