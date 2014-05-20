//
//  LCYXMLDictionaryParser.m
//  ArtSearching
//
//  Created by eagle on 14-5-16.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYXMLDictionaryParser.h"
@interface LCYXMLDictionaryParser ()
@property (strong, nonatomic) NSMutableString *xmlTempString;
@end
@implementation LCYXMLDictionaryParser
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    self.xmlTempString = [[NSMutableString alloc] init];
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    [self.xmlTempString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    NSData *data = [self.xmlTempString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&error];
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(didFinishGetXMLInfo:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate didFinishGetXMLInfo:jsonResponse];
        });
    } else if (self.delegate &&
               [self.delegate respondsToSelector:@selector(parser:didFinishGetXMLInfo:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate parser:self didFinishGetXMLInfo:jsonResponse];
        });
    }
}
@end
