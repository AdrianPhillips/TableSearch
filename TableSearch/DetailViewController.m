//
//  DetailViewController.m
//  TableSearch
//
//  Created by Adrian Phillips on 4/26/13.
//  Copyright (c) 2013 Adrian Phillips. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize cityImageString, cityTextString, cityNameString, stateNameString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    cityImage.image = [UIImage imageNamed:cityImageString];
    cityText.text = cityTextString;
    cityName.text = cityNameString;
    stateName.text = stateNameString;
    
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
    
    // Construct the expected URL for the image.
    NSURL *imageFileURL = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
    imageFileURL = [imageFileURL URLByAppendingPathComponent:cityImageString isDirectory:NO];
    // Attempt to load the image at the above URL.
    cityImage.image = [[[UIImage alloc] initWithContentsOfFile:[imageFileURL path]] autorelease];
    if (!cityImage.image)
        // If that failed, look in the app bundle.
        cityImage.image = [UIImage imageNamed:cityImageString];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
