//
//  MazeTile+CoreDataProperties.h
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-04.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "MazeTile+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MazeTile (CoreDataProperties)

+ (NSFetchRequest<MazeTile *> *)fetchRequest;

@property (nonatomic) BOOL highlighted;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, copy) NSString *title;
@property (nonatomic) BOOL valid;
@property (nonatomic) int16_t xPosition;
@property (nonatomic) int16_t yPosition;

@end

NS_ASSUME_NONNULL_END
