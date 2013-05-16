//
//  NSDictionary+CityRecord.h
//  TableSearch
//
//  Created by Gayle Dunham on 5/16/13.
//  Copyright (c) 2013 Adrian Phillips. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CityRecord)

@property (readonly) NSString *cityName;
@property (readonly) NSString *stateName;
@property (readonly) NSString *cityText;
@property (readonly) NSString *cityImageName;
@property (readonly) UIImage  *cityImage;

+ (NSDictionary *) dictionaryForCityRecordWithCityName:(NSString *) city
                                             stateName:(NSString *) state
                                       cityDescription:(NSString *) text
                                         cityImageName:(NSString *)  imageName;


@end
