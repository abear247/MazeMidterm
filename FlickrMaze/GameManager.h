//
//  GameManager.h
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-03.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class MazeTile;

@interface GameManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;
- (NSURL*) generateURL: (NSString*) tagEntry;
- (NSManagedObjectContext *) getContext;
- (void) createMazeTileWithDictionary: (NSDictionary*)photo;
- (NSArray *) getArray;
- (void) generateMaze;

@end
