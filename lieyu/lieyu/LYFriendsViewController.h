//
//  LYFriendsViewController.h
//  lieyu
//
//  Created by 狼族 on 15/12/24.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "LYFriendsSendViewController.h"

@interface LYFriendsViewController : LYBaseViewController<sendBackVedioAndImage>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_top;

@property (nonatomic, strong) NSString *mediaUrl;//视频地址
@property (nonatomic, strong) UIImage *mediaImage;//视频截图
@property (nonatomic, strong) NSArray *imageArray;//图片数组
@property (nonatomic, strong) NSString *content;//动态文字

@end
