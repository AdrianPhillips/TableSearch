//
//  AddViewController.m
//  TableSearch
//
//  Created by Adrian Phillips on 5/10/13.
//  Copyright (c) 2013 Adrian Phillips. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController
@synthesize cityTextField, stateTextField, cityDescription;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)save
{
    // Make sure the user has entered at least a recipe name
    if (self.cityTextField.text.length == 0)
    {
        UIAlertView* alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Whoops..."
                                  message:@"Please enter a city name"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        
        [alertView show];
        [alertView release];
        return;
    }
    
    if (self.stateTextField.text.length == 0)
    {
        UIAlertView* alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Whoops..."
                                  message:@"Please enter a city name"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        
        [alertView show];
        [alertView release];
        return;
    }
    // Make sure the user has entered at least a recipe name
    if (self.cityDescription.text.length == 0)
    {
        UIAlertView* alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Whoops..."
                                  message:@"Please enter city description"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        
        [alertView show];
        [alertView release];
        return;
    }
    
    self.name = self.cityTextField.text;
    self.name = self.stateTextField.text;
    self.description = self.cityDescription.text;
    
    [self.delegate addViewController:self
                         setCityName:self.cityTextField.text
                        setStateName:self.stateTextField.text
                  setCityDescription:self.cityDescription.text
                        setCityImage:self.image];
        
    if ([[self parentViewController] respondsToSelector:@selector(dismissViewControllerAnimated:)]){
        
        [[self parentViewController] dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)cancel {
    {
        
        if ([[self parentViewController] respondsToSelector:@selector(dismissModalViewControllerAnimated:)]){
            
            [[self parentViewController] dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            
            [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (IBAction)choosePhoto
{
    // Show the image picker with the photo library
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)takePhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    if ([cityDescription isFirstResponder] && [touch view] != cityDescription) {
        
        [cityDescription resignFirstResponder];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [cityTextField resignFirstResponder];
    [stateTextField resignFirstResponder];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController*)picker     didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    // We get here when the user has successfully picked an image.
    // Put the image in our property and set it on the button.
    
    if (imagePicker) {
        self.image = [info objectForKey:UIImagePickerControllerEditedImage];
        [self.choosePhotoButton setImage:self.image forState:UIControlStateNormal];
    } else {
        
        if (picker) {
            self.image = [info objectForKey:UIImagePickerControllerEditedImage];
            [self.takePhotoButton setImage:self.image forState:UIControlStateNormal];
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [imagePicker release];
    imagePicker = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [imagePicker release];
    imagePicker = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end