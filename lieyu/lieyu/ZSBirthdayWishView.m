//
//  ZSBirthdayWishView.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/26.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSBirthdayWishView.h"
@interface ZSBirthdayWishView()

@property (nonatomic, strong) NSArray *textArray;

@end

@implementation ZSBirthdayWishView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    _wishTextView.layer.borderColor = [[UIColor blackColor]CGColor];
    _wishTextView.layer.borderWidth = 0.5;
    _wishTextView.layer.cornerRadius = 3;
    
    _sendWishButton.layer.borderColor = [COMMON_PURPLE CGColor];
    _sendWishButton.layer.borderWidth = 0.6;
    _sendWishButton.layer.cornerRadius = 6;
    
    _dontCareButton.layer.borderColor = [COMMON_PURPLE CGColor];
    _dontCareButton.layer.borderWidth = 0.6;
    _dontCareButton.layer.cornerRadius = 6;
    
    _textArray = @[@"亲爱的朋友，愿您天天快乐，年年好运，一生幸福！生日快乐！",
                   @"愿您的生日充满无穷的快乐，愿您今天的回忆温馨，愿您今天的梦想甜美，愿您这一年称心如意！",
                   @"打开的是吉祥，看到的是鸿运，愿所有期望和祝福涌向您，祈望您心情舒畅万事顺意，愿这美好心愿化作真挚的祝福送您：生日快乐！",
                   @"常欢笑，祝福时常身边绕，短信此刻不能少，只因你的生日到，祝您生日快乐！",
                   @"时间因祝福而流光溢彩，空气因祝福而芬芳袭人，心情因祝福而心花灿烂，祝您生日快乐！",
                   @"祈望您心灵深处芳草永绿，青春常驻，笑口常开。祝您生日快乐，健康幸福！",
                   @"忙碌的生活带走的只是时间，对朋友的牵挂常留心底，一声问候一个祝福，在这美丽神怡的日子里祝您生日快乐！",
                   @"短短的短信带上我深深的生日祝福，请允许我个人十分荣幸的代表百姓，不用千言万语，只道一句“生日快乐”！",
                   @"日月轮转永不断，情若真挚长相伴，不论您身在天涯海角，我将永远记住这一天。祝您生日快乐！",
                   @"生日到了！愿您今天有数不完的快乐，收不完的祝福，收不完的礼物，用不完的幸福！在这个美丽的时刻，祝福您生日快乐！"];
    
    self.layer.cornerRadius = 3;
}

- (void)setBookModel:(AddressBookModel *)bookModel{
    _bookModel = bookModel;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"今天是您好友%@的生日！",bookModel.name]];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 6)];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(attributeString.length - 4, 4)];
    [_nameLabel setAttributedText:attributeString];
    [_sexLabel setText:[bookModel.sex isEqualToString:@"0"] ? @"为她送上生日祝福吧！" : @"为他送上生日祝福吧！"];
    int index =  arc4random() % _textArray.count;
    [_wishTextView setText:[_textArray objectAtIndex:index]];
    if (_bookModel.mobile.length > 0) {
        _phoneButton.hidden = NO;
        [_phoneButton setTitle:bookModel.mobile forState:UIControlStateNormal];
        [_phoneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        _phoneButton.hidden = YES;
    }
}

@end
