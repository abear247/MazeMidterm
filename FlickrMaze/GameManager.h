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

@interface GameManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic) Player *player;

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
+(id)sharedManager;
//- (void) endGame;

@end
