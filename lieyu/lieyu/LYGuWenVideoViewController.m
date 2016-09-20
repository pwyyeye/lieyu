//
//  LYGuWenVideoViewController.m
//  lieyu
//
//  Created by 狼族 on 16/6/4.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYGuWenVideoViewController.h"
#import "HotMenuButton.h"
#import "LYAdviserHttpTool.h"
#import "LYGuWenOutsideCollectionViewCell.h"
#import "LYFriendsAMessageDetailViewController.h"
#import "FriendsRecentModel.h"

#define margin (SCREEN_WIDTH - 240) / 3
#define LIMIT 10

@interface LYGuWenVideoViewController ()<LYGuWenCollectionDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,sendBackVedioAndImage>
{
    UIButton *filterBtn;
    
    UIView *_filterBgView;//筛选背景图
    UIVisualEffectView *_filterView;//筛选菜单毛玻璃
    
    NSArray *classArray ;
    NSMutableArray *_buttonsArray;
    
    NSInteger _filterFlag;
    
    NSInteger _start;
    NSString *_attachType;
    
    NSMutableArray *_dataList;
    
    BOOL _isChangedFilter;
    
    UILabel *_kongLabel;
    
    LYFriendsSendViewController *friendsSendVC;
}
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) NSMutableDictionary *notificationDict;
@property (nonatomic, strong) NSString *typeOfImagePicker;
@end

@implementation LYGuWenVideoViewController


- (void)dealloc{
//    NSLog(@"LYGuWenVideoViewController   dealloc    success");
}

#pragma - mark 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [self setupCarmerBtn];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [effectView removeFromSuperview];
}

- (void)viewDidLoad {
    _attachType = @"1";
    classArray = @[@"全部",@"顾问",@"玩友"];
    _dataList = [[NSMutableArray alloc]init];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 初始操作
- (void)createMenuView{
    [self createFilterView];
    
    UIBlurEffect *effectExtraLight = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    _menuView = [[UIVisualEffectView alloc]initWithEffect:effectExtraLight];
    _menuView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    _menuView.alpha = 5;
    _menuView.layer.shadowColor = RGBA(0, 0, 0, 1).CGColor;
    _menuView.layer.shadowOffset = CGSizeMake(0, 0.5);
//    _menuView.layer.shadowOpacity = 0.3;
    _menuView.layer.shadowRadius = 1;
    [self.view addSubview:_menuView];
    
    _titelLabel = [[UILabel alloc]init];
    _titelLabel.frame = CGRectMake(0, 30, SCREEN_WIDTH, 30);
    _titelLabel.textAlignment = NSTextAlignmentCenter;
    _titelLabel.text = @"直播";
    _titelLabel.font = [UIFont boldSystemFontOfSize:16];
    _titelLabel.textColor = [UIColor blackColor];
    [_menuView addSubview:_titelLabel];
    
    UIButton *backBtn = [[UIButton alloc]init];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(5, 30, 30, 30);
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_menuView addSubview:backBtn];
    
    filterBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 46, 33, 32, 22)];
    [filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
    filterBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [filterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [filterBtn addTarget:self action:@selector(filterClick:) forControlEvents:UIControlEventTouchUpInside];
    [_menuView addSubview:filterBtn];
}

//#pragma mark - 配置发布按钮
//- (void)setupCarmerBtn{
//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//    effectView = [[UIVisualEffectView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.f - 30, SCREEN_HEIGHT, 60, 60)];
//    effectView.layer.cornerRadius = effectView.frame.size.width/2.f;
//    effectView.layer.masksToBounds = YES;
//    effectView.effect = effect;
//    [self.view addSubview:effectView];
//    effectView.layer.zPosition = 5;
//    //发布按钮
//    _carmerBtn = [[UIButton alloc]initWithFrame:CGRectMake((effectView.frame.size.width - 35)/2.f,effectView.frame.size.height /2.f - 15, 35, 30)];
//    [_carmerBtn addTarget:self action:@selector(carmerClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_carmerBtn setBackgroundImage:[UIImage imageNamed:@"daohang_xiangji"] forState:UIControlStateNormal];
//    [effectView addSubview:_carmerBtn];
//    
//    //发布按钮出来动画
//    CGFloat offset = 60;
//    [UIView animateWithDuration:.4 animations:^{
//        effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - offset - 3, 60, 60);
//    }completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.2 animations:^{
//            effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - offset, 60, 60);
//        }];
//    }];
//}

- (void)createLineForMenuView{
    
}

- (void)createFilterView{
    
    _buttonsArray = [[NSMutableArray alloc]initWithCapacity:classArray.count];
    
    _filterBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0)];
    _filterBgView.backgroundColor = [UIColor colorWithWhite:.5 alpha:.2];
    UITapGestureRecognizer *tapFilter = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(filterHideAnimation)];
    [_filterBgView addGestureRecognizer:tapFilter];
    [self.view addSubview:_filterBgView];
    _filterBgView.hidden = YES;
    
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleExtraLight)];
    _filterView = [[UIVisualEffectView alloc]initWithEffect:effect];
    _filterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    _filterView.clipsToBounds = YES;
    [_filterBgView addSubview:_filterView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 42, 20)];
    [label setText:@"分类"];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setTextColor:RGBA(198, 38, 217, 1)];
    [_filterView addSubview:label];
    
    for (int i = 0; i < classArray.count; i ++) {
        HotMenuButton *button = [[HotMenuButton alloc]initWithFrame:CGRectMake(72 + i % 3 * (56 + margin), i / 3 * 35 + 20, 56, 20)];
        [button setTitle:[classArray objectAtIndex:i] forState:UIControlStateNormal];
        if (i == 0) {
            button.isGuWenSelected = YES;
        }else{
            button.isGuWenSelected = NO;
        }
        [button addTarget:self action:@selector(filterClass:) forControlEvents:UIControlEventTouchUpInside];
        [_filterView addSubview:button];
        [_buttonsArray addObject:button];
    }
}

