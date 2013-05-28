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
    
    content = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"]];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *filePath = [self plistFileDocumentPath:@"Data.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:filePath];
    if (!exist) {
        return;
    }
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    content = dataArray;
    [self.tableView reloadData];
}

- (NSString *)plistFileDocumentPath:(NSString *)plistName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writablePath = [documentsDirectory stringByAppendingPathComponent:plistName];
    return writablePath; 
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
        
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
        nameLabel.text = [[self.content objectAtIndex:indexPath.row] valueForKey:@"city"];
        UILabel *stateLabel = (UILabel *)[cell viewWithTag:101];
        stateLabel.text = [[self.content objectAtIndex:indexPath.row] valueForKey:@"state"];
        // Construct the expected URL for the image.
        NSURL *imageFileURL = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
        imageFileURL = [imageFileURL URLByAppendingPathComponent:[[self.content objectAtIndex:indexPath.row] valueForKey:@"cityImage"] isDirectory:NO];
        // Attempt to load the image at the above URL.
        cell.imageView.image = [[[UIImage alloc] initWithContentsOfFile:[imageFileURL path]] autorelease];
        UIImageView * cityImage = (UIImageView *) [cell viewWithTag:102];
        
        if (!cell.imageView.image)
        cityImage.image = [UIImage imageNamed:[[self.content objectAtIndex:indexPath.row] valueForKey:@"cityImage"]];

    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)_tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Data.plist"];
        [self.content removeObjectAtIndex:indexPath.row];
        [self.content writeToFile:path atomically:YES];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    // remove object and insert at new position
    NSString *tmp = [[NSString alloc] initWithString:[self.content objectAtIndex:fromIndexPath.row]];
    [content removeObjectAtIndex:fromIndexPath.row];
    [content insertObject:tmp atIndex:toIndexPath.row];
    [tmp release];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
            
            DVC.cityTextString = [[self.content objectAtIndex:indexPath.row] valueForKey:@"cityText"];
            DVC.cityNameString = [[self.content objectAtIndex:indexPath.row] valueForKey:@"city"];
            DVC.stateNameString = [[self.content objectAtIndex:indexPath.row] valueForKey:@"state"];
            DVC.cityImageString = [[self.content objectAtIndex:indexPath.row] valueForKey:@"cityImage"];
        }
    }
}

@end