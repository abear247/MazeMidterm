//
//  MapViewController.m
//  FlickrMaze
//
//  Created by Alex Bearinger on 2017-02-05.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.mapCollectionView.collectionViewLayout;
    CGFloat width = self.mapCollectionView.frame.size.width/10;
    CGSize size = CGSizeMake(width, width);
    layout.itemSize = size;
    [self.mapCollectionView reloadData];
    [self setTimer];
    
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
    
}

- (void) setTimer {
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                    repeats:NO
                                      block:^(NSTimer *timer){
                                          [self dismissViewControllerAnimated:YES completion:nil];
                                      }];
}


@end
