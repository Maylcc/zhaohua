//
//  DrawPointLineDelegate.h
//  ArtSearching
//
//  Created by developer on 14-5-19.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    DrawArtsPoint = 0,
    DrawArtistsPoint = 1,
    DrawGalleryPoint =2,
}DrawPointType;

@protocol DrawPointLineDelegate <NSObject>
- (void)drawPointLine:(NSNumber *)artsID withType:(DrawPointType) typeDraw;
@end
