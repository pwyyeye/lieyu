//
//  FansModel.h
//  lieyu
//
//  Created by 狼族 on 16/9/3.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FansModel : NSObject

@property (nonatomic, assign) int id;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *usernick;
@property (nonatomic, assign) int sex;
@property (nonatomic, strong) NSString *avatar_img;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, assign) BOOL friend;

@end
