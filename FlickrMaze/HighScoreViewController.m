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
#import "ScoreTableViewCell.h"
#import "MapViewController.h"
#import "Maze.h"
#import "GameManager.h"

@interface HighScoreViewController ()


@property (weak, nonatomic) IBOutlet UITableView *highScoreTableView;
@property NSInteger mapIndex;
@property GameManager *manager;
@property NSArray <ScoreKeeper*> *activeArray;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapSelect;
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
    ScoreTableViewCell *cell = [self.highScoreTableView dequeueReusableCellWithIdentifier:@"Cell"];
    ScoreKeeper *score = self.activeArray[indexPath.row];
    if(!score.playerName)
        score.playerName = @"A man has no name";
    cell.scoreLabel.text = [NSString stringWithFormat:@"Score: %hd", score.score];
    cell.playerNameLabel.text = [NSString stringWithFormat:@"%@", score.playerName];
    cell.playerImageView.image = [UIImage imageWithData:score.playerImage];
    cell.playerTimeLabel.text = [NSString stringWithFormat:@"Time: %hd", score.playerTime];
    cell.playerMovesLabel.text = [NSString stringWithFormat:@"Moves: %hd", score.moves];
    cell.playerWonLabel.text = @"Loss";
    if (score.playerWon) {
        cell.playerWonLabel.text = @"Win";
    }
    return cell;
}
- (IBAction)returnButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)mapSelectValueChange:(id)sender {
    self.activeArray = self.mapScores[self.mapSelect.selectedSegmentIndex];
    self.mapIndex = self.mapSelect.selectedSegmentIndex;
    self.title = [NSString stringWithFormat:@"Map:%ld", (long)self.mapSelect.tag];
    [self.highScoreTableView reloadData];
}

- (IBAction)resetHighScores:(id)sender {
    NSManagedObjectContext *context = [self.manager getContext];
    NSFetchRequest *request = [ScoreKeeper fetchRequest];
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    for (ScoreKeeper *score in results) {
        [context deleteObject:score];
    }
    [self.manager saveContext];
    self.activeArray = nil;
    self.mapScores = @[ [NSMutableArray new],
                        [NSMutableArray new],
                        [NSMutableArray new],
                        [NSMutableArray new],
                        [NSMutableArray new],
                        [NSMutableArray new]
                        ];
    [self.highScoreTableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"MapViewController"]) {
        MapViewController *mvc = segue.destinationViewController;
        Maze *maze = [Maze new];
        [maze selectMazeWithID:self.mapIndex];
        int theme = [maze getTheme];
        if (self.mapIndex == 0) {
            theme = 0;
        }
        [maze selectThemeWithID:theme];
        GameManager *manager = [GameManager sharedManager];
        manager.maze = maze;
        mvc.invalidSquareDictionary = [maze getDictionary];
    }
}

@end
