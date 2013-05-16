//
//  AddViewController.h
//  TableSearch
//
//  Created by Adrian Phillips on 5/10/13.
//  Copyright (c) 2013 Adrian Phillips. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddViewController;

@protocol AddViewControllerDelegate <NSObject>
- (void)addViewController:(AddViewController *)sender
              setCityName:(NSString *)city
             setStateName:(NSString *)state
       setCityDescription:(NSString *)text
             setCityImage:(UIImage *)image;
@end

@interface AddViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    
    IBOutlet UITextField *cityTextField;
    IBOutlet UITextField *stateTextField;
    IBOutlet UITextView *cityDescription;
    
    UIImagePickerController* imagePicker;
}
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* description;
@property (nonatomic, strong) UIImage* image;
@property (nonatomic, retain) IBOutlet UINavigationBar* navigationBar;

@property (nonatomic, strong) UITextField *cityTextField;
@property (nonatomic, strong) UITextField *stateTextField;
@property (nonatomic, strong) UITextView *cityDescription;

@property (nonatomic, strong) IBOutlet UIButton* choosePhotoButton;
@property (nonatomic, strong) IBOutlet UIButton* takePhotoButton;

@property (strong, nonatomic) id <AddViewControllerDelegate> delegate;


- (IBAction)save;
- (IBAction)cancel;

- (IBAction)choosePhoto;
- (IBAction)takePhoto;

@end