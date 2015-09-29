//
//  DeckFullModel.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeckFullModel : NSObject
//"deckDate": "2015-09-29",
//"id": 0,
//"isFull": 1,
//"weekNum": "周二"
@property(nonatomic,assign)int id;
@property(nonatomic,assign)int isFull;
@property(nonatomic,copy)NSString * weekNum;
@property(nonatomic,copy)NSString * deckDate;
@end
