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
    
    NSArray *dataSource;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        dataSource = self.searchResults;
    } else {
        dataSource = self.content;
    }
    
    cell.textLabel.text       = [[dataSource objectAtIndex:indexPath.row] valueForKey:@"city"];
    cell.detailTextLabel.text = [[dataSource objectAtIndex:indexPath.row] valueForKey:@"state"];
    cell.imageView.image      = [self loadImageNamed:[[dataSource objectAtIndex:indexPath.row] valueForKey:@"cityImage"]];
    
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

- (UIImage *)loadImageNamed:(NSString *)name
{
    NSString *imageDir  = [self.writeableFilePath stringByDeletingLastPathComponent];
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", imageDir, name];

    // Try loading the image from the documents directory
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    // If we didn't find it try the  main bundle
    if (!image) {
        image = [UIImage imageNamed:name];
    }

    return image;
}

- (void)addViewController:(AddViewController *)sender
              setCityName:(NSString *)city
             setStateName:(NSString *)state
       setCityDescription:(NSString *)text
             setCityImage:(UIImage *)image
{
    NSString *imageName = [self createFileForImage:image];    
    
    NSDictionary *newRecord = @{ @"city"        : city,
                                 @"state"       : state,
                                 @"cityText"    : text,
                                 @"cityImage"   : imageName };
    
    [self.content addObject:newRecord];
    
    [self.content writeToFile:self.writeableFilePath atomically:YES];
    
    [self.tableView reloadData];
}

NSString * const ImageCounterKey   = @"ImageCounter";

- (NSString *)createFileForImage:(UIImage *)image
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger imageCount = [userDefaults integerForKey:ImageCounterKey];
    imageCount++;
    
    NSString *imageDir  = [self.writeableFilePath stringByDeletingLastPathComponent];
    NSString *imageName = [NSString stringWithFormat:@"image%d.jpg", imageCount];
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", imageDir, imageName];
    
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0);

    [imageData writeToFile:imagePath atomically:YES];

    [userDefaults setInteger:imageCount  forKey:ImageCounterKey];

    return imageName;
}



@end