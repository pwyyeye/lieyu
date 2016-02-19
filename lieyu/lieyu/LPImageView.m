//
//  LPImageView.m
//  lieyu
//
//  Created by 王婷婷 on 16/2/19.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LPImageView.h"

@implementation LPImageView

- (CGSize)intrinsicContentSize {
    
    CGSize s =[super intrinsicContentSize];
    
    s.height = self.frame.size.width / self.image.size.width  * self.image.size.height;
    
    return s;
    
}

@end
