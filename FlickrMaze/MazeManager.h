//
//  MazeManager.h
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-03.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MazeTile+CoreDataClass.h"

@interface MazeManager : NSObject

- (NSArray *) makeMazeWith: (NSArray <MazeTile*> *)mazeTileArray;

@end
