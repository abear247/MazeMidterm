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
}

-(void)viewDidAppear:(BOOL)animated{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.mazeCollectionView.collectionViewLayout;
    CGFloat width = self.mazeCollectionView.frame.size.width/3;
    CGSize size = CGSizeMake(width, width);
    layout.itemSize = size;
    [self.manager startGame];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sectionCount;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.rowCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MazeCell *cell = (MazeCell *)[self.mazeCollectionView dequeueReusableCellWithReuseIdentifier:@"MazeCell" forIndexPath:indexPath];
    NSArray *array = [self.manager getArray];
    NSInteger section = self.manager.player.currentY + indexPath.section - 1;
    NSInteger row = self.manager.player.currentX +indexPath.row -1;
    if (section < 0 || row < 0 || section > 9 || row > 9) {
        cell.mazeCellImageView.image = [UIImage imageNamed:@"Lava"];
        return cell;
    }
    NSArray *tileArray = array[section];
    MazeTile *tile = tileArray[row];
    NSData *data = tile.image;
    
    if (tile.valid){
        cell.mazeCellImageView.image = [UIImage imageWithData:data];
    }
    else{
        cell.mazeCellImageView.image = [UIImage imageNamed:@"Lava"];
    }
    return cell;
}

- (IBAction)moveLeft:(UIButton *)sender {
    self.manager.player.currentX -= 1;
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

- (IBAction)moveUp:(UIButton *)sender {
    self.manager.player.currentY -= 1;
    self.sectionCount += 1;
    [self.mazeCollectionView insertSections:[NSIndexSet indexSetWithIndex:0]];
    self.sectionCount -= 1;
    [self.mazeCollectionView deleteSections:[NSIndexSet indexSetWithIndex:3]];
}

- (IBAction)moveRight:(UIButton *)sender {
    self.manager.player.currentX += 1;
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

- (IBAction)moveDown:(UIButton *)sender {
    self.manager.player.currentY += 1;
    self.sectionCount += 1;
    [self.mazeCollectionView insertSections:[NSIndexSet indexSetWithIndex:3]];
    self.sectionCount -= 1;
    [self.mazeCollectionView deleteSections:[NSIndexSet indexSetWithIndex:0]];
}

@end
