//
//  FriendsUserMessageModel.h
//  lieyu
//
//  Created by 狼族 on 15/12/26.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendsUserMessageModel : UserModel
@property (nonatomic,copy) NSString *fansNum;

@property (nonatomic,copy) NSString *isAttention;
@property (nonatomic,copy) NSString *attendNum;
@property (nonatomic,copy) NSString *liked;
@property (nonatomic,strong) NSArray *moments;

+(FriendsUserMessageModel *)initFormDictionary:(NSDictionary *)dic;
@end
