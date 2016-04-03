//
//  FingerAnalyseViewController.m
//  lieyu
//
//  Created by 狼族 on 16/4/1.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "FingerAnalyseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FingerMainViewController.h"

@interface FingerAnalyseViewController (){
    UIScrollView *_scrollview;
    UIImageView *_analyseImgV;
    NSMutableArray *_percentCount;
    NSArray *_typeArray,*_detailArray;
    NSString *_percentStr,*_typeStr,*_detailStr;
    NSInteger _count,_progressViewWidth;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressView_cons_width;

@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *label_percent;
@property (weak, nonatomic) IBOutlet UILabel *label_type;
@property (weak, nonatomic) IBOutlet UITextView *textView_detail;
@property (weak, nonatomic) IBOutlet UILabel *label_fenxi;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textview_cons_bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label_percent_cons_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label_percent_cons_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textview_cons_right;

@end

@implementation FingerAnalyseViewController{
    AVAudioPlayer *_player;
    NSTimer *_timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _textView_detail.editable = NO;
    // Do any additional setup after loading the view from its nib.
    _percentCount = [[NSMutableArray alloc]initWithCapacity:0];
    _progressView.layer.cornerRadius = CGRectGetHeight(_progressView.frame)/2.f;
    for (int i = 75; i < 101; i ++) {
        [_percentCount addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    _label_percent_cons_left.constant = 0.13848631 *SCREEN_WIDTH;
    _label_percent_cons_top.constant = 0.06431159 * SCREEN_HEIGHT;
    _textview_cons_right.constant = 0.12848631 *SCREEN_WIDTH;
    
    if([[MyUtil deviceString] isEqualToString:@"iPhone 4S"]||
       [[MyUtil deviceString] isEqualToString:@"iPhone 4"]){
        _textview_cons_bottom.constant = 208;
    }
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"fingerAnalyse" ofType:@"mp3"]] error:nil];
    [_player prepareToPlay];
    _player.numberOfLoops = -1;
    [_player play];
    
    _typeArray = @[@"细熬慢炖式爱情",
                   @"互补式爱情",
                   @"一见钟情式爱情",
                   @"浪漫式爱情",
                   @"游戏式爱情",
                   @"占有式爱情",
                   @"伴侣式爱情",
                   @"奉献式爱情",
                   @"现实式爱情",
                   @"好朋友式爱情",
                   @"利他式爱情",
                   @"一体式爱情",
                   @"以假乱真类式爱情",
                   @"完美式爱情类",
                   @"为性而爱",
                   @"无奈之爱",
                   @"日久之爱",
                   @"柏拉图式恋爱",
                   @"机会主义式爱情",
                   @"理智型爱情",
                   @"情绪型爱情",
                   @"好奇型爱情",
                   @"智慧型爱情",
                   @"胆小型爱情",
                   @"好面子型爱情",
                   @"沉默型爱情",
                   @"喜欢式爱情",
                   @"迷恋式爱情",
                   @"空洞式爱情",
                   @"愚蠢式爱情"];
    
