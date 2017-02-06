//
//  Maze.m
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-03.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import "Maze.h"
#import <UIKit/UIKit.h>

@interface Maze ()
@property NSDictionary <NSNumber *, NSArray<NSNumber*>*>*invalidSquareDictionary;
@end

@implementation Maze

- (NSArray *) makeMazeWith: (NSArray <MazeTile*> *)mazeTileArray {
    self.invalidSquareDictionary = [self createBasicInvalidSquares];
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
            if (section == self.endY && row == self.endX) {
                UIImage *trophy = [UIImage imageNamed:@"Trophy"];
                NSData *data = UIImagePNGRepresentation(trophy);
                tile.image = data;
            }
                [rowArray addObject:tile];
            x+=1;
                
        }
        [columnArray addObject:rowArray];
    }
    return columnArray;
}

- (NSDictionary <NSNumber*,NSArray*>*) createBasicInvalidSquares {
    int selection = arc4random_uniform(2);
    switch (selection) {
        case 0:
        {
            self.startX = 0;
            self.startY = 9;
            self.endX = 9;
            self.endY = 0;
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
            break;
        case 1:
        {
            self.startX = 0;
            self.startY = 9;
            self.endX = 9;
            self.endY = 0;
            return  @{@0: @[@0, @1, @2, @3, @4, @5, @6, @7, @8],
                                @1: @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9],
                                @2: @[@9],
                                @3: @[@1, @2, @3, @5, @6, @7],
                                @4: @[@2, @6],
                                @5: @[@4],
                                @6: @[@3, @4, @5],
                                @8:@[@2, @3, @4, @5, @6],
                                };
        }

        default:
            return nil;
            break;
    }
 }

-(NSDictionary<NSNumber *,NSArray<NSNumber *> *> *)getDictionary{
    return self.invalidSquareDictionary;
}

@end
