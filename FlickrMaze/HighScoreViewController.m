//
//  HighScoreViewController.m
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-07.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import "HighScoreViewController.h"
#import "GameManager.h"
#import "ScoreKeeper+CoreDataClass.h"

@interface HighScoreViewController ()

@property UITableView *highScoreTableView;
@property NSInteger mapIndex;
@property GameManager *manager;
@property NSArray <ScoreKeeper*> *activeArray;
@property UISegmentedControl *mapSelect;
@property NSArray <NSMutableArray*>*mapScores;
@end

@implementation HighScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [GameManager sharedManager];
    self.mapScores = @[ [NSMutableArray new],
                        [NSMutableArray new],
                        [NSMutableArray new],
                        [NSMutableArray new],
                        [NSMutableArray new],
                        [NSMutableArray new]
                        ];
    self.mapIndex = 1;
    NSManagedObjectContext *context = [self.manager getContext];
    NSFetchRequest *request = [ScoreKeeper fetchRequest];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO];
    [request setSortDescriptors:@[sort]];
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    for (ScoreKeeper *score in results) {
        [self.mapScores[score.map] addObject:score];
    }
    self.activeArray = self.mapScores[1];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.activeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.highScoreTableView dequeueReusableCellWithIdentifier:@"cell"];
    ScoreKeeper *score = self.activeArray[indexPath.row];
    cell.textLabel.text = @(score.score).stringValue;
    cell.textLabel.text = score.playerName;
    cell.imageView.image = [UIImage imageWithData:score.playerImage];
    return cell;
}

- (void) mapselectValueChange{
    self.activeArray = self.mapScores[self.mapSelect.tag];
    self.mapIndex = self.mapSelect.tag;
    self.title = [NSString stringWithFormat:@"Map:%ld", (long)self.mapSelect.tag];
    [self.highScoreTableView reloadData];
}

/*  MapViewController
    if (self.manager.player.ghostX == indexPath.row && self.manager.player.ghostY == indexPath.section) {
            cell.mapImage.image = [UIImage imageNamed:@"Ghost"];
        }
*/

 /*EndGameViewController
 - (void) calculateScore {
 NSManagedObjectContext *context = [self.manager getContext];
 ScoreKeeper *score = [[ScoreKeeper alloc] initWithContext:context];
 //score.playerName = self.manager.player.name;
 score.playerImage = self.manager.player.playerImage;
 score.score = 100* map target movecount / self.manager.player.moveCount;
 if (self.won) {
 score.score *= 10;
 }
 score.moves = self.manager.player.moveCount;
 //score.map = mapindex
 //self.manager set player to start of map and reset movecount
 [self.manager saveContext];
 }
 */
@end
