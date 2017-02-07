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

@interface HomeViewController ()
@property GameManager *manager;
@property (weak, nonatomic) IBOutlet UITextField *tagTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *themePicker;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (nonatomic) NSTimer *progressTimer;
@property NSArray *themes;
@property NSString *selectedTheme;
@property UIView *backgroundView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [GameManager sharedManager];
    self.themes = @[@"Cats",@"Donald_Trump",@"Indoor",@"Outdoor"];
    self.themePicker.delegate = self;
    self.themePicker.dataSource = self;
}

-(void)viewDidAppear:(BOOL)animated {
    self.startButton.hidden = NO;
    self.startButton.userInteractionEnabled = YES;
    self.progressBar.progress = 0.0;
    
}

- (IBAction)startButton:(id)sender {
    NSString *tags = self.tagTextField.text;
    if (self.selectedTheme)
    {
        tags = [NSString stringWithFormat:@"%@&sort=interestingness_asc",
                self.selectedTheme];
        self.manager.gameTheme = self.selectedTheme;
    }
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
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(advanceProgressBar) userInfo:nil repeats:YES];
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


#pragma mark Picker methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return  1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.themes.count;
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.themes[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectedTheme = self.themes[row];
}

@end
