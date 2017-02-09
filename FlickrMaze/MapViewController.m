//
//  MapViewController.m
//  FlickrMaze
//
//  Created by Alex Bearinger on 2017-02-05.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import "MapViewController.h"
#import "Maze.h"
#import "Player+CoreDataClass.h"
#import "MapCell.h"
#import "GameManager.h"

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *mapCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *scrollImageView;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissSelf) name:@"gameOver" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mapCollectionView reloadData];
    self.scrollImageView.image = [UIImage imageNamed:@"Scroll"];
}

-(void)viewDidLayoutSubviews{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.mapCollectionView.collectionViewLayout;
    CGFloat width = self.mapCollectionView.frame.size.width/10;
    CGSize size = CGSizeMake(width, width);
    layout.itemSize = size;
}

- (IBAction)return:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 10;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GameManager *manager = [GameManager sharedManager];
    Maze *maze = manager.maze;
    MapCell *cell = (MapCell*)[self.mapCollectionView dequeueReusableCellWithReuseIdentifier:@"mapCell" forIndexPath:indexPath];
    cell.mapImage.image = [UIImage imageWithData:manager.maze.pathImage];
    if ([self.invalidSquareDictionary[@(indexPath.section)] containsObject:@(indexPath.row)]) {
        cell.mapImage.image = [UIImage imageWithData:manager.maze.invalidSquareImage];
    }
    if (manager.player) {
        if (manager.player.currentX == indexPath.row && manager.player.currentY == indexPath.section) {
            cell.mapImage.image = [UIImage imageWithData:manager.player.image];
        }
        if (manager.player.ghostX == indexPath.row && manager.player.ghostY == indexPath.section) {
            cell.mapImage.image = [UIImage imageWithData:manager.maze.ghostImage];
        }
    }
    else {
        if (maze.startX == indexPath.row && maze.startY == indexPath.section) {
            cell.mapImage.image = [UIImage imageNamed:@"Player"];
        }
    }
    if (maze.endX == indexPath.row && maze.endY == indexPath.section) {
        cell.mapImage.image = [UIImage imageNamed:@"Trophy"];
    }
    return cell;
}

- (void) dismissSelf{
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
