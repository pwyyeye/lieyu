//
//  EmptyView.m
//
//  Code generated using QuartzCode 1.38.4 on 16/2/20.
//  www.quartzcodeapp.com
//

#import "EmptyView.h"
#import "QCMethod.h"

@interface EmptyView ()

@property (nonatomic, strong) NSMutableDictionary * layers;


@end

@implementation EmptyView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setupProperties];
		[self setupLayers];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self setupProperties];
		[self setupLayers];
	}
	return self;
}

- (void)setupProperties{
	self.layers = [NSMutableDictionary dictionary];
	
}

- (void)setupLayers{
	CAShapeLayer * path1 = [CAShapeLayer layer];
	path1.frame     = CGRectMake(10, 7.55, 80, 84.91);
	path1.fillColor = [UIColor colorWithRed:0.729 green: 0.157 blue:0.89 alpha:1].CGColor;
	path1.lineWidth = 0;
	path1.path      = [self path1Path].CGPath;
	[self.layer addSublayer:path1];
	self.layers[@"path1"] = path1;
}



#pragma mark - Animation Setup

- (void)addUntitled1Animation{
	NSString * fillMode = kCAFillModeForwards;
	
	////An infinity animation
	
	////Path1 animation
	CAKeyframeAnimation * path1TransformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	path1TransformAnim.values         = @[[NSValue valueWithCATransform3D:CATransform3DIdentity], 
		 [NSValue valueWithCATransform3D:CATransform3DIdentity], 
		 [NSValue valueWithCATransform3D:CATransform3DMakeScale(-1, 1, 1)], 
		 [NSValue valueWithCATransform3D:CATransform3DIdentity]];
	path1TransformAnim.keyTimes       = @[@0, @0.219, @0.642, @1];
	path1TransformAnim.duration       = 2.37;
	path1TransformAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.36 :0.0219 :0.344 :1.01];
	path1TransformAnim.repeatCount    = INFINITY;
	
	CAAnimationGroup * path1Untitled1Anim = [QCMethod groupAnimations:@[path1TransformAnim] fillMode:fillMode];
	[self.layers[@"path1"] addAnimation:path1Untitled1Anim forKey:@"path1Untitled1Anim"];
}

#pragma mark - Animation Cleanup

- (void)updateLayerValuesForAnimationId:(NSString *)identifier{
	if([identifier isEqualToString:@"Untitled1"]){
		[QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"path1"] animationForKey:@"path1Untitled1Anim"] theLayer:self.layers[@"path1"]];
	}
}

- (void)removeAnimationsForAnimationId:(NSString *)identifier{
	if([identifier isEqualToString:@"Untitled1"]){
		[self.layers[@"path1"] removeAnimationForKey:@"path1Untitled1Anim"];
	}
}

- (void)removeAllAnimations{
	[self.layers enumerateKeysAndObjectsUsingBlock:^(id key, CALayer *layer, BOOL *stop) {
		[layer removeAllAnimations];
	}];
}

#pragma mark - Bezier Path

