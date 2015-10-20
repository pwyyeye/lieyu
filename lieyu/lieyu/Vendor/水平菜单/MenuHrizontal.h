//
//  MenuHrizontal.h
//  ShowProduct
//
//  Created by lin on 14-5-22.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import <UIKit/UIKit.h>

#define NOMALKEY   @"normalKey"
#define HEIGHTKEY  @"helightKey"
#define TITLEKEY   @"titleKey"
#define WEEKKEY   @"weekKey"
#define TITLEWIDTH @"titleWidth"
#define TOTALWIDTH @"totalWidth"
#define COUNTORDER @"countOrder"
@protocol MenuHrizontalDelegate <NSObject>

@optional
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex;
@end
@interface MenuHrizontal : UIView
{
    NSMutableArray        *mButtonArray;
    NSMutableArray        *mItemInfoArray;
    UIScrollView          *mScrollView;
    float                 mTotalWidth;
    int                 jianWidth;
}

@property (nonatomic,assign) id <MenuHrizontalDelegate> delegate;

#pragma mark 初始化菜单
- (id)initWithFrame:(CGRect)frame ButtonItems:(NSArray *)aItemsArray;
- (id)initWithFrameForTime:(CGRect)frame ButtonItems:(NSArray *)aItemsArray;
@property (nonatomic,assign) NSInteger selectIndex;
#pragma mark 选中某个button
-(void)clickButtonAtIndex:(NSInteger)aIndex;

#pragma mark 改变第几个button为选中状态，不发送delegate
-(void)changeButtonStateAtIndex:(NSInteger)aIndex;

@end
