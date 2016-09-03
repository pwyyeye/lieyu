//
//  HomepageHotBarsTableViewCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/8/29.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomepageHotBarsTableViewCell <NSObject>

- (void)chooseIndex:(NSInteger)index;

@end

@interface HomepageHotBarsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *checkHotBarsButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@property (nonatomic, strong) NSArray *barList;

@end
