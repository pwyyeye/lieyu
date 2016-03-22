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

@interface LYFriendsTopicViewController (){
    NSInteger _pageStartCount,_pageCount;
    UIVisualEffectView *_effectView;
    UIButton *_carmerBtn;
    CGFloat _contentOffSetY;
}

@end

@implementation LYFriendsTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _pageStartCount = 0;
    _pageCount = 10;
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
        _effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 123, 60, 60);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            _effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 130, 60, 60);
        }];
    }];
}


#pragma mark 发布动态
- (void)carmerClick:(UIButton *)carmerClick{
    LYFriendsSendViewController *friendsSendVC = [[LYFriendsSendViewController alloc]init];
    friendsSendVC.TopicID = _topicTypeId;
    friendsSendVC.TopicTitle = [NSString stringWithFormat:@"#%@#", _topicName];
    [self.navigationController pushViewController:friendsSendVC animated:YES];
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
        [weakSelf addTableViewHeader];
    }];
    
}

- (void)addTableViewHeader{
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 187 / 375)];
    imgView.backgroundColor = [UIColor redColor];
    [imgView sd_setImageWithURL:[NSURL URLWithString:_headerViewImgLink] placeholderImage:[UIImage imageNamed:@"empyImage16_9"]];
    self.tableView.tableHeaderView = imgView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > _contentOffSetY) {
        if (scrollView.contentOffset.y <= 0.f) {
            _effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 130, 60, 60);
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
