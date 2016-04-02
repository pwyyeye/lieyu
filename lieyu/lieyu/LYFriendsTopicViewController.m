//
//  LYFriendsTopicViewController.m
//  lieyu
//
//  Created by 狼族 on 16/3/21.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsTopicViewController.h"
#import "LYFriendsHttpTool.h"
#import "UIImageView+WebCache.h"
#import "LYFriendsSendViewController.h"
#import "LYChangeImageViewController.h"
#import "ImagePickerViewController.h"
#import "FriendsRecentModel.h"
#import "FriendsPicAndVideoModel.h"
#import "LYFriendsMessageDetailViewController.h"

@interface LYFriendsTopicViewController ()<UIActionSheetDelegate,ImagePickerFinish,sendBackVedioAndImage,UIImagePickerControllerDelegate,
UINavigationControllerDelegate>{
    NSInteger _pageStartCount,_pageCount;
    UIVisualEffectView *_effectView;
    UIButton *_carmerBtn;
    CGFloat _contentOffSetY;
     NSInteger _saveImageAndVideoIndex;
    LYFriendsSendViewController *friendsSendVC;
}
@property (nonatomic, assign) int pagesCount;
@property (nonatomic, strong) NSString *typeOfImagePicker;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) NSMutableDictionary *notificationDict;
@end

@implementation LYFriendsTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _pageStartCount = 0;
    _pagesCount = 4;
    _pageCount = 10;
    _notificationDict = [[NSMutableDictionary alloc]init];
    self.navigationItem.title = _topicName;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createCameraBtn];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_effectView removeFromSuperview];
    _effectView = nil;
}

- (void)createCameraBtn{
    
    if (_isFriendsTopic) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _effectView = [[UIVisualEffectView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.f - 30, SCREEN_HEIGHT - 60, 60, 60)];
        _effectView.layer.cornerRadius = _effectView.frame.size.width/2.f;
        _effectView.layer.masksToBounds = YES;
        _effectView.effect = effect;
        [self.view addSubview:_effectView];
        [self.view bringSubviewToFront:_effectView];
        
        
        _carmerBtn = [[UIButton alloc]initWithFrame:CGRectMake((_effectView.frame.size.width - 35)/2.f,(_effectView.frame.size.height - 30)/2.f , 35, 30)];
        [_carmerBtn addTarget:self action:@selector(carmerClick:) forControlEvents:UIControlEventTouchUpInside];
        [_carmerBtn setBackgroundImage:[UIImage imageNamed:@"daohang_xiangji"] forState:UIControlStateNormal];
        [_effectView addSubview:_carmerBtn];
        
        [UIView animateWithDuration:.4 animations:^{
            _effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 133, 60, 60);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                _effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 130, 60, 60);
            }];
        }];

    }else{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    _effectView = [[UIVisualEffectView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT -64, SCREEN_WIDTH, 47)];
    _effectView.effect = effect;
    [self.view addSubview:_effectView];
    [self.view bringSubviewToFront:_effectView];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = RGBA(243, 243, 243, 1);
    [_effectView addSubview:lineView];
    
    _carmerBtn = [[UIButton alloc]initWithFrame:CGRectMake(7,4, SCREEN_WIDTH - 14, 35)];
    [_carmerBtn addTarget:self action:@selector(carmerClick:) forControlEvents:UIControlEventTouchUpInside];
    _carmerBtn.backgroundColor = [UIColor blackColor];
    [_carmerBtn setBackgroundImage:[UIImage imageNamed:@"LoginNew"] forState:UIControlStateNormal];
    _carmerBtn.layer.cornerRadius = 4;
    _carmerBtn.layer.masksToBounds = YES;
    [_carmerBtn setTitle:@"我来评一评" forState:UIControlStateNormal];
    [_effectView addSubview:_carmerBtn];
    
//    [UIView animateWithDuration:.4 animations:^{
//        _effectView.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 47);
//    }completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.2 animations:^{
//            _effectView.frame = CGRectMake(0, SCREEN_HEIGHT - 47, SCREEN_WIDTH, 47);
//        }];
//    }];
    
    [UIView animateWithDuration:.4 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        _effectView.frame = CGRectMake(0, SCREEN_HEIGHT - 47 - 64, SCREEN_WIDTH, 47);
    } completion:^(BOOL finished) {
        
    }];
    }
}


