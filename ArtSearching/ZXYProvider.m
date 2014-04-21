//
//  ZXYProvider.m
//  ArtSearching
//
//  Created by developer on 14-4-18.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ZXYProvider.h"
#import "StartArtList.h"
#import "StartArtistsList.h"
#import "StartGalleryList.h"
@implementation ZXYProvider
static ZXYProvider *instance = nil;
+ (ZXYProvider *)sharedInstance
{
   @synchronized(self)
   {
       if(instance == nil)
       {
           return [[self alloc] init];
       }
    }
    return instance;
}

+ (id)alloc
{
    @synchronized(self)
    {
        instance = [super alloc];
        return instance;
    }
    return nil;
}
#pragma mark - delete
-(BOOL)deleteCoreDataFromDB:(NSString *)stringName
{
    LCYAppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *manageContext = [app managedObjectContext];
    NSArray *deleteObjects = [self readCoreDataFromDB:stringName];
    NSError *error;
    for(int i = 0;i<deleteObjects.count;i++)
    {
        NSManagedObject *deleteObject = [deleteObjects objectAtIndex:i];
        [manageContext deleteObject:deleteObject];
    }
    if([manageContext save:&error])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - read
- (NSArray *)readCoreDataFromDB:(NSString *)stringName
{
    LCYAppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *manageContext = [app managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:stringName inManagedObjectContext:manageContext ];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSError *error;
    NSArray *resultArr = [manageContext executeFetchRequest:request error:&error];
    if(error)
    {
        NSAssert(error, @"readCoreDataFromDB: error");
        return nil;
    }
    else
    {
        return resultArr;
    }
}

-(NSArray *)readCoreDataFromDB:(NSString *)stringName withContent:(NSString *)content andKey:(NSString *)key
{
    LCYAppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *manageContext = [app managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:stringName inManagedObjectContext:manageContext ];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    if(key != nil || content!=nil)
    {
        NSString *stringFormat = [NSString stringWithFormat:@"%@==\'%@\'",key,content];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:stringFormat];
        [request setPredicate:predicate];
    }
    [request setEntity:entity];
    NSError *error;
    NSArray *resultArr = [manageContext executeFetchRequest:request error:&error];
    if(error)
    {
        NSAssert(error, @"readCoreDataFromDB: error");
        return nil;
    }
    else
    {
        return resultArr;
    }

}

- (NSArray *)readCoreDataFromDB:(NSString *)stringName orderByKey:(NSString *)stringKey isDes:(BOOL)isDes
{
    LCYAppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *manageContext = [app managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:stringName inManagedObjectContext:manageContext ];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sorDiscriper = [NSSortDescriptor sortDescriptorWithKey:stringKey ascending:isDes];
    NSArray *sortArr = [NSArray arrayWithObjects:sorDiscriper, nil];
    [request setSortDescriptors:sortArr];
    [request setEntity:entity];
    NSError *error;
    NSArray *resultArr = [manageContext executeFetchRequest:request error:&error];
    if(error)
    {
        NSAssert(error, @"readCoreDataFromDB: error");
        return nil;
    }
    else
    {
        return resultArr;
    }

}

#pragma mark - save
-(BOOL)saveDataToCoreData:(NSDictionary *)dic withDBName:(NSString *)dbName
{
    [self deleteCoreDataFromDB:dbName];
    LCYAppDelegate *app = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *manageContext = [app managedObjectContext];
    NSEntityDescription *description = [NSEntityDescription entityForName:dbName inManagedObjectContext:manageContext];
    NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:description insertIntoManagedObjectContext:manageContext];
    for(int i = 0; i<dic.allKeys.count;i++)
    {
        [object setValue:[dic valueForKey:[dic.allKeys objectAtIndex:i]] forKey:[dic.allKeys objectAtIndex:i]];
    }
    NSError *error;
     [manageContext save:&error];
     if(error)
     {
         return NO;
     }
     else
     {
//         NSNotification *noti = [NSNotification notificationWithName:@"DataListViewFresh" object:nil];
//         [[NSNotificationCenter defaultCenter] postNotification:noti];
         return YES;
     }
}

