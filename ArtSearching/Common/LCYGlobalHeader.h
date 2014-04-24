//
//  LCYGlobalHeader.h
//  ArtSearching
//
//  Created by Licy on 14-4-24.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#ifndef ArtSearching_LCYGlobalHeader_h
#define ArtSearching_LCYGlobalHeader_h


#ifdef DEBUG
    #define LCYLOG(...) NSLog(__VA_ARGS__)
#else
    #define LCYLOG(...)
#endif

#endif
