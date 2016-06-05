//
//  LYAdviserItem.h
//  lieyu
//
//  Created by 狼族 on 16/6/3.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
//"age": "年龄",
//"attach": "",
//"attachType":"附件类型",
//"avatar_img":"头像URL",
//"birthday":"生日",
//"city":"城市",
//"commentList":[{//前五条评论
@interface LYAdviserItem : NSObject

@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *attach;
@property (nonatomic, strong) NSString *attachType;
@property (nonatomic, strong) NSString *avatar_img;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSArray *commentList;

@end
