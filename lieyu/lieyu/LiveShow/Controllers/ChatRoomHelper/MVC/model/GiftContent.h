//
//  GiftContent.h
//  lieyu
//
//  Created by 狼族 on 16/9/1.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftContent : NSObject

@property (nonatomic ,strong) NSString *giftId;
@property (nonatomic, strong) NSString *giftUrl;
@property (nonatomic, strong) NSString *giftLocalUrl;
@property (nonatomic, assign) BOOL isMsgShow;


@end
