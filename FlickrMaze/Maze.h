//
//  MazeManager.h
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-03.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MazeTile+CoreDataClass.h"

@interface Maze : NSObject

@property NSData *outOfBoundsImage;
@property NSData *gameOverImage;
@property NSData *pathImage;
@property (nonatomic) NSData *invalidSquareImage;
@property NSInteger startX;
@property NSInteger startY;
@property NSInteger endX;
@property NSInteger endY;
@property NSInteger minMoves;
@property NSArray *sounds;
- (NSArray *) makeMazeWith: (NSArray <MazeTile*> *)mazeTileArray;
- (NSDictionary <NSNumber *, NSArray<NSNumber*>*>*)getDictionary;
- (void) selectMazeWithID:(NSInteger) mazeID;
- (void) selectThemeWithID:(NSInteger) themeID;
- (int) getTheme;
@end
