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
#import <AVFoundation/AVFoundation.h>
#import "ScoreKeeper+CoreDataClass.h"

@interface GameManager ()

@property (nonatomic) NSMutableArray<MazeTile*>* mazeTileArray;
@property (nonatomic) NSArray <NSArray <MazeTile*>*> *mazeSectionArray;
@property (nonatomic) NSTimer *ghostTimer;
@property (nonatomic) NSTimer *playerTimer;
@property (nonatomic) NSArray *sounds;
@property (nonatomic) AVAudioPlayer *audioPlayer;
@property (nonatomic) AVAudioPlayer *invalidPlayer;
@property (nonatomic) AVAudioPlayer *ghostPlayer;
@property (nonatomic) AVAudioPlayer *ghostMovePlayer;
@property (nonatomic) AVAudioPlayer *ghostClosePlayer;
@property (nonatomic) NSInteger ghostSpeed;
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

-(void) clearData {
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
- (BOOL) checkLoad {
    NSManagedObjectContext *context = [self getContext];
    NSError *playerError;
    NSFetchRequest *playerRequest = [Player fetchRequest];
    NSArray <Player*> *playerResult = [context executeFetchRequest:playerRequest error:&playerError];
    if (playerResult.count < 1) {
        return NO;
    }
    if (playerResult[0].time == 0) {
        return NO;
    }
    self.player = playerResult[0];
    return YES;
}

- (void) loadGame {
    [self togglePracticeMode];
    self.playerImage = self.player.image;
    self.maze = [Maze new];
    [self.maze selectThemeWithID:self.player.themeID];
    [self.maze selectMazeWithID:self.player.mazeID];
    NSFetchRequest *request = [MazeTile fetchRequest];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"xPosition" ascending:YES];
    [request setSortDescriptors:@[sort]];
    NSError *error = nil;
    NSArray *results = [[self getContext] executeFetchRequest:request error:&error];
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
        if (tile.yPosition < 10) {
            [sectionArray[tile.yPosition] addObject:tile];
        }
    }
    self.mazeSectionArray = sectionArray;
    if (self.player.ghostX == 100) {
        self.player.ghostX = self.maze.startX;
        self.player.ghostY = self.maze.startY;
    }
    self.playerTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                        target:self
                                                      selector:@selector(incrementPlayerTime)
                                                      userInfo:nil
                                                       repeats:YES];
    
    self.ghostTimer = [NSTimer scheduledTimerWithTimeInterval:self.ghostSpeed
                                                       target:self
                                                     selector:@selector(moveGhost)
                                                     userInfo:nil
                                                      repeats:YES];
    self.sounds = self.maze.sounds;
    [self setupSounds];
    NSNotification *notification = [NSNotification notificationWithName:@"playerTimeIncrement" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma mark Maze Making Methods
- (void) generateMaze {
    self.maze = [Maze new];
    self.mazeSectionArray = [self.maze makeMazeWith:self.mazeTileArray];
}

- (void) createPlayer {
    NSManagedObjectContext *context = [self getContext];
    UIImage *image = [self getPlayerImage];
    NSData *data = UIImagePNGRepresentation(image);
    self.player = [[Player alloc] initWithContext:context];
    self.player.image = data;
    self.player.name = self.playerName;
}

- (UIImage *) getPlayerImage {
    if (self.playerImage) {
        UIImage *image = [UIImage imageWithData:self.playerImage];
        return image;
    }
    return [UIImage imageNamed:@"Player"];
}

#pragma mark Game Control Methods
- (void) startGame {
    [self resetPlayer];
    self.sounds = self.maze.sounds;
    [self setupSounds];
    self.playerTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                        target:self
                                                      selector:@selector(incrementPlayerTime)
                                                      userInfo:nil
                                                       repeats:YES];
    
    self.ghostTimer = [NSTimer scheduledTimerWithTimeInterval:60.0
                                                       target:self
                                                     selector:@selector(startGhost)
                                                     userInfo:nil
                                                      repeats:NO];
}

- (void) startGhost {
    self.player.ghostX = self.maze.startX;
    self.player.ghostY = self.maze.startY;
    self.ghostTimer = [NSTimer scheduledTimerWithTimeInterval:self.ghostSpeed
                                                       target:self
                                                     selector:@selector(moveGhost)
                                                     userInfo:nil
                                                      repeats:YES];
    
    [self.ghostPlayer play];
    
}

- (void) resetPlayer {
    self.player.currentX = self.maze.startX;
    self.player.currentY = self.maze.startY;
    self.player.ghostX = 100;
    self.player.ghostY = 100;
    self.player.moveCount = 0;
    self.player.gameWon = NO;
    self.player.time = 0;
    [self saveContext];
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
    if ([self checkLoss]) {
        return;
    }
    [self saveContext];
    if ([self checkGhost]) {
        NSNotification *notification = [NSNotification notificationWithName:@"ghostClose" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [self.ghostClosePlayer play];
        NSLog(@"HE'S COMING");
    }
    [self.ghostMovePlayer play];
    NSLog(@"\nGhost X: %hd\n Ghost Y: %hd", self.player.ghostX, self.player.ghostY);
}

- (BOOL) movePlayerOnX: (NSInteger) amount {
    NSDataAsset *sound = [[NSDataAsset alloc] initWithName:self.sounds.firstObject];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:sound.data error:&error];
    if (self.player.currentX + amount >= 0 && self.player.currentX + amount <= 9) {
        NSArray *section = self.mazeSectionArray[self.player.currentY];
        MazeTile *newTile = section[self.player.currentX+amount];
        if (newTile.valid) {
            self.player.currentX += amount;
            if ([self checkLoss]) {
                return YES;
            }
            if ([self checkWin]) {
                return YES;
            }
            if ([self checkGhost]) {
                NSLog(@"He's close shhhhhh");
            }
            return YES;
        }
        [self.invalidPlayer play];
        NSLog(@"Lava!");
        return NO;
    }
    [self.audioPlayer play];
    NSLog(@"Out of bounds!");
    return NO;
}

