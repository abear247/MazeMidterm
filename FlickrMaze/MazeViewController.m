//
//  MazeViewController.m
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-03.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import "MazeViewController.h"
#import "GameManager.h"
#import "MazeCell.h"
#import "MazeTile+CoreDataClass.h"
#import "MazeFlowLayout.h"

@interface MazeViewController ()

@property UICollectionView *collectionView;

@end

@implementation MazeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.manager generateMaze];
    self.collectionView.collectionViewLayout = [MazeFlowLayout new];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.manager getArray].count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray <NSArray*>*array = [self.manager getArray];
    return array[section].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MazeCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"MazeCell" forIndexPath:indexPath];
    NSArray *array = [self.manager getArray];
    NSArray *tileArray = array[indexPath.section];
    MazeTile *tile = tileArray[indexPath.row];
    NSData *data = tile.image;
    if (tile.valid){
        cell.mazeCellImageView.image = [UIImage imageWithData:data];
    }
    return cell;
}

@end
