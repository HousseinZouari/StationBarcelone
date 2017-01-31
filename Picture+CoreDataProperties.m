//
//  Picture+CoreDataProperties.m
//  StationBarcelone
//
//  Created by cyrine on 19/10/2016.
//
//

#import "Picture+CoreDataProperties.h"

@implementation Picture (CoreDataProperties)

+ (NSFetchRequest<Picture *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Picture"];
}

@dynamic date_p;
@dynamic name;
@dynamic pic;
@dynamic stat;

@end
