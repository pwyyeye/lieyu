//
//  LYFriendsSendViewController.h
//  lieyu
//
//  Created by 狼族 on 15/12/25.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "YBImgPickerViewController.h"
#import "preview.h"
#import "LYFriendsChooseLocationViewController.h"

@interface LYFriendsSendViewController : LYBaseViewController<UIActionSheetDelegate,UINavigationControllerDelegate,YBImgPickerViewControllerDelegate,PullLocationInfo>

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;


@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) MPMoviePlayerController *player;
@property (nonatomic, strong) preview *subView;

@property (nonatomic, strong) NSString *typeOfImagePicker;
@property (nonatomic, assign) int pageCount;
@property (nonatomic, assign) int initCount;
@property (nonatomic, assign) BOOL isVedio;

@property (nonatomic, strong) NSMutableArray *fodderArray;//删除素材时就删除这里面的元素
@property (nonatomic, strong) NSMutableArray *imageViewArray;//imageView的所有元素
@property (nonatomic, strong) NSMutableString *mediaUrl;

- (void)imagePickerSpecificOperation:(NSDictionary<NSString *,id> *)info;
- (void)YBImagePickerDidFinishWithImages:(NSArray *)imageArray;

@end