- (BOOL) movePlayerOnY: (NSInteger) amount {
    if (self.player.currentY + amount >= 0 && self.player.currentY + amount <= 9) {
        NSArray *section = self.mazeSectionArray[self.player.currentY+amount];
        MazeTile *newTile = section[self.player.currentX];
        if (newTile.valid) {
            self.player.currentY += amount;
            if ([self checkLoss]) {
                return YES;
            }
            if ([self checkWin]) {
                return YES;
            }
            if ([self checkGhost]) {
                [self.ghostMovePlayer pause];
                [self.ghostClosePlayer play];
                NSLog(@"He's close shhhhhh");
            }
            return YES;
        }
        
        NSLog(@"Lava!");
        return NO;
    }
    [self.audioPlayer play];
    NSLog(@"Out of bounds!");
    return NO;
}

- (BOOL) checkGhost {
    int XDif = self.player.currentX - self.player.ghostX;
    int YDif = self.player.currentY - self.player.ghostY;
    if (XDif <= 1 && XDif >= -1 && YDif <= 1 && YDif >= -1) {
        return YES;
    }
    return NO;
}

#pragma mark Helper Methods

- (NSURL*) generateURL: (NSString*) tagEntry {
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=4ecacf0cd6441400e02e57ec12f0bb68&has_geo&tags="];
    if ([self togglePracticeMode]) {
        urlString = [[NSMutableString alloc] initWithString:@"https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&per_page=200&format=json&nojsoncallback=1&api_key=4ecacf0cd6441400e02e57ec12f0bb68&has_geo&tags="];
    }
    NSString *tagWithoutWhiteSpace = [tagEntry stringByReplacingOccurrencesOfString:@" " withString:@""];
    [urlString appendString:tagWithoutWhiteSpace];
    return [NSURL URLWithString:urlString];
}

- (void) createMazeTileWithDictionary: (NSDictionary*)photo {
    if (!self.mazeTileArray) {
        self.mazeTileArray = [NSMutableArray new];
    }
    NSManagedObjectContext *context = [self getContext];
    MazeTile *tile = [[MazeTile alloc] initWithContext:context];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", photo[@"farm"], photo[@"server"], photo[@"id"], photo[@"secret"]]];
    if([NSData dataWithContentsOfURL:url])
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

- (BOOL) togglePracticeMode {
    if (self.practiceMode) {
        self.ghostSpeed = 15;
        self.player.practiceMode = YES;
        return YES;
    }
    self.ghostSpeed = 8;
    return NO;
}

- (BOOL) checkWin {
    if (self.player.currentX == self.maze.endX && self.player.currentY == self.maze.endY) {
        self.player.gameWon = YES;
        [self endGame];
        NSNotification *notification = [NSNotification notificationWithName:@"playerWins" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        return YES;
    }
    return NO;
}

- (BOOL) checkLoss {
    if (self.player.currentX == self.player.ghostX && self.player.currentY == self.player.ghostY) {
        self.player.gameWon = NO;
        [self endGame];
        NSNotification *notification = [NSNotification notificationWithName:@"playerLoses" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        return YES;
    }
    return NO;
}

- (void) endGame {
    [self.playerTimer invalidate];
    self.playerTimer = nil;
    [self.ghostTimer invalidate];
    self.ghostTimer = nil;
    [self calculateScore];
}

- (void) calculateScore {
    NSManagedObjectContext *context = [self getContext];
    NSInteger playerScore = 20* self.maze.minMoves / (self.player.moveCount+1) + self.player.time*20;
    if (!self.practiceMode) {
        ScoreKeeper *score = [[ScoreKeeper alloc] initWithContext:context];
        score.playerName = self.player.name;
        score.playerImage = self.player.image;
        if (self.player.gameWon) {
            playerScore *= 3;
            score.playerWon = self.player.gameWon;
        }
        self.playerScore = playerScore;
        score.score = playerScore;
        score.moves = self.player.moveCount;
        score.map = self.player.mazeID;
        score.playerTime = self.player.time;
        [self saveContext];
    }
}

- (NSData *)getOutOfBoundsImage {
    return self.maze.outOfBoundsImage;
}

- (NSData *) getGameOverImage {
    return self.maze.gameOverImage;
}

- (void) incrementPlayerTime {
    self.player.time += 1;
    NSNotification *notification = [NSNotification notificationWithName:@"playerTimeIncrement" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma mark - Setup sounds
-(void)setupSounds{
    NSError *error;
    NSDataAsset *outOfBounds = [[NSDataAsset alloc] initWithName:self.sounds[0]];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:outOfBounds.data error:&error];
    NSDataAsset *invalid = [[NSDataAsset alloc] initWithName:self.sounds[1]];
    self.invalidPlayer = [[AVAudioPlayer alloc] initWithData:invalid.data error:&error];
    NSDataAsset *sound = [[NSDataAsset alloc] initWithName:self.sounds[2]];
    self.ghostPlayer = [[AVAudioPlayer alloc] initWithData:sound.data error:&error];
    NSDataAsset *moveSound = [[NSDataAsset alloc] initWithName:self.sounds[3]];
    self.ghostMovePlayer = [[AVAudioPlayer alloc] initWithData:moveSound.data error:&error];
    NSDataAsset *closeSound = [[NSDataAsset alloc] initWithName:self.sounds[4]];
    self.ghostClosePlayer = [[AVAudioPlayer alloc] initWithData:closeSound.data error:&error];
    
}

@end
