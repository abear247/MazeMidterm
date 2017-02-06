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
#import "TitleCell.h"
#import "MapViewController.h"

@interface MazeViewController ()

@property int rowCount;
@property int sectionCount;
@property (weak, nonatomic) IBOutlet UICollectionView *mazeCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *movesLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetMovesLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playerImage;
@property (nonatomic) NSMutableArray *titles;
@property (nonatomic) NSTimer *timer;
@property GameManager *manager;
@property int moves;

@end

@implementation MazeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [GameManager sharedManager];
    [self.manager generateMaze];
    self.rowCount = 3;
    self.sectionCount = 3;
    self.movesLabel.text = @"Moves: ";
    self.targetMovesLabel.text = @"10";
    self.moves = 0;
}

-(void)viewDidAppear:(BOOL)animated{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.mazeCollectionView.collectionViewLayout;
    CGFloat width = self.mazeCollectionView.frame.size.width/3;
    CGSize size = CGSizeMake(width, width);
    layout.itemSize = size;
    [self.manager startGame];
    self.playerImage.image = [UIImage imageNamed:@"Steve"];
    [self.mazeCollectionView addSubview:self.playerImage];
}

#pragma mark Collection View Data Source Methods

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

#pragma Table View Data Source Methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TitleCell *cell = (TitleCell *)[tableView dequeueReusableCellWithIdentifier:@"TitleCell" forIndexPath:indexPath];
    NSArray *array = [self.manager getArray];
    NSArray *tileArray = array[indexPath.section];
    MazeTile *tile = tileArray[self.manager.player.currentX];
    cell.title.text = tile.title;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

#pragma mark Table View Delegate Method

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self movePlayerUp];
    [self.tableView reloadData];
    self.moves++;
    self.movesLabel.text = [NSString stringWithFormat:@"Moves: %d",self.moves];
    
}

#pragma mark Debug Movement Buttons

- (IBAction)moveLeft:(UIButton *)sender {
    if ([self.manager movePlayerOnX: -1]) {
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
}

- (IBAction)moveRight:(UIButton *)sender {
    if ([self.manager movePlayerOnX: 1]) {
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
}

- (IBAction)moveUp:(UIButton *)sender {
    if ([self.manager movePlayerOnY: -1]) {
        self.sectionCount += 1;
        [self.mazeCollectionView insertSections:[NSIndexSet indexSetWithIndex:0]];
        self.sectionCount -= 1;
        [self.mazeCollectionView deleteSections:[NSIndexSet indexSetWithIndex:3]];
    }
}

- (IBAction)moveDown:(UIButton *)sender {
    if ([self.manager movePlayerOnY: 1]) {
        self.sectionCount += 1;
        [self.mazeCollectionView insertSections:[NSIndexSet indexSetWithIndex:3]];
        self.sectionCount -= 1;
        [self.mazeCollectionView deleteSections:[NSIndexSet indexSetWithIndex:0]];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"MapViewController"]){
        MapViewController *mvc = (MapViewController*)[segue destinationViewController];
        mvc.invalidSquareDictionary = [self.manager getDictionary];
    }
}

-(void)movePlayerLeft{
    if ([self.manager movePlayerOnX: -1]) {
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
}

-(void)movePlayerRight{
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

-(void)movePlayerUp{
    self.manager.player.currentY -= 1;
    self.sectionCount += 1;
    [self.mazeCollectionView insertSections:[NSIndexSet indexSetWithIndex:0]];
    self.sectionCount -= 1;
    [self.mazeCollectionView deleteSections:[NSIndexSet indexSetWithIndex:3]];
}

-(void)movePlayerDown{
    self.manager.player.currentY += 1;
    self.sectionCount += 1;
    [self.mazeCollectionView insertSections:[NSIndexSet indexSetWithIndex:3]];
    self.sectionCount -= 1;
    [self.mazeCollectionView deleteSections:[NSIndexSet indexSetWithIndex:0]];
}

//-(NSString *)timeString:(NSTimeInterval*)time{
//    int hours = time / 3600;
//    int minutes = time / 60 % 60;
//    int seconds = time % 60;
//    return [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, seconds];
//}

@end
