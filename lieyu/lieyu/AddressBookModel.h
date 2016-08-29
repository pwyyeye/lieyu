//
//  AddressBookModel.h
//  lieyu
//
//  Created by 王婷婷 on 16/8/23.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressBookModel : NSObject

@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *headUrl;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSData *image;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *id;

@property (nonatomic, assign) NSInteger appUserType;

@property (nonatomic, assign) NSInteger dayFactor;
@property (nonatomic, strong) NSString *dayFactorStr;
@property (nonatomic, strong) NSString *isSendBlessing;
@property (nonatomic, strong) NSString *sendBlessingDate;

@property (nonatomic, assign) NSInteger sectionNumber;

@property (nonatomic, strong) NSString *lastDayForBirthday;

@property (nonatomic, strong) NSString *sex;


@end
