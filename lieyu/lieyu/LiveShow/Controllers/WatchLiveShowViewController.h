//
//  WatchLiveShowViewController.h
//  lieyu
//
//  Created by 狼族 on 16/8/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCMessageBaseCell.h"
#import "RCMessageModel.h"
#import <RongIMToolKit/RongIMToolKit.h>
#import <RongIMToolKit/RCInputBarControl.h>
#import "RongIMKit.h"

#import "roomHostUser.h"

///输入栏扩展输入的唯一标示
#define PLUGIN_BOARD_ITEM_ALBUM_TAG    1001
#define PLUGIN_BOARD_ITEM_CAMERA_TAG   1002
#define PLUGIN_BOARD_ITEM_LOCATION_TAG 1003
#if RC_VOIP_ENABLE
#define PLUGIN_BOARD_ITEM_VOIP_TAG     1004
#endif

@interface WatchLiveShowViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, UIScrollViewDelegate,RCMessageCellDelegate, UIGestureRecognizerDelegate,UITextFieldDelegate,
UIScrollViewDelegate, UINavigationControllerDelegate,RCInputBarControlDelegate,RCIMConnectionStatusDelegate>

@property (nonatomic, strong) NSString *chatRoomId;

@property (nonatomic, strong) NSString *stream;//直播流

#pragma mark - 会话属性

/*!
 当前会话的会话类型
 */
@property(nonatomic) RCConversationType conversationType;

/*!
 是否全屏模式
 */

@property(nonatomic, assign) BOOL isFullScreen;

/*!
 播放内容地址
 */
@property(nonatomic, strong) NSString *contentURL;
@property (nonatomic, strong) NSDictionary *hostUser;//主播
@property (nonatomic, strong) UIImage *shareIamge;//分享图片
@property (nonatomic, strong) NSString *joinNum;//回放时主播标签显示总共观看的人数
@property (nonatomic, strong) NSString *shareText;//分享文字

#pragma mark - 聊天界面属性

/*!
 聊天内容的消息Cell数据模型的数据源
 
 @discussion 数据源中存放的元素为消息Cell的数据模型，即RCMessageModel对象。
 */
@property(nonatomic, strong) NSMutableArray<RCMessageModel *> *conversationDataRepository;

/*!
 消息列表CollectionView和输入框都在这个view里
 */
@property(nonatomic, strong) UIView *contentView;
/**
 *  当前融云连接状态
 */
@property (nonatomic, assign) RCConnectionStatus currentConnectionStatus;
/*!
 聊天界面的CollectionView
 */
@property(nonatomic, strong) UICollectionView *conversationMessageCollectionView;

#pragma mark - 输入工具栏

@property(nonatomic,strong) RCInputBarControl *inputBar;

#pragma mark - 显示设置
/*!
 设置进入聊天室需要获取的历史消息数量（仅在当前会话为聊天室时生效）
 
 @discussion 此属性需要在viewDidLoad之前进行设置。
 -1表示不获取任何历史消息，0表示不特殊设置而使用SDK默认的设置（默认为获取10条），0<messageCount<=50为具体获取的消息数量,最大值为50。
 */
@property(nonatomic, assign) int defaultHistoryMessageCountOfChatRoom;

@end
