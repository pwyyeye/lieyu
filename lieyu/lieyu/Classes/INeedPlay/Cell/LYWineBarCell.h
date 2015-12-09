//
//  LYWineBarCell.h
//  lieyu
//
//  Created by 狼族 on 15/11/28.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JiuBaModel;

@interface LYWineBarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView_header;

@property (weak, nonatomic) IBOutlet UILabel *label_jiuba;
@property (weak, nonatomic) IBOutlet UILabel *label_descr;
@property (weak, nonatomic) IBOutlet UILabel *label_price;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_content;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_point;
@property (weak, nonatomic) IBOutlet UILabel *label_point;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_rectangle;
@property (weak, nonatomic) IBOutlet UILabel *label_fanli;
@property (weak, nonatomic) IBOutlet UILabel *label_fanli_percent;
@property (weak, nonatomic) IBOutlet UIView *viewLineTop;
@property (weak, nonatomic) IBOutlet UIView *viewLineBottom;

@property (weak, nonatomic) IBOutlet UIImageView *imageView_star;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_zang;
@property (weak, nonatomic) IBOutlet UILabel *label_star_count;
@property (weak, nonatomic) IBOutlet UILabel *label_zang_count;

@property (weak, nonatomic) IBOutlet UIButton *btn_star;
@property (weak, nonatomic) IBOutlet UIButton *btn_zang;

@property (nonatomic,strong) JiuBaModel *jiuBaModel;
@end
