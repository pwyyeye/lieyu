//
//  YBImgPickerViewCell.m
//  settingsTest
//
//  Created by 宋奕兴 on 15/9/7.
//  Copyright (c) 2015年 宋奕兴. All rights reserved.
//

#import "YBImgPickerViewCell.h"
@interface YBImgPickerViewCell ()
@property (nonatomic , strong) IBOutlet UIImageView * mainImageView;
@property (nonatomic , strong) IBOutlet UIImageView * isChoosenImageView;

@end
@implementation YBImgPickerViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setContentImg:(UIImage *)contentImg {
    if (contentImg) {
        __weak typeof(self) weakself = self;
        _contentImg = contentImg;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            weakself.mainImageView.image = nil;
            weakself.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
            weakself.mainImageView.clipsToBounds = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
            
                weakself.mainImageView.image = _contentImg;
            });
        });
//        self.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
//        self.mainImageView.clipsToBounds = YES;
//        self.mainImageView.image = _contentImg;
    }
}

- (void)setIsChoosen:(BOOL)isChoosen {
    _isChoosen = isChoosen;
    [UIView animateWithDuration:0.2 animations:^{
        if (isChoosen) {
            self.isChoosenImageView.image = [UIImage imageNamed:@"YBimgPickerView.bundle/isChoosenY"];
            
        }else {
            self.isChoosenImageView.image = nil;
        }
        self.isChoosenImageView.transform = CGAffineTransformMakeScale (1.1,1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.isChoosenImageView.transform = CGAffineTransformMakeScale (1.0,1.0);
        } completion:^(BOOL finished) {
            
        }];
    }];
    
}
- (void)setIsChoosenImgHidden:(BOOL)isChoosenImgHidden {
    _isChoosenImgHidden = isChoosenImgHidden;
    self.isChoosenImageView.hidden = isChoosenImgHidden;
}
@end
