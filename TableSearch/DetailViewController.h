//
//  DetailViewController.h
//  PopulateTableView
//
//  Created by Adrian Phillips on 4/26/13.
//  Copyright (c) 2013 Adrian Phillips. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController {
    IBOutlet UIImageView *cityImage;
    IBOutlet UITextView *cityText;
    NSString *cityImageString;
    NSString *cityTextString;
    
}

@property (nonatomic, retain) NSString *cityImageString;
@property (nonatomic, retain) NSString *cityTextString;


@end