#pragma mark - 筛选
- (void)filterClick:(UIButton *)button{
    if ([filterBtn.currentTitle isEqualToString:@"筛选"]) {
        [self filterShowAnimation];
    }else{
        [self filterHideAnimation];
    }
}

- (void)filterShowAnimation{
    _filterBgView.hidden = NO;
    [filterBtn setTitle:@"确定" forState:UIControlStateNormal];
    [filterBtn setTitleColor:RGBA(197, 55, 255, 1) forState:UIControlStateNormal];
    
    _filterBgView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    [UIView animateWithDuration:0.5 animations:^{
        [_filterView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, [classArray count] / 3 * 20 + 40)];
    } completion:^(BOOL finished) {
        
    }];

}

- (void)filterHideAnimation{
    [filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [filterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    _filterBgView.frame = CGRectMake(0,  64, SCREEN_WIDTH, 0);
    
    [UIView animateWithDuration:0.5 animations:^{
        _filterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        _filterBgView.hidden = YES;
        if (_isChangedFilter == YES) {
            _start = 0 ;
            _isChangedFilter = NO;
            [self getDataForHot];
        }
    }];
}

- (void)filterClass:(UIButton *)button{
    for (int i = 0 ; i < _buttonsArray.count; i ++) {
        HotMenuButton *btn = [_buttonsArray objectAtIndex:i];
        if (btn == button) {
            _isChangedFilter = YES;
            btn.isGuWenSelected = YES;
            _filterFlag = i ;
        }else{
            btn.isGuWenSelected = NO;
        }
    }
}

#pragma mark - 获取数据
- (void)getDataForHotWith:(NSInteger)tag{
    [self getDataForHot];
}

- (void)getDataForHot{
    NSDictionary *dict = @{@"start":[NSNumber numberWithInteger:_start],
                           @"limit":[NSNumber numberWithInteger:LIMIT],
                           @"attachType":_attachType,
                           @"releaseUserType":[NSNumber numberWithInteger:_filterFlag],
                           @"city":[USER_DEFAULT objectForKey:@"UserChoosedLocation"]==nil?@"上海":(NSString *)[USER_DEFAULT objectForKey:@"UserChoosedLocation"]};
    [LYAdviserHttpTool lyGetAdviserVideoWithParams:dict complete:^(NSArray *dataList) {
        LYGuWenOutsideCollectionViewCell *cell = (LYGuWenOutsideCollectionViewCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        if (dataList.count) {
            [self hideKongView];
            if (_start == 0) {
                //start
                [_dataList removeAllObjects];
                [cell.collectViewInside.mj_header endRefreshing];
                cell.collectViewInside.contentOffset = CGPointMake(0, -64);
            }
            [_dataList addObjectsFromArray:dataList];
            [cell.collectViewInside.mj_footer endRefreshing];
            _start = _start + LIMIT;
            
        }else{
            if (_start == 0) {
                [_dataList removeAllObjects];
                [cell.collectViewInside.mj_header endRefreshing];
                [self initKongView];
            }
            [cell.collectViewInside.mj_footer endRefreshingWithNoMoreData];
        }
        [cell.collectViewInside reloadData];
    }];
}

#pragma mark - 空界面
- (void)initKongView{
    if (!_kongLabel) {
        _kongLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 2 - 45, SCREEN_WIDTH, 20)];
        [_kongLabel setText:@"抱歉，暂无直播视频！"];
        [_kongLabel setTextAlignment:NSTextAlignmentCenter];
        [_kongLabel setFont:[UIFont systemFontOfSize:14]];
        [_kongLabel setTextColor:RGBA(186, 40, 227, 1)];
        _kongLabel.layer.zPosition = 3;
    }
        [self.view addSubview:_kongLabel];
    
}

- (void)hideKongView{
    [_kongLabel removeFromSuperview];
}

#pragma mark - collectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LYGuWenOutsideCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LYGuWenOutsideCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.typeForShow = 2;
    cell.delegate = self;
    __weak __typeof(self)weakSelf = self;
    cell.collectViewInside.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        _start = 0 ;
        [weakSelf getDataForHot];
    }];
    MJRefreshGifHeader *header = (MJRefreshGifHeader *)cell.collectViewInside.mj_header;
    [self initMJRefeshHeaderForGif:header];
    
    cell.collectViewInside.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [weakSelf getDataForHot];
    }];
    MJRefreshBackGifFooter *footer = (MJRefreshBackGifFooter *)cell.collectViewInside.mj_footer;
    [self initMJRefeshFooterForGif:footer];
    
    cell.videoArray = _dataList;
    
    return cell;
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//#pragma mark - scrollView的各种代理
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView.contentOffset.y > _contentOffSetY) {
//        if (scrollView.contentOffset.y <= 0.f) {//发布按钮弹出
//            effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 60, 60, 60);
//        }else{
//            [UIView animateWithDuration:0.4 animations:^{
//                effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT, 60, 60);
//            }];
//        }
//    }else{
//        if(CGRectGetMaxY(effectView.frame) > SCREEN_HEIGHT - 5){//发布按钮下移
//            [UIView animateWithDuration:.4 animations:^{
//                effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 123, 60, 60);
//            }completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.2 animations:^{
//                    effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT , 60, 60);
//                }];
//            }];
//        }
//    }
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    _contentOffSetY = scrollView.contentOffset.y;//拖拽结束获取偏移量
//}

#pragma mark - 发布视频

- (void)publishVideo{
    _typeOfImagePicker = @"filming";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FriendSendViewDidLoad) name:@"FriendSendViewDidLoad" object:nil];
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (UIImagePickerController *)imagePicker{
    _imagePicker = [[UIImagePickerController alloc]init];
    _imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//摄影
    _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;//后置摄像头
    _imagePicker.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
    _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式
    _imagePicker.videoMaximumDuration = 10;
    _imagePicker.editing = YES;
    _imagePicker.delegate = self;
    return _imagePicker;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    friendsSendVC = [[LYFriendsSendViewController alloc]initWithNibName:@"LYFriendsSendViewController" bundle:[NSBundle mainBundle]];
    friendsSendVC.delegate = self;
    [self.navigationController pushViewController:friendsSendVC animated:YES];
    _notificationDict = [[NSMutableDictionary alloc]initWithDictionary:@{@"info":info}];
}

