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
    // Name for the image
    NSString *imageName;
    
    if (self.image) {
        // Create a unique name for the image by generating a UUID, converting it to
        // a string, and appending the .jpg extension.
        CFUUIDRef imageUUID = CFUUIDCreate(kCFAllocatorDefault);
        imageName = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, imageUUID);
        CFRelease(imageUUID);
        imageName = [imageName stringByAppendingString:@".jpg"];
        
        // Lookup the URL for the Documents folder
        NSURL *imageFileURL = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
        // Append the file name to create the complete URL for saving the image.
        imageFileURL = [imageFileURL URLByAppendingPathComponent:imageName isDirectory:NO];
        
        // Convert the image to JPG format and write the data to disk at the above URL.
        [UIImageJPEGRepresentation(self.image, 1.0f) writeToURL:imageFileURL atomically:YES];
    } else {
        // If there is no image, we must make sure imageName is not nil.
        imageName = @"";
    }
#define PLIST_NAME @"Data.plist"
    [self createPlistCopyInDocuments:PLIST_NAME];
    NSString *filePath = [self plistFileDocumentPath:PLIST_NAME];
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    NSDictionary *data = @{@"city":self.name,@"state":self.stateTextField.text,@"cityText":self.cityDescription.text, @"cityImage": imageName};
    [dataArray addObject:data];
    [dataArray writeToFile:filePath atomically:YES];
    
    if ([[self parentViewController] respondsToSelector:@selector(dismissViewControllerAnimated:)]){
        
        [[self parentViewController] dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }
}

- (NSString *)plistFileDocumentPath:(NSString *)plistName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writablePath = [documentsDirectory stringByAppendingPathComponent:plistName];
    return writablePath;
}

- (void)createPlistCopyInDocuments:(NSString *)plistName
{
    // First, test for existence.
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *plistFilePath = [self plistFileDocumentPath:plistName];
    success = [fileManager fileExistsAtPath:plistFilePath];
    
    if (success) {
        return;
    }
    
    // The writable file does not exist, so copy from the bundle to the appropriate location.
    NSString *defaultPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:plistName];
    success = [fileManager copyItemAtPath:defaultPath toPath:plistFilePath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable file with message '%@'.", [error localizedDescription]);
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