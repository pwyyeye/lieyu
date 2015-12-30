//
//  preview.m
//  播放器
//
//  Created by 王婷婷 on 15/12/26.
//  Copyright © 2015年 王婷婷. All rights reserved.
//

#import "preview.h"

@implementation preview

- (void)awakeFromNib{
}

- (void)viewConfigure{
    [self.button setImage:[UIImage imageNamed:@"imageSelected"] forState:UIControlStateNormal];
    self.imageView.image = self.image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.button.selected = YES;
}

@end
