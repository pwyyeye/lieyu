//
//  LPBuyManagerCell.h
//  lieyu
//
//  Created by 王婷婷 on 15/12/2.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectManager<NSObject>

- (void)selectManager:(int) index;

@end


@interface LPBuyManagerCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
{
    BOOL notFirstLayout;
}
@property (nonatomic, strong) NSArray *managerList;

@property (nonatomic, assign) id<SelectManager> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableVIew;

- (void)cellConfigure;

@end
