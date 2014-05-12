//
//  XMLParserHelper.h
//  ArtSearching
//
//  Created by developer on 14-5-12.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLParserHelper : NSObject<NSXMLParserDelegate>
{
    NSData *_parserData;
    NSString *_currentElementString;
}
@property (nonatomic,strong)NSData *parserData;
@property (nonatomic,strong)NSString *elementString;
@property (nonatomic,strong)NSString *elementContent;
+ (XMLParserHelper *)sharedSelf;

@end
