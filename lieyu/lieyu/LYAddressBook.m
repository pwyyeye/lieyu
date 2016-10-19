//
//  LYAddressBook.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/24.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYAddressBook.h"
#import <AddressBook/AddressBook.h>
#import "AddressBookModel.h"
#import "CustomerModel.h"

@interface LYAddressBook()

@property (nonatomic, strong) NSMutableArray *addressArray;

@end

@implementation LYAddressBook

- (NSArray *)getAddressBook{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    __block NSArray *dataList;
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            CFErrorRef *error1 = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
            dataList = [self copyAddressBook:addressBook];
        });
    }else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        dataList = [self copyAddressBook:addressBook];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MyUtil showPlaceMessage:@"没有获取通讯录权限！"];
        });
    }
    return dataList;
}

#pragma mark - 循环保存每个联系人的信息
- (NSArray *)copyAddressBook:(ABAddressBookRef)addressBook{
    _addressArray = [[NSMutableArray alloc]init];
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    for (int i = 0 ; i < numberOfPeople; i ++) {
        AddressBookModel *addressBook = [[AddressBookModel alloc]init];
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        
        //读取电话多值
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k < ABMultiValueGetCount(phone); k++)
        {
            //获取电话Label
            NSString * personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
            //获取該Label下的电话值
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            //该号码是否是座机
            NSString *tempPhone;
            if (personPhone.length < 11 || [personPhone characterAtIndex:0] == '0') {
                //可能是座机，无效手机号
            }else if ([[personPhone substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"+86 "]){
                tempPhone = [personPhone substringFromIndex:4];
            }else{
                tempPhone = personPhone;
            }
            NSString *mobile ;
            if (tempPhone.length == 13) {
                NSArray *array = [tempPhone componentsSeparatedByString:@" "];
                if (array.count >= 3) {
                    mobile = [NSString stringWithFormat:@"%@%@%@",array[0],array[1],array[2]];
                }else{
                    NSArray *tempArray = [tempPhone componentsSeparatedByString:@"-"];
                    if (tempArray.count >= 3) {
                        mobile = [NSString stringWithFormat:@"%@%@%@",tempArray[0],tempArray[1],tempArray[2]];
                    }
                }
            }else if (tempPhone.length == 11){
                mobile = tempPhone;
            }
            //最终获取到的mobile
            if (mobile.length == 11) {
                addressBook.mobile = mobile;
                if ((__bridge NSDate*)ABRecordCopyValue(person, kABPersonBirthdayProperty)) {
                    NSDate *birthdayDate = (__bridge NSDate*)ABRecordCopyValue(person, kABPersonBirthdayProperty);
                    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    addressBook.birthday = [formatter stringFromDate:birthdayDate];
                }else{
                    addressBook.birthday = @"";
                }
                if (firstName.length > 0) {
                    if (lastName.length > 0) {
                        addressBook.name = [NSString stringWithFormat:@"%@%@",lastName,firstName];
                    }else{
                        addressBook.name = firstName;
                    }
                }else if(lastName.length > 0){
                    addressBook.name = lastName;
                }else{
                    addressBook.name = @"";
                }
                addressBook.image = (__bridge NSData*)ABPersonCopyImageData(person);
                [_addressArray addObject:addressBook];
            }
        }
    }
    return _addressArray;
}

#pragma mark - 将Custom数组转换成sectionArray
- (NSMutableArray *)getCustomArrayToSectionArray:(NSMutableArray *)addressBookTemp{
    NSMutableArray *backArray = [[NSMutableArray alloc]init];
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for (CustomerModel *addressBook in addressBookTemp) {
        if ([MyUtil isEmptyString:addressBook.username]) {
            NSInteger sect = [theCollation sectionForObject:addressBook collationStringSelector:@selector(usernick)];
            addressBook.sectionNumber = sect;
            
//            if ([[addressBook.usernick substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"沈"]) {
//                addressBook.sectionNumber = 18;
//            }
        }else{
            NSInteger sect = [theCollation sectionForObject:addressBook collationStringSelector:@selector(username)];
            addressBook.sectionNumber = sect;
            
            if ([[addressBook.username substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"沈"]) {
                addressBook.sectionNumber = 18;
            }
        }
    }
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i=0; i<=highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    for (CustomerModel *addressBook in addressBookTemp) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:addressBook.sectionNumber] addObject:addressBook];
    }
    
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(username)];
        [backArray addObject:sortedSection];
    }
    return backArray;
}

#pragma mark - 将user model数组转换成sectionArray
- (NSMutableArray *)getUserModelArrayToSectionArray:(NSMutableArray *)addressBookTemp{
    NSMutableArray *backArray = [[NSMutableArray alloc]init];
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for (UserModel *addressBook in addressBookTemp) {
        if ([MyUtil isEmptyString:addressBook.usernick]) {
            NSInteger sect = [theCollation sectionForObject:addressBook collationStringSelector:@selector(username)];
            addressBook.sectionNumber = sect;
        }else{
            NSInteger sect = [theCollation sectionForObject:addressBook collationStringSelector:@selector(usernick)];
            addressBook.sectionNumber = sect;
            if ([[addressBook.usernick substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"沈"]) {
                addressBook.sectionNumber = 18;
            }
        }
    }
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i=0; i<=highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    for (UserModel *addressBook in addressBookTemp) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:addressBook.sectionNumber] addObject:addressBook];
    }
    
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(usernick)];
        [backArray addObject:sortedSection];
    }
    return backArray;
}

#pragma mark - 将addressBookModel数组转换成section数组
- (NSMutableArray *)getAddressBookModelArrayToSectionArray:(NSMutableArray *)addressBookTemp{
    NSMutableArray *backArray = [[NSMutableArray alloc]init];
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for (AddressBookModel *addressBook in addressBookTemp) {
        if ([MyUtil isEmptyString:addressBook.name]) {
            NSInteger sect = [theCollation sectionForObject:addressBook collationStringSelector:@selector(mobile)];
            addressBook.sectionNumber = sect;
        }else{
            NSInteger sect = [theCollation sectionForObject:addressBook collationStringSelector:@selector(name)];
            addressBook.sectionNumber = sect;
            if ([[addressBook.name substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"沈"]) {
                addressBook.sectionNumber = 18;
            }
        }
    }
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i=0; i<=highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    for (AddressBookModel *addressBook in addressBookTemp) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:addressBook.sectionNumber] addObject:addressBook];
    }
    
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name)];
        [backArray addObject:sortedSection];
    }
    return backArray;
}


@end
