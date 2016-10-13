//
//  FreeOrderViewController.m
//  lieyu
//
//  Created by 狼族 on 16/5/30.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "FreeOrderViewController.h"
#import "AdvisorBookIngoTableViewCell.h"
#import "AdvisorBookChooseTableViewCell.h"
#import "LYAdviserHttpTool.h"
#import "LYAdviserInfoModel.h"
#import "TimePickerView.h"
#import "ChooseNumber.h"
#import "LPAlertView.h"
#import "ChooseKaZuo.h"
#import "LYKaZuoTypeButton.h"
#import "ChoosePeopleNumber.h"
#import "AdviserBookChooseTableViewCell.h"

@interface FreeOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,LPAlertViewDelegate>
{
    NSDate *_choosedDate;
    NSUInteger _choosedNum;
    NSInteger _choosedType;
    NSString *_stringDate;
}
@property (nonatomic, strong) TimePickerView *LPTimeView;
@property (nonatomic, strong) ChooseNumber *LPPeopleView;
@property (nonatomic, strong) ChooseKaZuo *LPKaZuoView;
@property (nonatomic, strong) ChoosePeopleNumber *LPPeopleNumberView;

@end

@implementation FreeOrderViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"预订";
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self registerCells];
//    [self getdata];
}

- (void)registerCells{
    [_tableView registerNib:[UINib nibWithNibName:@"AdvisorBookChooseTableViewCell" bundle:nil] forCellReuseIdentifier:@"AdvisorBookChooseTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"AdvisorBookIngoTableViewCell" bundle:nil] forCellReuseIdentifier:@"AdvisorBookIngoTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"AdviserBookChooseTableViewCell" bundle:nil] forCellReuseIdentifier:@"AdviserBookChooseTableViewCell"];
}

#pragma mark - tableView的各种代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_barDict && _userDict) {
        return 2;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if(section == 1){
        return 3;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        AdvisorBookIngoTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"AdvisorBookIngoTableViewCell" owner:nil options:nil]firstObject];
        if (indexPath.row == 0) {
            if (_userDict) {
                cell.userDict = _userDict;
            }
        }else if(indexPath.row == 1){
            if (_barDict) {
                cell.barDict = _barDict;
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            AdvisorBookChooseTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"AdvisorBookChooseTableViewCell" owner:nil options:nil]firstObject];
            [cell configureTime];
            [cell.anvance_button addTarget:self action:@selector(chooseSomething:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            AdviserBookChooseTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"AdviserBookChooseTableViewCell" owner:nil options:nil] firstObject];
            if (indexPath.row == 1){
                [cell configureChoosePeopleNumber];
            }else if (indexPath.row == 2){
                [cell configureChooseKazuo];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 52;
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            return 52;
        }else if (indexPath.row == 1){
            return 110;
        }else{
            return 80;
        }
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

- (void)initChooseTimeView{
    LPAlertView *alertView = [[LPAlertView alloc]initWithDelegate:self buttonTitles:@"取消",@"确定", nil];
    _LPTimeView = [[[NSBundle mainBundle]loadNibNamed:@"TimePickerView" owner:nil options:nil]firstObject];
    _LPTimeView.tag = 11;
    if (!_choosedDate) {
        _LPTimeView.timePicker.date = [NSDate date];
    }else{
        [_LPTimeView showTimeWithDate:_choosedDate];
    }
    alertView.contentView = _LPTimeView;
    _LPTimeView.frame = CGRectMake(10, SCREEN_HEIGHT - 270, SCREEN_WIDTH - 20, 200);
    [_LPTimeView configreTitleForAdviser];
    
    [alertView show];
}

- (void)chooseSomething:(UIButton *)sender{
    
    if (sender.tag == 0) {
        [self initChooseTimeView];
    }
//    else if (sender.tag == 1) {//选择到场人数
//        _LPPeopleNumberView = [[[NSBundle mainBundle] loadNibNamed:@"ChoosePeopleNumber" owner:nil options:nil] firstObject];
//        _LPPeopleNumberView.tag = 16;
//        if (_choosedNum <= 0 || _choosedNum >= 11) {
//            _LPPeopleNumberView.selectedTag = 1;
//        } else {
//            _LPPeopleNumberView.selectedTag = _choosedNum;
//        }
//        alertView.contentView = _LPPeopleNumberView;
//        _LPPeopleNumberView.frame = CGRectMake(10, SCREEN_HEIGHT - 270, SCREEN_WIDTH - 20, 200);
//    }else if (sender.tag == 2){
//        _LPKaZuoView = [[[NSBundle mainBundle]loadNibNamed:@"ChooseKaZuo" owner:nil options:nil]firstObject];
//        _LPKaZuoView.tag = 15;
//        if (_choosedType <= 0 || _choosedType >= 5) {
//            _LPKaZuoView.selectedTag = 1;
//        }else{
//            _LPKaZuoView.selectedTag = _choosedType;
//        }
//        alertView.contentView = _LPKaZuoView;
//        _LPKaZuoView.frame = CGRectMake(10, SCREEN_HEIGHT - 270, SCREEN_WIDTH - 20, 200);
////        _LPKaZuoView 
//    }
    
    
}

