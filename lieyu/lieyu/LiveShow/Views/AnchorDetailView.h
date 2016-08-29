//
//  AnchorDetailView.h
//  lieyu
//
//  Created by 狼族 on 16/8/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnchorDetailView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *anchorIcon;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *genderIamge;

@property (weak, nonatomic) IBOutlet UILabel *starlabel;

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@property (weak, nonatomic) IBOutlet UIButton *focusButton;

@property (weak, nonatomic) IBOutlet UIButton *secretMaeeageButton;

@property (weak, nonatomic) IBOutlet UIButton *mainViewButton;

- (IBAction)closeButtonAction:(UIButton *)sender;


@end
