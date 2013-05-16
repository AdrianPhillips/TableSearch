//
//  AppDelegate.m
//  TableSearch
//
//  Created by Adrian Phillips on 4/26/13.
//  Copyright (c) 2013 Adrian Phillips. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (NSString *)writeableFilePath
{
    static NSString *dataFileName       = @"Data.plist";
    static NSString *_writeableFilePath = nil;

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

NSString * const ImageCounterKey   = @"ImageCounter";

+ (NSString *)createFileForImage:(UIImage *)image
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger imageCount = [userDefaults integerForKey:ImageCounterKey];
    imageCount++;
    
    NSString *imageDir  = [[AppDelegate writeableFilePath] stringByDeletingLastPathComponent];
    NSString *imageName = [NSString stringWithFormat:@"image%d.jpg", imageCount];
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", imageDir, imageName];
    
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
    
    [imageData writeToFile:imagePath atomically:YES];
    
    [userDefaults setInteger:imageCount  forKey:ImageCounterKey];
    
    return imageName;
}

@end
