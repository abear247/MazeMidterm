//
//  MapViewController.m
//  FlickrMaze
//
//  Created by Alex Bearinger on 2017-02-05.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *mapCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *scrollImageView;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property int currentTime;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentTime = 300;
    self.timerLabel.text = @"3";
}

-(void)countDown:(NSTimer *) aTimer {
    self.currentTime -= 10;
    [self updateTimerLabel:self.currentTime];
    if ([self.timerLabel.text isEqualToString:@"0"]) {
        //do whatever
        [aTimer invalidate];
    }
}

-(void)updateTimerLabel:(int)milliseconds{
    int seconds = milliseconds/100;
    self.timerLabel.text = [NSString stringWithFormat:@"%d:%01d",seconds,milliseconds%1000];
}

- (void)viewDidAppear:(BOOL)animated {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.mapCollectionView.collectionViewLayout;
    CGFloat width = self.mapCollectionView.frame.size.width/10;
    CGSize size = CGSizeMake(width, width);
    layout.itemSize = size;
    [self.mapCollectionView reloadData];
    
    [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
    [self setTimer];
    self.scrollImageView.image = [UIImage imageNamed:@"Scroll"];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 10;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.mapCollectionView dequeueReusableCellWithReuseIdentifier:@"mapCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
    if ([self.invalidSquareDictionary[@(indexPath.section)] containsObject:@(indexPath.row)]) {
        cell.backgroundColor = [UIColor redColor];
    }
    return cell;
}

- (void) setTimer {
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                    repeats:NO
                                      block:^(NSTimer *timer){
                                          [self dismissViewControllerAnimated:YES completion:nil];
                                      }];
}


@end
