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
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