-(BOOL)saveStartArtistsList:(NSArray *)artists
{
    [self deleteCoreDataFromDB:@"StartArtistsList"];
    LCYAppDelegate *app = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *manageContext = [app managedObjectContext];
    StartArtistsList *startArtist ;
    for(int i = 0;i<artists.count;i++)
    {
       startArtist = [NSEntityDescription insertNewObjectForEntityForName:@"StartArtistsList" inManagedObjectContext:manageContext];
        NSDictionary *dic = [artists objectAtIndex:i];
        startArtist.id_Art = (NSNumber *)[dic objectForKey:@"id"];
        startArtist.beScanTime = (NSNumber *)[dic objectForKey:@"beScanTime"];
        startArtist.beStoreTime = (NSNumber *)[dic objectForKey:@"beStoreTime"];
        startArtist.author      = [dic valueForKey:@"author"];
        startArtist.workCount   = (NSNumber *)[dic objectForKey:@"workCount"];
        startArtist.url         = [dic valueForKey:@"url"];
        startArtist.url_small   = [dic valueForKey:@"url_s"];
    }
    if([manageContext save:nil])
    {

        return YES;
    }
    else
    {
        return NO;
    }
}

-(BOOL)saveStartArtList:(NSArray *)artList
{
     [self deleteCoreDataFromDB:@"StartArtList"];
    LCYAppDelegate *app = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *manageContext = [app managedObjectContext];
    StartArtList *startArtist;
    for(int i = 0;i<artList.count;i++)
    {
        startArtist = [NSEntityDescription insertNewObjectForEntityForName:@"StartArtList" inManagedObjectContext:manageContext];

        NSDictionary *dic = [artList objectAtIndex:i];
        startArtist.id_Art = (NSNumber *)[dic objectForKey:@"id"];
        startArtist.beScanTime = (NSNumber *)[dic objectForKey:@"beScanTime"];
        startArtist.beStoreTime = (NSNumber *)[dic objectForKey:@"beStoreTime"];
        startArtist.author      = [dic valueForKey:@"author"];
        startArtist.url         = [dic valueForKey:@"url"];
        startArtist.url_Small   = [dic valueForKey:@"url_s"];
        startArtist.title       = [dic valueForKey:@"title"];
    }
    if([manageContext save:nil])
    {
//        NSNotification *noti = [NSNotification notificationWithName:@"DataListViewFresh" object:nil];
//        [[NSNotificationCenter defaultCenter] postNotification:noti];
        return YES;
    }
    else
    {
        return NO;
    }

}

-(BOOL)saveStartGalleryList:(NSArray *)galleryList
{
    [self deleteCoreDataFromDB:@"StartGalleryList"];
    LCYAppDelegate *app = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *manageContext = [app managedObjectContext];
    StartGalleryList *startArtist;
    for(int i = 0;i<galleryList.count;i++)
    {
        startArtist = [NSEntityDescription insertNewObjectForEntityForName:@"StartGalleryList" inManagedObjectContext:manageContext];
        NSDictionary *dic = [galleryList objectAtIndex:i];
        startArtist.id_Art = (NSNumber *)[dic objectForKey:@"id"];
        startArtist.beScanTime = (NSNumber *)[dic objectForKey:@"beScanTime"];
        startArtist.beStoreTime = (NSNumber *)[dic objectForKey:@"beStoreTime"];
        startArtist.name      = [dic valueForKey:@"name"];
        startArtist.url         = [dic valueForKey:@"url"];
        startArtist.workCount   = (NSNumber *)[dic objectForKey:@"workCount"];
    }
    if([manageContext save:nil])
    {
       
        return YES;
    }
    else
    {
        return NO;
    }

}

@end
