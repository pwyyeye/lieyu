//
//  LYActivitySendViewController.m
//  lieyu
//
//  Created by 狼族 on 16/4/23.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYActivitySendViewController.h"
#import "LYActivitySendButton.h"
#import "LYFriendsChooseLocationViewController.h"
#import "BarActivityList.h"
#import "LYYUHttpTool.h"

@interface LYActivitySendViewController ()<UITextViewDelegate,PullLocationInfo,UITextFieldDelegate>{
    
    UIScrollView *_scrollView;
    NSMutableArray *_btnArray;
    UILabel *_textCountLabel;
    UILabel *_addressStrLabel;//地址显示的label
    NSString *_currentThemeId;//当前主题id
    UITextView *_textView;//描述框
    UITextField *_yuguTextField;//预估价格
    NSArray *_titleArray;//主题数组
    BOOL _isBeyond;//字数超过50；
    BOOL _isScrollToBottom;//滑到底部
}

@end

@implementation LYActivitySendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"发布想玩";
    
    [self getDataForTheme];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(_isScrollToBottom) [_scrollView setContentOffset:CGPointMake(0, _scrollView.contentSize.height - _scrollView.frame.size.height) animated:YES];
}

#pragma mark - 获取主题
- (void)getDataForTheme{
    [LYYUHttpTool yuGetYUAllTagsWithParams:nil complete:^(NSMutableArray *yuTagsModelArr) {
        _titleArray = yuTagsModelArr;
        [self createUI];
    }];
}

- (void)createUI{
    _btnArray = [[NSMutableArray alloc]init];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _scrollView.showsVerticalScrollIndicator = NO;
    if (SCREEN_WIDTH < 375) {
        [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, 667)];
    }else{
        [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, _scrollView.frame.size.height)];
    }
    [self.view addSubview:_scrollView];
    
    UIView *btn_bottom_View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 63)];
    btn_bottom_View.backgroundColor = RGBA(247, 247, 247, 1);
    [_scrollView addSubview:btn_bottom_View];
    
    CGFloat btnWidth = (SCREEN_WIDTH - 26 - (_titleArray.count - 1) * 10) / 4.f;
    CGFloat leftEdge = 13;
    
    for (int i = 0; i < _titleArray.count; i ++) {
        BarActivityList *themeModel = _titleArray[i];
        LYActivitySendButton *btn = [[LYActivitySendButton alloc]initWithFrame:CGRectMake(leftEdge + i * (btnWidth + 10), (63 - 28)/2.f, btnWidth, 28)];
        btn.tag = i;
        if(i == 0) {
            btn.isActivitySelect = YES;
            _currentThemeId = themeModel.id;
        }
        else btn.isActivitySelect = NO;
        btn.layer.cornerRadius = 2;
        [btn setTitle:themeModel.name forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn_bottom_View addSubview:btn];
        [_btnArray addObject:btn];
    }
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(leftEdge, CGRectGetMaxY(btn_bottom_View.frame) + 10, SCREEN_WIDTH - leftEdge * 2, 66)];
    [_textView setFont:[UIFont systemFontOfSize:14]];
    _textView.delegate = self;
    _textView.text = @"你想";
    _textView.textColor = RGBA(144, 153, 167, 1);
    [_scrollView addSubview:_textView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(leftEdge, CGRectGetMaxY(_textView.frame) + 10, SCREEN_WIDTH - leftEdge * 2, 1)];
    lineView.backgroundColor = RGBA(151, 151, 151, 1);
    [_scrollView addSubview:lineView];
    
    CGFloat labelWidth = 50;
    _textCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - leftEdge - labelWidth, CGRectGetMaxY(lineView.frame) + 5, labelWidth, 17)];
    _textCountLabel.text = @"0/50";
    _textCountLabel.textAlignment = NSTextAlignmentRight;
    [_textCountLabel setFont:[UIFont systemFontOfSize:12]];
    [_scrollView addSubview:_textCountLabel];
    
    //预估按钮
    UIImageView *yuguImgVBG = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 107)/2.f, CGRectGetMaxY(_textCountLabel.frame) + 28, 107, 107)];
    yuguImgVBG.image = [UIImage imageNamed:@"yu_money_yugu"];
    yuguImgVBG.userInteractionEnabled = YES;
    [_scrollView addSubview:yuguImgVBG];
    
    //预估金额输入框
    _yuguTextField = [[UITextField alloc]initWithFrame:CGRectMake((107 - 90)/2.f, 56, 90, 33)];
    _yuguTextField.text = @"预估";
    _yuguTextField.font = [UIFont systemFontOfSize:24];
    _yuguTextField.textAlignment = NSTextAlignmentCenter;
    _yuguTextField.textColor = [UIColor whiteColor];
    _yuguTextField.delegate = self;
    _yuguTextField.keyboardType = UIKeyboardTypeNumberPad;
    [yuguImgVBG addSubview:_yuguTextField];
    
    //选择位置按钮
    CGFloat selectAddressBtnWidth = 50;
    UIButton *selectAddressBtn = [[UIButton alloc]initWithFrame:CGRectMake( (SCREEN_WIDTH - selectAddressBtnWidth)/2.f, CGRectGetMaxY(yuguImgVBG.frame) + 64, selectAddressBtnWidth, 35)];
    [selectAddressBtn setTitle:@"选择位置" forState:UIControlStateNormal];
    [selectAddressBtn setTitleColor:RGBA(178, 38, 217, 1) forState:UIControlStateNormal];
    selectAddressBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [selectAddressBtn addTarget:self action:@selector(selectAddressClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:selectAddressBtn];
    
    //地址显示文本
    _addressStrLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(selectAddressBtn.frame) + 13, SCREEN_WIDTH, 20)];
    _addressStrLabel.textAlignment = NSTextAlignmentCenter;
    [_addressStrLabel setFont:[UIFont systemFontOfSize:14]];
    _addressStrLabel.textColor = RGBA(101, 101, 101, 1);
    [_scrollView addSubview:_addressStrLabel];
    
    //发布按钮
    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(7,_scrollView.contentSize.height - 43, SCREEN_WIDTH - 14, 37)];
    NSLog(@"--->%@",NSStringFromCGRect(sendBtn.frame));
    [sendBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.backgroundColor = [UIColor blackColor];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"LoginNew"] forState:UIControlStateNormal];
    sendBtn.layer.cornerRadius = 4;
    sendBtn.layer.masksToBounds = YES;
    [sendBtn setTitle:@"立即发布" forState:UIControlStateNormal];
    [_scrollView addSubview:sendBtn];
}

