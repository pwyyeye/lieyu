//
//  ChatUseres.h
//  lieyu
//
//  Created by 狼族 on 16/9/1.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatUseres : NSObject

@property (nonatomic, strong) NSString *time;//加入时间
@property (nonatomic, strong) NSString *username;//
@property (nonatomic, strong) NSString *usernick;
@property (nonatomic, strong) NSString *avatar_img;
@property (nonatomic, assign) NSInteger id;

@end
