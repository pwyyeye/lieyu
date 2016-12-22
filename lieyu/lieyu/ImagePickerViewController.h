//
//  ImagePickerViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/1/19.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYBaseViewController.h"

@protocol ImagePickerFinish <NSObject>
- (void)ImagePickerDidFinishWithImages:(NSArray *)imageArray;
@end


typedef NS_ENUM(NSInteger, PickerType)
{
    pickImages = 0,
    pickVideo,
};

@interface ImagePickerViewController : LYBaseViewController
@property (nonatomic, assign) int imagesCount;

@property (nonatomic, assign) id<ImagePickerFinish> delegate;

@property (nonatomic, assign)  PickerType pickType;

@end
