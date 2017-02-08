//
//  ScoreKeeper+CoreDataProperties.m
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-08.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "ScoreKeeper+CoreDataProperties.h"

@implementation ScoreKeeper (CoreDataProperties)

+ (NSFetchRequest<ScoreKeeper *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ScoreKeeper"];
}

@dynamic map;
@dynamic moves;
@dynamic playerImage;
@dynamic playerName;
@dynamic score;
@dynamic playerWon;
@dynamic playerTime;

@end
