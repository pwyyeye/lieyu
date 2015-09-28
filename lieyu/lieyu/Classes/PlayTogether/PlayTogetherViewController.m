//
//  PlayTogetherViewController.m
//  lieyu
//
//  Created by newfly on 9/19/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "PlayTogetherViewController.h"
#import "MacroDefinition.h"
#import "LYRestfulBussiness.h"

@interface PlayTogetherViewController
()

@property(nonatomic,weak) IBOutlet UIButton * allListButton;
@property(nonatomic,weak) IBOutlet UIButton * nearDistanceButton;
@property(nonatomic,strong) IBOutlet UIButton * fillterButton;
@property(nonatomic,strong) NSArray *oriNavItems;


@end

@implementation PlayTogetherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewStyles];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [self performSelector:@selector(setCustomTitle:) withObject:@"一起玩" afterDelay:0.1];
    self.oriNavItems = [self.navigationController.navigationBar.items copy];
    [self.navigationController.navigationBar addSubview:_fillterButton];
    CGRect rc = _fillterButton.frame;
    rc.origin.x = 10;
    rc.origin.y = 8;
    _fillterButton.frame = rc;

}
- (void)viewWillLayoutSubviews
{

    if (self.navigationController.navigationBarHidden != NO) {
        [self.navigationController setNavigationBarHidden:NO];

    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self setCustomTitle:nil];
    [_fillterButton removeFromSuperview];
}

- (IBAction)filterClick:(id)sender
{


}

- (void)setupViewStyles
{
//    [self.nearDistanceButton setBackgroundImage:<#(nullable UIImage *)#> forState:<#(UIControlState)#>]
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
