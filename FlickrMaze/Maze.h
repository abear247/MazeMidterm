//
//  MazeManager.h
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-03.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MazeTile+CoreDataClass.h"

@interface Maze : NSObject

@property NSArray *invalidSquares;
- (NSArray *) makeMazeWith: (NSArray <MazeTile*> *)mazeTileArray;
- (NSDictionary <NSNumber *, NSArray<NSNumber*>*>*)getDictionary;
@end
