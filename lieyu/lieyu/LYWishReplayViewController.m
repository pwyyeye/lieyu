//
//  LYWishReplayViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/5/14.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYWishReplayViewController.h"
#import "LYYUHttpTool.h"

@interface LYWishReplayViewController ()

@end

@implementation LYWishReplayViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"回复";
    _questionLabel.text = _model.desc;
    _replayLabel.text = _model.replyContent;
    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    [sendBtn setTitle:@"发布" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendReply) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendReply{
    if (_replayLabel.text.length <= 0) {
        [MyUtil showPlaceMessage:@"请输入回复！"];
        return;
    }
    NSDictionary *dict = @{@"replyContent":_replayLabel.text,
                           @"id":[NSNumber numberWithInt:_model.id]};
    __weak __typeof(self) weakSelf = self;
    [LYYUHttpTool yuReplyWishCompleteWithParams:dict complete:^(BOOL result) {
        if (result) {
            _model.replyContent = _replayLabel.text;
            [weakSelf.navigationController popViewControllerAnimated:YES];
            if ([weakSelf.delegate respondsToSelector:@selector(delegateReply:)]){
                [weakSelf.delegate delegateReply:_model];
            }
        }
    }];
}

@end
