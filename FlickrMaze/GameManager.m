//
//  GameManager.m
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-03.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import "GameManager.h"
#import "MazeManager.h"
#import "MazeTile+CoreDataClass.h"

@interface GameManager ()

@property (nonatomic) NSMutableArray<MazeTile*>* mazeTileArray;
@property (nonatomic) NSArray <NSArray *> *mazeColumnArray;
@property (nonatomic) MazeManager *mazeManager;
@end

@implementation GameManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mazeTileArray = [NSMutableArray new];
        _mazeManager = [MazeManager new];
    }
    return self;
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"FlickrMaze"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

- (NSManagedObjectContext *) getContext {
    return self.persistentContainer.viewContext;
}

-(void) clearTestData {
    self.mazeTileArray = [NSMutableArray new];
    NSManagedObjectContext *context = [self getContext];
    NSFetchRequest *request = [MazeTile fetchRequest];
    NSError *error = nil;
    NSArray *mazeArray = [context executeFetchRequest:request error:&error];
    NSLog(@"%lu", (unsigned long)mazeArray.count);
    for (MazeTile *mazeTile in mazeArray) {
        [context deleteObject:mazeTile];
    }
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

#pragma mark Maze Methods
- (void) generateMaze {
    self.mazeColumnArray = [self.mazeManager makeMazeWith:self.mazeTileArray];
}


#pragma mark Helper Methods

- (NSURL*) generateURL: (NSString*) tagEntry {
    [self clearTestData];
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=4ecacf0cd6441400e02e57ec12f0bb68&has_geo&tags="];
    NSString *tagWithoutWhiteSpace = [tagEntry stringByReplacingOccurrencesOfString:@" " withString:@""];
    [urlString appendString:tagWithoutWhiteSpace];
    return [NSURL URLWithString:urlString];
}

- (void) createMazeTileWithDictionary: (NSDictionary*)photo {
    NSManagedObjectContext *context = [self getContext];
    MazeTile *tile = [[MazeTile alloc] initWithContext:context];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", photo[@"farm"], photo[@"server"], photo[@"id"], photo[@"secret"]]];
    tile.image = [NSData dataWithContentsOfURL:url];
    tile.title = photo[@"title"];
    [self.mazeTileArray addObject:tile];
    [self saveContext];
}

- (NSArray *) getArray {
    return self.mazeColumnArray;
}


@end
