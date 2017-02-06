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
@property (weak, nonatomic) IBOutlet UITableView *themeTableView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property NSArray *themes;
@property NSString *selectedTheme;
@property UIView *backgroundView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [GameManager sharedManager];
    self.themes = @[@"Cats",@"Donald_Trump",@"Indoor",@"Outdoor"];
    self.themeTableView.scrollEnabled = NO;
    self.startButton.hidden = NO;
    self.startButton.userInteractionEnabled = YES;
}
- (IBAction)startButton:(id)sender {
    NSString *tags = self.tagTextField.text;
    if (self.selectedTheme)
        tags = [NSString stringWithFormat:@"%@&sort=interestingness_asc",self.selectedTheme];
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
            [self.manager saveContext];
            [self performSegueWithIdentifier:@"MazeViewController" sender:self];
        }];
    }];
    [dataTask resume];
    self.startButton.hidden = YES;
    self.startButton.userInteractionEnabled = NO;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(advanceProgressBar) userInfo:nil repeats:NO];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThemeCell" forIndexPath:indexPath];
    cell.textLabel.text = self.themes[indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.backgroundView = [[UIView alloc] initWithFrame:cell.frame];
    self.backgroundView.backgroundColor = [UIColor greenColor];
    cell.selectedBackgroundView = self.backgroundView;
    self.selectedTheme = self.themes[indexPath.row];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedTheme = nil;
    self.backgroundView = nil;
}

- (void) advanceProgressBar {
    self.progressBar.progress += 0.2 * (1-self.progressBar.progress);
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(advanceProgressBar) userInfo:nil repeats:NO];
}

@end
