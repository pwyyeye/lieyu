//
//  UserCenterCell.m
//  lieyu
//
//  Created by pwy on 15/11/29.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYUserCenterCell.h"

@implementation LYUserCenterCell

- (void)awakeFromNib {
    // Initialization code
    self.icon.contentMode = UIViewContentModeScaleAspectFit;
    //重置之前的layer
    if (self.layer.sublayers.count>1) {
        CALayer *restLayer=self.layer.sublayers.lastObject;
        //        restLayer.frame=CGRectZero;
        
        [restLayer removeFromSuperlayer];
    }
    
    CGFloat layerShdowWidth = SCREEN_WIDTH / 3.f;
    
    CALayer *layerShadowTop=[[CALayer alloc]init];
    layerShadowTop.frame=CGRectMake(0, 0, layerShdowWidth,0.5);
    layerShadowTop.borderColor=[RGBA(0, 0, 0, 0.1) CGColor];
    layerShadowTop.borderWidth=0.5;
    
//    [self.layer addSublayer:layerShadowTop];
    //做右边的分割线
//    _layerShadowRight=[[CALayer alloc]init];
//    _layerShadowRight.frame=CGRectMake(layerShdowWidth-0.5, 0,0.5,layerShdowWidth);
//    _layerShadowRight.borderColor=[RGBA(0, 0, 0, 0.1) CGColor];
//    _layerShadowRight.borderWidth=0.5;
//    
//    [self.layer addSublayer:_layerShadowRight];
    
    
    _layerShadowBottom=[[CALayer alloc]init];
    _layerShadowBottom.frame=CGRectMake(17, 39.5,SCREEN_WIDTH - 17,0.5);
    _layerShadowBottom.borderColor=[RGBA(0, 0, 0, 0.1) CGColor];
    _layerShadowBottom.borderWidth=0.5;
    
    [self.layer addSublayer:_layerShadowBottom];
    [self bringSubviewToFront:self];
    
    self.backgroundColor=[UIColor whiteColor];
    
    _icon.contentMode=UIViewContentModeScaleAspectFit;
    
    _btn_count.layer.cornerRadius = CGRectGetHeight(_btn_count.frame)/2.f;
    _btn_count.layer.masksToBounds = YES;
    
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"LYUserCenterCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

@end