#pragma mark 等待下一个页面load以后再进行操作
- (void)FriendSendViewDidLoad{
    friendsSendVC.typeOfImagePicker = self.typeOfImagePicker;
    [friendsSendVC imagePickerSpecificOperation:[_notificationDict objectForKey:@"info"]];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - 创建自己发布动态的Model
- (FriendsRecentModel *)createModelForISendAMessageWithDicForMessage:(NSDictionary *)messageDic{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    FriendsRecentModel *recentM = [[FriendsRecentModel alloc]init];
    recentM.attachType = [messageDic objectForKey:@"attachType"];
    recentM.username = app.userModel.username;
    recentM.userId = [NSString stringWithFormat:@"%d",app.userModel.userid];
    recentM.usernick = app.userModel.usernick;
    recentM.avatar_img = app.userModel.avatar_img;
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc]init];
    [dateFmt setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    recentM.date = [dateFmt stringFromDate:[NSDate date]];
    recentM.tags = app.userModel.tags;
    recentM.birthday = app.userModel.birthday;
    recentM.message = [messageDic objectForKey:@"content"];
    recentM.liked = @"0";
    recentM.isMeSendMessage = YES;
    recentM.commentList = [[NSMutableArray alloc]init];
    recentM.likeList = [[NSMutableArray alloc]init];
    recentM.location = [messageDic objectForKey:@"location"];
    
    NSString *topicID = [messageDic objectForKey:@"topicID"];
    NSString *topicName = [messageDic objectForKey:@"topicName"];
    if (topicID.length && topicName.length) {
        recentM.topicTypeId = topicID;
        NSArray *strArray = [topicName componentsSeparatedByString:@"#"];
        if(strArray.count >= 2) recentM.topicTypeName = strArray[1];
    }else{
        recentM.topicTypeId = @"";
        recentM.topicTypeName = @"";
    }
    return recentM;
}


