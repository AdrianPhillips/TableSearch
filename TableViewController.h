//
//  TableViewController.h
//  TableSearch
//
//  Created by Adrian Phillips on 4/26/13.
//  Copyright (c) 2013 Adrian Phillips. All rights reserved.
//

@interface TableViewController : UITableViewController <UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray *content;
@property (strong, nonatomic) NSArray *searchResults;


- (IBAction)add;

@end