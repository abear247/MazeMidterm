//
//  MazeViewController.h
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-03.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GameManager;

@interface MazeViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property GameManager *manager;

@end
