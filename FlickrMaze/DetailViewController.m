//
//  DetailViewController.m
//  FlickrMaze
//
//  Created by Alex Bearinger on 2017-02-06.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *tileImageView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSData *data = self.mazeTile.image;
    self.tileImageView.image = [UIImage imageWithData:data];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissSelf) name:@"gameOver" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismissButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) dismissSelf{
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)tapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
