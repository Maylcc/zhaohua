//
//  LCYXDTools.m
//  ArtSearching
//
//  Created by Licy on 14-4-29.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYXDTools.h"
#import "JSONKit.h"

@implementation LCYXDTools

+ (ASIFormDataRequest*)postRequestWithDict:(NSString *)body API:(NSString *)api
{
    static NSString *hostURL        = @"http://115.29.41.251:88/webservice_art_base.asmx?op=";
    static NSString *userName       = @"111111";
    static NSString *userPassword   = @"111111";
    static NSString *nameSpace      = @"http://tempuri.org/";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",hostURL,api]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    //设置头
    
    NSString  *soap = [NSString stringWithFormat:
                       @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       " <soap:Header>\n"
                       " <CredentialSoapHeader xmlns=\"http://tempuri.org/\">\n"
                       "<UserName>%@</UserName>\n"
                       " <UserPassword>%@</UserPassword>\n"
                       " </CredentialSoapHeader>"
                       "</soap:Header>"
                       "<soap:Body>\n"
                       "%@"
                       "</soap:Body>\n"
                       "</soap:Envelope>\n",userName,userPassword,body
                       ];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soap length]];
    
    
    [request addRequestHeader:@"Content-Length" value:msgLength];
    [request addRequestHeader:@"Host" value:@"115.29.41.251"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml;charset=utf-8"];
    [request addRequestHeader: @"SOAPAction" value:[NSString stringWithFormat:@"%@%@",nameSpace,api]];
    [request appendPostData:[soap dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    
    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:12];

    return request;
}

+ (NSDictionary *)JSonFromString:(NSString* )result
{
    NSDictionary *json = [result objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    return json;
    
}

@end
