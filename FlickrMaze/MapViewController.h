//
//  MapViewController.h
//  FlickrMaze
//
//  Created by Alex Bearinger on 2017-02-05.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property NSDictionary *invalidSquareDictionary;
@property NSInteger currentX;
@property NSInteger currentY;
@property NSInteger endX;
@property NSInteger endY;
@end
