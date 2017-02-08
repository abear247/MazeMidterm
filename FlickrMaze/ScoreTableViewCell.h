//
//  ScoreTableViewCell.h
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-08.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreTableViewCell : UITableViewCell

@property UIImageView *playerImageView;
@property UILabel *playerNameLabel;
@property UILabel *scoreLabel;
@property UILabel *playerTimeLabel;
@property UILabel *playerMovesLabel;
@property UILabel *playerWonLabel;

@end
