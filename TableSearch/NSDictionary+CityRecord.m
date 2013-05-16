//
//  NSDictionary+CityRecord.m
//  TableSearch
//
//  Created by Gayle Dunham on 5/16/13.
//  Copyright (c) 2013 Adrian Phillips. All rights reserved.
//

#import "NSDictionary+CityRecord.h"
#import "AppDelegate.h"

NSString * const CityNameKey        = @"city";
NSString * const StateNameKey       = @"state";
NSString * const CityTextKey        = @"cityText";
NSString * const CityImageNameKey   = @"cityImage";


@implementation NSDictionary (CityRecord)

- (NSString *)cityName
{
    return [self valueForKey:CityNameKey];
}

- (NSString *)stateName
{
    return [self valueForKey:StateNameKey];
}

- (NSString *)cityText
{
    return [self valueForKey:CityTextKey];
}

- (NSString *)cityImageName
{
    return [self valueForKey:CityImageNameKey];
}

- (UIImage *)cityImage
{
    NSString *imageDir  = [[AppDelegate writeableFilePath] stringByDeletingLastPathComponent];
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", imageDir, self.cityImageName];
    
    // Try loading the image from the documents directory
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    // If we didn't find it try the  main bundle
    if (!image) {
        image = [UIImage imageNamed:self.cityImageName];
    }
    
    return image;
}

+ (NSDictionary *) dictionaryForCityRecordWithCityName:(NSString *) city
                                             stateName:(NSString *) state
                                       cityDescription:(NSString *) text
                                         cityImageName:(NSString *) imageName
{
    NSDictionary *newRecord = @{ CityNameKey        : city,
                                 StateNameKey       : state,
                                 CityTextKey        : text,
                                 CityImageNameKey   : imageName };
    
    return newRecord;
}

@end
