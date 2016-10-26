//
//  RegisterLiveShowView.h
//  lieyu
//
//  Created by 狼族 on 16/8/18.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterLiveShowView : UIView

@property (nonatomic, copy) void(^beginLive)(CGFloat);
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIButton *shiftCamreButton;

@property (weak, nonatomic) IBOutlet UISlider *beautifySlider;

@property (copy, nonatomic) void(^begainImage)(UIImage *);

@property (nonatomic, strong) NSString *streamID;

@property (nonatomic, strong) NSString *roomId;//生成直播间ID

@property (nonatomic, strong) NSString *shareText;//分享文字

@end
