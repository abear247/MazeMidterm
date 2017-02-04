//
//  MazeManager.m
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-03.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import "MazeManager.h"

@implementation MazeManager

- (NSArray *) makeMazeWith: (NSArray <MazeTile*> *)mazeTileArray {
    NSMutableArray *columnArray = [NSMutableArray new];
    int x = 0;
    for (int i = 0; i < 10; i+=1) {
        NSMutableArray *rowArray = [NSMutableArray new];
        for (int j = 0; j <10; j+=1) {
            [rowArray addObject:mazeTileArray[x]];
            x+=1;
        }
        [columnArray addObject:rowArray];
    }
    return columnArray;
}

@end
