//
//  LYAddressBook.h
//  lieyu
//
//  Created by 王婷婷 on 16/8/24.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYAddressBook : NSObject

- (NSArray *)getAddressBook;

- (NSMutableArray *)getCustomArrayToSectionArray:(NSMutableArray *)addressBookTemp;

- (NSMutableArray *)getUserModelArrayToSectionArray:(NSMutableArray *)addressBookTemp;
- (NSMutableArray *)getAddressBookModelArrayToSectionArray:(NSMutableArray *)addressBookTemp;
@end
