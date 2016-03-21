//
//  LYFriendsSendViewController.h
//  lieyu
//
//  Created by 狼族 on 15/12/25.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "preview.h"
#import "LYFriendsChooseLocationViewController.h"
@protocol sendBackVedioAndImage <NSObject>

- (void)sendVedio:(NSString *)mediaUrl andImage:(UIImage *)image andContent:(NSString *)content andLocation:(NSString *)location;
- (void)sendImagesArray:(NSArray *)imagesArray andContent:(NSString *)content andLocation:(NSString *)location;
- (void)sendSucceed:(NSString *)messageId;//发布成功以后

@end

@interface LYFriendsSendViewController : LYBaseViewController<UIActionSheetDelegate,UINavigationControllerDelegate,PullLocationInfo>
@property (nonatomic, strong) NSString *TopicID;//话题ID
@property (nonatomic, strong) NSString *TopicTitle;//话题名称

@property (nonatomic, strong) NSString *type;//话题类型
@property (nonatomic, strong) NSString *barid;//酒吧名字


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

@property (nonatomic, assign) id<sendBackVedioAndImage> delegate;

- (void)imagePickerSpecificOperation:(NSDictionary<NSString *,id> *)info;
- (void)YBImagePickerDidFinishWithImages:(NSArray *)imageArray;

@end
