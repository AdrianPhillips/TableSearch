//
//  TableViewController.m
//  TableSearch
//
//  Created by Adrian Phillips on 4/26/13.
//  Copyright (c) 2013 Adrian Phillips. All rights reserved.
//

#import "TableViewController.h"
#import "DetailViewController.h"
#import "AddViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

@synthesize content, searchResults;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    content = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"]];
}

- (IBAction)add;
{
    AddViewController* controller = [[AddViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
        
    } else {
        return [self.content count];
        
    }
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat: @"SELF['city'] BEGINSWITH[c] %@ ", searchText];
    
    searchResults = [[content filteredArrayUsingPredicate:resultPredicate] retain];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier] autorelease];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [[searchResults objectAtIndex:indexPath.row] valueForKey:@"city"];
        cell.detailTextLabel.text = [[searchResults objectAtIndex:indexPath.row] valueForKey:@"state"];
        cell.imageView.image = [UIImage imageNamed:[[self.searchResults objectAtIndex:indexPath.row] valueForKey:@"cityImage"]];
    } else {
        cell.textLabel.text = [[self.content objectAtIndex:indexPath.row] valueForKey:@"city"];
        cell.detailTextLabel.text = [[self.content objectAtIndex:indexPath.row] valueForKey:@"state"];
        cell.imageView.image = [UIImage imageNamed:[[self.content objectAtIndex:indexPath.row] valueForKey:@"cityImage"]];

    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [self performSegueWithIdentifier: @"showDetails" sender: self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

{
    
    if ([segue.identifier isEqualToString:@"showDetails"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *DVC = [segue destinationViewController];
        
        if ([self.searchDisplayController isActive]) {
            
            DVC.cityImageString = [[searchResults objectAtIndex:indexPath.row] valueForKey:@"cityImage"];
            DVC.cityTextString = [[searchResults objectAtIndex:indexPath.row] valueForKey:@"cityText"];
            DVC.cityNameString = [[searchResults objectAtIndex:indexPath.row] valueForKey:@"city"];
            DVC.stateNameString = [[searchResults objectAtIndex:indexPath.row] valueForKey:@"state"];
        } else {
            
            DVC.cityImageString = [[self.content objectAtIndex:indexPath.row] valueForKey:@"cityImage"];
            DVC.cityTextString = [[self.content objectAtIndex:indexPath.row] valueForKey:@"cityText"];
            DVC.cityNameString = [[self.content objectAtIndex:indexPath.row] valueForKey:@"city"];
            DVC.stateNameString = [[self.content objectAtIndex:indexPath.row] valueForKey:@"state"];
        }
    }
}

@end