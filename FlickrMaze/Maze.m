//
//  Maze.m
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-03.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import "Maze.h"
#import <UIKit/UIKit.h>
#import "GameManager.h"

@interface Maze ()
@property (nonatomic) NSData *invalidSquareImage;
@property (nonatomic) NSDictionary <NSNumber *, NSArray<NSNumber*>*>*invalidSquareDictionary;
@property (nonatomic) GameManager *manager;
@end

@implementation Maze

- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [GameManager sharedManager];
    }
    return self;
}

- (NSArray *) makeMazeWith: (NSArray <MazeTile*> *)mazeTileArray {
    [self createBasicInvalidSquares];
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
                tile.image = self.invalidSquareImage;
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
        [self.manager saveContext];
    }
    return columnArray;
}

- (void) createBasicInvalidSquares {
    NSString *theme = self.manager.gameTheme;
    int selection;
    if ([theme isEqualToString:@"Donald_Trump"]) {
        selection = 0;
    }
    else if ([theme isEqualToString:@"Cats"]) {
        selection = 1;
    }
    else {
        selection = 1;
    }
    int mazeID = 1;//arc4random_uniform(5)+1;
    self.manager.player.mazeID = mazeID;
    self.manager.player.themeID = selection;
    [self selectThemeWithID:selection];
    [self selectMazeWithID:self.manager.player.mazeID];
}

- (void) selectThemeWithID:(NSInteger) themeID {
    switch (themeID) {
        case 0:
        {
            UIImage *goImage = [UIImage imageNamed:@"Trump_game_over"];
            self.gameOverImage = UIImagePNGRepresentation(goImage);
            UIImage *image = [UIImage imageNamed:@"Trump_wall"];
            NSData *data = UIImagePNGRepresentation(image);
            self.outOfBoundsImage = data;
            self.invalidSquareImage = data;
            self.manager.player.mazeID = 0;
            self.sounds =  @[@"Wrong",@"China",@"Suffer",@"Congratulations"];
            return;
        }
        case 1:
        {   UIImage *goImage = [UIImage imageNamed:@"Game_over"];
            self.gameOverImage = UIImagePNGRepresentation(goImage);
            UIImage *image = [UIImage imageNamed:@"Hedge"];
            NSData *data = UIImagePNGRepresentation(image);
            self.outOfBoundsImage = data;
            self.invalidSquareImage = data;
             self.sounds =  @[@"Wrong",@"China",@"Suffer",@"Congratulations"];
            return;
            break;
        }
            
        default:{
            self.sounds =  @[@"Wrong",@"China",@"Suffer",@"Congratulations"];
            return;
            break;
        }
    }
}

- (void) selectMazeWithID:(NSInteger)mazeID {
    switch (mazeID) {
        case 0: {
            self.startX = 0;
            self.startY = 9;
            self.endX = 9;
            self.endY = 0;
            self.invalidSquareDictionary = @{@0: @[@0, @1, @2, @3, @4, @5, @6, @7, @8],
                                             @1: @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9],
                                             @2: @[@9],
                                             @3: @[@1, @2, @3, @5, @6, @7],
                                             @4: @[@2, @6],
                                             @5: @[@4],
                                             @6: @[@3, @4, @5],
                                             @8:@[@2, @3, @4, @5, @6],
                                             };
            break;
        }
        case 1: {
            self.startX = 0;
            self.startY = 9;
            self.endX = 9;
            self.endY = 0;
            self.invalidSquareDictionary = @{@0: @[@4, @5, @6, @7, @8],
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
            break;
        }
        case 2: {
            self.startX = 4;
            self.startY = 9;
            self.endX = 0;
            self.endY = 0;
            self.invalidSquareDictionary = @{//@0: @[],
                                             @1: @[@0, @1, @2, @4, @5, @6, @7, @8],
                                             @2: @[@2, @4, @8],
                                             @3: @[@1, @2, @4, @5, @6, @8],
                                             @4: @[@8],
                                             @5: @[@0, @1, @2, @3, @4, @5, @7, @8],
                                             @6: @[@0, @5],
                                             @7: @[@0, @2, @3, @4, @5, @7, @8],
                                             @8: @[@0, @7],
                                             @9: @[@0, @1, @2, @3, @5, @6, @7, @8, @9]
                                             };
            break;
        }
        case 3: {
            self.startX = 0;
            self.startY = 9;
            self.endX = 9;
            self.endY = 0;
            self.invalidSquareDictionary = @{@0: @[@3, @7],
                                             @1: @[@1, @3, @5, @7, @9],
                                             //@2: @[],
                                             @3: @[@0, @1, @3, @5, @6, @7, @8, @9],
                                             @4: @[@3],
                                             @5: @[@1, @3, @5, @7, @9],
                                             //@6: @[],
                                             @7: @[@0, @1, @3, @4, @5, @7, @9],
                                             @8: @[@7],
                                             @9: @[@1, @2, @3, @4, @5, @6, @7, @8, @9]
                                             };
            break;
        }
        case 4: {
            self.startX = 5;
            self.startY = 8;
            self.endX = 9;
            self.endY = 0;
            self.invalidSquareDictionary = @{@0: @[@3, @4, @5, @6, @7],
                                             @1: @[@1, @3, @9],
                                             @2: @[@1, @3, @6, @8, @9],
                                             @3: @[@1, @3, @4, @6],
                                             @4: @[@6],
                                             @5: @[@1],
                                             @6: @[@1, @2, @3, @4, @5, @6, @7, @9],
                                             @7: @[@3, @7],
                                             //@8: @[],
                                             @9: @[@3, @7]
                                             };
            break;
        }
        case 5: {
            self.startX = 9;
            self.startY = 9;
            self.endX = 4;
            self.endY = 4;
            self.invalidSquareDictionary = @{@0: @[@9],
                                             @1: @[@1, @2, @4, @6, @7, @9],
                                             @2: @[@1, @7, @9],
                                             @3: @[@3, @5, @9],
                                             @4: @[@1 ,@5, @7 ,@9],
                                             @5: @[@3, @4, @5, @7, @9],
                                             @6: @[@1, @9],
                                             @7: @[@1, @2, @4, @5, @7, @9],
                                             // @8: @[],
                                             @9: @[@0, @1, @2 , @3, @4, @5, @6, @7]
                                             };
            
            break;
        }
        default: {
            self.startX = 0;
            self.startY = 9;
            self.endX = 9;
            self.endY = 0;
            self.invalidSquareDictionary = @{@0: @[@4, @5, @6, @7, @8],
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
            break;
        }
    }
}

-(NSDictionary<NSNumber *,NSArray<NSNumber *> *> *)getDictionary{
    return self.invalidSquareDictionary;
}

-(void)makeSoundDictionary:(NSArray*)themeSounds{
    NSMutableDictionary *dictonary = [NSMutableDictionary new];
    for(NSString *soundName in themeSounds){
        NSDataAsset *sound = [[NSDataAsset alloc] initWithName:soundName];
        [dictonary setObject:sound forKey:soundName];
    }
    self.sounds =  [dictonary copy];
}

@end
