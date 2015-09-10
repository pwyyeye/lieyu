//
//  MAccount.h
//  
//
//  Created by apple on 15/4/28.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "IdentifiedObject.h"

@interface User : IdentifiedObject

@property (nonatomic, retain) NSString * account;
@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * name;


@end



