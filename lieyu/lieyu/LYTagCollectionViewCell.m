//
//  LYTagCollectionViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/12/22.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYTagCollectionViewCell.h"
#import "UserTagModel.h"

@implementation LYTagCollectionViewCell
- (void)drawRect:(CGRect)rect{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = RGBA(220, 231, 239, 1).CGColor;
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
}

- (void)deployCellWith:(UserTagModel *)tagM index:(NSInteger)index selectedTagM:(UserTagModel *)selectedTagM{
    _tagLabel = [[LYTagLabel alloc]initWithFrame:CGRectMake(0, 0, 90, 32)];
    self.tagLabel.backgroundColor = RGBA(255, 255, 255, 1);
    self.tagLabel.textColor = RGBA(102,102,102, 1);
    _tagLabel.font = [UIFont systemFontOfSize:16];
    _tagLabel.textAlignment = NSTextAlignmentCenter;
    _tagLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:_tagLabel];
    self.tagLabel.text = tagM.name;
//    if ([tagM.name isEqualToString:selectedTagM.tagname]) {
//        if ([_delegate respondsToSelector:@selector(selectedCellWith:)]) {
//            [_delegate selectedCellWith:index];
//        }
//    }
}

- (void)setSelected:(BOOL)selected{
    if (selected) {
        self.tagLabel.backgroundColor = RGBA(114, 5, 147, 1);
        self.tagLabel.textColor = RGBA(255,255,255, 1);
    }else{
        self.tagLabel.backgroundColor = RGBA(255, 255, 255, 1);
        self.tagLabel.textColor = RGBA(102,102,102, 1);
    }
}


@end
