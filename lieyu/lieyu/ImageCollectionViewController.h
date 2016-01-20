//
//  ImageCollectionViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/1/19.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ImageCollectionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, assign) int imagesCount;


@property (nonatomic, strong) void(^pushSuccessBlock)(NSArray *);

@end
