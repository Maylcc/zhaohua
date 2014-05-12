//
//  NetHelperDelegate.h
//  ArtSearching
//
//  Created by developer on 14-5-12.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPRequestOperation.h>
typedef enum
{
    requestCompleteFail = 0,
    requestCompleteSuccess ,
}requestCompleteFlag;
@protocol NetHelperDelegate <NSObject>
- (void)requestCompleteDelegateWithFlag:(requestCompleteFlag)flag withOperation:(AFHTTPRequestOperation *)opertation withObject:(id)object;
@end
