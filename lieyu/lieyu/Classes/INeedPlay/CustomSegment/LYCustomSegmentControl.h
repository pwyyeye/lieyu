//
//  LYCustomSegmentControl.h
//  lieyu
//
//  Created by newfly on 9/27/15.
//  Copyright © 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectItem)(NSInteger index);

@interface LYCustomSegmentControl : UIView

@property(nonatomic ,strong)UIColor * selectedColor;
@property(nonatomic ,strong)UIColor * titleColor;
@property(nonatomic ,strong)UIFont * font;
@property(nonatomic, assign)NSInteger selectedIndex;

@property(nonatomic ,copy)selectItem selectedItem;

- (LYCustomSegmentControl *)initWithTitleItems:(NSArray *)ary frame:(CGRect)frame;


@end