- (UIBezierPath*)path1Path{
	UIBezierPath *path1Path = [UIBezierPath bezierPath];
	[path1Path moveToPoint:CGPointMake(33.052, 81.859)];
	[path1Path addCurveToPoint:CGPointMake(37.796, 77.115) controlPoint1:CGPointMake(35.652, 81.851) controlPoint2:CGPointMake(37.815, 79.702)];
	[path1Path addLineToPoint:CGPointMake(38.134, 42.213)];
	[path1Path addCurveToPoint:CGPointMake(37.118, 39.841) controlPoint1:CGPointMake(38.132, 41.511) controlPoint2:CGPointMake(37.682, 40.413)];
	[path1Path addLineToPoint:CGPointMake(0.522, 3.245)];
	[path1Path addCurveToPoint:CGPointMake(1.199, 1.55) controlPoint1:CGPointMake(-0.388, 2.343) controlPoint2:CGPointMake(-0.074, 1.585)];
	[path1Path addLineToPoint:CGPointMake(2.385, 1.72)];
	[path1Path addCurveToPoint:CGPointMake(5.604, 2.906) controlPoint1:CGPointMake(3.415, 1.585) controlPoint2:CGPointMake(4.879, 2.192)];
	[path1Path addLineToPoint:CGPointMake(38.812, 36.114)];
	[path1Path addCurveToPoint:CGPointMake(41.015, 36.283) controlPoint1:CGPointMake(39.501, 36.813) controlPoint2:CGPointMake(40.19, 37.063)];
	[path1Path addLineToPoint:CGPointMake(74.561, 2.736)];
	[path1Path addCurveToPoint:CGPointMake(77.78, 1.211) controlPoint1:CGPointMake(75.363, 1.89) controlPoint2:CGPointMake(76.827, 1.277)];
	[path1Path addLineToPoint:CGPointMake(78.797, 1.211)];
	[path1Path addCurveToPoint:CGPointMake(79.475, 2.906) controlPoint1:CGPointMake(80.076, 1.252) controlPoint2:CGPointMake(80.389, 2.002)];
	[path1Path addLineToPoint:CGPointMake(42.878, 39.502)];
	[path1Path addCurveToPoint:CGPointMake(41.862, 41.874) controlPoint1:CGPointMake(42.317, 40.074) controlPoint2:CGPointMake(41.863, 41.173)];
	[path1Path addLineToPoint:CGPointMake(41.862, 77.115)];
	[path1Path addCurveToPoint:CGPointMake(46.606, 81.859) controlPoint1:CGPointMake(41.886, 79.634) controlPoint2:CGPointMake(44.032, 81.787)];
	[path1Path addLineToPoint:CGPointMake(52.027, 81.859)];
	[path1Path addCurveToPoint:CGPointMake(55.755, 84.231) controlPoint1:CGPointMake(53.82, 81.643) controlPoint2:CGPointMake(55.794, 84.174)];
	[path1Path addCurveToPoint:CGPointMake(55.416, 84.909) controlPoint1:CGPointMake(56.141, 84.571) controlPoint2:CGPointMake(55.994, 84.893)];
	[path1Path addLineToPoint:CGPointMake(24.919, 84.909)];
	[path1Path addCurveToPoint:CGPointMake(24.58, 84.231) controlPoint1:CGPointMake(24.341, 84.894) controlPoint2:CGPointMake(24.2, 84.575)];
	[path1Path addCurveToPoint:CGPointMake(28.308, 81.859) controlPoint1:CGPointMake(24.567, 84.194) controlPoint2:CGPointMake(26.65, 81.711)];
	[path1Path addLineToPoint:CGPointMake(33.052, 81.859)];
	[path1Path addLineToPoint:CGPointMake(33.052, 81.859)];
	[path1Path addLineToPoint:CGPointMake(33.052, 81.859)];
	[path1Path addLineToPoint:CGPointMake(33.052, 81.859)];
	[path1Path addLineToPoint:CGPointMake(33.052, 81.859)];
	[path1Path addLineToPoint:CGPointMake(33.052, 81.859)];
	[path1Path addLineToPoint:CGPointMake(33.052, 81.859)];
	[path1Path closePath];
	[path1Path moveToPoint:CGPointMake(71.173, 2.397)];
	[path1Path addCurveToPoint:CGPointMake(50.841, 14.935) controlPoint1:CGPointMake(65.69, 6.575) controlPoint2:CGPointMake(60.942, 12.002)];
	[path1Path addCurveToPoint:CGPointMake(32.204, 16.629) controlPoint1:CGPointMake(46.37, 16.112) controlPoint2:CGPointMake(35.421, 15.503)];
	[path1Path addCurveToPoint:CGPointMake(25.089, 20.357) controlPoint1:CGPointMake(32.121, 16.549) controlPoint2:CGPointMake(26.441, 18.319)];
	[path1Path addLineToPoint:CGPointMake(39.659, 34.927)];
	[path1Path addCurveToPoint:CGPointMake(40.339, 34.929) controlPoint1:CGPointMake(39.846, 35.114) controlPoint2:CGPointMake(40.15, 35.115)];
	[path1Path addCurveToPoint:CGPointMake(72.189, 3.414) controlPoint1:CGPointMake(40.339, 34.929) controlPoint2:CGPointMake(61.824, 13.63)];
	[path1Path addCurveToPoint:CGPointMake(74.731, 1.211) controlPoint1:CGPointMake(72.841, 2.753) controlPoint2:CGPointMake(73.416, 2.135)];
	[path1Path addCurveToPoint:CGPointMake(78.797, 0.195) controlPoint1:CGPointMake(76.209, 0.263) controlPoint2:CGPointMake(78.797, 0.195)];
	[path1Path addCurveToPoint:CGPointMake(71.173, 2.397) controlPoint1:CGPointMake(76.135, -0.548) controlPoint2:CGPointMake(73.082, 0.974)];
	[path1Path addLineToPoint:CGPointMake(71.173, 2.397)];
	[path1Path addLineToPoint:CGPointMake(71.173, 2.397)];
	[path1Path addLineToPoint:CGPointMake(71.173, 2.397)];
	[path1Path addLineToPoint:CGPointMake(71.173, 2.397)];
	[path1Path addLineToPoint:CGPointMake(71.173, 2.397)];
	[path1Path addLineToPoint:CGPointMake(71.173, 2.397)];
	[path1Path closePath];
	[path1Path moveToPoint:CGPointMake(71.173, 2.397)];
	
	return path1Path;
}


@end