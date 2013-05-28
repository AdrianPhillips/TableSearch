//
//  DetailViewController.h
//  TableSearch
//
//  Created by Adrian Phillips on 4/26/13.
//  Copyright (c) 2013 Adrian Phillips. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController {
    IBOutlet UIImageView *cityImage;
    IBOutlet UITextView *cityText;
    IBOutlet UILabel *cityName;
    IBOutlet UILabel *stateName;
    NSString *cityImageString;
    NSString *cityTextString;
    NSString *cityNameString;
    NSString *stateNameString;
    
}

@property (nonatomic, retain) NSString *cityImageString;
@property (nonatomic, retain) NSString *cityTextString;
@property (nonatomic, retain) NSString *cityNameString;
@property (nonatomic, retain) NSString *stateNameString;
@property (nonatomic, strong) UIImage* image;

@end
