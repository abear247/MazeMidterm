//
//  Player+CoreDataProperties.m
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-07.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Player+CoreDataProperties.h"

@implementation Player (CoreDataProperties)

+ (NSFetchRequest<Player *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Player"];
}

@dynamic currentX;
@dynamic currentY;
@dynamic ghostX;
@dynamic ghostY;
@dynamic mazeID;
@dynamic moveCount;
@dynamic themeID;
@dynamic playerImage;

@end
