//
//  LYFriendsTopicsViewController.m
//  lieyu
//
//  Created by 狼族 on 16/5/6.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsTopicsViewController.h"

@interface LYFriendsTopicsViewController ()<sendBackVedioAndImage>

@end

@implementation LYFriendsTopicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = _topicName;
    self.pageNum = 1;
}


#pragma mark - 获取话题
- (void)getDataWithType:(dataType)type needLoad:(BOOL)need{
    UITableView *tableView = nil;
    __block int pageStartCount;
    if (type == dataForFriendsMessage) {
        pageStartCount = _pageStartCountArray[0];
        tableView = _tableViewArray.firstObject;
        tableView.frame= CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 47);
    }else if(type == dataForMine){
        pageStartCount = _pageStartCountArray[1];
        tableView = [_tableViewArray objectAtIndex:1];
        tableView.frame= CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 47);
    }
    NSString *startStr = [NSString stringWithFormat:@"%ld",pageStartCount * _pageCount];
    NSString *pageCountStr = [NSString stringWithFormat:@"%ld",(long)_pageCount];
    NSDictionary *paraDic = @{@"userId":_useridStr,@"start":startStr,@"limit":pageCountStr,@"topicTypeId":_topicTypeId};
    __weak __typeof(self) weakSelf = self;
    if (type == dataForFriendsMessage) {
        [LYFriendsHttpTool friendsGetFriendsTopicWithParams:paraDic complete:^(NSArray *dataArray) {
                [weakSelf loadDataWith:tableView dataArray:dataArray.mutableCopy pageStartCount:pageStartCount type:type];
                if(_isFriendsTopic) [weakSelf addTableViewHeader];
            
            NSArray *dataArr = _dataArray.firstObject;
            
            [self removePlaceView];
            if (!dataArr.count) {
                [self createPlaceView];
            }
        }];
    }
}

- (void)removePlaceView{
    UILabel *label = (UILabel *)[self.view viewWithTag:800];
    if (label) {
        [label removeFromSuperview];
        label = nil;
    }
}

- (void)createPlaceView{
    UILabel *placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - 40)/2.f, SCREEN_WIDTH, 40)];
    placeLabel.tag = 800;
    //    NSLog(@"--->%@",NSStringFromCGPoint(self.view.center));
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

#pragma mark - 添加表头
- (void)addTableViewHeader{
    UITableView *tableView = _tableViewArray.firstObject;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 187 / 375)];
    [imgView sd_setImageWithURL:[NSURL URLWithString:_headerViewImgLink] placeholderImage:[UIImage imageNamed:@"empyImage16_9"]];
    
    tableView.tableHeaderView = imgView;
}

#pragma mark - 获取我的未读消息数
- (void)getFriendsNewMessage{
    
}


#pragma mark - 话题
- (void)addTableViewHeaderViewForTopic{
    
}

#pragma mark - 配置导航
- (void)setupMenuView{};

#pragma mark - 配置发布按钮
- (void)setupCarmerBtn{
    if(_isFriendsTopic) [super setupCarmerBtn];
    else{
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        effectView = [[UIVisualEffectView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT -64, SCREEN_WIDTH, 47)];
        effectView.effect = effect;
        [self.view addSubview:effectView];
        effectView.layer.zPosition = 5;
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = RGBA(243, 243, 243, 1);
        [effectView addSubview:lineView];
        
        _carmerBtn = [[UIButton alloc]initWithFrame:CGRectMake(7,4, SCREEN_WIDTH - 14, 35)];
        [_carmerBtn addTarget:self action:@selector(carmerClick:) forControlEvents:UIControlEventTouchUpInside];
        _carmerBtn.backgroundColor = [UIColor blackColor];
        [_carmerBtn setBackgroundImage:[UIImage imageNamed:@"LoginNew"] forState:UIControlStateNormal];
        _carmerBtn.layer.cornerRadius = 4;
        _carmerBtn.layer.masksToBounds = YES;
        [_carmerBtn setTitle:@"我来评一评" forState:UIControlStateNormal];
        [effectView addSubview:_carmerBtn];
        [UIView animateWithDuration:.4 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            effectView.frame = CGRectMake(0, SCREEN_HEIGHT - 47 - 64, SCREEN_WIDTH, 47);
        } completion:nil];
    }
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
    [self.notificationDict setObject:imageArray forKey:@"info"];
}

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
    [self.notificationDict setObject:info forKey:@"info"];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(_isFriendsTopic){
        [super scrollViewDidScroll:scrollView];
    }else{
        if (scrollView.contentOffset.y > _contentOffSetY) {
            if (scrollView.contentOffset.y <= 0.f) {
                //            _effectView.frame = CGRectMake(0,  SCREEN_HEIGHT - 47 - 64, 60, 60);
            }else{
                
                [UIView animateWithDuration:.4 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//                    effectView.frame = CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 47);
                } completion:^(BOOL finished) {
                    
                }];
                
                //            [UIView animateWithDuration:0.4 animations:^{
                //                _effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT, 60, 60);
                //            }];
            }
        }else{
            if(CGRectGetMaxY(effectView.frame) + 64 > SCREEN_HEIGHT - 5){
                
                
                [UIView animateWithDuration:.4 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//                    effectView.frame = CGRectMake(0, SCREEN_HEIGHT - 47 - 64, SCREEN_WIDTH, 47);
                } completion:^(BOOL finished) {
                    
                }];
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    _contentOffSetY = scrollView.contentOffset.y;
}

- (void)sendSucceed:(NSString *)messageId{//发布成功以后
    [super sendSucceed:messageId];
    NSArray *dataArr = [_dataArray objectAtIndex:0];
    [self removePlaceView];
    if (!dataArr.count) {
        [self createPlaceView];
    }
}

- (void)sendVedio:(NSString *)mediaUrl andImage:(UIImage *)image andContent:(NSString *)content andLocation:(NSString *)location andTopicID:(NSString *)topicID andTopicName:(NSString *)topicName{
    [super sendVedio:mediaUrl andImage:image andContent:content andLocation:location andTopicID:topicID andTopicName:topicName];
    
    if ([_commentDelegate respondsToSelector:@selector(lyBarCommentsSendSuccess)]) {
        [_commentDelegate lyBarCommentsSendSuccess];
    }
}


- (void)sendImagesArray:(NSArray *)imagesArray andContent:(NSString *)content andLocation:(NSString *)location andTopicID:(NSString *)topicID andTopicName:(NSString *)topicName{
    [super sendImagesArray:imagesArray andContent:content andLocation:location andTopicID:topicID andTopicName:topicName];
    
    if ([_commentDelegate respondsToSelector:@selector(lyBarCommentsSendSuccess)]) {
        [_commentDelegate lyBarCommentsSendSuccess];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
