//
//  ScoreTableViewCell.h
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-08.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *playerImageView;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerMovesLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerWonLabel;
@end
