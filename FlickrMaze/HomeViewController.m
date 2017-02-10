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
#import "GameOptionsViewController.h"

@interface HomeViewController ()
@property GameManager *manager;
@property (weak, nonatomic) IBOutlet UIButton *highScoreButton;
@property (strong,nonatomic) AVAudioPlayer *backgroundPlayer;
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
    self.backgroundImage.image = [UIImage imageNamed:@"Default_background"];
    NSDataAsset *sound = [[NSDataAsset alloc] initWithName:@"Home_sound"];
    NSError *error;
    self.backgroundPlayer = [[AVAudioPlayer alloc] initWithData:sound.data error:&error];
    self.backgroundPlayer.numberOfLoops = -1;
    [self.backgroundPlayer play];
    if(self.manager.practiceMode){
        
    }
}

-(void)viewDidAppear:(BOOL)animated {
    self.startButton.userInteractionEnabled = YES;
    self.progressBar.progress = 0.0;
    self.highScoreButton.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.backgroundPlayer stop];
}


- (IBAction)startButton:(id)sender {
    if(!self.manager.tags)
        self.manager.tags = @"";
    NSString *tags = self.manager.tags;
    self.highScoreButton.hidden = YES;
    if (self.manager.gameTheme)
    {
        tags = [NSString stringWithFormat:@"%@&sort=interestingness_asc",
                self.manager.gameTheme];
    }
    else {
        self.manager.gameTheme = @"Default";
    }
    [self.manager clearData];
//    self.manager.player.practiceMode = self.practiceModeSwitch;
    [self.manager createPlayer];
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
    self.startButton.userInteractionEnabled = NO;
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(advanceProgressBar) userInfo:nil repeats:YES];
    NSDataAsset *sound = [[NSDataAsset alloc] initWithName:[NSString stringWithFormat:@"%@_sound",self.manager.gameTheme]];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:sound.data error:&error];
    [self.audioPlayer play];
}

- (IBAction)loadButton:(id)sender {
    if ([self.manager checkLoad]) {
        [self.manager loadGame];
            [self performSegueWithIdentifier:@"MazeViewController" sender:self];
    }
}

- (void) changeBackgroundImage:(UIImage*)image {
    if(image){
         self.backgroundImage.image = image;
    }
   
}

- (void) advanceProgressBar {
    self.progressBar.progress += 0.2 * (1-self.progressBar.progress);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"GameOptionsViewController"]) {
        GameOptionsViewController *govc = segue.destinationViewController;
        govc.delegate = self;
    }
}

@end