#pragma mark 发布动态
- (void)carmerClick:(UIButton *)carmerClick{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册",@"短视频", nil];
    actionSheet.tag = 100;
    [actionSheet showInView:self.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FriendSendViewDidLoad) name:@"FriendSendViewDidLoad" object:nil];
    
//    LYFriendsSendViewController *friendsSendVC = [[LYFriendsSendViewController alloc]init];
//    friendsSendVC.TopicID = _topicTypeId;
//    friendsSendVC.TopicTitle = [NSString stringWithFormat:@"#%@#", _topicName];
//    [self.navigationController pushViewController:friendsSendVC animated:YES];
}

#pragma mark 等待下一个页面load以后再进行操作
- (void)FriendSendViewDidLoad{
    if([_typeOfImagePicker isEqualToString:@"photos"]){
        [friendsSendVC YBImagePickerDidFinishWithImages:[_notificationDict objectForKey:@"info"]];
    }else if ([_typeOfImagePicker isEqualToString:@"takePhoto"] || [_typeOfImagePicker isEqualToString:@"filming"]){
        friendsSendVC.typeOfImagePicker = self.typeOfImagePicker;
        [friendsSendVC imagePickerSpecificOperation:[_notificationDict objectForKey:@"info"]];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark 点击三个按键的相应处理方法
- (void)photosActionClick{
    if(self.pagesCount <= 0){
        [MyUtil showCleanMessage:@"抱歉，无法再添加照片"];
        return;//给出提示
    }
    _typeOfImagePicker = @"photos";
    ImagePickerViewController *imagePicker = [[ImagePickerViewController alloc]init];
    imagePicker.imagesCount = self.pagesCount;
    imagePicker.delegate = self;
    imagePicker.title = @"相册";
    [self.navigationController pushViewController:imagePicker animated:YES];
}

- (void)takePhotoActionClick{
    if(self.pagesCount <= 0){
        [MyUtil showCleanMessage:@"抱歉，无法再添加照片"];
        return;//给出提示
    }
    _typeOfImagePicker = @"takePhoto";
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)filmingActionClick{
    if(self.pagesCount < 4){
        [MyUtil showCleanMessage:@"抱歉，无法再添加视频"];
        return;//给出提示
    }
    _typeOfImagePicker = @"filming";
    [self presentViewController:self.imagePicker animated:YES completion:nil];
    
}

#pragma mark 选择拍照或拍摄后的操作
- (UIImagePickerController *)imagePicker{
    _imagePicker = [[UIImagePickerController alloc]init];
    if([_typeOfImagePicker isEqualToString:@"takePhoto"]){//拍照
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//拍照
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;//后置摄像头
        _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    }else if([_typeOfImagePicker isEqualToString:@"filming"]){//小视频
        _imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//摄影
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;//后置摄像头
        _imagePicker.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
        _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式
        _imagePicker.videoMaximumDuration = 10;
    }
    _imagePicker.editing = YES;
    _imagePicker.delegate = self;
    return _imagePicker;
}

#pragma mark - 作为代理收取视频路径地址与截图
- (void)sendVedio:(NSString *)mediaUrl andImage:(UIImage *)image andContent:(NSString *)content andLocation:(NSString *)location andTopicID:(NSString *)topicID andTopicName:(NSString *)topicName{
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    FriendsRecentModel *recentM = [[FriendsRecentModel alloc]init];
    recentM.attachType = @"1";
    recentM.username = app.userModel.username;
    recentM.usernick = app.userModel.usernick;
    recentM.avatar_img = app.userModel.avatar_img;
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc]init];
    [dateFmt setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    recentM.date = [dateFmt stringFromDate:[NSDate date]];
    recentM.tags = app.userModel.tags;
    recentM.birthday = app.userModel.birthday;
    recentM.message = content;
    recentM.liked = @"0";
    recentM.isMeSendMessage = YES;
    recentM.commentList = [[NSMutableArray alloc]init];
    recentM.likeList = [[NSMutableArray alloc]init];
    recentM.location = location;
    if (topicID.length && topicName.length) {
        recentM.topicTypeId = topicID;
        NSArray *strArray = [topicName componentsSeparatedByString:@"#"];
        if(strArray.count >= 2) recentM.topicTypeName = strArray[1];
    }else{
        recentM.topicTypeId = @"";
        recentM.topicTypeName = @"";
    }
    
    FriendsPicAndVideoModel *pvModel = [[FriendsPicAndVideoModel alloc]init];
    pvModel.imageLink = mediaUrl;
    [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL URLWithString:[MyUtil  getQiniuUrl:mediaUrl mediaType:QiNiuUploadTpyeDefault width:0 andHeight:0]]];
    _saveImageAndVideoIndex ++;
    recentM.lyMomentsAttachList = @[pvModel];
    
    [_dataArray insertObject:recentM atIndex:0];
    [self.tableView reloadData];
    
}

