//
//  Stat.h
//  StationBarcelone
//
//  Created by cyrine on 19/10/2016.
//
//

#import <Foundation/Foundation.h>

@interface Stat : NSObject
@property  NSInteger *id;

@property (copy) NSString *streetName;
@property (copy) NSString *city;
@property (copy) NSString *furniture;
@property (copy) NSString *buses;

@property (copy) NSString *utm_x;
@property (copy) NSString *utm_y;
@property (copy) NSString *latitude;
@property (copy) NSString *longitude;
@property (copy) NSString *distance;
@end
