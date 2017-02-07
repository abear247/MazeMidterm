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

@interface EndGameViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *winningImage;
@property GameManager *manager;
@property AVAudioPlayer *audioPlayer;
@end

@implementation EndGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // GameManager *manager = [GameManager sharedManager];
    self.view.backgroundColor = [UIColor blackColor];
    if(self.won)
        self.winningImage.image = [UIImage imageNamed:@"Trophy"];
    else{
        GameManager *manager = [GameManager sharedManager];
        NSData *data = [manager getGameOverImage];
        self.winningImage.image = [UIImage imageWithData:data];
        
    }
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
//               [self performSegueWithIdentifier:@"HomeViewController" sender:self];
//               [self.navigationController popViewControllerAnimated:YES];
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"HomeViewController"]){
        
    }
}


@end
