//
//  GameOptionsViewController.m
//  FlickrMaze
//
//  Created by Alex Bearinger on 2017-02-08.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import "GameOptionsViewController.h"
#import "GameManager.h"

@interface GameOptionsViewController ()
@property NSArray *themes;
@property (weak, nonatomic) IBOutlet UIPickerView *themePicker;
@property (weak, nonatomic) IBOutlet UIImageView *playerImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextView;
@property (weak, nonatomic) IBOutlet UITextField *tagTextField;
@property NSString *selectedTheme;
@property GameManager *manager;
@end

@implementation GameOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [GameManager sharedManager];
    self.themes = @[@"Default",@"Cats",@"Jaws",@"Donald_Trump"];
    self.themePicker.delegate = self;
    self.themePicker.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.manager.gameTheme = self.themes[row];
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
