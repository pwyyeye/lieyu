//
//  LYGuWenOutsideCollectionViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/5/27.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYGuWenOutsideCollectionViewCell.h"
#import "LYGuWenPersonCollectionViewCell.h"
#import "LYGuWenVideoCollectionViewCell.h"
#import "FriendsPicAndVideoModel.h"
#import "LYDateUtil.h"
#import <MediaPlayer/MediaPlayer.h>
#import "LYFriendsHttpTool.h"
#import "FriendsLikeModel.h"
#import "LYFriendsAMessageDetailViewController.h"
#import "LYFriendsMessagesViewController.h"
#import "LYMyFriendDetailViewController.h"

@interface LYGuWenOutsideCollectionViewCell()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate,LYRecentMessageLikeDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSInteger playSection;
    MPMoviePlayerViewController *_player;
    BOOL _isDisturb;
    LYGuWenVideoCollectionViewCell *_friendVideoCell;
    
    NSInteger _selectedItem;
    
    int tag;
    
    
    UIVisualEffectView *effectView;//发布按钮的背景view
    UIButton *_carmerBtn;//照相机按钮
    LYFriendsSendViewController *friendsSendVC;
    CGFloat _contentOffSetY;//表的偏移量
}

@end

@implementation LYGuWenOutsideCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _collectViewInside.dataSource = self;
    _collectViewInside.delegate = self;
    _collectViewInside.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

#pragma mark - 配置发布按钮
- (void)setupCarmerBtn{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    effectView = [[UIVisualEffectView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.f - 30, SCREEN_HEIGHT, 60, 60)];
    effectView.layer.cornerRadius = effectView.frame.size.width/2.f;
    effectView.layer.masksToBounds = YES;
    effectView.effect = effect;
    [self addSubview:effectView];
    effectView.layer.zPosition = 5;
    //发布按钮
    _carmerBtn = [[UIButton alloc]initWithFrame:CGRectMake((effectView.frame.size.width - 35)/2.f,effectView.frame.size.height /2.f - 15, 35, 30)];
    [_carmerBtn addTarget:self action:@selector(cameraClick:) forControlEvents:UIControlEventTouchUpInside];
    [_carmerBtn setBackgroundImage:[UIImage imageNamed:@"daohang_xiangji"] forState:UIControlStateNormal];
    [effectView addSubview:_carmerBtn];
    
    //发布按钮出来动画
    CGFloat offset = 76;
    [UIView animateWithDuration:.4 animations:^{
        effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - offset - 3, 60, 60);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - offset, 60, 60);
        }];
    }];
}

