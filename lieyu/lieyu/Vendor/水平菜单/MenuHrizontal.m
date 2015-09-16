//
//  MenuHrizontal.m
//  ShowProduct
//
//  Created by lin on 14-5-22.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import "MenuHrizontal.h"

#define BUTTONITEMWIDTH   70

@implementation MenuHrizontal
- (id)initWithFrame:(CGRect)frame ButtonItems:(NSArray *)aItemsArray
{
    self = [super initWithFrame:frame];
    if (self) {
        if (mButtonArray == nil) {
            mButtonArray = [[NSMutableArray alloc] init];
        }
        if (mScrollView == nil) {
            mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            mScrollView.backgroundColor=RGB(255, 13, 94);
            mScrollView.showsHorizontalScrollIndicator = NO;
        }
        if (mItemInfoArray == nil) {
            mItemInfoArray = [[NSMutableArray alloc]init];
        }
        [mItemInfoArray removeAllObjects];
        [self createMenuItems:aItemsArray];
    }
    return self;
}


-(void)createMenuItems:(NSArray *)aItemsArray{
    int i = 0;
    float menuWidth = 0.0;
    //
    for (NSDictionary *lDic in aItemsArray) {
        NSDictionary *lDic=aItemsArray[i];
        NSString *vNormalImageStr = [lDic objectForKey:NOMALKEY];
        NSString *vHeligtImageStr = [lDic objectForKey:HEIGHTKEY];
        NSString *vTitleStr = [lDic objectForKey:TITLEKEY];
        float vButtonWidth = [[lDic objectForKey:TITLEWIDTH] floatValue];
        UIButton *vButton = [UIButton buttonWithType:UIButtonTypeCustom];
        vButton.userInteractionEnabled=YES;
        CGSize imageSize = CGSizeMake(vButtonWidth, self.frame.size.height);
        UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
        [RGB(255, 13, 94) set];
        UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
        UIImage *normalImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        

        UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
        [hexColor(@"#e30d55") set];
        UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
        UIImage *secImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        [vButton setBackgroundImage:normalImg forState:UIControlStateNormal];
        [vButton setBackgroundImage:secImg forState:UIControlStateSelected];
//        [vButton setTitle:vTitleStr forState:UIControlStateNormal];
//        [vButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [vButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [vButton setTag:i];
        [vButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [vButton setFrame:CGRectMake(menuWidth, 0, vButtonWidth, self.frame.size.height)];
        if(i==0){
            [vButton setSelected:true];
        }
        //添加图片和title；
        UrlImageView *icomImg=[[UrlImageView alloc]initWithFrame:CGRectMake(vButton.width/2-27/2, 3, 27, 27)];
        
        NSRange range = [vNormalImageStr rangeOfString:@"http"];//判断字符串是否包含
        [icomImg setBackgroundColor:[UIColor clearColor]];
        //包含
        if (range.length >0){
            [icomImg setImageWithURL:[NSURL URLWithString:vNormalImageStr]];
        }else{
            if([vNormalImageStr isEqualToString:@""]){
                switch (i) {
                    case 1:
                        [icomImg setImage:[UIImage imageNamed:@"Nav_icon_meizhuang"]];

                        break;
                    default:
                        [icomImg setImage:[UIImage imageNamed:@"NavBar_icon_SheChiPin"]];
                        break;
                }
            }else{
                [icomImg setImage:[UIImage imageNamed:vNormalImageStr]];
            }
            
        }
        [vButton addSubview:icomImg];
        //title
        UILabel *titlelbl=[[UILabel alloc]initWithFrame:CGRectMake(0, icomImg.top+icomImg.height+3,vButton.width, 10)];
        titlelbl.text=vTitleStr;
        titlelbl.font=[UIFont systemFontOfSize:12];
        titlelbl.backgroundColor=[UIColor clearColor];
        titlelbl.textColor =[UIColor whiteColor];
        titlelbl.textAlignment=1;
        [vButton addSubview:titlelbl];
        
        //
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

#pragma mark - 其他辅助功能
#pragma mark 取消所有button点击状态
-(void)changeButtonsToNormalState{
    for (UIButton *vButton in mButtonArray) {
        vButton.selected = NO;
    }
}

#pragma mark 模拟选中第几个button
-(void)clickButtonAtIndex:(NSInteger)aIndex{
    UIButton *vButton = [mButtonArray objectAtIndex:aIndex];
    [self menuButtonClicked:vButton];
}

#pragma mark 改变第几个button为选中状态，不发送delegate
-(void)changeButtonStateAtIndex:(NSInteger)aIndex{
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
