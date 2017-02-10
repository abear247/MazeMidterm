//
//  TutorialViewController.m
//  FlickrMaze
//
//  Created by Alex Bearinger on 2017-02-09.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurWithVibrancyView;
@property (weak, nonatomic) IBOutlet UILabel *gameExplanationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mapImageArrow;
@property (weak, nonatomic) IBOutlet UILabel *mapLabel;
@property (weak, nonatomic) IBOutlet UIImageView *validImageArrow;
@property (weak, nonatomic) IBOutlet UILabel *validLabel;
@property (weak, nonatomic) IBOutlet UIImageView *validTableArrow;
@property (weak, nonatomic) IBOutlet UILabel *validTableLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playerImageArrow;
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *invalidImageArrow;
@property (weak, nonatomic) IBOutlet UIImageView *invalidTableArrow;
@property (weak, nonatomic) IBOutlet UILabel *invalidTableLabel;
@property (weak, nonatomic) IBOutlet UIImageView *outOfBoundsImageArrow;
@property (weak, nonatomic) IBOutlet UIImageView *outOfBoundsTableArrow;
@property (weak, nonatomic) IBOutlet UILabel *outOfBoundsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleTableArrow;
@property (nonatomic) NSArray <UIImageView*> *arrows;
@property (nonatomic) NSArray <UILabel*> *labels;
@property int tapNumber;
@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tapNumber = 0;
    self.gameExplanationLabel.hidden = NO;
    self.blurView.hidden = NO;
    self.arrows = @[self.mapImageArrow,self.validImageArrow,self.validTableArrow,self.playerImageArrow,self.invalidImageArrow,self.invalidTableArrow,self.outOfBoundsImageArrow,self.outOfBoundsTableArrow,self.titleTableArrow];
    self.labels = @[self.mapLabel,self.validLabel,self.validTableLabel,self.playerLabel,self.invalidTableLabel,self.outOfBoundsLabel];
    for(UIImageView *view in self.arrows){
        view.hidden=YES;
    }
    for(UILabel *label in self.labels){
        label.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tapScreen:(id)sender {
    switch (self.tapNumber) {
        case 0:{ //show game description
            self.gameExplanationLabel.hidden = YES;
            [UIView animateWithDuration:0.2 animations: ^ {
                [self.blurWithVibrancyView setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
            } completion:nil];
            break;
            
        }
        case 1:{ //show map
            self.mapImageArrow.hidden = NO;
            self.mapLabel.hidden = NO;
            break;
        }
        case 2:{ //show player
            self.mapImageArrow.hidden = YES;
            self.mapLabel.hidden = YES;
            self.playerLabel.hidden = NO;
            self.playerImageArrow.hidden = NO;
            break;
        }
        case 3:{ //show valid choice
            self.playerLabel.hidden = YES;
            self.playerImageArrow.hidden = YES;
            self.validImageArrow.hidden = NO;
            self.validLabel.hidden = NO;
            self.validTableArrow.hidden = NO;
            self.validTableLabel.hidden = NO;
            break;
        }
        case 4:{ //show out of bounds
            self.validImageArrow.hidden = YES;
            self.validLabel.hidden = YES;
            self.validTableArrow.hidden = YES;
            self.validTableLabel.hidden = YES;
            self.outOfBoundsImageArrow.hidden = NO;
            self.outOfBoundsLabel.hidden = NO;
            self.outOfBoundsTableArrow.hidden = NO;
            break;
        }
        case 5:{ //show invalid
            self.outOfBoundsImageArrow.hidden = YES;
            self.outOfBoundsLabel.hidden = YES;
            self.outOfBoundsTableArrow.hidden = YES;
            self.invalidImageArrow.hidden = NO;
            self.invalidTableArrow.hidden = NO;
            self.invalidTableLabel.hidden = NO;
            break;
        }
            
        default:{
            [self dismissViewControllerAnimated:YES completion:nil];
             break;
        }
           
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
