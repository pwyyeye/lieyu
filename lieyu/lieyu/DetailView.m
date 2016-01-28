//
//  DetailView.m
//  lieyu
//
//  Created by 王婷婷 on 16/1/26.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "DetailView.h"
#import "UIImageView+WebCache.h"
@implementation DetailView
- (void)awakeFromNib{
    _collect_btn.hidden = YES;
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
}

- (void)Configure{
//    _tcModel = model;
    self.title_lbl.text = _tcModel.title;
    self.buyed_lbl.text = [NSString stringWithFormat:@"%d人购",_tcModel.buynum];
    self.fitNum_lbl.text = [NSString stringWithFormat:@"(适合%d-%d人)",_tcModel.minnum,_tcModel.maxnum];
    self.price_lbl.text = [NSString stringWithFormat:@"¥%@",_packModel.price];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",_packModel.marketprice] attributes:attribtDic];
    self.marketPrice_lbl.attributedText = attribtStr;
    CGFloat rebate = [_packModel.rebate floatValue];
    CGFloat profit = [_packModel.price intValue] * rebate;
    NSString *percentStr =[NSString stringWithFormat:@"返利:%.0f元",profit];
    self.profit_lbl.text = percentStr;
    //tableView---data
    self.content_table.delegate = self;
    self.content_table.dataSource = self;
    if(_tcModel.goodsList.count <= 3){
        _content_table.scrollEnabled = NO;
        _tableHeight.constant = 128 / 3 * _tcModel.goodsList.count;
    }else{
        _tableHeight.constant = 128;
    }
    _content_table.separatorColor = [UIColor clearColor];
    //scrollView---data
    imagesArray = [_tcModel.linkUrl componentsSeparatedByString:@","];
    _image_scroll.showsHorizontalScrollIndicator = NO;
    _image_scroll.showsVerticalScrollIndicator = NO;
    _scrollHeight.constant = SCREEN_WIDTH / 3 - 20;
    _image_scroll.contentSize = CGSizeMake(26 + (SCREEN_WIDTH / 3 - 14) * imagesArray.count, SCREEN_WIDTH / 3 - 20);
    for (int i = 0 ; i < imagesArray.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(16 + (SCREEN_WIDTH / 3 - 14) * i, 0, SCREEN_WIDTH / 3 - 20, SCREEN_WIDTH / 3 - 20)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imagesArray[i]] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        UIButton *button = [[UIButton alloc]initWithFrame:imageView.frame];
        button.tag = i;
        [button addTarget:self action:@selector(tapImage:) forControlEvents:UIControlEventTouchUpInside];
        
        [_image_scroll addSubview:imageView];
        [_image_scroll addSubview:button];
    }
}

- (void)tapImage:(UIButton *)sender{
    int tag = sender.tag;
    
    NSArray *urlArray = [imagesArray[tag] componentsSeparatedByString:@"?"];
    if([_delegate respondsToSelector:@selector(showImageInPreview:)]){
        [_delegate showImageInPreview:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlArray[0]]]]];
    }
//    _subView = [[[NSBundle mainBundle]loadNibNamed:@"preview" owner:nil options:nil]firstObject];
//    _subView.frame = CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT);
//    _subView.button.hidden = YES;
//    [_subView.imageView sd_setImageWithURL:[NSURL URLWithString:imagesArray[tag]] placeholderImage:[UIImage imageNamed:@"empyImage300"]];
//    _subView.imageView.center = _subView.center;
//    [self addSubview:_subView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tcModel.goodsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailView_cell"];
//    if(!cell){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailView_cell"];
        
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(16, 12, 135, 18)];
        name.textColor = [UIColor blackColor];
        name.font = [UIFont systemFontOfSize:14];
        name.textAlignment = NSTextAlignmentLeft;
        name.tag = 1;
        
        UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 - 13, 12, 26, 18)];
        number.textColor = [UIColor blackColor];
        number.font = [UIFont systemFontOfSize:14];
        number.textAlignment = NSTextAlignmentCenter;
        number.tag = 2;
        
        UILabel *money = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 116, 12, 100, 18)];
        money.textAlignment = NSTextAlignmentRight;
        money.textColor = [UIColor blackColor];
        money.font = [UIFont systemFontOfSize:14];
        money.tag = 3;
        
        [cell addSubview:name];
        [cell addSubview:number];
        [cell addSubview:money];
//    }
    KuCunModel *model = [_tcModel.goodsList objectAtIndex:indexPath.row];
//    UILabel *name = [cell viewWithTag:1];
    name.text = model.name;
//    UILabel *number = [cell viewWithTag:2];
    number.text = [NSString stringWithFormat:@"%@%@",model.num,model.unit];
//    UILabel *money = [cell viewWithTag:3];
    NSString *priceTotle = [NSString stringWithFormat:@"%d",model.price.integerValue * model.num.integerValue];
    money.text = [NSString stringWithFormat:@"¥%@",priceTotle];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 128 / 3;
}

@end