#pragma mark - 主题选择
- (void)menuClick:(LYActivitySendButton *)button{
    [_btnArray enumerateObjectsUsingBlock:^(LYActivitySendButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isActivitySelect = NO;
    }];
    button.isActivitySelect = YES;
    BarActivityList *themeModel = _titleArray[button.tag];
    _currentThemeId = themeModel.id;
}

#pragma mark - 选择地址action
- (void)selectAddressClick{
//    if ([CLLocationManager locationServicesEnabled] &&
//        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized
//         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
//            //定位功能可用，开始定位
//                    }
    
     if (![CLLocationManager locationServicesEnabled]){
        [MyUtil showCleanMessage:@"定位功能不可用，请开启"];
         return;
    }
    LYFriendsChooseLocationViewController *chooseLocationVC = [[LYFriendsChooseLocationViewController alloc]init];
    chooseLocationVC.delegate = self;
    [self.navigationController pushViewController:chooseLocationVC animated:YES];
}

#pragma mark 选择地址delegate
- (void)getLocationInfo:(NSString *)city Location:(NSString *)location{
    if([city isEqualToString:@""]){
        _addressStrLabel.text = @"不显示位置";
    }else{
        _addressStrLabel.text = location;
    }
    _isScrollToBottom = YES;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    NSUInteger textCount = textView.text.length;
    _textCountLabel.text = [NSString stringWithFormat:@"%lu/50",(unsigned long)textCount];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:_textCountLabel.text];
    if(textCount > 50) {
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 2)];
        _isBeyond = YES;
    }else{
        _isBeyond = NO;
    }
    _textCountLabel.attributedText = attributedStr;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"你想"]) {
        textView.text = @"";
        textView.textColor = RGBA(73, 82, 91, 1);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (!textView.text.length) {
        textView.text = @"你想";
        textView.textColor = RGBA(144, 153, 167, 1);
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField.text isEqualToString:@"预估"]) {
        textField.text = @"";
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (!textField.text.length) {
        textField.text = @"预估";
    }
}

#pragma mark - 发布action
- (void)sendClick{
    if(!_textView.text.length || [_textView.text isEqualToString:@"你想"]){
        [MyUtil showCleanMessage:@"请点号召口语吧！"];
        return;
    }
    
    if(_isBeyond){
        [MyUtil showCleanMessage:@"号召口语超过50字！"];
        return;
    }
    
    if(!_yuguTextField.text.length || [_yuguTextField.text isEqualToString:@"预估"]){
        [MyUtil showCleanMessage:@"请输入预估金额！"];
        return;
    }
    
    if(!_addressStrLabel.text.length){
        [MyUtil showCleanMessage:@"请输入地址！"];
        return;
    }
    
    NSDictionary *dic = @{@"desc":_textView.text,
                          @"tagid":_currentThemeId,
                          @"moneyStart":_yuguTextField.text,
                          @"address":_addressStrLabel.text};
    __weak __typeof(self) weakSelf = self;
    [LYYUHttpTool yuSendMYThemeWithParams:dic complete:^(BOOL result) {
        if (result) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            if ([_delegate respondsToSelector:@selector(activitySendViewControllerSendFinish)]) {
                [_delegate activitySendViewControllerSendFinish];
            }
        }
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
