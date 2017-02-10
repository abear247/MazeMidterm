//
//  EndGameViewController.m
//  FlickrMaze
//
//  Created by Alex Bearinger on 2017-02-05.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import "EndGameViewController.h"
#import "HomeViewController.h"
#import "GameManager.h"
#import <AVFoundation/AVFoundation.h>
#import "ScoreKeeper+CoreDataClass.h"

@interface EndGameViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *winningImage;
@property GameManager *manager;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property AVAudioPlayer *audioPlayer;
@end

@implementation EndGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [GameManager sharedManager];
    self.view.backgroundColor = [UIColor blackColor];
    self.scoreLabel.text = [NSString stringWithFormat:@"Final score: %ld", (long)self.manager.playerScore];
    if(self.manager.player.gameWon){
        NSDataAsset *sound = [[NSDataAsset alloc] initWithName:[NSString stringWithFormat:@"%@_game_over_victory",self.manager.gameTheme]];
        NSError *error;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:sound.data error:&error];
        [self.audioPlayer play];
        self.winningImage.image = [UIImage imageNamed:@"Trophy"];
    }
    else{
        NSDataAsset *sound = [[NSDataAsset alloc] initWithName:[NSString stringWithFormat:@"%@_game_over_defeat",self.manager.gameTheme]];
        NSError *error;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:sound.data error:&error];
        [self.audioPlayer play];
        NSData *data = [self.manager getGameOverImage];
        self.winningImage.image = [UIImage imageWithData:data];
    }
    [self.manager resetPlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseGame:(id)sender {
    UISegmentedControl *control = sender;
    switch (control.selectedSegmentIndex) {
        case 0:{
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        }
        case 1:{
            NSNotification *notification = [NSNotification notificationWithName:@"startGame" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"HomeViewController"]){
        [self.audioPlayer stop];
    }
}


@end
