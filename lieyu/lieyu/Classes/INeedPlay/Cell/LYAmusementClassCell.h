//
//  LYAmusementClassCell.h
//  lieyu
//
//  Created by 狼族 on 15/11/27.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYAmusementClassCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label_lineTop;
@property (weak, nonatomic) IBOutlet UILabel *label_line_blue;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_line_Three;
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UIButton *button_page_left;
@property (weak, nonatomic) IBOutlet UIButton *button_page_right;
@property (weak, nonatomic) IBOutlet UILabel *label_line_middle;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *label_line_bottom;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViewArray;


@end
