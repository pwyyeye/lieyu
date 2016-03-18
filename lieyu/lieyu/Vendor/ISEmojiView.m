//
//  ISEmojiView.m
//  ISEmojiViewSample
//
//  Created by isaced on 14/12/25.
//  Copyright (c) 2014 Year isaced. All rights reserved.
//

#import "ISEmojiView.h"

static const CGFloat EmojiWidth = 53;
static const CGFloat EmojiHeight = 50;
static const CGFloat EmojiFontSize = 32;

@interface ISEmojiView()<UIScrollViewDelegate>

/**
 *  All emoji characters
 */
@property (nonatomic, strong) NSArray *emojis;

@end

@implementation ISEmojiView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        // init emojis
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ISEmojiList" ofType:@"plist"];
        self.emojis = [NSArray arrayWithContentsOfFile:plistPath];
        
        //
        NSInteger rowNum = ((CGRectGetHeight(frame) - 40) / EmojiHeight);
        NSInteger colNum = (CGRectGetWidth(frame) / EmojiWidth);
        NSInteger numOfPage = ceil((float)[self.emojis count] / (float)(rowNum * colNum));
        
        // init scrollview
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.delegate = self;
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(frame) * numOfPage,
                                                 CGRectGetHeight(frame));
        [self addSubview:self.scrollView];
        
        // add emojis
        
        NSInteger row = 0;
        NSInteger column = 0;
        NSInteger page = 0;
        
        NSInteger emojiPointer = 0;
        for (int i = 0; i < [self.emojis count] + numOfPage - 1; i++) {
            
            // Pagination
            if (i % (rowNum * colNum) == 0) {
                page ++;    // Increase the number of pages
                row = 0;    // the number of lines is 0
                column = 0; // the number of columns is 0
            }else if (i % colNum == 0) {
                // NewLine
                row += 1;   // Increase the number of lines
                column = 0; // The number of columns is 0
            }
            
            CGRect currentRect = CGRectMake(((page-1) * frame.size.width) + (column * EmojiWidth),
                                            row * EmojiHeight,
                                            EmojiWidth,
                                            EmojiHeight);
            
            if (row == (rowNum - 1) && column == (colNum - 1)) {
                // last position of page, add delete button
                
                UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [deleteButton setImage:[UIImage imageNamed:@"emojDelete"] forState:UIControlStateNormal];
                deleteButton.frame = currentRect;
                deleteButton.tintColor = [UIColor blackColor];
                [self.scrollView addSubview:deleteButton];
                
            }else{
                NSString *emoji = self.emojis[emojiPointer++];
                
                // init Emoji Button
                UIButton *emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
                emojiButton.titleLabel.font = [UIFont fontWithName:@"Apple color emoji" size:EmojiFontSize];
                [emojiButton setTitle:emoji forState:UIControlStateNormal];
                [emojiButton addTarget:self action:@selector(emojiButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                emojiButton.frame = currentRect;
                [self.scrollView addSubview:emojiButton];
            }
            
            column++;
        }
        
        // add PageControl
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.hidesForSinglePage = YES;
        self.pageControl.currentPage = 0;
        self.pageControl.backgroundColor = [UIColor clearColor];
        self.pageControl.numberOfPages = numOfPage;
        self.pageControl.pageIndicatorTintColor = RGBA(200, 200,200, 1);
        self.pageControl.currentPageIndicatorTintColor = RGBA(120, 120, 120, 1);
        CGSize pageControlSize = [self.pageControl sizeForNumberOfPages:numOfPage];
        self.pageControl.frame = CGRectMake(CGRectGetMidX(frame) - (pageControlSize.width / 2),
                                            CGRectGetHeight(frame) - pageControlSize.height + 5 - 40,
                                            pageControlSize.width,
                                            pageControlSize.height);
        [self.pageControl addTarget:self action:@selector(pageControlTouched:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.pageControl];
        
        // default allow animation
        self.popAnimationEnable = YES;
        
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        UIView *sendView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 40, SCREEN_WIDTH, 40)];
        sendView.backgroundColor = [UIColor whiteColor];
        [self addSubview:sendView];
        
        UIImageView *shadowImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60 - 37, 0, 37, 40)];
        shadowImgView.image = [UIImage imageNamed:@"emojShadow"];
        [sendView addSubview:shadowImgView];
        
        _sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 0, 60, 40)];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:RGBA(114, 114, 114, 1) forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];

        [_sendBtn setBackgroundColor:RGBA(250, 250, 250, 1)];
