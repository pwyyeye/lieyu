//
//  CloseLiveShowView.h
//  lieyu
//
//  Created by 狼族 on 16/8/18.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CloseLiveShowView : UIView

@property (weak, nonatomic) IBOutlet UIButton *backButton;


@property (weak, nonatomic) IBOutlet UIButton *notSaveButton;


@property (strong, nonatomic) NSString *chatRoomID;
@property (strong, nonatomic) UIImage *begainImage;
@end