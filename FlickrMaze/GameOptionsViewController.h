//
//  GameOptionsViewController.h
//  FlickrMaze
//
//  Created by Alex Bearinger on 2017-02-08.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameOptionsViewControllerDelegate.h"

@interface GameOptionsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property id<GameOptionsViewControllerDelegate> delegate;
@end
