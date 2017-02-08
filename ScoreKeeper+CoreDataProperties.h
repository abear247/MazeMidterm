//
//  ScoreKeeper+CoreDataProperties.h
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-08.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "ScoreKeeper+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ScoreKeeper (CoreDataProperties)

+ (NSFetchRequest<ScoreKeeper *> *)fetchRequest;

@property (nonatomic) int16_t map;
@property (nonatomic) int16_t moves;
@property (nullable, nonatomic, retain) NSData *playerImage;
@property (nullable, nonatomic, copy) NSString *playerName;
@property (nonatomic) int16_t score;
@property (nonatomic) BOOL playerWon;
@property (nonatomic) int16_t playerTime;

@end

NS_ASSUME_NONNULL_END
