//
//  Player+CoreDataProperties.h
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-08.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Player+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Player (CoreDataProperties)

+ (NSFetchRequest<Player *> *)fetchRequest;

@property (nonatomic) int16_t currentX;
@property (nonatomic) int16_t currentY;
@property (nonatomic) int16_t ghostX;
@property (nonatomic) int16_t ghostY;
@property (nonatomic) int16_t mazeID;
@property (nonatomic) int16_t moveCount;
@property (nullable, nonatomic, retain) NSData *image;
@property (nonatomic) int16_t themeID;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int16_t time;
@property (nonatomic) BOOL gameWon;

@end

NS_ASSUME_NONNULL_END
