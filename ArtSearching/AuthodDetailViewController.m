//
//  AuthodDetailViewController.m
//  ArtSearching
//
//  Created by developer on 14-4-23.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "AuthodDetailViewController.h"

@interface AuthodDetailViewController ()
{
    NSString *_artistID;
}
@property (nonatomic,strong)NSString *artistID;
@end

@implementation AuthodDetailViewController
@synthesize artistID = _artistID;
- (id)initWithArtistID:(NSString *)artistID
{
    self = [super initWithNibName:@"AuthodDetailViewController" bundle:nil];
    if(self)
    {
        self.artistID = artistID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
