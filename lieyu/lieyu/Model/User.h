//
//  MAccount.h
//  
//
//  Created by apple on 15/4/28.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "LYCoreDataObject.h"

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * account;
@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * name;


@end