#pragma mark - 作为代理接受返回的图片
- (void)sendImagesArray:(NSArray *)imagesArray andContent:(NSString *)content andLocation:(NSString *)location andTopicID:(NSString *)topicID andTopicName:(NSString *)topicName{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    FriendsRecentModel *recentM = [[FriendsRecentModel alloc]init];
    recentM.attachType = @"0";
    recentM.liked = @"0";
    recentM.usernick = app.userModel.usernick;
    recentM.avatar_img = app.userModel.avatar_img;
    recentM.commentList = [[NSMutableArray alloc]init];
    recentM.likeList = [[NSMutableArray alloc]init];
    recentM.location = location;
    recentM.isMeSendMessage = YES;
    if (topicID.length && topicName.length) {
        recentM.topicTypeId = topicID;
        NSArray *strArray = [topicName componentsSeparatedByString:@"#"];
        if(strArray.count >= 2) recentM.topicTypeName = strArray[1];
    }else{
        recentM.topicTypeId = @"";
        recentM.topicTypeName = @"";
    }
    
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc]init];
    [dateFmt setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    recentM.date = [dateFmt stringFromDate:[NSDate date]];
    NSLog(@"---->%@",[dateFmt stringFromDate:[NSDate date]]);
    recentM.tags = app.userModel.tags;
    
    recentM.birthday = app.userModel.birthday;
    recentM.message = [NSString stringWithFormat:@"%@",content];
    
    FriendsPicAndVideoModel *pvModel = [[FriendsPicAndVideoModel alloc]init];
    NSString *imageLink = nil;
    NSString *appendLink = nil;
CGFloat picWidth = 0;
    for (int i = 0;i < imagesArray.count;i ++) {
        UIImage *image = imagesArray[i];
           pvModel.imageLink = [pvModel.imageLink stringByAppendingString:[[NSString stringWithFormat:@"myPicture%ld%d",_saveImageAndVideoIndex,i] stringByAppendingString:@","]];
        
        appendLink = [NSString stringWithFormat:@"myPicture%ld%d,",_saveImageAndVideoIndex,i];
        if(i == imagesArray.count - 1) appendLink = [NSString stringWithFormat:@"myPicture%ld%d",_saveImageAndVideoIndex,i];
        NSLog(@"--->%@",imageLink);
        if(!i) imageLink = appendLink;
        else imageLink = [imageLink stringByAppendingString:appendLink];
        switch (imagesArray.count) {
            case 1:
            {
                picWidth = 0;
            }
                break;
            default:{
                picWidth = 450;
            }
                break;
        }
        
        [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL URLWithString:[MyUtil getQiniuUrl:[NSString stringWithFormat:@"myPicture%ld%d",_saveImageAndVideoIndex,i] width:0 andHeight:0]]];
        _saveImageAndVideoIndex ++;
        
    }
    pvModel.imageLink = imageLink;
    recentM.lyMomentsAttachList = @[pvModel];
    
    [_dataArray insertObject:recentM atIndex:0];
    [self reloadTableViewAndSetUpProperty];
    
}

