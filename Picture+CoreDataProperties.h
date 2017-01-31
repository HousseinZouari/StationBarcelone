//
//  Picture+CoreDataProperties.h
//  StationBarcelone
//
//  Created by cyrine on 19/10/2016.
//
//

#import "Picture+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Picture (CoreDataProperties)

+ (NSFetchRequest<Picture *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *date_p;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSData *pic;
@property (nullable, nonatomic, retain) Station *stat;

@end

NS_ASSUME_NONNULL_END
