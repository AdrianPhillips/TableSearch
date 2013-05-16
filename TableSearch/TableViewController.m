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
#import "AppDelegate.h"
#import "NSDictionary+CityRecord.h"

@interface TableViewController () <AddViewControllerDelegate>

@end

@implementation TableViewController

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
    
    self.content = [[NSMutableArray alloc] initWithContentsOfFile:[AppDelegate writeableFilePath]];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    self.searchResults = [[self.content filteredArrayUsingPredicate:resultPredicate] retain];
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
    
    NSDictionary *cityRecord;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cityRecord = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        cityRecord = [self.content objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text       = cityRecord.cityName;
    cell.detailTextLabel.text = cityRecord.stateName;
    cell.imageView.image      = cityRecord.cityImage;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [self performSegueWithIdentifier: @"showDetails" sender: self];
    }
}

// Override to support Edit mode for the table view
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.content removeObjectAtIndex:indexPath.row];
        [self.content writeToFile:[AppDelegate writeableFilePath] atomically:YES];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

{
    
    if ([segue.identifier isEqualToString:@"showDetails"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *DVC = [segue destinationViewController];
        
        if ([self.searchDisplayController isActive]) {
            DVC.cityRecord = [self.searchResults objectAtIndex:indexPath.row];
        } else {
            DVC.cityRecord = [self.content objectAtIndex:indexPath.row];
        }
        
    }
    else if ([segue.identifier isEqualToString:@"ShowAdd"]) {
        
        AddViewController *addController = [segue destinationViewController];
        addController.delegate = self;
    }
}

- (void)addViewController:(AddViewController *)sender
              setCityName:(NSString *)city
             setStateName:(NSString *)state
       setCityDescription:(NSString *)text
             setCityImage:(UIImage *)image
{
    NSString *imageName = [AppDelegate createFileForImage:image];
    
    NSDictionary *newRecord = [NSDictionary dictionaryForCityRecordWithCityName:city
                                                                      stateName:state
                                                                cityDescription:text
                                                                  cityImageName:imageName];

    [self.content addObject:newRecord];
    
    [self.content writeToFile:[AppDelegate writeableFilePath] atomically:YES];
    
    [self.tableView reloadData];
}

@end