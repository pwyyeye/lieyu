//
//  DetailView.h
//  lieyu
//
//  Created by 王婷婷 on 16/1/26.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendPackageModel.h"
#import "TaoCanModel.h"
#import "LYHomePageHttpTool.h"
#import "LYTaoCanListTableViewCell.h"
#import "KuCunModel.h"
#import "preview.h"
@protocol showImageInPreview <NSObject>
- (void)showImageInPreview:(UIImage *)image;
@end

@interface DetailView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *imagesArray;
}
@property (weak, nonatomic) IBOutlet UILabel *title_lbl;
@property (weak, nonatomic) IBOutlet UILabel *buyed_lbl;
@property (weak, nonatomic) IBOutlet UILabel *fitNum_lbl;
@property (weak, nonatomic) IBOutlet UIButton *collect_btn;
@property (weak, nonatomic) IBOutlet UIScrollView *image_scroll;
@property (weak, nonatomic) IBOutlet UITableView *content_table;
@property (weak, nonatomic) IBOutlet UILabel *price_lbl;
@property (weak, nonatomic) IBOutlet UILabel *marketPrice_lbl;
@property (weak, nonatomic) IBOutlet UILabel *profit_lbl;

@property (nonatomic, strong) RecommendPackageModel *packModel;
@property (nonatomic, strong) TaoCanModel *tcModel;
@property (nonatomic, strong) PinKeModel *pkModel;
@property (nonatomic, strong) preview *subView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;

@property (nonatomic, assign) id<showImageInPreview> delegate;

- (void)Configure;
- (void)fillPinkeModel:(PinKeModel *)model;
@end
