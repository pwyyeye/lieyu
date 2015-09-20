//
//  LYShareSnsView.m
//  lieyu
//
//  Created by newfly on 9/20/15.
//  Copyright © 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYShareSnsView.h"
#import "LYColors.h"

@interface LYShareSnsView()

@property(nonatomic,weak)IBOutlet UIView *viewContainer;
@property(nonatomic,weak)IBOutlet UIButton *addButton;

@end

@implementation LYShareSnsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(LYShareSnsView *)loadFromNib
{
    UINib * nib = [UINib nibWithNibName:@"LYShareSnsView" bundle:nil];
    NSArray * owners = [nib instantiateWithOwner:nil options:nil];
    LYShareSnsView *view = [owners firstObject];
    view.backgroundColor = [LYColors commonBgColor];
    return view;
}


-(IBAction)shareClick:(id)sender
{

}

- (IBAction)likeClick:(id)sender
{

}

- (IBAction)likedClick:(id)sender
{
    
}

- (IBAction)addClick:(id)sender
{
    CGRect addRc = _addButton.frame;
    __block BOOL hidden = self.viewContainer.hidden;
    hidden = !hidden;
    CGPoint endPos = addRc.origin;
    
    if (hidden == NO) {
        self.viewContainer.hidden = hidden;
    }
    
    [UIView animateWithDuration:0.3 animations:
    ^{
        if (hidden == NO)
        {
            self.viewContainer.frame = CGRectMake(0, 0, self.viewContainer.frame.size.width, self.viewContainer.frame.size.height);
        }
        else
        {
            self.viewContainer.frame = CGRectMake(endPos.x, endPos.y, self.viewContainer.frame.size.width, self.viewContainer.frame.size.height);

        }
        
    } completion:^(BOOL finished) {
        hidden == YES?(self.viewContainer.hidden = YES):NO;
    }];
}



@end