    _detailArray = @[@"你们的感情类似于《名侦探柯蓝》中的工藤新一与毛利兰，属于细熬慢炖型。",
                   @"你们俩的组合就像贝克汉姆与维多利亚，属于互补型的组合。",
                   @"你俩有望上演司马相如与卓文君的一见钟情，是非常理想的一对。",
                   @"你们俩是将爱情理想化，强调形体美，追求肉体与心灵融合为一个境界。",
                   @"你们俩是视恋爱如游戏，只追求个人需求只满足，对其所爱者不负道义责任。因而对恋爱对象之更换，视为轻易之事。",
                   @"你们俩是对所爱之对象，付予极强烈之感情，希望对方以同样的方式以回应之，具极度占有欲，对方稍有怠忽，即心存猜疑妒忌。",
                   @"你们俩是在缓慢中逐渐由友情转变为爱情，在这种爱情之中，温存多于热情，信任多于嫉妒，是一种平淡而深厚的爱情。",
                   @"你们俩是付出不是回报的原则，甘愿为其所爱牺牲一切，不求回报。",
                   @"你们俩是将爱情视为生活之应用，但求彼此实现需求的满足，不求理想的追求。男子娶妻，煮饭洗衣，女子嫁汉，穿衣吃饭，正为此种爱情的典型。",
                   @"你们俩如同亲密的朋友关系，没有神秘感、缺乏冲动，多由异性朋友发展而来。",
                   @"你们俩是无私的、利他地爱，温柔、关爱、忠诚而且付出是无条件的，不求回报。",
                   @"你们俩是在共同的目标下勤勤恳恳工作、生活，就象周恩来与邓颖超、孙中山与宋庆龄一样。",
                   @"你们俩一般都是为了帮助朋友不被别人追而去假冒朋友的女友/男友,结果成真了有爱情。",
                   @"你们俩的爱情开头都是不完美的,到了最终的结局却是完美的。",
                   @"你们俩是很明显是为性欲和性感来的。这种爱是浪漫的。",
                   @"你们俩主要是迫一某些原因勉强而为的，如年龄，条件等因素而接受的。这种爱是平淡的。",
                   @"你们俩是因为长时间相处产生了依赖直情，因此去爱对方，可以说是因一些道德观念，念旧情绪等引起的。这种爱是长久的。",
                   @"你们俩是柏拉图式恋爱也称为柏拉图式爱情，以西方哲学家柏拉图命名的一种精神恋爱，追求心灵沟通，排斥肉欲。",
                   @"你们俩有很随和的个性，随时都可以坠入情网，你的爱情可以随时发生，也可以随时结束。你选择的爱情一定非常适合你，因为你是一个能掌握爱情机会并创造幸运的人。",
                   @"你们俩天性善良，喜欢享受爱情，能够理智的区分感情，知道谁才是真正的爱你，因此你很懂得保护自己。",
                   @"你们俩是一个感情丰富的人，你的爱情气氛是非常重要的，因为你是顺应情绪发展感情的人。因此你爱的很执着也很专一，你需要的是拥抱和呵护的感情。",
                   @"你是一个喜欢表现个人特色，又能够享受人生的人。不适合与忧郁的人在一起。你的情人必须热情、活泼又机智，才能帮助你创造一个有变化的人生，并满足你的好奇心。你是一个智慧又快乐的人，但是欠缺了一些勇气，使你没办法表现更多的智慧和才华。你需要一个机智又人生经验丰富的伴侣。",
                   @"天性需要友情和伴侣，爱情机会非常多，但是常常错失良缘。你的爱情需要鼓励和支持，也需要了解爱情和多听朋友的意见，如此你才会懂得如何去掌握和创造爱情。并使自己成为智慧型的人。",
                   @"你不是一个容易恋爱的人。缺乏人生经验又胆小，不能区分情人的好坏，多半是以固执的态度交朋友。常常因为情绪冲动而在朋友之间发生爱情，只有在遇见一个很懂得谈恋爱的人，才会和你创造爱情奇迹。",
                   @"你需要被人捧着呵护才能谈恋爱，你的情人必须很了解你的性格，随时能够观察你的需要。他的体贴和谅解能够打动你的芳心，当然，你也会是一个非常体贴、温柔、善良、可爱的小情人。",
                   @"你的个性非常的乖巧，因为不喜欢反对别人的意见，所以让你变成一个沉默型的情人。这种类型的人，容易爱上善于表达言词的人。而这类的人往往主动表示关怀和合作，和你建立了良好的关系，也许他多少会挑剔或嫌弃你，但只要他心存善意，应该还是你的好情人。",
                   @"只有亲密，在一起感觉很舒服，但是觉得缺少激情，也不一定愿意厮守终生。没有激情和承诺，如友谊。显然，友谊并不是爱情，喜欢并不等于爱情。不过友谊还是有可能发展成爱情的，尽管有人因为恋爱不成连友谊都丢了。",
                   @"只有激情体验。认为对方有强烈吸引力，除此之外，对对方了解不多，也没有想过将来。只有激情，没有亲密和承诺，如初恋。第一次的恋爱总是充满了激情，却少了成熟与稳重，是一种受到本能牵引和导向的青涩爱情。",
                   @"只有承诺。缺乏亲密和激情，如纯粹的为了结婚的爱情。此类“爱情”看上去丰满，却缺少必要的内容，金玉其外，败絮其中。",
                   @"只有激情和承诺，没有亲密关系。没有亲密的激情顶多是生理上的冲动，而没有亲密的承诺不过是空头支票。"];
    
    
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - SCREEN_HEIGHT * 0.1567029 - SCREEN_HEIGHT *0.213315, SCREEN_WIDTH, SCREEN_HEIGHT * 0.1567029)];
    _scrollview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollview];
    
    _analyseImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, (_scrollview.frame.size.height - 71) /2.f , 779, 71)];
    _analyseImgV.image = [UIImage imageNamed:@"指纹分析"];
    [_scrollview addSubview:_analyseImgV];
    
    _scrollview.contentSize  =CGSizeMake(_analyseImgV.frame.size.width, 0);
    [_scrollview setContentOffset:CGPointMake(_scrollview.contentSize.width - SCREEN_WIDTH, 0)];
    
    _scrollview.userInteractionEnabled = NO;
    
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:5 animations:^{
            [_scrollview setContentOffset:CGPointMake(0, 0)];
        NSInteger percentRandomN = arc4random()%_percentCount.count;
        NSInteger typeRandomN = arc4random()%_typeArray.count;
        NSInteger detailRandomN = arc4random()%_detailArray.count;
        _percentStr = _percentCount[percentRandomN];
        _typeStr = _typeArray[typeRandomN];
        _detailStr = _detailArray[detailRandomN];
    } completion:^(BOOL finished) {
        _label_fenxi.hidden = YES;
        [_player stop];
        [weakSelf updateResult];
    }];
}

- (void)updateResult{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)onTimer:(NSTimer *)timer{
    _count ++;
//    _progressViewWidth ++;
    _label_percent.text = [NSString stringWithFormat:@"配对率:%ld%@",_count,@"%"];
    _progressView_cons_width.constant = _count / 100.f * (SCREEN_WIDTH * (1- 0.26797262));
    _label_type.text = [NSString stringWithFormat:@"配对型:%@",_typeStr];
    _textView_detail.text = _detailStr;
    
    
    if (_count == _percentStr.integerValue) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backClick:(id)sender {
    NSLog(@"--->%@",self.navigationController.viewControllers);
    __weak __typeof(self) weakSelf = self;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[FingerMainViewController class]]) {
            [weakSelf.navigationController popToViewController:obj animated:YES];
        }
    }];
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
