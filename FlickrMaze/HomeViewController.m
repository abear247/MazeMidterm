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
@property (weak, nonatomic) IBOutlet UIPickerView *themePicker;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (nonatomic) NSTimer *progressTimer;
@property NSArray *themes;
@property NSString *selectedTheme;
@property UIView *backgroundView;
@property AVAudioPlayer *audioPlayer;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [GameManager sharedManager];
    self.themes = @[@"Default",@"Cats",@"Jaws",@"Donald_Trump"];
    self.themePicker.delegate = self;
    self.themePicker.dataSource = self;
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
    self.loadingImageView.hidden = NO;
    if(!self.selectedTheme)
        self.loadingImageView.image = [UIImage imageNamed:@"Default"];
    else
        self.loadingImageView.image = [UIImage imageNamed:self.selectedTheme];
    [UIImageView animateWithDuration:10.0 animations:^(void) {
        self.loadingImageView.alpha = 0;
        self.loadingImageView.alpha = 1;
    }];
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(advanceProgressBar) userInfo:nil repeats:YES];
    NSDataAsset *sound = [[NSDataAsset alloc] initWithName:[NSString stringWithFormat:@"%@_sound",self.selectedTheme]];
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

- (IBAction)pickCharacterFromImages:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePicker animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    NSData *data = UIImagePNGRepresentation(image);
    self.manager.playerImage = data;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
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

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    UILabel* tView = (UILabel*)view;
//    if (!tView)
//    {
//        tView = [[UILabel alloc] init];
//        [tView setFont:[UIFont fontWithName:@"Helvetica" size:14]];
//        tView.numberOfLines=3;
//    }
//    // Fill the label text here
//    tView.textColor = [UIColor whiteColor];
//    tView.shadowColor = [UIColor blackColor];
//    tView.shadowOffset = CGSizeMake(-1, -1);
//    return tView;
//}

@end