#pragma mark 选择玩照片后的操作
- (void)ImagePickerDidFinishWithImages:(NSArray *)imageArray{
    friendsSendVC = [[LYFriendsSendViewController alloc]initWithNibName:@"LYFriendsSendViewController" bundle:[NSBundle mainBundle]];
    friendsSendVC.delegate = self;
    friendsSendVC.TopicTitle = [NSString stringWithFormat:@"#%@#",_topicName];
    friendsSendVC.TopicID = _topicTypeId;
    [self.navigationController pushViewController:friendsSendVC animated:YES];
    /**
     */
    //        [self YBImagePickerDidFinishWithImages:imageArray];
    [_notificationDict setObject:imageArray forKey:@"info"];
}

//- (void)YBImagePickerDidFinishWithImages:(NSArray *)imageArray{
//    friendsSendVC = [[LYFriendsSendViewController alloc]initWithNibName:@"LYFriendsSendViewController" bundle:[NSBundle mainBundle]];
//    friendsSendVC.delegate = self;
//    friendsSendVC.TopicTitle = _topicName;
//    friendsSendVC.TopicID = _topicTypeId;
//    [self.navigationController pushViewController:friendsSendVC animated:YES];
//    /**
//     */
//    //        [self YBImagePickerDidFinishWithImages:imageArray];
//    [_notificationDict setObject:imageArray forKey:@"info"];
//}

#pragma mark imagepicker的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    friendsSendVC = [[LYFriendsSendViewController alloc]initWithNibName:@"LYFriendsSendViewController" bundle:[NSBundle mainBundle]];
    friendsSendVC.delegate = self;
        friendsSendVC.TopicTitle = [NSString stringWithFormat:@"#%@#",_topicName];
    friendsSendVC.TopicID = _topicTypeId;
    [self.navigationController pushViewController:friendsSendVC animated:YES];
    /**
     */
    //    self.friendsSendVC.typeOfImagePicker = self.typeOfImagePicker;
    //    [self.friendsSendVC imagePickerSpecificOperation:info];
    //    _notificationDict = [[NSMutableDictionary alloc]init];
    [_notificationDict setObject:info forKey:@"info"];
}



#pragma mark - sendSuccess
- (void)sendSucceed:(NSString *)messageId{
    
    if (_dataArray.count) {
    FriendsRecentModel *recentM = _dataArray[0];
    recentM.id = [NSString stringWithFormat:@"%@",messageId];
    [self reloadTableViewAndSetUpProperty];
    }
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag == 100){
        switch (buttonIndex) {
            case 0://拍照
            {
                [self takePhotoActionClick];
            }
                break;
            case 1://相册
            {
                [self photosActionClick];
                
            }
                break;
            case 2://短视频
            {
                [self filmingActionClick];
            }
                break;
            default:
                break;
        }
    }
}

