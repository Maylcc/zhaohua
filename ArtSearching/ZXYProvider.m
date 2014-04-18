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
    NSEntityDescription *entity = [[NSEntityDescription alloc] init];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:stringName];
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
         return YES;
     }
}

-(BOOL)saveStartArtistsList:(NSArray *)artists
{
    [self deleteCoreDataFromDB:@"StartArtistsList"];
    LCYAppDelegate *app = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *manageContext = [app managedObjectContext];
    StartArtistsList *startArtist = [NSEntityDescription insertNewObjectForEntityForName:@"StartArtistsList" inManagedObjectContext:manageContext];
    for(int i = 0;i<artists.count;i++)
    {
        NSDictionary *dic = [artists objectAtIndex:i];
        startArtist.id_Art = [dic valueForKey:@"id"];
        startArtist.beScanTime = [dic valueForKey:@"beScanTime"];
        startArtist.beStoreTime = [dic valueForKey:@"beStoreTime"];
        startArtist.author      = [dic valueForKey:@"author"];
        startArtist.workCount   = [dic valueForKey:@"workCount"];
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
    StartArtList *startArtist = [NSEntityDescription insertNewObjectForEntityForName:@"StartArtList" inManagedObjectContext:manageContext];
    for(int i = 0;i<artList.count;i++)
    {
        NSDictionary *dic = [artList objectAtIndex:i];
        startArtist.id_Art = [dic valueForKey:@"id"];
        startArtist.beScanTime = [dic valueForKey:@"beScanTime"];
        startArtist.beStoreTime = [dic valueForKey:@"beStoreTime"];
        startArtist.author      = [dic valueForKey:@"author"];
        startArtist.url         = [dic valueForKey:@"url"];
        startArtist.url_Small   = [dic valueForKey:@"url_s"];
        startArtist.title       = [dic valueForKey:@"title"];
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

-(BOOL)saveStartGalleryList:(NSArray *)galleryList
{
    [self deleteCoreDataFromDB:@"StartGalleryList"];
    LCYAppDelegate *app = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *manageContext = [app managedObjectContext];
    StartGalleryList *startArtist = [NSEntityDescription insertNewObjectForEntityForName:@"StartGalleryList" inManagedObjectContext:manageContext];
    for(int i = 0;i<galleryList.count;i++)
    {
        NSDictionary *dic = [galleryList objectAtIndex:i];
        startArtist.id_Art = [dic valueForKey:@"id"];
        startArtist.beScanTime = [dic valueForKey:@"beScanTime"];
        startArtist.beStoreTime = [dic valueForKey:@"beStoreTime"];
        startArtist.name      = [dic valueForKey:@"name"];
        startArtist.url         = [dic valueForKey:@"url"];
        startArtist.workCount   = [dic valueForKey:@"workCount"];
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
