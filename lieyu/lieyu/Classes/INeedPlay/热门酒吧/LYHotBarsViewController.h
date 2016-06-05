//
//  LYHotBarViewController.h
//  lieyu
//
//  Created by lin on 16/1/26.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "LYGuWenOutsideCollectionViewCell.h"

@interface LYHotBarsViewController : LYBaseViewController{
    NSArray *_btnTitleArray;
    NSMutableArray *_dataArray;
    UICollectionView *_collectView;
    NSMutableArray *_menuBtnArray;
    UIView *_purpleLineView;
    NSInteger _index;
    UIVisualEffectView *_menuView;
    UILabel *_titelLabel;
}
@property (nonatomic,copy) NSString *subidStr;
@property (nonatomic,unsafe_unretained) NSInteger contentTag;
@property (nonatomic,copy) NSString *titleText;
//@property (strong, nonatomic) UIVisualEffectView *menuView;
@property (nonatomic,unsafe_unretained) BOOL isGuWenListVC;//是否事顾问列表界面
@property (nonatomic,unsafe_unretained) BOOL isVideoListVC;//是否是直播列表界面
//@property (strong, nonatomic) NSMutableArray *menuBtnArray;
//@property (nonatomic, strong) UIView *purpleLineView;
//@property (nonatomic, assign) NSInteger index;
//@property (nonatomic, strong) UICollectionView *collectView;

- (void)getDataForHotWith:(NSInteger)tag;//获取数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
#pragma mark - 创建菜单view
- (void)createMenuView;
@end
