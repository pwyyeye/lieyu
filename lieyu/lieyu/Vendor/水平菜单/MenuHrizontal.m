//
//  MenuHrizontal.m
//  ShowProduct
//
//  Created by lin on 14-5-22.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import "MenuHrizontal.h"
#import "MacroDefinition.h"
#import "UIViewExt.h"
#import "TimeButton.h"

#define BUTTONITEMWIDTH   70

@implementation MenuHrizontal
- (id)initWithFrame:(CGRect)frame ButtonItems:(NSArray *)aItemsArray{
    jianWidth=0;
    self = [super initWithFrame:frame];
    if (self) {
        if (mButtonArray == nil) {
            mButtonArray = [[NSMutableArray alloc] init];
        }
        if (mScrollView == nil) {
            mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            mScrollView.backgroundColor=RGB(114, 5, 147);
            mScrollView.showsHorizontalScrollIndicator = NO;
        }
        if (mItemInfoArray == nil) {
            mItemInfoArray = [[NSMutableArray alloc]init];
        }
        [mItemInfoArray removeAllObjects];
        [self createMenuItems:aItemsArray withOrderType:0];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame ButtonItems:(NSArray *)aItemsArray andOrderType:(NSInteger) orderType
{
    jianWidth=0;
    self = [super initWithFrame:frame];
    if (self) {
        if (mButtonArray == nil) {
            mButtonArray = [[NSMutableArray alloc] init];
        }
        if (mScrollView == nil) {
            mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            mScrollView.backgroundColor=RGB(114, 5, 147);
            mScrollView.showsHorizontalScrollIndicator = NO;
        }
        if (mItemInfoArray == nil) {
            mItemInfoArray = [[NSMutableArray alloc]init];
        }
        [mItemInfoArray removeAllObjects];
        [self createMenuItems:aItemsArray withOrderType:orderType];
    }
    return self;
}
- (id)initWithFrameForTime:(CGRect)frame ButtonItems:(NSArray *)aItemsArray
{
    jianWidth=52;
    self = [super initWithFrame:frame];
    if (self) {
        if (mButtonArray == nil) {
            mButtonArray = [[NSMutableArray alloc] init];
        }
        if (mScrollView == nil) {
            mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            mScrollView.backgroundColor=RGB(114, 5, 147);
            mScrollView.showsHorizontalScrollIndicator = NO;
        }
        if (mItemInfoArray == nil) {
            mItemInfoArray = [[NSMutableArray alloc]init];
        }
        [mItemInfoArray removeAllObjects];
        [self createMenuItemsForTime:aItemsArray];
    }
    return self;
}

-(void)createMenuItems:(NSArray *)aItemsArray withOrderType:(NSInteger)orderType{
    int i = 0;
    float menuWidth = 0.0;
    //
    for (NSDictionary *lDic in aItemsArray) {
        
        UIImage *normalImg = [lDic objectForKey:NOMALKEY];
        UIImage *secImg = [lDic objectForKey:HEIGHTKEY];
        NSString *vTitleStr = [lDic objectForKey:TITLEKEY];
        float vButtonWidth = [[lDic objectForKey:TITLEWIDTH] floatValue];
//        NSString *countSumStr=[lDic objectForKey:COUNTORDER];
        UIButton *vButton = [UIButton buttonWithType:UIButtonTypeCustom];
        vButton.userInteractionEnabled=YES;
        
        [vButton setBackgroundImage:normalImg forState:UIControlStateNormal];
        [vButton setBackgroundImage:secImg forState:UIControlStateSelected];
        //设置title
        [vButton setTitle:vTitleStr forState:UIControlStateNormal];
        [vButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [vButton setTitleColor:RGB(37, 82, 157) forState:UIControlStateSelected];
        vButton.titleLabel.font=[UIFont systemFontOfSize:10];
        [vButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [vButton setTag:i];
        [vButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [vButton setFrame:CGRectMake(menuWidth, 0, vButtonWidth, self.frame.size.height)];
        if(i==orderType){
            [vButton setSelected:true];
        }
  
        [mScrollView addSubview:vButton];
        [mButtonArray addObject:vButton];
        
        menuWidth += vButtonWidth;
        i++;
        
        //保存button资源信息，同时增加button.oringin.x的位置，方便点击button时，移动位置。
        NSMutableDictionary *vNewDic = [lDic mutableCopy];
        [vNewDic setObject:[NSNumber numberWithFloat:menuWidth] forKey:TOTALWIDTH];
        [mItemInfoArray addObject:vNewDic];
    }
    
    [mScrollView setContentSize:CGSizeMake(menuWidth, self.frame.size.height)];
    [self addSubview:mScrollView];
    // 保存menu总长度，如果小于320则不需要移动，方便点击button时移动位置的判断
    mTotalWidth = menuWidth;
}
-(void)createMenuItemsForTime:(NSArray *)aItemsArray{
    int i = 0;
    float menuWidth = 0.0;
    //
    for (NSDictionary *lDic in aItemsArray) {
        
//        UIImage *normalImg = [lDic objectForKey:NOMALKEY];
        NSString *weekStr = [lDic objectForKey:WEEKKEY];
        NSString *vTitleStr = [lDic objectForKey:TITLEKEY];
        NSString *vMonthStr = [lDic objectForKey:MONTHKEY];
        float vButtonWidth = [[lDic objectForKey:TITLEWIDTH] floatValue];
        TimeButton *vButton = [TimeButton buttonWithType:UIButtonTypeCustom];
        vButton.userInteractionEnabled=YES;
        
        
        [vButton setBackgroundColor:RGB(114, 5, 147)];

        //[vButton setBackgroundImage:[UIImage imageNamed:@"portrait_bg"] forState:UIControlStateSelected];
        //        [vButton setTitle:vTitleStr forState:UIControlStateNormal];
        //        [vButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        [vButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [vButton setTag:i];
        [vButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [vButton setFrame:CGRectMake(menuWidth, 0, vButtonWidth, self.frame.size.height)];
        
        //title
        vButton.weekLal=[[UILabel alloc]initWithFrame:CGRectMake(20, 10,20, 14)];
        vButton.weekLal.text=weekStr;
        vButton.weekLal.font=[UIFont systemFontOfSize:10];
        vButton.weekLal.backgroundColor=[UIColor clearColor];
        vButton.weekLal.textColor =RGB(255, 255, 255);
        vButton.weekLal.textAlignment=1;
        [vButton addSubview:vButton.weekLal];
        
        
        vButton.titleLal =[[UILabel alloc]initWithFrame:CGRectMake(11, 28,40, 10)];
        vButton.titleLal.text= [NSString stringWithFormat:@"%@月%@日",vMonthStr, vTitleStr];
        vButton.titleLal.font=[UIFont systemFontOfSize:9];
        vButton.titleLal.backgroundColor=[UIColor clearColor];
        vButton.titleLal.alpha = 0.7;
        vButton.titleLal.textColor =RGB(255, 255, 255);
        vButton.titleLal.textAlignment=1;
        [vButton addSubview:vButton.titleLal];
        //
        if(i==0){
            [vButton setSelected:true];
        }
        [mScrollView addSubview:vButton];
        [mButtonArray addObject:vButton];
        
        menuWidth += vButtonWidth;
        i++;
        
        //保存button资源信息，同时增加button.oringin.x的位置，方便点击button时，移动位置。
        NSMutableDictionary *vNewDic = [lDic mutableCopy];
        [vNewDic setObject:[NSNumber numberWithFloat:menuWidth] forKey:TOTALWIDTH];
        [mItemInfoArray addObject:vNewDic];
    }
    
    [mScrollView setContentSize:CGSizeMake(menuWidth, self.frame.size.height)];
    [mScrollView setBackgroundColor: [UIColor clearColor]];//RGB(35, 166, 116)
    [self addSubview:mScrollView];
    // 保存menu总长度，如果小于320则不需要移动，方便点击button时移动位置的判断
    mTotalWidth = menuWidth;
}
#pragma mark - 其他辅助功能
#pragma mark 取消所有button点击状态
-(void)changeButtonsToNormalState{
    for (UIButton *vButton in mButtonArray) {
        vButton.selected = NO;
    }
}

#pragma mark 模拟选中第几个button
-(void)clickButtonAtIndex:(NSInteger)aIndex{
    self.selectIndex=aIndex;
    UIButton *vButton = [mButtonArray objectAtIndex:aIndex];
    [self menuButtonClicked:vButton];
}

#pragma mark 改变第几个button为选中状态，不发送delegate
-(void)changeButtonStateAtIndex:(NSInteger)aIndex{
    self.selectIndex=aIndex;
    UIButton *vButton = [mButtonArray objectAtIndex:aIndex];
    [self changeButtonsToNormalState];
    vButton.selected = YES;
    [self moveScrolViewWithIndex:aIndex];
}

#pragma mark 移动button到可视的区域
-(void)moveScrolViewWithIndex:(NSInteger)aIndex{
    if (mItemInfoArray.count < aIndex) {
        return;
    }
     //宽度小于320肯定不需要移动
    if (mTotalWidth <= 320) {
        return;
    }
    NSDictionary *vDic = [mItemInfoArray objectAtIndex:aIndex];
    float vButtonOrigin = [[vDic objectForKey:TOTALWIDTH] floatValue];
    if (vButtonOrigin >= 300) {
        if ((vButtonOrigin + 180) >= mScrollView.contentSize.width) {
            [mScrollView setContentOffset:CGPointMake(mScrollView.contentSize.width - 320, mScrollView.contentOffset.y) animated:YES];
            return;
        }
        
        float vMoveToContentOffset = vButtonOrigin - 180;
        if (vMoveToContentOffset > 0) {
            [mScrollView setContentOffset:CGPointMake(vMoveToContentOffset, mScrollView.contentOffset.y) animated:YES];
        }
//        NSLog(@"scrollwOffset.x:%f,ButtonOrigin.x:%f,mscrollwContentSize.width:%f",mScrollView.contentOffset.x,vButtonOrigin,mScrollView.contentSize.width);
    }else{
        [mScrollView setContentOffset:CGPointMake(0, mScrollView.contentOffset.y) animated:YES];
            return;
    }
}

#pragma mark - 点击事件
-(void)menuButtonClicked:(UIButton *)aButton{
    [self changeButtonStateAtIndex:aButton.tag];
    if ([_delegate respondsToSelector:@selector(didMenuHrizontalClickedButtonAtIndex:)]) {
        [_delegate didMenuHrizontalClickedButtonAtIndex:aButton.tag];
    }
}


#pragma mark 内存相关
-(void)dealloc{
    [mButtonArray removeAllObjects],mButtonArray = nil;
}

@end