//        _sendBtn.layer.borderColor = RGBA(244, 244, 246, 1).CGColor;
//        _sendBtn.layer.borderWidth = 0.3;
        [_sendBtn addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
        [sendView addSubview:_sendBtn];
        
        UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        grayView.backgroundColor = RGBA(244, 244, 246, 1);
        [sendView addSubview:grayView];
        
        UIButton *emojNormal = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
        emojNormal.backgroundColor = RGBA(244, 244, 246, 1);
        [emojNormal setImage:[UIImage imageNamed:@"emojNormal"] forState:UIControlStateNormal];
        [sendView addSubview:emojNormal];
    }
    return self;
}

- (void)sendClick:(UIButton *)button{
    if ([_delegate respondsToSelector:@selector(emojiView:didPressSendButton:)]) {
        [_delegate emojiView:self didPressSendButton:button];
    }
}

- (void)pageControlTouched:(UIPageControl *)sender {
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * sender.currentPage;
    [self.scrollView scrollRectToVisible:bounds animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
    NSInteger newPageNumber = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (self.pageControl.currentPage == newPageNumber) {
        return;
    }
    self.pageControl.currentPage = newPageNumber;
}

- (void)emojiButtonPressed:(UIButton *)button {
    
    // Add a simple scale animation
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.byValue = @0.3;
    animation.duration = 0.1;
    animation.autoreverses = YES;
    [button.layer addAnimation:animation forKey:nil];

    if (self.popAnimationEnable) {
        // Animation emojibutton
        UIButton *animationEmojiButton = [UIButton buttonWithType:UIButtonTypeCustom];;
        [animationEmojiButton setTitle: [button titleForState:UIControlStateNormal] forState:UIControlStateNormal];
        animationEmojiButton.titleLabel.font = [UIFont fontWithName:@"Apple color emoji" size:EmojiFontSize];
        
        // Conver frame from scrollview to self and add to self
        animationEmojiButton.frame = [button.superview convertRect:button.frame toView:self];
        [self addSubview:animationEmojiButton];
        
        // get animation traget position from input view
        CGPoint newPoint = [self.inputView convertPoint:self.inputView.center toView:self];
        [UIView animateWithDuration:0.3 animations:^{
//            animationEmojiButton.center = newPoint;
//            animationEmojiButton.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                // Callback
                if ([self.delegate respondsToSelector:@selector(emojiView:didSelectEmoji:)]) {
                    [self.delegate emojiView:self didSelectEmoji:button.titleLabel.text];
                }
                [animationEmojiButton removeFromSuperview];
            }
        }];
    }else{
        // Callback
        if ([self.delegate respondsToSelector:@selector(emojiView:didSelectEmoji:)]) {
            [self.delegate emojiView:self didSelectEmoji:button.titleLabel.text];
        }
    }
}

- (void)deleteButtonPressed:(UIButton *)button{
    // Add a simple scale animation
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.toValue = @0.9;
    animation.duration = 0.1;
    animation.autoreverses = YES;
    [button.layer addAnimation:animation forKey:nil];
    
    // Callback
    if ([self.delegate respondsToSelector:@selector(emojiView:didPressDeleteButton:)]) {
        [self.delegate emojiView:self didPressDeleteButton:button];
    }
}

@end

@implementation ISDeleteButton

/**
 *  Draw the delete key
 *
 *  @param rect Context Rect
 */
-(void)drawRect:(CGRect)rect{

    // Rectangle Drawing
    UIBezierPath* rectanglePath = UIBezierPath.bezierPath;
    [rectanglePath moveToPoint: CGPointMake(10, 25.05)];
    [rectanglePath addLineToPoint: CGPointMake(20.16, 33)];
    [rectanglePath addLineToPoint: CGPointMake(40.5, 33)];
    [rectanglePath addLineToPoint: CGPointMake(40.5, 16.5)];
    [rectanglePath addLineToPoint: CGPointMake(20.16, 16.5)];
    [rectanglePath addLineToPoint: CGPointMake(10, 25.05)];
    [rectanglePath closePath];
    [self.tintColor setStroke];
    rectanglePath.lineWidth = 1;
    [rectanglePath stroke];
    
    
    // Bezier Drawing
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint: CGPointMake(26.5, 20)];
    [bezierPath addLineToPoint: CGPointMake(36.5, 29.5)];
    [bezierPath moveToPoint: CGPointMake(36.5, 20)];
    [bezierPath addLineToPoint: CGPointMake(26.5, 29.5)];
    [self.tintColor setStroke];
    bezierPath.lineWidth = 1;
    [bezierPath stroke];
}

@end