- (void)getData{
    NSString *startStr = [NSString stringWithFormat:@"%ld",_pageStartCount * _pageCount];
    NSString *pageCountStr = [NSString stringWithFormat:@"%ld",_pageCount];
    NSDictionary *paraDic = @{@"userId":_useridStr,@"start":startStr,@"limit":pageCountStr,@"topicTypeId":_topicTypeId};
    NSLog(@"----->%@",paraDic);
    __weak LYFriendsToUserMessageViewController *weakSelf = self;
    
    [LYFriendsHttpTool friendsGetFriendsTopicWithParams:paraDic complete:^(NSArray *dataArray) {
        if(dataArray.count){
            if(_pageStartCount == 0) {
                _dataArray = dataArray.mutableCopy;
            }else{
                [_dataArray addObjectsFromArray:dataArray];
            }
            [weakSelf reloadTableViewAndSetUpProperty];
            _pageStartCount ++;
            [weakSelf.tableView.mj_footer endRefreshing];
        }else {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if(_isFriendsTopic) [weakSelf addTableViewHeader];
    }];
    
}
#pragma mark － 刷新表
- (void)reloadTableViewAndSetUpProperty{
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    
    [self removePlaceView];
    if (!_dataArray.count) {
        [self createPlaceView];
    }
}

- (void)createPlaceView{
    UILabel *placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    placeLabel.tag = 800;
    placeLabel.center = self.view.center;
    if (_isFriendsTopic) {
        placeLabel.text = @"暂无话题";
    }else{
        placeLabel.text = @"暂无评论";
    }
    placeLabel.textAlignment = NSTextAlignmentCenter;
//    [placeLabel  sizeToFit] ;
    placeLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:placeLabel];
    
}

- (void)removePlaceView{
    UILabel *label = (UILabel *)[self.view viewWithTag:800];
    if (label) {
        [label removeFromSuperview];
        label = nil;
    }
}

#pragma mark - 点击动态中话题文字
- (void)topicNameClick:(UIButton *)button{
    
}

#pragma mark － 跳转消息详情页面
- (void)pushFriendsMessageDetailVCWithIndex:(NSInteger)index{
    FriendsRecentModel *recentM = _dataArray[index];
    LYFriendsMessageDetailViewController *messageDetailVC = [[LYFriendsMessageDetailViewController alloc]init];
    messageDetailVC.recentM = recentM;
    messageDetailVC.isTopicDetail = YES;
    [self.navigationController pushViewController:messageDetailVC animated:YES];
}

- (void)addTableViewHeader{
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 187 / 375)];
    imgView.backgroundColor = [UIColor redColor];
    [imgView sd_setImageWithURL:[NSURL URLWithString:_headerViewImgLink] placeholderImage:[UIImage imageNamed:@"empyImage16_9"]];
    self.tableView.tableHeaderView = imgView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    if(_isFriendsTopic){
        if (scrollView.contentOffset.y > _contentOffSetY) {
            if (scrollView.contentOffset.y <= 0.f) {
//                _effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 130, 60, 60);
            }else{
                
                            [UIView animateWithDuration:0.4 animations:^{
                                _effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT, 60, 60);
                            }];
            }
        }else{
            if(CGRectGetMaxY(_effectView.frame) > SCREEN_HEIGHT - 5){
                [UIView animateWithDuration:.4 animations:^{
                    _effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 133, 60, 60);
                }completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.2 animations:^{
                        _effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 130, 60, 60);
                    }];
                }];
            }
        }

    }else{
    if (scrollView.contentOffset.y > _contentOffSetY) {
        if (scrollView.contentOffset.y <= 0.f) {
//            _effectView.frame = CGRectMake(0,  SCREEN_HEIGHT - 47 - 64, 60, 60);
        }else{
            
            [UIView animateWithDuration:.4 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                _effectView.frame = CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 47);
            } completion:^(BOOL finished) {
                
            }];
            
//            [UIView animateWithDuration:0.4 animations:^{
//                _effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT, 60, 60);
//            }];
        }
    }else{
        if(CGRectGetMaxY(_effectView.frame) + 64 > SCREEN_HEIGHT - 5){
            
            
            [UIView animateWithDuration:.4 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                _effectView.frame = CGRectMake(0, SCREEN_HEIGHT - 47 - 64, SCREEN_WIDTH, 47);
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    _contentOffSetY = scrollView.contentOffset.y;
}

- (void)setupTableViewFresh{
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        _pageStartCount = 0;
        [self getData];
    }];
    
    MJRefreshGifHeader *header = (MJRefreshGifHeader *)self.tableView.mj_header;
    [self initMJRefeshHeaderForGif:header];
    
    self.tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [self getData];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
