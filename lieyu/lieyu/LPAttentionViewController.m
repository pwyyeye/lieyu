//
//  LPAttentionViewController.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/2.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LPAttentionViewController.h"

@interface LPAttentionViewController ()

@end

@implementation LPAttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注意事项";
//    self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;
    //back item zhuyi
    UIBarButtonItem *leftBack = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"leftBackItem"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftBack;
    
    
    _label1.textAlignment = NSTextAlignmentNatural;
//    CGSize size = [self.label1.text sizeWithFont:_label1.font constrainedToSize:CGSizeMake(_label1.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
//    
//    NSMutableAttributedString *attributeString1= [[NSMutableAttributedString alloc] initWithString:self.label1.text];
//    //计算文字大小，参数一定要符合相应的字体和大小
//    CGSize attributeSize1 = [attributeString1.string sizeWithAttributes:@{NSFontAttributeName:self.label1.font}];
//    //    //计算字符间隔
//    CGRect frame1 = CGRectMake(10, 35, size.width, size.height);
//    NSNumber *wordSpace1 = [NSNumber numberWithInt:(frame1.size.width - attributeSize1.width)/(attributeString1.length-1)];
//    //    //添加属性
//    [attributeString1 addAttribute:NSKernAttributeName value:wordSpace1 range:NSMakeRange(0, attributeString1.length)];
//    _label1.attributedText = attributeString1;
/*
 
 
 
 UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 200, 20)];
 label.font = [UIFont boldSystemFontOfSize:20.0f];  //UILabel的字体大小
 label.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
 label.textColor = [UIColor whiteColor];
 label.textAlignment = NSTextAlignmentLeft;  //文本对齐方式
 [label setBackgroundColor:[UIColor redColor]];
 
 //宽度不变，根据字的多少计算label的高度
 NSString *str = @"可以更改此内容进行测试，宽度不变，高度根据内容自动调节";
 CGSize size = [str sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
 //根据计算结果重新设置UILabel的尺寸
 [label setFrame:CGRectMake(0, 10, 200, size.height)];
 label.text = str;
 
 [self.view addSubview:label];
 [label release];
    NSMutableAttributedString *attributeString1= [[NSMutableAttributedString alloc] initWithString:self.label1.text];
    //计算文字大小，参数一定要符合相应的字体和大小
    CGSize attributeSize1 = [attributeString1.string sizeWithAttributes:@{NSFontAttributeName:self.label1.font}];
//    //计算字符间隔
    CGSize frame1 = self.label1.frame.size;
    NSNumber *wordSpace1 = [NSNumber numberWithInt:(frame1.width-attributeSize1.width)/(attributeString1.length-1)];
//    //添加属性
    [attributeString1 addAttribute:NSKernAttributeName value:wordSpace1 range:NSMakeRange(0, attributeString1.length)];
    _label1.attributedText = attributeString1;
    
    NSMutableAttributedString *attributeString2= [[NSMutableAttributedString alloc] initWithString:self.label2.text];
    //计算文字大小，参数一定要符合相应的字体和大小
    CGSize attributeSize2 = [attributeString2.string sizeWithAttributes:@{NSFontAttributeName:self.label2.font}];
    //    //计算字符间隔
    CGSize frame2 = self.label2.frame.size;
    NSNumber *wordSpace2 = [NSNumber numberWithInt:(frame2.width-attributeSize2.width)/(attributeString2.length-1)];
    //    //添加属性
    [attributeString2 addAttribute:NSKernAttributeName value:wordSpace2 range:NSMakeRange(0, attributeString2.length)];
    _label2.attributedText = attributeString2;
    
    NSMutableAttributedString *attributeString3= [[NSMutableAttributedString alloc] initWithString:self.label3.text];
    //计算文字大小，参数一定要符合相应的字体和大小
    CGSize attributeSize3 = [attributeString3.string sizeWithAttributes:@{NSFontAttributeName:self.label3.font}];
    //    //计算字符间隔
    CGSize frame3 = self.label3.frame.size;
    NSNumber *wordSpace3 = [NSNumber numberWithInt:(frame3.width-attributeSize3.width)/(attributeString3.length-1)];
    //    //添加属性
    [attributeString3 addAttribute:NSKernAttributeName value:wordSpace3 range:NSMakeRange(0, attributeString3.length)];
    _label3.attributedText = attributeString3;
    
    NSMutableAttributedString *attributeString4= [[NSMutableAttributedString alloc] initWithString:self.label4.text];
    //计算文字大小，参数一定要符合相应的字体和大小
    CGSize attributeSize4 = [attributeString4.string sizeWithAttributes:@{NSFontAttributeName:self.label4.font}];
    //    //计算字符间隔
    CGSize frame4 = self.label4.frame.size;
    NSNumber *wordSpace4 = [NSNumber numberWithInt:(frame4.width-attributeSize4.width)/(attributeString4.length-1)];
    //    //添加属性
    [attributeString4 addAttribute:NSKernAttributeName value:wordSpace4 range:NSMakeRange(0, attributeString4.length)];
    _label4.attributedText = attributeString4;*/
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
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