- (void)drawRect:(CGRect)rect{
    if (_typeForShow == 1) {
        _collectViewInside.contentInset = UIEdgeInsetsMake(90, 0, 0, 0);
        [_collectViewInside registerNib:[UINib nibWithNibName:@"LYGuWenPersonCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LYGuWenPersonCollectionViewCell"];
    }else if (_typeForShow == 2){
        _collectViewInside.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        [_collectViewInside registerNib:[UINib nibWithNibName:@"LYGuWenVideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LYGuWenVideoCollectionViewCell"];
        if (!effectView) {
            [self setupCarmerBtn];
        }
    }
}

- (void)setGuWenArray:(NSArray *)guWenArray{
    _guWenArray = guWenArray;
    [_collectViewInside reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_typeForShow == 1) {
        return _guWenArray.count;
    }else if(_typeForShow == 2){
        return _videoArray.count;
    }else{
        return 0;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 3;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 3;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(3, 3, 3, 3);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_typeForShow == 1) {
        return CGSizeMake(SCREEN_WIDTH - 6, 122);
    }else if (_typeForShow == 2){
        return CGSizeMake(SCREEN_WIDTH - 6 , SCREEN_WIDTH / 3 * 2 + 64);
    }else{
        return CGSizeMake(0, 0);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_typeForShow == 1) {
        LYGuWenPersonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LYGuWenPersonCollectionViewCell" forIndexPath:indexPath];
        cell.vipModel = [_guWenArray objectAtIndex:indexPath.row];
        return cell;
    }else if (_typeForShow == 2){
        LYGuWenVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LYGuWenVideoCollectionViewCell" forIndexPath:indexPath];
        cell.playButton.tag = indexPath.item;
        cell.reportButton.tag = indexPath.item;
        cell.likeButton.tag = indexPath.item;
        [cell.playButton addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
        [cell.reportButton addTarget:self action:@selector(reportVideo:) forControlEvents:UIControlEventTouchUpInside];
        [cell.likeButton addTarget:self action:@selector(likeVideo:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.recentM = [_videoArray objectAtIndex:indexPath.row];
        
        UIView *view = [cell viewWithTag:6611];
        if (indexPath.item != playSection && view) {
            [_player.view removeFromSuperview];
            [_player removeFromParentViewController];
        }
        
        return cell;
    }else{
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_typeForShow == 1) {
        UserModel *model = (UserModel *)[_guWenArray objectAtIndex:indexPath.item];
        if(_delegate && [_delegate respondsToSelector:@selector(GuWenSelected:)]){
            [_delegate GuWenSelected:[NSString stringWithFormat:@"%d",model.userid]];
        }
    }else if (_typeForShow == 2){
        FriendsRecentModel *model = (FriendsRecentModel *)[_videoArray objectAtIndex:indexPath.item];
        LYMyFriendDetailViewController *detailVC = [[LYMyFriendDetailViewController alloc]init];
        detailVC.userID = model.userId;
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.navigationController pushViewController:detailVC animated:YES];
    }else{
        
    }
}

- (void)lyRecentMessageLikeChange:(NSString *)liked{
    FriendsRecentModel *model = (FriendsRecentModel *)[_videoArray objectAtIndex:_selectedItem];
    model.liked = liked;
    LYGuWenVideoCollectionViewCell *cell = (LYGuWenVideoCollectionViewCell *)[_collectViewInside cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedItem inSection:0]];
    cell.recentM = model;
    
}

#pragma mark - 按钮事件
- (void)reportVideo:(UIButton *)button{
    tag = (int)button.tag;
    UIActionSheet *reportAction = [[UIActionSheet alloc]initWithTitle:@"选择举报原因" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"污秽色情",@"垃圾广告",@"其他原因", nil];
    [reportAction showInView:self.collectViewInside];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *message;
    if (buttonIndex == 0) {
        message = @"污秽色情";
    }else if (buttonIndex == 1){
        message = @"垃圾广告";
    }else if (buttonIndex == 2){
        message = @"其他原因";
    }
    if (buttonIndex != 3) {
        FriendsRecentModel *model = (FriendsRecentModel *)[_videoArray objectAtIndex:tag];
        UserModel *userModel = ((AppDelegate *)[UIApplication sharedApplication].delegate).userModel;
        NSDictionary *dict = @{
                @"reportedUserid":model.userId,
                @"momentId":model.id,
                @"message":message,
                @"userid":[NSNumber numberWithInt:userModel.userid]};
        [LYFriendsHttpTool friendsJuBaoWithParams:dict complete:^(NSString *message) {
            [MyUtil showPlaceMessage:message];
        }];
    }
}

- (void)likeVideo:(UIButton *)button{
    
    UserModel *userModel = ((AppDelegate *)[UIApplication sharedApplication].delegate).userModel;
    
    LYGuWenVideoCollectionViewCell *cell = (LYGuWenVideoCollectionViewCell *)[_collectViewInside cellForItemAtIndexPath:[NSIndexPath indexPathForItem:button.tag inSection:0]];
    
    FriendsRecentModel *model = [_videoArray objectAtIndex:button.tag];
    
    cell.likeButton.enabled = NO;
    
    NSString *likeStr;
    if ([model.liked isEqualToString:@"0"]) {
        likeStr = @"1";
    }else{
        likeStr = @"0";
    }
    NSDictionary *dict = @{
                @"userId":[NSString stringWithFormat:@"%d",userModel.userid],
                @"messageId":model.id,
                @"type":likeStr};
    [LYFriendsHttpTool friendsLikeMessageWithParams:dict compelte:^(bool result) {
        if (result) {
            [cell.likeButton setImage:[UIImage imageNamed:@"videoLiked"] forState:UIControlStateNormal];
            
            FriendsLikeModel *likeModel = [[FriendsLikeModel alloc]init];
            likeModel.userId = [NSString stringWithFormat:@"%d",userModel.userid];
            likeModel.icon = userModel.avatar_img;
            likeModel.imUserId = userModel.imuserId;
            likeModel.userNick = userModel.usernick;
            [model.likeList insertObject:likeModel atIndex:0];
            
            model.liked = @"1";
        }else{
            [cell.likeButton setImage:[UIImage imageNamed:@"videounLiked"] forState:UIControlStateNormal];
            
            for (FriendsLikeModel *likeModel in model.likeList) {
                if ([likeModel.userId isEqualToString:[NSString stringWithFormat:@"%d",userModel.userid]]) {
                    [model.likeList removeObject:likeModel];
                    break;
                }
            }
            
            model.liked = @"0";
        }
        
        cell.likeButton.enabled = YES;
    }];
}

- (void)playVideo:(UIButton *)button{
    playSection = button.tag;
    FriendsRecentModel *recentM = (FriendsRecentModel *)_videoArray[button.tag];
    FriendsPicAndVideoModel *pvM = (FriendsPicAndVideoModel *)recentM.lyMomentsAttachList[0];
    QiNiuUploadTpye quType = [MyUtil configureNetworkConnect] == 1 ? QiNiuUploadTpyeSmallMedia : QiNiuUploadTpyeMedia;
    NSURL *url;
    if ([LYDateUtil isMoreThanFiveMinutes:recentM.date]) {
        url = [NSURL URLWithString:[MyUtil getQiniuUrl:pvM.imageLink mediaType:quType width:0 andHeight:0]];
    }else{
        url = [NSURL URLWithString:[MyUtil getQiniuUrl:pvM.imageLink mediaType:QiNiuUploadTpyeBigMedia width:0 andHeight:0]];
    }
    if (recentM.isMeSendMessage){
        url = [[NSURL alloc] initFileURLWithPath:pvM.imageLink];
    }
    if (_player.moviePlayer.playbackState != MPMoviePlaybackStateStopped) {
        _isDisturb = YES;
    }
    [_player.view removeFromSuperview];
    
    _friendVideoCell = (LYGuWenVideoCollectionViewCell *)[_collectViewInside cellForItemAtIndexPath:[NSIndexPath indexPathForItem:button.tag inSection:0]];
    _player = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    _player.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    _player.view.frame = _friendVideoCell.videoImage.frame;
    _player.view.tag = 6611;
    _player.moviePlayer.controlStyle = MPMovieControlStyleDefault;
    [_friendVideoCell addSubview:_player.view];
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerWillPlay) name:MPMoviePlayerPlaybackStateDidChangeNotification object:_player.moviePlayer];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerWillPlay) name:MPMoviePlayerLoadStateDidChangeNotification object:_player.moviePlayer];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerWillPlay) name:MPMoviePlayerScalingModeDidChangeNotification object:_player.moviePlayer];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerDidFinishPlay) name:MPMoviePlayerPlaybackDidFinishNotification object:_player.moviePlayer];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerDidPlay) name:MPMoviePlayerDidExitFullscreenNotification object:_player.moviePlayer];
    
    _isDisturb = NO;
}

