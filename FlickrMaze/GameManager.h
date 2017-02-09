//
//  GameManager.h
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-03.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Player+CoreDataClass.h"
@class MazeTile;
@class Maze;
@class ScoreKeeper;

@interface GameManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic) Player *player;
@property  (nonatomic, strong) NSString *gameTheme;
@property (nonatomic) Maze *maze;
@property NSData *playerImage;
@property NSInteger playerScore;
@property NSString *tags;
@property NSString *playerName;
@property BOOL practiceMode;

-(void) clearData;
- (void)saveContext;
- (NSURL*) generateURL: (NSString*) tagEntry;
- (NSManagedObjectContext *) getContext;
- (void) createMazeTileWithDictionary: (NSDictionary*)photo;
- (NSArray *) getArray;
- (void) generateMaze;
- (void) startGame;
- (BOOL) movePlayerOnX: (NSInteger) amount;
- (BOOL) movePlayerOnY: (NSInteger) amount;
- (MazeTile *) getMazeTileAtIndexPath: (NSIndexPath*) indexPath;
-(NSDictionary <NSNumber *, NSArray<NSNumber*>*>*)getDictionary;
- (NSData *) getOutOfBoundsImage;
- (NSData *) getGameOverImage;
- (void) loadGame;
+(id)sharedManager;
- (void) resetPlayer;
- (BOOL) checkLoad;
- (void) createPlayer;
- (NSData *) getGhostImage;

@end
