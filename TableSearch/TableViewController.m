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

@interface TableViewController () <AddViewControllerDelegate>

@property (readonly, strong, nonatomic) NSString *writeableFilePath;

@end

@implementation TableViewController

@synthesize writeableFilePath = _writeableFilePath;

static NSString *dataFileName = @"Data.plist";

// Lazy create and cache writable file path
- (NSString *)writeableFilePath
{
    if (_writeableFilePath)
        return _writeableFilePath;
    
    // You can not write to files in the application bundle. The bundle is signed and can not be changed.
    // You need to copy the data file from the application bundle to the application documents directory. 

    // Get the path to the data file in the documents directory.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    _writeableFilePath = [[documentsDirectory stringByAppendingPathComponent:dataFileName] copy];
    
    // The data file does not exist copy it from the bundle.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:_writeableFilePath]) {
        
        NSString *readOnlyFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dataFileName];
        NSError *error;
        BOOL success = [fileManager copyItemAtPath:readOnlyFilePath toPath:_writeableFilePath error:&error];
        if (!success) {
            [[[UIAlertView alloc] initWithTitle:@"Can not create data file!"
                                        message:@"[error localizedDescription]"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }

    }
    
    return _writeableFilePath;
}

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
    
    self.content = [[NSMutableArray alloc] initWithContentsOfFile:self.writeableFilePath];
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
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [[self.searchResults objectAtIndex:indexPath.row] valueForKey:@"city"];
        cell.detailTextLabel.text = [[self.searchResults objectAtIndex:indexPath.row] valueForKey:@"state"];
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
            
            DVC.cityImageString = [[self.searchResults objectAtIndex:indexPath.row] valueForKey:@"cityImage"];
            DVC.cityTextString = [[self.searchResults objectAtIndex:indexPath.row] valueForKey:@"cityText"];
            DVC.cityNameString = [[self.searchResults objectAtIndex:indexPath.row] valueForKey:@"city"];
            DVC.stateNameString = [[self.searchResults objectAtIndex:indexPath.row] valueForKey:@"state"];
        } else {
            
            DVC.cityImageString = [[self.content objectAtIndex:indexPath.row] valueForKey:@"cityImage"];
            DVC.cityTextString = [[self.content objectAtIndex:indexPath.row] valueForKey:@"cityText"];
            DVC.cityNameString = [[self.content objectAtIndex:indexPath.row] valueForKey:@"city"];
            DVC.stateNameString = [[self.content objectAtIndex:indexPath.row] valueForKey:@"state"];
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
         setCityImageName:(NSString *)imageName
{
    NSDictionary *newRecord = @{ @"city"        : city,
                                 @"state"       : state,
                                 @"cityText"    : text,
                                 @"cityImage"   : imageName };
    
    [self.content addObject:newRecord];
    
    [self.content writeToFile:self.writeableFilePath atomically:YES];
    
    [self.tableView reloadData];
}



@end