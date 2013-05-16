//
//  DetailViewController.h
//  TableSearch
//
//  Created by Adrian Phillips on 4/26/13.
//  Copyright (c) 2013 Adrian Phillips. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (weak, nonatomic)   IBOutlet UILabel      *cityName;
@property (weak, nonatomic)   IBOutlet UILabel      *stateName;
@property (weak, nonatomic)   IBOutlet UITextView   *cityText;
@property (weak, nonatomic)   IBOutlet UIImageView  *cityImage;

@property (strong, nonatomic) NSDictionary *cityRecord;

@end