#pragma mark - 发布之后
- (void)sendVedio:(NSString *)mediaUrl andImage:(UIImage *)image andContent:(NSString *)content andLocation:(NSString *)location andTopicID:(NSString *)topicID andTopicName:(NSString *)topicName{
    NSDictionary *dic = @{@"attachType":@"1",@"content":content,@"location":location,@"topicID":topicID,@"topicName":topicName};
    FriendsRecentModel *recentM = [self createModelForISendAMessageWithDicForMessage:dic];
    recentM.thunbImage = image;
    FriendsPicAndVideoModel *pvModel = [[FriendsPicAndVideoModel alloc]init];
    pvModel.imageLink = mediaUrl;
    [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL URLWithString:[MyUtil  getQiniuUrl:mediaUrl mediaType:QiNiuUploadTpyeDefault width:0 andHeight:0]]];//利用sdwebImage把自己发的动态图片缓存道本地（下面同理）
    recentM.lyMomentsAttachList = @[pvModel];
    recentM.avatar_img = self.userModel.avatar_img;
    recentM.usernick = self.userModel.usernick;
    if ([self.userModel.usertype isEqualToString:@"2"]||[self.userModel.usertype isEqualToString:@"3"]) {
        recentM.isManageRelease = YES;
    }else{
        recentM.isManageRelease = NO;
    }
    recentM.liked = @"0";
    [_dataList insertObject:recentM atIndex:0];
    LYGuWenOutsideCollectionViewCell *cell = (LYGuWenOutsideCollectionViewCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    cell.videoArray = _dataList;
    [cell.collectViewInside reloadData];
}

- (void)sendSucceed:(NSString *)messageId{
    if(_dataList.count){
        FriendsRecentModel *recentM = [_dataList objectAtIndex:0];
        recentM.id = [NSString stringWithFormat:@"%@",messageId];
    }
    LYGuWenOutsideCollectionViewCell *cell = (LYGuWenOutsideCollectionViewCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
//    cell.videoArray = _dataList;
    [cell.collectViewInside reloadData];
}


















@end
