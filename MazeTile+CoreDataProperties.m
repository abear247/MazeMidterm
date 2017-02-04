//
//  MazeTile+CoreDataProperties.m
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-03.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "MazeTile+CoreDataProperties.h"

@implementation MazeTile (CoreDataProperties)

+ (NSFetchRequest<MazeTile *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MazeTile"];
}

@dynamic image;
@dynamic title;
@dynamic valid;
@dynamic highlighted;

@end
