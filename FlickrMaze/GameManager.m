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
@property (nonatomic) NSArray <NSArray <MazeTile*>*> *mazeSectionArray;
@property (nonatomic) Maze *maze;
@property (nonatomic) NSTimer *ghostTimer;

@end

@implementation GameManager

+(id)sharedManager{
    static GameManager *gameManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gameManager = [[self alloc] init];
    });
    return gameManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mazeTileArray = [NSMutableArray new];
        _maze = [Maze new];
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
    NSFetchRequest *request2 = [Player fetchRequest];
    NSError *error2 = nil;
    NSArray *playerArray = [context executeFetchRequest:request2 error:&error2];
    NSLog(@"%lu", (unsigned long)playerArray.count);
    for (Player *player in playerArray) {
        [context deleteObject:player];
    }
    self.player = [NSEntityDescription insertNewObjectForEntityForName:@"Player" inManagedObjectContext:context];
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

#pragma mark Load Game methods
- (void) loadGame {
    NSManagedObjectContext *context = [self getContext];
    NSError *playerError;
    NSFetchRequest *playerRequest = [Player fetchRequest];
    NSArray *playerResult = [context executeFetchRequest:playerRequest error:&playerError];
    if (playerResult.count < 1) {
        return;
    }
    self.player = playerResult[0];
    NSFetchRequest *request = [MazeTile fetchRequest];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"xposition" ascending:YES];
    [request setSortDescriptors:@[sort]];
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"error: %@", error.localizedDescription);
        abort();
    }
    NSArray *sectionArray = @[ [NSMutableArray new],
                               [NSMutableArray new],
                               [NSMutableArray new],
                               [NSMutableArray new],
                               [NSMutableArray new],
                               [NSMutableArray new],
                               [NSMutableArray new],
                               [NSMutableArray new],
                               [NSMutableArray new],
                               [NSMutableArray new]];
    for (MazeTile *tile in results) {
        if (tile.yPosition) {
            [sectionArray[tile.yPosition] addObject:tile];
        }
    }
    self.maze = [Maze new];
    [self.maze selectThemeWithID:self.player.themeID];
    [self.maze selectMazeWithID:self.player.mazeID];
}


#pragma mark Maze Making Methods
- (void) generateMaze {
    self.mazeSectionArray = [self.maze makeMazeWith:self.mazeTileArray];
}

#pragma mark Game Control Methods
- (void) startGame {
    self.player.currentX = self.maze.startX;
    self.player.currentY = self.maze.startY;
    self.ghostTimer = [NSTimer new];
    self.player.ghostX = self.player.currentX;
    self.player.ghostY = self.player.currentY;
    self.ghostTimer = [NSTimer scheduledTimerWithTimeInterval:20.0
                                     target:self
                                   selector:@selector(startGhost)
                                   userInfo:nil
                                    repeats:NO];
}

- (void) startGhost {
    self.ghostTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(moveGhost)
                                   userInfo:nil
                                    repeats:YES];
}

- (void) moveGhost {
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
    if (self.player.currentX == self.player.ghostX && self.player.currentY == self.player.ghostY) {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        NSNotification *notification = [NSNotification notificationWithName:@"playerLoses" object:self];
        [notificationCenter postNotification:notification];
        [self endGame];
        return;
    }
        NSLog(@"\nGhost X: %hd\n Ghost Y: %hd", self.player.ghostX, self.player.ghostY);
}

- (BOOL) movePlayerOnX: (NSInteger) amount {
    if (self.player.currentX + amount >= 0 && self.player.currentX + amount <= 9) {
        NSArray *section = self.mazeSectionArray[self.player.currentY];
        MazeTile *newTile = section[self.player.currentX+amount];
        if (newTile.valid) {
            self.player.currentX += amount;
            [self checkWin];
            return YES;
        }
        NSLog(@"Lava!");
        return NO;
    }
    NSLog(@"Out of bounds!");
    return NO;
}

- (BOOL) movePlayerOnY: (NSInteger) amount {
    if (self.player.currentY + amount >= 0 && self.player.currentY + amount <= 9) {
        NSArray *section = self.mazeSectionArray[self.player.currentY+amount];
        MazeTile *newTile = section[self.player.currentX];
        if (newTile.valid) {
            self.player.currentY += amount;
            [self checkWin];
            return YES;
        }
        NSLog(@"Lava!");
        return NO;
    }
    NSLog(@"Out of bounds!");
    return NO;
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
    tile.valid = YES;
    [self.mazeTileArray addObject:tile];
}

- (NSArray *) getArray {
    return self.mazeSectionArray;
}

-(NSDictionary <NSNumber *, NSArray<NSNumber*>*>*)getDictionary{
    return [self.maze getDictionary];
}

- (MazeTile *) getMazeTileAtIndexPath: (NSIndexPath*) indexPath {
    NSInteger sectionIndex = self.player.currentY + indexPath.section -1;
    long rowIndex = self.player.currentX + indexPath.row - 1;
    if (sectionIndex >= 0 && sectionIndex <= 9 && rowIndex >= 0 && rowIndex <= 9) {
        MazeTile *tile = self.mazeSectionArray[sectionIndex][rowIndex];
        if (tile.valid == YES) {
            return tile;
        }
    }
    return nil;
}

- (void) checkWin {
    if (self.player.currentX == self.maze.endX && self.player.currentY == self.maze.endY) {
        NSNotification *notification = [NSNotification notificationWithName:@"playerWins" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [self endGame];
    }
}

- (void) endGame {
    [self.ghostTimer invalidate];
    self.ghostTimer = nil;
}

- (NSData *)getOutOfBoundsImage {
    return self.maze.outOfBoundsImage;
}

- (NSData *) getGameOverImage {
    return self.maze.gameOverImage;
}


@end
