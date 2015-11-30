//
//  SelectButton.m
//  lieyu
//
//  Created by 王婷婷 on 15/11/30.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LPSelectButton.h"

@implementation LPSelectButton

/**
 *description:
 传入参数：dict:
 fontName   字体
 fontSize   大小
 textColor  颜色
 content    内容
 imageW     图片宽
 imageH     图片高
 imageUnSelectedName  未选择的图片
 imageSelectedName    已选择的图片
 itemsArray 供选择项目数组
 传入参数：frame   按钮frame
 *author:WTT
 */

- (id)initWithFrame:(CGRect)frame AndDictionary:(NSDictionary *)dict{
    if(self = [super init]){
        self.dict = dict;
        
        NSLog(@"dict:%@",dict);
        
        self.frame = frame;
        _contentLbl = [[UILabel alloc]init];
        [self addSubview:_contentLbl];
        
        _imageIcon = [[UIImageView alloc]init];
        _imageIcon.backgroundColor = [UIColor redColor];
        [self addSubview:_imageIcon];
        
        _contentLbl.font = [UIFont systemFontOfSize:[dict[@"fontSize"] floatValue]];
        _contentLbl.textColor = RGBA(30, 30, 30, 1);
        CGSize size = [dict[@"content"] sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:[dict[@"fontSize"] floatValue]], NSFontAttributeName,nil]];
        CGFloat nameH = size.height;
        CGFloat nameW = size.width;
        CGFloat imageH = [dict[@"imageH"]intValue];
        CGFloat imageW = [dict[@"imageW"] intValue];
        
        _contentLbl.frame = CGRectMake((frame.size.width - nameW - imageW) / 2, (frame.size.height - nameH) / 2, nameW, nameH);
        _imageIcon.frame = CGRectMake(_contentLbl.frame.origin.x + nameW, (self.frame.size.height - imageH) / 2, imageW, imageH);
        _contentLbl.text = dict[@"content"];
        _imageIcon.image = [UIImage imageNamed:dict[@"imageUnSelectedName"]];

//        [self addTarget:self action:@selector(selectChangeImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}




//- (void)selectChangeImage:(LPSelectButton *)button{
//    NSLog(@"button.tag:%ld",button.tag);
//    if(button.selected == YES){
//        button.selected = NO;
//    }else{
//        button.selected = YES;
//    }
//    if(button.selected == YES){
//        button.imageIcon.image = [UIImage imageNamed:self.dict[@"imageSelectedName"]];
//    }else{
//        button.imageIcon.image = [UIImage imageNamed:self.dict[@"imageUnSelectedName"]];
//    }
////    CGAffineTransform rotation = CGAffineTransformMakeRotation(0);
////    [self.imageIcon setTransform:rotation];
//}

@end
