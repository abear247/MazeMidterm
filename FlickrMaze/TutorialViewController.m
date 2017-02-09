//
//  TutorialViewController.m
//  FlickrMaze
//
//  Created by Alex Bearinger on 2017-02-09.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *mapImageArrow;
@property (weak, nonatomic) IBOutlet UIImageView *validImageArrow;
@property (weak, nonatomic) IBOutlet UIImageView *playerImageArrow;
@property (weak, nonatomic) IBOutlet UIImageView *invalidImageArrow;
@property (weak, nonatomic) IBOutlet UIImageView *outOfBoundsImageArrow;
@property (weak, nonatomic) IBOutlet UIImageView *titleTableArrow;
@property (nonatomic) NSArray *arrows;
@property int tapNumber;
@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.arrows = @[self.mapImageArrow,self.validImageArrow,self.playerImageArrow,self.invalidImageArrow,self.outOfBoundsImageArrow,self.titleTableArrow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tapScreen:(id)sender {
    switch (self.tapNumber) {
        case 0:{
            
            break;
        }
        case 1:{
            
            break;
        }
        case 2:{
            
            break;
        }
        case 3:{
            
            break;
        }
        case 4:{
            
            break;
        }
        case 5:{
            
            break;
        }
            
        default:
            break;
    }
    self.tapNumber += 1;
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