//alertView代理时间
- (void)LPAlertView:(LPAlertView *)alertView clickedButtonAtIndexWhenTime:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        _choosedDate = _LPTimeView.timePicker.date;
        NSLog(@"time:%@",_choosedDate);
        AdvisorBookChooseTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *string = [formatter stringFromDate:_choosedDate];
        _stringDate = [[NSString alloc]initWithString:string];
        [cell.content_label setText:_stringDate];
    }else{
//        NSLog(@"time:%@",_choosedDate);
    }
}

//- (void)LPAlertView:(LPAlertView *)alertView clickedButtonAtIndexChooseNum:(NSInteger)buttonIndex{
//    if (buttonIndex == 1) {
//        _choosedNum = [_LPPeopleView.numberField.text intValue];
////        NSLog(@"number:%ld",_choosedNum);
//        AdvisorBookChooseTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
//        [cell.content_label setText:[NSString stringWithFormat:@"%ld 人",_choosedNum]];
//    }else{
////        NSLog(@"number:%ld",_choosedNum);
//    }
//}

- (void)LPAlertView:(LPAlertView *)alertView clickedButtonAtIndexChooseKaZuo:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        for (LYKaZuoTypeButton *button in _LPKaZuoView.choose_buttons) {
            if (button.choosed == YES) {
                _choosedType = button.tag;
//                NSLog(@"type:%ld",_choosedType);
                AdvisorBookChooseTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
                [cell.content_label setText:button.titleLabel.text];
                break;
            }
        }
        
    }else{
//        NSLog(@"type:%ld",_choosedType);
    }
}

- (void)LPAlertView:(LPAlertView *)alertView clickedButtonAtIndexChoosePeopleNumber:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        for (LYKaZuoTypeButton *button in _LPPeopleNumberView.choosebuttons) {
            if (button.choosed == YES) {
                _choosedNum = button.tag;
                //                NSLog(@"type:%ld",_choosedType);
                AdvisorBookChooseTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                [cell.content_label setText:button.titleLabel.text];
                break;
            }
        }
        
    }else{
        //        NSLog(@"type:%ld",_choosedType);
    }
}

- (void)checkChooseKazuo{
    AdviserBookChooseTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    
    for (LYKaZuoTypeButton *button in cell.chooseKazuo.choose_buttons) {
        if (button.choosed == YES) {
            _choosedType = button.tag;
            //                NSLog(@"type:%ld",_choosedType);
//            AdvisorBookChooseTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
//            [cell.content_label setText:button.titleLabel.text];
            break;
        }
    }
}

- (void)checkChoosePeopleNumber{
    AdviserBookChooseTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    for (LYKaZuoTypeButton *button in cell.choosePeople.choosebuttons) {
        if (button.choosed == YES) {
            _choosedNum = button.tag;
            //                NSLog(@"type:%ld",_choosedType);
//            AdvisorBookChooseTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
//            [cell.content_label setText:button.titleLabel.text];
            break;
        }
    }
}

- (IBAction)submitClick:(UIButton *)sender {
    [self checkChooseKazuo];
    [self checkChoosePeopleNumber];
    if (!_choosedDate) {
//        [MyUtil showPlaceMessage:@"请选择到达现场时间！"];
        [self initChooseTimeView];
        return;
    }
    if (_choosedNum <= 0) {
        [MyUtil showPlaceMessage:@"请选择到达现场人数！"];
        return;
    }
    if (_choosedType <= 0) {
        [MyUtil showPlaceMessage:@"请选择卡座类型！"];
        return;
    }
    NSDictionary *dict = @{@"barid":[_barDict objectForKey:@"barid"],
                           @"vipUserid":[_userDict objectForKey:@"userid"],
                           @"minPartNumber":[NSNumber numberWithInteger:_choosedNum],
                           @"partNumber":[NSNumber numberWithInteger:_choosedNum + 1],
                           @"cassetteType":[NSNumber numberWithInteger:_choosedType],
                           @"orderStatus":@"1",
                           @"reachTime":_stringDate};
    
    __weak __typeof(self)weakSelf = self;
    [LYAdviserHttpTool lyFreeBookWithParams:dict complete:^(NSString *message) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [MyUtil showPlaceMessage:message];
    }];
}
@end
