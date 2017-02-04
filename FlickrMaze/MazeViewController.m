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

@property int rowCount;
@property int sectionCount;
@property (weak, nonatomic) IBOutlet UICollectionView *mazeCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *movesLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetMovesLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation MazeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.manager generateMaze];
    self.rowCount = 3;
    self.sectionCount = 3;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.mazeCollectionView.collectionViewLayout;
    CGFloat width = self.mazeCollectionView.frame.size.width/3;
    CGSize size = CGSizeMake(width, width);
    layout.itemSize = size;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.manager getArray].count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray <NSArray*>*array = [self.manager getArray];
    return array[section].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MazeCell *cell = [self.mazeCollectionView dequeueReusableCellWithReuseIdentifier:@"MazeCell" forIndexPath:indexPath];
    NSArray *array = [self.manager getArray];
    NSArray *tileArray = array[indexPath.section];
    MazeTile *tile = tileArray[indexPath.row];
    NSData *data = tile.image;
    if (tile.valid){
        cell.mazeCellImageView.image = [UIImage imageWithData:data];
    }
    return cell;
}

- (void) moveLeft:(UIButton *)sender {
    self.rowCount -= 1;
    [self.mazeCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0],
                                                       [NSIndexPath indexPathForRow:2 inSection:1],
                                                       [NSIndexPath indexPathForRow:2 inSection:2]
                                                       ]];
    self.rowCount += 1;
    [self.mazeCollectionView insertItemsAtIndexPaths:@[
                                                       [NSIndexPath indexPathForRow:0 inSection:0],
                                                       [NSIndexPath indexPathForRow:0 inSection:1],
                                                       [NSIndexPath indexPathForRow:0 inSection:2]                                                       ]];
}

- (void)moveRight:(UIButton *)sender {
    self.rowCount -= 1;
    [self.mazeCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0],
                                                       [NSIndexPath indexPathForRow:0 inSection:1],
                                                       [NSIndexPath indexPathForRow:0 inSection:2]
                                                       ]];
    self.rowCount += 1;
    [self.mazeCollectionView insertItemsAtIndexPaths:@[
                                                       [NSIndexPath indexPathForRow:2 inSection:0],
                                                       [NSIndexPath indexPathForRow:2 inSection:1],
                                                       [NSIndexPath indexPathForRow:2 inSection:2]                                                       ]];
}
- (void)moveUp:(UIButton *)sender {
    self.sectionCount += 1;
    [self.mazeCollectionView insertSections:[NSIndexSet indexSetWithIndex:0]];
    self.sectionCount -= 1;
    [self.mazeCollectionView deleteSections:[NSIndexSet indexSetWithIndex:3]];
}

- (void)moveDown:(UIButton *)sender {
    self.sectionCount += 1;
    [self.mazeCollectionView insertSections:[NSIndexSet indexSetWithIndex:3]];
    self.sectionCount -= 1;
    [self.mazeCollectionView deleteSections:[NSIndexSet indexSetWithIndex:0]];
}

@end
