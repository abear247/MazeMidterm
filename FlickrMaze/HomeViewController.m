//
//  HomeViewController.m
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-03.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import "HomeViewController.h"
#import "GameManager.h"
#import "MazeTile+CoreDataClass.h"
#import "MazeViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface HomeViewController ()
@property GameManager *manager;
@property (weak, nonatomic) IBOutlet UIImageView *loadingImageView;
@property (weak, nonatomic) IBOutlet UITextField *tagTextField;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (nonatomic) NSTimer *progressTimer;
@property NSArray *themes;
@property UIView *backgroundView;
@property AVAudioPlayer *audioPlayer;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [GameManager sharedManager];
    self.backgroundImage.image = [UIImage imageNamed:@"Maze"];
}

-(void)viewDidAppear:(BOOL)animated {
    self.startButton.hidden = NO;
    self.startButton.userInteractionEnabled = YES;
    self.progressBar.progress = 0.0;
    self.loadingImageView.hidden = YES;

}

- (IBAction)startButton:(id)sender {
    NSString *tags = self.tagTextField.text;
    if (self.manager.gameTheme)
    {
        tags = [NSString stringWithFormat:@"%@&sort=interestingness_asc",
                self.manager.gameTheme];
    }
    else
        self.manager.gameTheme = @"Default";
    NSURL *url = [self.manager generateURL:tags];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog (@"error:%@", error.localizedDescription);
            return;
        }
        NSError *jsonError = nil;
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            NSLog (@"jsonerror:%@", jsonError.localizedDescription);
            return;
        }
        NSDictionary *photoDictionary = [results objectForKey:@"photos"];
        NSArray *photoArray = [photoDictionary objectForKey:@"photo"];
        for (NSDictionary *photo in photoArray) {
            
            [self.manager createMazeTileWithDictionary: photo];
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
            self.progressBar.progress = 1.0;
            [self.progressTimer invalidate];
            [self.manager saveContext];
            [self.manager generateMaze];
            [self.manager startGame];
            [self performSegueWithIdentifier:@"MazeViewController" sender:self];
        }];
    }];
    [dataTask resume];
    self.startButton.hidden = YES;
    self.startButton.userInteractionEnabled = NO;
    self.loadingImageView.hidden = NO;
    if(!self.manager.gameTheme)
        self.loadingImageView.image = [UIImage imageNamed:@"Default"];
    else
        self.loadingImageView.image = [UIImage imageNamed:self.manager.gameTheme];
    [UIImageView animateWithDuration:10.0 animations:^(void) {
        self.loadingImageView.alpha = 0;
        self.loadingImageView.alpha = 1;
    }];
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(advanceProgressBar) userInfo:nil repeats:YES];
    NSDataAsset *sound = [[NSDataAsset alloc] initWithName:[NSString stringWithFormat:@"%@_sound",self.manager.gameTheme]];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:sound.data error:&error];
    [self.audioPlayer play];
}

- (IBAction)loadButton:(id)sender {
    [self.manager loadGame];
    if (self.manager.player) {
        [self performSegueWithIdentifier:@"MazeViewController" sender:self];
    }
}

- (void) advanceProgressBar {
    self.progressBar.progress += 0.2 * (1-self.progressBar.progress);
}



@end
