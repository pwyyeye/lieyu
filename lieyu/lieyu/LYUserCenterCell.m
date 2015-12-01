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
    
    //重置之前的layer
    if (self.layer.sublayers.count>1) {
        CALayer *restLayer=self.layer.sublayers.lastObject;
        //        restLayer.frame=CGRectZero;
        
        [restLayer removeFromSuperlayer];
    }
    
    CALayer *layerShadowTop=[[CALayer alloc]init];
    layerShadowTop.frame=CGRectMake(0, 0.5, self.frame.size.width,0.5);
    layerShadowTop.borderColor=[RGBA(0, 0, 0, 0.1) CGColor];
    layerShadowTop.borderWidth=0.5;
    
    [self.layer addSublayer:layerShadowTop];
    
    
    CALayer *layerShadowRight=[[CALayer alloc]init];
    layerShadowRight.frame=CGRectMake(self.frame.size.height-0.5, 0,0.5,self.frame.size.height);
    layerShadowRight.borderColor=[RGBA(0, 0, 0, 0.1) CGColor];
    layerShadowRight.borderWidth=0.5;
    
    [self.layer addSublayer:layerShadowRight];
    [self bringSubviewToFront:self];
    
    self.backgroundColor=[UIColor whiteColor];
    
    _icon.contentMode=UIViewContentModeScaleAspectFit;
    
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
