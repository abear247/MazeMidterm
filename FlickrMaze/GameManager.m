//
//  GameManager.m
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-03.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import "GameManager.h"
#import "Maze.h"
#import "MazeTile+CoreDataClass.h"

@interface GameManager ()

@property (nonatomic) NSMutableArray<MazeTile*>* mazeTileArray;
@property (nonatomic) NSArray <NSArray *> *mazeSectionArray;
@property (nonatomic) Maze *Maze;
@end

@implementation GameManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mazeTileArray = [NSMutableArray new];
        _Maze = [Maze new];
        _player = [[Player alloc] initWithContext:[self getContext]];
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

#pragma mark Maze Making Methods
- (void) generateMaze {
    self.mazeSectionArray = [self.Maze makeMazeWith:self.mazeTileArray];
}

#pragma mark Game Control Methods
- (void) startGame {
    self.player.ghostX = self.player.currentX;
    self.player.ghostY = self.player.currentY;
    [NSTimer scheduledTimerWithTimeInterval:20.0
                                     target:self
                                   selector:@selector(startGhost)
                                   userInfo:nil
                                    repeats:NO];
}

- (void) startGhost {
    int xDifference = self.player.currentX - self.player.ghostX;
    int yDifference = self.player.currentY - self.player.ghostY;
    if (xDifference > 0) {
        self.player.ghostX += 1;
    }
    else if (xDifference < 0) {
        self.player.ghostX -= 1;
    }
    if (yDifference > 0) {
        self.player.ghostY += 1;
    }
    else if (yDifference < 0) {
        self.player.ghostY -= 1;
    }
    if (self.player.currentX != self.player.ghostX || self.player.currentY != self.player.ghostY) {
        NSLog(@"Game over");
    }
    else {
        NSLog(@"\nGhost X: %hd\n Ghost Y: %hd", self.player.ghostX, self.player.ghostY);
        [NSTimer scheduledTimerWithTimeInterval:5.0
                                         target:self
                                       selector:@selector(startGhost)
                                       userInfo:nil
                                        repeats:NO];
    }
}

#pragma mark Helper Methods

- (NSURL*) generateURL: (NSString*) tagEntry {
    [self clearTestData];
    self.player.currentX = 0;
    self.player.currentY = 9;
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
    tile.valid = YES;
    [self.mazeTileArray addObject:tile];
}

- (NSArray *) getArray {
    return self.mazeSectionArray;
}

@end
