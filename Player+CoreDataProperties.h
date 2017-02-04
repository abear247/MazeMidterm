//
//  Player+CoreDataProperties.h
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-03.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Player+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Player (CoreDataProperties)

+ (NSFetchRequest<Player *> *)fetchRequest;

@property (nonatomic) int16_t currentX;
@property (nonatomic) int16_t currentY;
@property (nonatomic) int16_t previousX;
@property (nonatomic) int16_t previousY;

@end

NS_ASSUME_NONNULL_END
