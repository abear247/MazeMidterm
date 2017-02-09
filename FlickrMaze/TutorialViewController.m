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
@property (weak, nonatomic) IBOutlet UILabel *mapLabel;
@property (weak, nonatomic) IBOutlet UIImageView *validImageArrow;
@property (weak, nonatomic) IBOutlet UILabel *validLabel;
@property (weak, nonatomic) IBOutlet UILabel *validTableLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playerImageArrow;
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *invalidImageArrow;
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
    self.arrows = @[self.mapImageArrow,self.validImageArrow,self.playerImageArrow,self.invalidImageArrow,self.outOfBoundsImageArrow,self.titleTableArrow];
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
        case 0:{
            self.arrows[0].hidden = NO;
            self.labels[0].hidden = NO;
            break;
        }
        case 1:{
            self.labels[0].hidden = YES;
            self.arrows[0].hidden = YES;
            self.arrows[1].hidden = NO;
            
            break;
        }
        case 2:{
            self.arrows[1].hidden = YES;
            self.arrows[2].hidden = NO;
            break;
        }
        case 3:{
            self.arrows[2].hidden = YES;
            self.arrows[3].hidden = NO;
            break;
        }
        case 4:{
            self.arrows[3].hidden = YES;
            self.arrows[4].hidden = NO;
            break;
        }
        case 5:{
            self.arrows[4].hidden = YES;
            self.arrows[5].hidden = NO;
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
