//
//  Station+CoreDataProperties.h
//  StationBarcelone
//
//  Created by cyrine on 19/10/2016.
//
//

#import "Station+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Station (CoreDataProperties)

+ (NSFetchRequest<Station *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Picture *> *pics;

@end

@interface Station (CoreDataGeneratedAccessors)

- (void)addPicsObject:(Picture *)value;
- (void)removePicsObject:(Picture *)value;
- (void)addPics:(NSSet<Picture *> *)values;
- (void)removePics:(NSSet<Picture *> *)values;

@end

NS_ASSUME_NONNULL_END
