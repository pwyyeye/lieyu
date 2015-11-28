//
//  LYWineBarInfoCell.h
//  lieyu
//
//  Created by newfly on 9/14/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYWineBarInfoCell : UITableViewCell<LYTableViewCellLayout>
@property (nonatomic,unsafe_unretained) BOOL hidden;
@property (weak, nonatomic) IBOutlet UILabel *label_line_red;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_fire;
@property (weak, nonatomic) IBOutlet UILabel *label_hot;
@property (weak, nonatomic) IBOutlet UILabel *label_line;

@property (weak, nonatomic) IBOutlet UIImageView *imageView_header;

@property (weak, nonatomic) IBOutlet UILabel *label_jiuba;
@property (weak, nonatomic) IBOutlet UILabel *label_descr;
@property (weak, nonatomic) IBOutlet UILabel *label_price;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_content;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_point;
@property (weak, nonatomic) IBOutlet UILabel *label_point;
@property (weak, nonatomic) IBOutlet UILabel *labl_line_top;
@property (weak, nonatomic) IBOutlet UILabel *label_line_bottom;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_rectangle;
@property (weak, nonatomic) IBOutlet UILabel *label_fanli;
@property (weak, nonatomic) IBOutlet UIView *view_bottom;
@property (weak, nonatomic) IBOutlet UILabel *label_fanli_percent;

@property (weak, nonatomic) IBOutlet UIImageView *imageView_star;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_zang;
@property (weak, nonatomic) IBOutlet UILabel *label_star_count;
@property (weak, nonatomic) IBOutlet UILabel *label_zang_count;

@property (weak, nonatomic) IBOutlet UIButton *btn_star;
@property (weak, nonatomic) IBOutlet UIButton *btn_zang;

@end
