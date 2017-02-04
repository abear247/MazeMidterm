//
//  MazeManager.m
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-03.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import "MazeManager.h"

@interface MazeManager ()
@property NSDictionary <NSNumber *, NSArray<NSNumber*>*>*invalidSquareDictionary;
@end

@implementation MazeManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _invalidSquareDictionary = [self createBasicInvalidSquares];
    }
    return self;
}

- (NSArray *) makeMazeWith: (NSArray <MazeTile*> *)mazeTileArray {
    NSMutableArray *columnArray = [NSMutableArray new];
    int x = 0;
    for (int section = 0; section < 10; section+=1) {
        NSMutableArray *rowArray = [NSMutableArray new];
        for (int row = 0; row <10; row+=1) {
            MazeTile *tile = mazeTileArray[x];
            tile.xPosition = row;
            tile.yPosition = section;
            if ([self.invalidSquareDictionary[@(section)] containsObject:@(row)]) {
                tile.valid = NO;
            }
                [rowArray addObject:tile];
            x+=1;
                
        }
        [columnArray addObject:rowArray];
    }
    return columnArray;
}

- (NSDictionary <NSNumber*,NSArray*>*) createBasicInvalidSquares {
    return @{@0: @[@4, @5, @6, @7, @8],
             @1: @[@1, @2, @6],
             @2: @[@1, @2, @3, @4, @6, @8],
             @3: @[@4, @8],
             @4: @[@0, @2, @4, @6],
             @5: @[@2, @6, @7],
             @6: @[@1, @2, @4, @6, @7, @8],
             @7: @[@1, @4, @8],
             @8: @[@1, @3, @4, @6 ,@8],
             @9: @[@1, @6]
             };
}

@end
