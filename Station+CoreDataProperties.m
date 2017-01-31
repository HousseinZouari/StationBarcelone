//
//  Station+CoreDataProperties.m
//  StationBarcelone
//
//  Created by cyrine on 19/10/2016.
//
//

#import "Station+CoreDataProperties.h"

@implementation Station (CoreDataProperties)

+ (NSFetchRequest<Station *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Station"];
}

@dynamic name;
@dynamic pics;

@end
