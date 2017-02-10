//
//  GameOptionsViewController.m
//  FlickrMaze
//
//  Created by Alex Bearinger on 2017-02-08.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import "GameOptionsViewController.h"
#import "GameManager.h"
#import "HomeViewController.h"

@interface GameOptionsViewController () <UITextFieldDelegate>
@property NSArray *themes;
@property (weak, nonatomic) IBOutlet UIPickerView *themePicker;
@property (weak, nonatomic) IBOutlet UIImageView *playerImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextView;
@property (weak, nonatomic) IBOutlet UITextField *tagTextField;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *toggle;
@property UIImage *player;
@property NSString *selectedTheme;
@property GameManager *manager;
@end

@implementation GameOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [GameManager sharedManager];
    self.tagTextField.delegate = self;
    self.nameTextView.delegate = self;
    self.themes = @[@"Default",@"Cats",@"Jaws",@"Donald Trump"];
    self.themePicker.delegate = self;
    self.themePicker.dataSource = self;
    self.view.tintColor = [UIColor whiteColor];
    
    if(self.manager.playerImage)
        self.playerImageView.image = [UIImage imageWithData:self.manager.playerImage];
    if(self.manager.playerName)
        self.nameTextView.text = self.manager.playerName;
    if(self.manager.gameTheme){
        NSUInteger selected = [self.themes indexOfObject:self.manager.gameTheme];
        [self.themePicker selectRow:selected inComponent:0 animated:YES];
    }
    self.tagTextField.tintColor = [UIColor blackColor];
    self.nameTextView.tintColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)practiceMode:(id)sender {
    if(self.manager.practiceMode){
        self.manager.practiceMode = NO;
        self.tagTextField.userInteractionEnabled = YES;
        self.tagTextField.backgroundColor = [UIColor whiteColor];
        self.tagsLabel.hidden = NO;
        self.toggle.selectedSegmentIndex = 1;
    }
    else{
        self.tagTextField.userInteractionEnabled = NO;
        self.tagTextField.text = nil;
        self.tagTextField.backgroundColor = [UIColor clearColor];
        self.manager.practiceMode = YES;
        self.tagsLabel.hidden = YES;
        self.toggle.selectedSegmentIndex = 0;
    }
        
}

#pragma mark UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Image Picker methods
- (IBAction)cameraButton:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (IBAction)saveButton:(id)sender {
    self.manager.playerName = self.nameTextView.text;
    [self.delegate setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", self.manager.gameTheme]]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    NSData *data = UIImagePNGRepresentation(image);
    self.manager.playerImage = data;
    self.playerImageView.image = image;
    self.manager.tags = self.tagTextField.text;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}





#pragma mark Picker methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return  1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.themes.count;
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.themes[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(row == 3){
        self.manager.gameTheme = @"Donald_Trump";
        return;
    }
    self.manager.gameTheme = self.themes[row];
}

-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *title = self.themes[row];
    NSDictionary *attribute = @{ NSForegroundColorAttributeName : [UIColor whiteColor] };
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:title attributes:attribute];
    return string;
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