- (void)playerDidFinishPlay{
    _player.moviePlayer.scalingMode = MPMovieScalingModeFill;
    if (_isDisturb == NO) {
        [UIView animateWithDuration:0.5 animations:^{
            _player.view.alpha = 0 ;
        } completion:^(BOOL finished) {
            [_player.view removeFromSuperview];
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
        }];
    }
}
- (void)playerWillPlay{
    _player.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)playerDidPlay{
    _player.moviePlayer.scalingMode = MPMovieScalingModeFill;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark - scrollView的各种代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"scrollView.contentOffset.y： %f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y > _contentOffSetY) {
        //表格向上拖，变大，消失
        [UIView animateWithDuration:.4 animations:^{
            effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT, 60, 60);
        }];
        if (scrollView.contentOffset.y < 0 ) {
            [UIView animateWithDuration:.4 animations:^{
                effectView.frame = CGRectMake(SCREEN_WIDTH / 2 - 30 , SCREEN_HEIGHT - 76, 60, 60);
            }];
        }
    }else{
        [UIView animateWithDuration:.4 animations:^{
            effectView.frame = CGRectMake(SCREEN_WIDTH / 2 - 30 , SCREEN_HEIGHT - 76, 60, 60);
        }];
    }
    _contentOffSetY = scrollView.contentOffset.y;
}

#pragma mark 发布动态
- (void)cameraClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(publishVideo)]) {
        [self.delegate publishVideo];
    }
}



@end
