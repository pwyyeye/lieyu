//
//  qidongye.m
//
//  Code generated using QuartzCode 1.38.4 on 16/3/11.
//  www.quartzcodeapp.com
//

#import "qidongye.h"
#import "QCQDYMethod.h"

@interface qidongye ()

@property (nonatomic, strong) NSMutableDictionary * layers;
@property (nonatomic, strong) NSMapTable * completionBlocks;
@property (nonatomic, assign) BOOL  updateLayerValueForCompletedAnimation;


@end

@implementation qidongye

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
	self.completionBlocks = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsOpaqueMemory valueOptions:NSPointerFunctionsStrongMemory];;
	self.layers = [NSMutableDictionary dictionary];
	self.color_one = [UIColor colorWithRed:1 green: 0 blue:0.783 alpha:1];
	self.color_two  = [UIColor colorWithRed:0.814 green: 0.172 blue:1 alpha:1];
}

- (void)setupLayers{
	self.backgroundColor = [UIColor whiteColor];
	
	CALayer * Group2 = [CALayer layer];
	Group2.frame = CGRectMake(128.34, 289.34, 157.32, 157.32);
	[self.layer addSublayer:Group2];
	self.layers[@"Group2"] = Group2;
	{
		CAShapeLayer * polygon = [CAShapeLayer layer];
		polygon.frame = CGRectMake(0, 0, 157.32, 157.32);
		polygon.path = [self polygonPath].CGPath;
		CAGradientLayer * polygonGradient = [CAGradientLayer layer];
		[polygon addSublayer:polygonGradient];
		[Group2 addSublayer:polygon];
		self.layers[@"polygon"] = polygon;
		self.layers[@"polygonGradient"] = polygonGradient;
		CAShapeLayer * polygon2 = [CAShapeLayer layer];
		polygon2.frame = CGRectMake(3.39, 3.39, 150.54, 150.54);
		polygon2.path = [self polygon2Path].CGPath;
		[Group2 addSublayer:polygon2];
		self.layers[@"polygon2"] = polygon2;
		CALayer * Group = [CALayer layer];
		Group.frame = CGRectMake(21.29, 20.82, 115.71, 115.71);
		[Group2 addSublayer:Group];
		self.layers[@"Group"] = Group;
		{
			CAShapeLayer * path = [CAShapeLayer layer];
			path.frame = CGRectMake(0, 0, 115.71, 115.71);
			path.path = [self pathPath].CGPath;
			[Group addSublayer:path];
			self.layers[@"path"] = path;
			CAShapeLayer * CombinedShape = [CAShapeLayer layer];
			CombinedShape.frame = CGRectMake(0.21, 0.69, 115.09, 114.4);
			CombinedShape.path = [self CombinedShapePath].CGPath;
			[Group addSublayer:CombinedShape];
			self.layers[@"CombinedShape"] = CombinedShape;
		}
		
	}
	
	
	[self resetLayerPropertiesForLayerIdentifiers:nil];
}

- (void)resetLayerPropertiesForLayerIdentifiers:(NSArray *)layerIds{
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	
	if(!layerIds || [layerIds containsObject:@"Group2"]){
		CALayer * Group2 = self.layers[@"Group2"];
		Group2.backgroundColor = [UIColor colorWithRed:1 green: 1 blue:1 alpha:0].CGColor;
	}
	if(!layerIds || [layerIds containsObject:@"polygon"]){
		CAShapeLayer * polygon = self.layers[@"polygon"];
		polygon.fillColor                  = nil;
		polygon.lineWidth                  = 0;
		
		CAGradientLayer * polygonGradient = self.layers[@"polygonGradient"];
		CAShapeLayer * polygonMask         = [CAShapeLayer layer];
		polygonMask.path                   = polygon.path;
		polygonGradient.mask               = polygonMask;
		polygonGradient.frame              = polygon.bounds;
		polygonGradient.colors             = @[(id)[UIColor colorWithRed:0.814 green: 0.172 blue:1 alpha:0.197].CGColor, (id)[UIColor colorWithRed:0.729 green: 0.157 blue:0.89 alpha:0.475].CGColor];
		polygonGradient.startPoint         = CGPointMake(0.5, 0);
		polygonGradient.endPoint           = CGPointMake(0.5, 1);
	}
	if(!layerIds || [layerIds containsObject:@"polygon2"]){
		CAShapeLayer * polygon2 = self.layers[@"polygon2"];
		polygon2.fillColor = [UIColor whiteColor].CGColor;
		polygon2.lineWidth = 0;
	}
	if(!layerIds || [layerIds containsObject:@"path"]){
		CAShapeLayer * path = self.layers[@"path"];
		path.fillColor   = nil;
		path.strokeColor = [UIColor colorWithRed:0.814 green: 0.172 blue:1 alpha:1].CGColor;
		path.lineWidth   = 0.5;
	}
	if(!layerIds || [layerIds containsObject:@"CombinedShape"]){
		CAShapeLayer * CombinedShape = self.layers[@"CombinedShape"];
		CombinedShape.fillColor   = [UIColor blackColor].CGColor;
		CombinedShape.strokeColor = [UIColor whiteColor].CGColor;
	}
	
	[CATransaction commit];
}

#pragma mark - Animation Setup

- (void)addUntitled1Animation{
	[self addUntitled1AnimationCompletionBlock:nil];
}

- (void)addUntitled1AnimationCompletionBlock:(void (^)(BOOL finished))completionBlock{
	if (completionBlock){
		CABasicAnimation * completionAnim = [CABasicAnimation animationWithKeyPath:@"completionAnim"];;
		completionAnim.duration = 3;
		completionAnim.delegate = self;
		[completionAnim setValue:@"Untitled1" forKey:@"animId"];
		[completionAnim setValue:@(NO) forKey:@"needEndAnim"];
		[self.layer addAnimation:completionAnim forKey:@"Untitled1"];
		[self.completionBlocks setObject:completionBlock forKey:[self.layer animationForKey:@"Untitled1"]];
	}
	
	NSString * fillMode = kCAFillModeForwards;
	
	////Polygon2 animation
	CAKeyframeAnimation * polygon2TransformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
	polygon2TransformAnim.values         = @[@(0), 
		 @(-360 * M_PI/180)];
	polygon2TransformAnim.keyTimes       = @[@0, @1];
	polygon2TransformAnim.duration       = 3;
	polygon2TransformAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	CAAnimationGroup * polygon2Untitled1Anim = [QCQDYMethod groupAnimations:@[polygon2TransformAnim] fillMode:fillMode];
	[self.layers[@"polygon2"] addAnimation:polygon2Untitled1Anim forKey:@"polygon2Untitled1Anim"];
	
	////Path animation
	CAKeyframeAnimation * pathStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
	pathStrokeEndAnim.values         = @[@0, @1];
	pathStrokeEndAnim.keyTimes       = @[@0, @1];
	pathStrokeEndAnim.duration       = 3;
	pathStrokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	CAAnimationGroup * pathUntitled1Anim = [QCQDYMethod groupAnimations:@[pathStrokeEndAnim] fillMode:fillMode];
	[self.layers[@"path"] addAnimation:pathUntitled1Anim forKey:@"pathUntitled1Anim"];
	
	////CombinedShape animation
	CAKeyframeAnimation * CombinedShapeStrokeStartAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
	CombinedShapeStrokeStartAnim.values   = @[@0, @1];
	CombinedShapeStrokeStartAnim.keyTimes = @[@0, @1];
	CombinedShapeStrokeStartAnim.duration = 1.2;
	CombinedShapeStrokeStartAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	CAKeyframeAnimation * CombinedShapeFillColorAnim = [CAKeyframeAnimation animationWithKeyPath:@"fillColor"];
	CombinedShapeFillColorAnim.values   = @[(id)self.color_one.CGColor,
		 (id)self.color_two.CGColor];
	CombinedShapeFillColorAnim.keyTimes = @[@0, @1];
	CombinedShapeFillColorAnim.duration = 3;
	CombinedShapeFillColorAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	CAAnimationGroup * CombinedShapeUntitled1Anim = [QCQDYMethod groupAnimations:@[CombinedShapeStrokeStartAnim, CombinedShapeFillColorAnim] fillMode:fillMode];
	[self.layers[@"CombinedShape"] addAnimation:CombinedShapeUntitled1Anim forKey:@"CombinedShapeUntitled1Anim"];
}

#pragma mark - Animation Cleanup

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
	void (^completionBlock)(BOOL) = [self.completionBlocks objectForKey:anim];;
	if (completionBlock){
		[self.completionBlocks removeObjectForKey:anim];
		if ((flag && self.updateLayerValueForCompletedAnimation) || [[anim valueForKey:@"needEndAnim"] boolValue]){
			[self updateLayerValuesForAnimationId:[anim valueForKey:@"animId"]];
			[self removeAnimationsForAnimationId:[anim valueForKey:@"animId"]];
		}
		completionBlock(flag);
	}
}

- (void)updateLayerValuesForAnimationId:(NSString *)identifier{
	if([identifier isEqualToString:@"Untitled1"]){
		[QCQDYMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"polygon2"] animationForKey:@"polygon2Untitled1Anim"] theLayer:self.layers[@"polygon2"]];
		[QCQDYMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"path"] animationForKey:@"pathUntitled1Anim"] theLayer:self.layers[@"path"]];
		[QCQDYMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"CombinedShape"] animationForKey:@"CombinedShapeUntitled1Anim"] theLayer:self.layers[@"CombinedShape"]];
	}
}

- (void)removeAnimationsForAnimationId:(NSString *)identifier{
	if([identifier isEqualToString:@"Untitled1"]){
		[self.layers[@"polygon2"] removeAnimationForKey:@"polygon2Untitled1Anim"];
		[self.layers[@"path"] removeAnimationForKey:@"pathUntitled1Anim"];
		[self.layers[@"CombinedShape"] removeAnimationForKey:@"CombinedShapeUntitled1Anim"];
	}
}

- (void)removeAllAnimations{
	[self.layers enumerateKeysAndObjectsUsingBlock:^(id key, CALayer *layer, BOOL *stop) {
		[layer removeAllAnimations];
	}];
}

#pragma mark - Bezier Path

- (UIBezierPath*)polygonPath{
	UIBezierPath *polygonPath = [UIBezierPath bezierPath];
	[polygonPath moveToPoint:CGPointMake(78.66139, 0)];
	[polygonPath addLineToPoint:CGPointMake(64.6017, 1.26667)];
	[polygonPath addLineToPoint:CGPointMake(50.9939, 5.02597)];
	[polygonPath addLineToPoint:CGPointMake(38.27536, 11.15707)];
	[polygonPath addLineToPoint:CGPointMake(26.85485, 19.46292)];
	[polygonPath addLineToPoint:CGPointMake(17.09945, 29.67655)];
	[polygonPath addLineToPoint:CGPointMake(9.3227, 41.4697)];
	[polygonPath addLineToPoint:CGPointMake(3.77456, 54.46331)];
	[polygonPath addLineToPoint:CGPointMake(0.63334, 68.23978)];
	[polygonPath addLineToPoint:CGPointMake(0, 82.35629)];
	[polygonPath addLineToPoint:CGPointMake(1.89491, 96.35915)];
	[polygonPath addLineToPoint:CGPointMake(6.25715, 109.79829)];
	[polygonPath addLineToPoint:CGPointMake(12.94653, 122.24177)];
	[polygonPath addLineToPoint:CGPointMake(21.74803, 133.28963)];
	[polygonPath addLineToPoint:CGPointMake(32.37878, 142.58681)];
	[polygonPath addLineToPoint:CGPointMake(44.49709, 149.83446)];
	[polygonPath addLineToPoint:CGPointMake(57.71347, 154.79964)];
	[polygonPath addLineToPoint:CGPointMake(71.60313, 157.32278)];
	[polygonPath addLineToPoint:CGPointMake(85.71965, 157.32278)];
	[polygonPath addLineToPoint:CGPointMake(99.60931, 154.79964)];
	[polygonPath addLineToPoint:CGPointMake(112.82569, 149.83446)];
	[polygonPath addLineToPoint:CGPointMake(124.944, 142.58681)];
	[polygonPath addLineToPoint:CGPointMake(135.57475, 133.28963)];
	[polygonPath addLineToPoint:CGPointMake(144.37625, 122.24177)];
	[polygonPath addLineToPoint:CGPointMake(151.06563, 109.79829)];
	[polygonPath addLineToPoint:CGPointMake(155.42787, 96.35915)];
	[polygonPath addLineToPoint:CGPointMake(157.32278, 82.35629)];
	[polygonPath addLineToPoint:CGPointMake(156.68945, 68.23978)];
	[polygonPath addLineToPoint:CGPointMake(153.54823, 54.46331)];
	[polygonPath addLineToPoint:CGPointMake(148.00008, 41.4697)];
	[polygonPath addLineToPoint:CGPointMake(140.22333, 29.67655)];
	[polygonPath addLineToPoint:CGPointMake(130.46794, 19.46292)];
	[polygonPath addLineToPoint:CGPointMake(119.04743, 11.15707)];
	[polygonPath addLineToPoint:CGPointMake(106.32888, 5.02597)];
	[polygonPath addLineToPoint:CGPointMake(92.72108, 1.26667)];
	[polygonPath closePath];
	[polygonPath moveToPoint:CGPointMake(78.66139, 0)];
	
	return polygonPath;
}

- (UIBezierPath*)polygon2Path{
	UIBezierPath *polygon2Path = [UIBezierPath bezierPath];
	[polygon2Path moveToPoint:CGPointMake(75.272, 0)];
	[polygon2Path addLineToPoint:CGPointMake(52.01167, 3.68407)];
	[polygon2Path addLineToPoint:CGPointMake(31.02823, 14.37567)];
	[polygon2Path addLineToPoint:CGPointMake(14.37567, 31.02823)];
	[polygon2Path addLineToPoint:CGPointMake(3.68407, 52.01167)];
	[polygon2Path addLineToPoint:CGPointMake(0, 75.272)];
	[polygon2Path addLineToPoint:CGPointMake(3.68407, 98.53233)];
	[polygon2Path addLineToPoint:CGPointMake(14.37567, 119.51578)];
	[polygon2Path addLineToPoint:CGPointMake(31.02823, 136.16833)];
	[polygon2Path addLineToPoint:CGPointMake(52.01167, 146.85992)];
	[polygon2Path addLineToPoint:CGPointMake(75.272, 150.54401)];
	[polygon2Path addLineToPoint:CGPointMake(98.53233, 146.85992)];
	[polygon2Path addLineToPoint:CGPointMake(119.51578, 136.16833)];
	[polygon2Path addLineToPoint:CGPointMake(136.16833, 119.51578)];
	[polygon2Path addLineToPoint:CGPointMake(146.85992, 98.53233)];
	[polygon2Path addLineToPoint:CGPointMake(150.54401, 75.272)];
	[polygon2Path addLineToPoint:CGPointMake(146.85992, 52.01167)];
	[polygon2Path addLineToPoint:CGPointMake(136.16833, 31.02823)];
	[polygon2Path addLineToPoint:CGPointMake(119.51578, 14.37567)];
	[polygon2Path addLineToPoint:CGPointMake(98.53233, 3.68407)];
	[polygon2Path closePath];
	[polygon2Path moveToPoint:CGPointMake(75.272, 0)];
	
	return polygon2Path;
}

- (UIBezierPath*)pathPath{
	UIBezierPath *pathPath = [UIBezierPath bezierPath];
	[pathPath moveToPoint:CGPointMake(107.3942, 59.77641)];
	[pathPath addCurveToPoint:CGPointMake(79.9563, 52.77594) controlPoint1:CGPointMake(99.33005, 58.60485) controlPoint2:CGPointMake(90.83633, 59.21406)];
	[pathPath addCurveToPoint:CGPointMake(63.80772, 38.87539) controlPoint1:CGPointMake(75.24137, 49.81622) controlPoint2:CGPointMake(69.68435, 42.30952)];
	[pathPath addCurveToPoint:CGPointMake(53.93272, 35.47132) controlPoint1:CGPointMake(63.80502, 38.72865) controlPoint2:CGPointMake(56.76271, 34.85524)];
	[pathPath addLineToPoint:CGPointMake(53.93272, 60.60745)];
	[pathPath addCurveToPoint:CGPointMake(54.61831, 61.30151) controlPoint1:CGPointMake(53.93272, 60.98897) controlPoint2:CGPointMake(54.23813, 61.2997)];
	[pathPath addCurveToPoint:CGPointMake(107.3942, 61.60262) controlPoint1:CGPointMake(54.61831, 61.30151) controlPoint2:CGPointMake(90.2134, 61.46891)];
	[pathPath addCurveToPoint:CGPointMake(111.35432, 61.90699) controlPoint1:CGPointMake(108.49047, 61.59401) controlPoint2:CGPointMake(109.48525, 61.55549)];
	[pathPath addCurveToPoint:CGPointMake(115.59729, 64.01285) controlPoint1:CGPointMake(113.38016, 62.38278) controlPoint2:CGPointMake(115.59729, 64.01285)];
	[pathPath addCurveToPoint:CGPointMake(107.3942, 59.77641) controlPoint1:CGPointMake(113.99526, 60.95382) controlPoint2:CGPointMake(110.176, 60.21333)];
	[pathPath addLineToPoint:CGPointMake(107.3942, 59.77641)];
	[pathPath closePath];
	[pathPath moveToPoint:CGPointMake(9.61226, 94.21304)];
	[pathPath addCurveToPoint:CGPointMake(17.53247, 94.21304) controlPoint1:CGPointMake(11.79028, 96.37717) controlPoint2:CGPointMake(15.38924, 96.38826)];
	[pathPath addLineToPoint:CGPointMake(46.95043, 65.36081)];
	[pathPath addCurveToPoint:CGPointMake(48.08189, 62.53216) controlPoint1:CGPointMake(47.53376, 64.77278) controlPoint2:CGPointMake(48.07542, 63.48081)];
	[pathPath addLineToPoint:CGPointMake(48.08189, 1.43333)];
	[pathPath addCurveToPoint:CGPointMake(50.06195, 0.58473) controlPoint1:CGPointMake(48.07542, -0.07886) controlPoint2:CGPointMake(48.97044, -0.44913)];
	[pathPath addLineToPoint:CGPointMake(50.91054, 1.71619)];
	[pathPath addCurveToPoint:CGPointMake(52.60773, 5.39344) controlPoint1:CGPointMake(51.88263, 2.46287) controlPoint2:CGPointMake(52.59876, 4.19211)];
	[pathPath addLineToPoint:CGPointMake(52.60773, 60.83497)];
	[pathPath addCurveToPoint:CGPointMake(54.30492, 62.81503) controlPoint1:CGPointMake(52.59876, 61.99398) controlPoint2:CGPointMake(52.96545, 62.77759)];
	[pathPath addLineToPoint:CGPointMake(110.31219, 62.81503)];
	[pathPath addCurveToPoint:CGPointMake(114.2723, 64.22935) controlPoint1:CGPointMake(111.68761, 62.77759) controlPoint2:CGPointMake(113.42197, 63.48829)];
	[pathPath addLineToPoint:CGPointMake(115.1209, 65.07795)];
	[pathPath addCurveToPoint:CGPointMake(114.2723, 67.058) controlPoint1:CGPointMake(116.15469, 66.17911) controlPoint2:CGPointMake(115.79019, 67.06693)];
	[pathPath addLineToPoint:CGPointMake(53.17346, 67.058)];
	[pathPath addCurveToPoint:CGPointMake(50.34481, 68.18946) controlPoint1:CGPointMake(52.22704, 67.06693) controlPoint2:CGPointMake(50.93084, 67.60467)];
	[pathPath addLineToPoint:CGPointMake(20.92686, 97.60742)];
	[pathPath addCurveToPoint:CGPointMake(20.92686, 105.52764) controlPoint1:CGPointMake(18.84433, 99.73026) controlPoint2:CGPointMake(18.83895, 103.31883)];
	[pathPath addLineToPoint:CGPointMake(25.45269, 110.05348)];
	[pathPath addCurveToPoint:CGPointMake(26.58415, 115.14505) controlPoint1:CGPointMake(27.12965, 111.3692) controlPoint2:CGPointMake(26.66385, 115.13005)];
	[pathPath addCurveToPoint:CGPointMake(25.73556, 115.42792) controlPoint1:CGPointMake(26.62282, 115.75136) controlPoint2:CGPointMake(26.23147, 115.89696)];
	[pathPath addLineToPoint:CGPointMake(0.27771, 89.97007)];
	[pathPath addCurveToPoint:CGPointMake(0.56058, 89.12147) controlPoint1:CGPointMake(-0.19259, 89.47464) controlPoint2:CGPointMake(-0.04397, 89.09145)];
	[pathPath addCurveToPoint:CGPointMake(5.65215, 90.25293) controlPoint1:CGPointMake(0.5805, 89.07919) controlPoint2:CGPointMake(4.39194, 88.74549)];
	[pathPath addLineToPoint:CGPointMake(9.61226, 94.21304)];
	[pathPath addLineToPoint:CGPointMake(9.61226, 94.21304)];
	[pathPath closePath];
	[pathPath moveToPoint:CGPointMake(9.61226, 94.21304)];
	
	return pathPath;
}

- (UIBezierPath*)CombinedShapePath{
	UIBezierPath *CombinedShapePath = [UIBezierPath bezierPath];
	[CombinedShapePath moveToPoint:CGPointMake(78.38863, 60.85453)];
	[CombinedShapePath addCurveToPoint:CGPointMake(79.39254, 60.86) controlPoint1:CGPointMake(78.72202, 60.85624) controlPoint2:CGPointMake(79.05676, 60.85829)];
	[CombinedShapePath addLineToPoint:CGPointMake(85.17031, 55.10527)];
	[CombinedShapePath addCurveToPoint:CGPointMake(84.46107, 54.80668) controlPoint1:CGPointMake(84.93493, 55.00801) controlPoint2:CGPointMake(84.69885, 54.91008)];
	[CombinedShapePath addLineToPoint:CGPointMake(78.38863, 60.85453)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(80.39617, 60.86549)];
	[CombinedShapePath addCurveToPoint:CGPointMake(81.39973, 60.87095) controlPoint1:CGPointMake(80.7299, 60.8672) controlPoint2:CGPointMake(81.06464, 60.86924)];
	[CombinedShapePath addLineToPoint:CGPointMake(86.61971, 55.67211)];
	[CombinedShapePath addCurveToPoint:CGPointMake(85.8899, 55.39399) controlPoint1:CGPointMake(86.37781, 55.5827) controlPoint2:CGPointMake(86.1342, 55.48954)];
	[CombinedShapePath addLineToPoint:CGPointMake(80.39617, 60.86549)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(82.4035, 60.87654)];
	[CombinedShapePath addCurveToPoint:CGPointMake(83.40707, 60.88201) controlPoint1:CGPointMake(82.73757, 60.87825) controlPoint2:CGPointMake(83.07232, 60.8803)];
	[CombinedShapePath addLineToPoint:CGPointMake(88.11343, 56.19469)];
	[CombinedShapePath addCurveToPoint:CGPointMake(87.36068, 55.93944) controlPoint1:CGPointMake(87.864, 56.11313) controlPoint2:CGPointMake(87.61251, 56.02748)];
	[CombinedShapePath addLineToPoint:CGPointMake(82.4035, 60.87654)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(56.82068, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.57687, 66.45864)];
	[CombinedShapePath addCurveToPoint:CGPointMake(52.88935, 66.43578) controlPoint1:CGPointMake(52.68343, 66.44636) controlPoint2:CGPointMake(52.7893, 66.4368)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.60921, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(57.83007, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(56.82068, 62.232)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(100.46073, 60.98527)];
	[CombinedShapePath addCurveToPoint:CGPointMake(101.46326, 60.99209) controlPoint1:CGPointMake(100.79822, 60.98766) controlPoint2:CGPointMake(101.13263, 60.9897)];
	[CombinedShapePath addLineToPoint:CGPointMake(103.62903, 58.83475)];
	[CombinedShapePath addCurveToPoint:CGPointMake(102.71318, 58.74193) controlPoint1:CGPointMake(103.32478, 58.80336) controlPoint2:CGPointMake(103.01949, 58.7723)];
	[CombinedShapePath addLineToPoint:CGPointMake(100.46073, 60.98527)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(65.90391, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(64.89452, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(60.67366, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(61.68305, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(65.90391, 62.232)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(61.86687, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(60.85748, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(56.63662, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(57.64601, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(61.86687, 62.232)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(59.8484, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(58.83902, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(54.61816, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(55.62754, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(59.8484, 62.232)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(96.44994, 60.95923)];
	[CombinedShapePath addCurveToPoint:CGPointMake(97.45281, 60.96571) controlPoint1:CGPointMake(96.7864, 60.96128) controlPoint2:CGPointMake(97.1208, 60.96367)];
	[CombinedShapePath addLineToPoint:CGPointMake(99.95779, 58.47054)];
	[CombinedShapePath addCurveToPoint:CGPointMake(99.04501, 58.37465) controlPoint1:CGPointMake(99.6549, 58.43983) controlPoint2:CGPointMake(99.35064, 58.40775)];
	[CombinedShapePath addLineToPoint:CGPointMake(96.44994, 60.95923)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(98.45556, 60.97206)];
	[CombinedShapePath addCurveToPoint:CGPointMake(99.45809, 60.97854) controlPoint1:CGPointMake(98.79236, 60.97411) controlPoint2:CGPointMake(99.12677, 60.9765)];
	[CombinedShapePath addLineToPoint:CGPointMake(101.79449, 58.65195)];
	[CombinedShapePath addCurveToPoint:CGPointMake(100.87521, 58.5622) controlPoint1:CGPointMake(101.4892, 58.62226) controlPoint2:CGPointMake(101.18289, 58.59223)];
	[CombinedShapePath addLineToPoint:CGPointMake(98.45556, 60.97206)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(94.44401, 60.9467)];
	[CombinedShapePath addCurveToPoint:CGPointMake(95.44688, 60.95285) controlPoint1:CGPointMake(94.78013, 60.94875) controlPoint2:CGPointMake(95.11453, 60.9508)];
	[CombinedShapePath addLineToPoint:CGPointMake(98.13824, 58.27238)];
	[CombinedShapePath addCurveToPoint:CGPointMake(97.23952, 58.1625) controlPoint1:CGPointMake(97.84016, 58.23758) controlPoint2:CGPointMake(97.54036, 58.20106)];
	[CombinedShapePath addLineToPoint:CGPointMake(94.44401, 60.9467)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(90.43133, 60.92251)];
	[CombinedShapePath addCurveToPoint:CGPointMake(91.43455, 60.92831) controlPoint1:CGPointMake(90.76676, 60.92456) controlPoint2:CGPointMake(91.10117, 60.92661)];
	[CombinedShapePath addLineToPoint:CGPointMake(94.60251, 57.77317)];
	[CombinedShapePath addCurveToPoint:CGPointMake(93.74662, 57.62064) controlPoint1:CGPointMake(94.31881, 57.72506) controlPoint2:CGPointMake(94.0334, 57.67422)];
	[CombinedShapePath addLineToPoint:CGPointMake(90.43133, 60.92251)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(92.43781, 60.93449)];
	[CombinedShapePath addCurveToPoint:CGPointMake(93.44102, 60.94063) controlPoint1:CGPointMake(92.77358, 60.93653) controlPoint2:CGPointMake(93.10799, 60.93858)];
	[CombinedShapePath addLineToPoint:CGPointMake(96.34995, 58.04348)];
	[CombinedShapePath addCurveToPoint:CGPointMake(95.47043, 57.91414) controlPoint1:CGPointMake(96.05804, 58.00253) controlPoint2:CGPointMake(95.76508, 57.95953)];
	[CombinedShapePath addLineToPoint:CGPointMake(92.43781, 60.93449)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(88.42468, 60.91074)];
	[CombinedShapePath addCurveToPoint:CGPointMake(89.4279, 60.91654) controlPoint1:CGPointMake(88.75977, 60.91278) controlPoint2:CGPointMake(89.09418, 60.91449)];
	[CombinedShapePath addLineToPoint:CGPointMake(92.90354, 57.45531)];
	[CombinedShapePath addCurveToPoint:CGPointMake(92.07301, 57.27718) controlPoint1:CGPointMake(92.62807, 57.39866) controlPoint2:CGPointMake(92.35122, 57.33929)];
	[CombinedShapePath addLineToPoint:CGPointMake(88.42468, 60.91074)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(86.41779, 60.89917)];
	[CombinedShapePath addCurveToPoint:CGPointMake(87.42136, 60.90497) controlPoint1:CGPointMake(86.75254, 60.90122) controlPoint2:CGPointMake(87.08695, 60.90292)];
	[CombinedShapePath addLineToPoint:CGPointMake(91.25573, 57.08612)];
	[CombinedShapePath addCurveToPoint:CGPointMake(90.45123, 56.88205) controlPoint1:CGPointMake(90.98882, 57.02094) controlPoint2:CGPointMake(90.72089, 56.95303)];
	[CombinedShapePath addLineToPoint:CGPointMake(86.41779, 60.89917)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(63.88541, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(62.87602, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(58.65516, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(59.66455, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(63.88541, 62.232)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(64.33268, 60.78137)];
	[CombinedShapePath addCurveToPoint:CGPointMake(65.33693, 60.78649) controlPoint1:CGPointMake(64.66195, 60.78308) controlPoint2:CGPointMake(64.99601, 60.78479)];
	[CombinedShapePath addLineToPoint:CGPointMake(76.35249, 49.81517)];
	[CombinedShapePath addCurveToPoint:CGPointMake(75.82415, 49.33641) controlPoint1:CGPointMake(76.1774, 49.65889) controlPoint2:CGPointMake(76.00095, 49.49884)];
	[CombinedShapePath addLineToPoint:CGPointMake(64.33268, 60.78137)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(66.341, 60.79151)];
	[CombinedShapePath addCurveToPoint:CGPointMake(67.34525, 60.79663) controlPoint1:CGPointMake(66.6713, 60.79321) controlPoint2:CGPointMake(67.00571, 60.79492)];
	[CombinedShapePath addLineToPoint:CGPointMake(77.43639, 50.74633)];
	[CombinedShapePath addCurveToPoint:CGPointMake(76.88956, 50.28565) controlPoint1:CGPointMake(77.25514, 50.59686) controlPoint2:CGPointMake(77.07287, 50.44364)];
	[CombinedShapePath addLineToPoint:CGPointMake(66.341, 60.79151)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(62.32425, 60.77134)];
	[CombinedShapePath addCurveToPoint:CGPointMake(63.3285, 60.77646) controlPoint1:CGPointMake(62.65078, 60.77305) controlPoint2:CGPointMake(62.9869, 60.77475)];
	[CombinedShapePath addLineToPoint:CGPointMake(75.30205, 48.85137)];
	[CombinedShapePath addCurveToPoint:CGPointMake(74.78468, 48.36134) controlPoint1:CGPointMake(75.13039, 48.6903) controlPoint2:CGPointMake(74.95805, 48.5265)];
	[CombinedShapePath addLineToPoint:CGPointMake(62.32425, 60.77134)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(68.34923, 60.80175)];
	[CombinedShapePath addCurveToPoint:CGPointMake(69.35313, 60.80687) controlPoint1:CGPointMake(68.68021, 60.80345) controlPoint2:CGPointMake(69.0153, 60.80516)];
	[CombinedShapePath addLineToPoint:CGPointMake(78.56817, 51.62912)];
	[CombinedShapePath addCurveToPoint:CGPointMake(77.99495, 51.19506) controlPoint1:CGPointMake(78.37836, 51.49058) controlPoint2:CGPointMake(78.18716, 51.34521)];
	[CombinedShapePath addLineToPoint:CGPointMake(68.34923, 60.80175)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(72.36533, 60.82249)];
	[CombinedShapePath addCurveToPoint:CGPointMake(73.36924, 60.82761) controlPoint1:CGPointMake(72.69769, 60.8242) controlPoint2:CGPointMake(73.03243, 60.8259)];
	[CombinedShapePath addLineToPoint:CGPointMake(81.07533, 53.15305)];
	[CombinedShapePath addCurveToPoint:CGPointMake(80.424, 52.79645) controlPoint1:CGPointMake(80.8588, 53.036) controlPoint2:CGPointMake(80.64225, 52.91895)];
	[CombinedShapePath addLineToPoint:CGPointMake(72.36533, 60.82249)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(57.3028, 60.7467)];
	[CombinedShapePath addLineToPoint:CGPointMake(72.23634, 45.87361)];
	[CombinedShapePath addCurveToPoint:CGPointMake(71.72821, 45.37437) controlPoint1:CGPointMake(72.06776, 45.70742) controlPoint2:CGPointMake(71.89816, 45.5409)];
	[CombinedShapePath addLineToPoint:CGPointMake(56.29821, 60.74192)];
	[CombinedShapePath addCurveToPoint:CGPointMake(57.3028, 60.7467) controlPoint1:CGPointMake(56.60109, 60.74329) controlPoint2:CGPointMake(56.93824, 60.745)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(58.30708, 60.75158)];
	[CombinedShapePath addCurveToPoint:CGPointMake(59.31133, 60.75636) controlPoint1:CGPointMake(58.62504, 60.75329) controlPoint2:CGPointMake(58.96151, 60.75465)];
	[CombinedShapePath addLineToPoint:CGPointMake(73.25192, 46.87253)];
	[CombinedShapePath addCurveToPoint:CGPointMake(72.74415, 46.37329) controlPoint1:CGPointMake(73.08301, 46.70703) controlPoint2:CGPointMake(72.91375, 46.5405)];
	[CombinedShapePath addLineToPoint:CGPointMake(58.30708, 60.75158)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(60.31575, 60.76141)];
	[CombinedShapePath addCurveToPoint:CGPointMake(61.32, 60.76619) controlPoint1:CGPointMake(60.63988, 60.76311) controlPoint2:CGPointMake(60.97497, 60.76448)];
	[CombinedShapePath addLineToPoint:CGPointMake(74.27142, 47.86753)];
	[CombinedShapePath addCurveToPoint:CGPointMake(73.76056, 47.37102) controlPoint1:CGPointMake(74.10181, 47.70339) controlPoint2:CGPointMake(73.93153, 47.53789)];
	[CombinedShapePath addLineToPoint:CGPointMake(60.31575, 60.76141)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(67.92235, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(66.9133, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(62.6921, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(63.70148, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(67.92235, 62.232)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(71.95932, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(70.94993, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(66.72906, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(67.73846, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(71.95932, 62.232)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(69.94085, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(68.9318, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(64.7106, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(65.71999, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(69.94085, 62.232)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(73.97785, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(72.96847, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(68.7476, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(69.757, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(73.97785, 62.232)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(76.38099, 60.84372)];
	[CombinedShapePath addCurveToPoint:CGPointMake(77.3849, 60.84918) controlPoint1:CGPointMake(76.71437, 60.84542) controlPoint2:CGPointMake(77.04878, 60.84747)];
	[CombinedShapePath addLineToPoint:CGPointMake(83.7657, 54.4942)];
	[CombinedShapePath addCurveToPoint:CGPointMake(83.07873, 54.17309) controlPoint1:CGPointMake(83.53785, 54.39046) controlPoint2:CGPointMake(83.30863, 54.28263)];
	[CombinedShapePath addLineToPoint:CGPointMake(76.38099, 60.84372)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(75.99632, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(74.98693, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(70.76608, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(71.77546, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(75.99632, 62.232)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(74.37321, 60.83307)];
	[CombinedShapePath addCurveToPoint:CGPointMake(75.37712, 60.83853) controlPoint1:CGPointMake(74.70591, 60.83478) controlPoint2:CGPointMake(75.04066, 60.83648)];
	[CombinedShapePath addLineToPoint:CGPointMake(82.40001, 53.84372)];
	[CombinedShapePath addCurveToPoint:CGPointMake(81.73291, 53.50316) controlPoint1:CGPointMake(82.17902, 53.7335) controlPoint2:CGPointMake(81.95631, 53.61919)];
	[CombinedShapePath addLineToPoint:CGPointMake(74.37321, 60.83307)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(78.01482, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(77.00578, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(72.78458, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(73.79396, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(78.01482, 62.232)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(84.41074, 60.88777)];
	[CombinedShapePath addCurveToPoint:CGPointMake(85.4143, 60.89357) controlPoint1:CGPointMake(84.74514, 60.88982) controlPoint2:CGPointMake(85.0799, 60.89153)];
	[CombinedShapePath addLineToPoint:CGPointMake(89.65983, 56.66523)];
	[CombinedShapePath addCurveToPoint:CGPointMake(88.88069, 56.43591) controlPoint1:CGPointMake(89.40115, 56.59152) controlPoint2:CGPointMake(89.14177, 56.51576)];
	[CombinedShapePath addLineToPoint:CGPointMake(84.41074, 60.88777)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 13.4343)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 12.42899)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 16.91327)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 17.91823)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 13.4343)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 15.4446)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 14.43929)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 18.92357)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 19.92853)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 15.4446)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 11.42396)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 10.41866)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 14.90294)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 15.9079)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 11.42396)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 9.41363)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 8.40833)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 12.89261)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 13.89757)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 9.41363)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 17.45489)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 16.44993)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 20.93387)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 21.93883)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 17.45489)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 21.47559)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 20.47029)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 24.95457)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 25.95953)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 21.47559)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 23.48589)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 22.48059)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 26.96487)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 27.96983)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 23.48589)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 19.46523)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 18.45992)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 22.9442)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 23.94917)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 19.46523)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(54.32682, 60.73247)];
	[CombinedShapePath addCurveToPoint:CGPointMake(55.29406, 60.73691) controlPoint1:CGPointMake(54.32682, 60.73247) controlPoint2:CGPointMake(54.66876, 60.73418)];
	[CombinedShapePath addLineToPoint:CGPointMake(71.21883, 44.8766)];
	[CombinedShapePath addCurveToPoint:CGPointMake(70.70728, 44.38077) controlPoint1:CGPointMake(71.04888, 44.71109) controlPoint2:CGPointMake(70.87825, 44.54593)];
	[CombinedShapePath addLineToPoint:CGPointMake(54.2929, 60.72906)];
	[CombinedShapePath addCurveToPoint:CGPointMake(54.32682, 60.73247) controlPoint1:CGPointMake(54.30455, 60.7294) controlPoint2:CGPointMake(54.31517, 60.73247)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(26.55363, 112.47978)];
	[CombinedShapePath addLineToPoint:CGPointMake(25.13069, 113.89697)];
	[CombinedShapePath addLineToPoint:CGPointMake(25.59461, 114.35867)];
	[CombinedShapePath addCurveToPoint:CGPointMake(25.63949, 114.39518) controlPoint1:CGPointMake(25.61003, 114.37334) controlPoint2:CGPointMake(25.62442, 114.38187)];
	[CombinedShapePath addLineToPoint:CGPointMake(26.52725, 113.51102)];
	[CombinedShapePath addCurveToPoint:CGPointMake(26.55363, 112.47978) controlPoint1:CGPointMake(26.5502, 113.23495) controlPoint2:CGPointMake(26.56459, 112.87733)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(114.78829, 64.80866)];
	[CombinedShapePath addLineToPoint:CGPointMake(113.15462, 66.43571)];
	[CombinedShapePath addLineToPoint:CGPointMake(113.66994, 66.43571)];
	[CombinedShapePath addCurveToPoint:CGPointMake(114.2065, 66.39339) controlPoint1:CGPointMake(113.86935, 66.43707) controlPoint2:CGPointMake(114.04752, 66.42171)];
	[CombinedShapePath addLineToPoint:CGPointMake(115.08946, 65.51367)];
	[CombinedShapePath addCurveToPoint:CGPointMake(114.78829, 64.80866) controlPoint1:CGPointMake(115.06924, 65.30244) controlPoint2:CGPointMake(114.97022, 65.06425)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(0.55095, 88.29542)];
	[CombinedShapePath addCurveToPoint:CGPointMake(0.3673, 88.30225) controlPoint1:CGPointMake(0.48311, 88.29201) controlPoint2:CGPointMake(0.42315, 88.29542)];
	[CombinedShapePath addLineToPoint:CGPointMake(0, 88.66805)];
	[CombinedShapePath addCurveToPoint:CGPointMake(0.26965, 89.13625) controlPoint1:CGPointMake(0.01747, 88.80148) controlPoint2:CGPointMake(0.10279, 88.96118)];
	[CombinedShapePath addLineToPoint:CGPointMake(0.4043, 89.27035)];
	[CombinedShapePath addLineToPoint:CGPointMake(1.44213, 88.23672)];
	[CombinedShapePath addCurveToPoint:CGPointMake(0.55095, 88.29542) controlPoint1:CGPointMake(0.91414, 88.24321) controlPoint2:CGPointMake(0.55712, 88.28279)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 5.393)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 5.34113)];
	[CombinedShapePath addCurveToPoint:CGPointMake(52.22122, 4.4928) controlPoint1:CGPointMake(52.32469, 5.07871) controlPoint2:CGPointMake(52.287, 4.79002)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 8.87197)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 9.87694)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 5.393)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(47.82449, 5.85641)];
	[CombinedShapePath addLineToPoint:CGPointMake(51.29773, 2.39722)];
	[CombinedShapePath addCurveToPoint:CGPointMake(50.82867, 1.85942) controlPoint1:CGPointMake(51.15211, 2.19555) controlPoint2:CGPointMake(50.99484, 2.01366)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82449, 4.8511)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82449, 5.85641)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 7.4033)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 6.39799)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 10.88227)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 11.88723)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 7.4033)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(51.9907, 3.71736)];
	[CombinedShapePath addCurveToPoint:CGPointMake(51.68027, 3.02122) controlPoint1:CGPointMake(51.90195, 3.47985) controlPoint2:CGPointMake(51.79814, 3.24542)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82466, 6.86157)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82466, 7.86653)];
	[CombinedShapePath addLineToPoint:CGPointMake(51.9907, 3.71736)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 25.49623)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 24.49092)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 28.9752)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 29.98016)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 25.49623)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(113.88004, 62.69769)];
	[CombinedShapePath addLineToPoint:CGPointMake(114.24494, 62.33427)];
	[CombinedShapePath addCurveToPoint:CGPointMake(113.74676, 61.82513) controlPoint1:CGPointMake(114.08871, 62.15307) controlPoint2:CGPointMake(113.92116, 61.98518)];
	[CombinedShapePath addLineToPoint:CGPointMake(113.23761, 62.33256)];
	[CombinedShapePath addCurveToPoint:CGPointMake(113.88004, 62.69769) controlPoint1:CGPointMake(113.46751, 62.45678) controlPoint2:CGPointMake(113.68372, 62.58031)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(114.98787, 63.41877)];
	[CombinedShapePath addCurveToPoint:CGPointMake(114.68087, 62.9052) controlPoint1:CGPointMake(114.8933, 63.23928) controlPoint2:CGPointMake(114.79018, 63.069)];
	[CombinedShapePath addLineToPoint:CGPointMake(114.49996, 63.08572)];
	[CombinedShapePath addCurveToPoint:CGPointMake(114.98787, 63.41877) controlPoint1:CGPointMake(114.80354, 63.28467) controlPoint2:CGPointMake(114.98787, 63.41877)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(105.4716, 61.02055)];
	[CombinedShapePath addLineToPoint:CGPointMake(107.21524, 59.28396)];
	[CombinedShapePath addCurveToPoint:CGPointMake(106.82772, 59.22152) controlPoint1:CGPointMake(107.08469, 59.26247) controlPoint2:CGPointMake(106.95415, 59.24131)];
	[CombinedShapePath addCurveToPoint:CGPointMake(106.33673, 59.15395) controlPoint1:CGPointMake(106.66429, 59.19797) controlPoint2:CGPointMake(106.50051, 59.17613)];
	[CombinedShapePath addLineToPoint:CGPointMake(104.46974, 61.01304)];
	[CombinedShapePath addCurveToPoint:CGPointMake(105.4716, 61.02055) controlPoint1:CGPointMake(104.80963, 61.01577) controlPoint2:CGPointMake(105.14267, 61.01816)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(111.86805, 61.68608)];
	[CombinedShapePath addCurveToPoint:CGPointMake(112.56941, 61.99286) controlPoint1:CGPointMake(112.10686, 61.78094) controlPoint2:CGPointMake(112.34157, 61.88468)];
	[CombinedShapePath addLineToPoint:CGPointMake(113.19334, 61.37145)];
	[CombinedShapePath addCurveToPoint:CGPointMake(112.58894, 60.9681) controlPoint1:CGPointMake(112.99839, 61.22779) controlPoint2:CGPointMake(112.79726, 61.09266)];
	[CombinedShapePath addLineToPoint:CGPointMake(111.86805, 61.68608)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(106.47321, 61.02813)];
	[CombinedShapePath addCurveToPoint:CGPointMake(106.82748, 61.03086) controlPoint1:CGPointMake(106.59106, 61.02915) controlPoint2:CGPointMake(106.71133, 61.02983)];
	[CombinedShapePath addCurveToPoint:CGPointMake(107.48499, 61.02574) controlPoint1:CGPointMake(107.04813, 61.02915) controlPoint2:CGPointMake(107.26468, 61.02642)];
	[CombinedShapePath addLineToPoint:CGPointMake(108.91171, 59.6048)];
	[CombinedShapePath addCurveToPoint:CGPointMake(108.07397, 59.43384) controlPoint1:CGPointMake(108.62903, 59.54167) controlPoint2:CGPointMake(108.34945, 59.48536)];
	[CombinedShapePath addLineToPoint:CGPointMake(106.47321, 61.02813)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(71.36132, 60.81727)];
	[CombinedShapePath addLineToPoint:CGPointMake(79.78317, 52.42951)];
	[CombinedShapePath addCurveToPoint:CGPointMake(79.53271, 52.28585) controlPoint1:CGPointMake(79.69957, 52.38071) controlPoint2:CGPointMake(79.61665, 52.33533)];
	[CombinedShapePath addCurveToPoint:CGPointMake(79.1613, 52.0439) controlPoint1:CGPointMake(79.40971, 52.20872) controlPoint2:CGPointMake(79.28568, 52.12683)];
	[CombinedShapePath addLineToPoint:CGPointMake(70.35741, 60.81215)];
	[CombinedShapePath addCurveToPoint:CGPointMake(71.36132, 60.81727) controlPoint1:CGPointMake(70.68909, 60.81386) controlPoint2:CGPointMake(71.02383, 60.81557)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(102.46549, 60.99895)];
	[CombinedShapePath addCurveToPoint:CGPointMake(103.46769, 61.00611) controlPoint1:CGPointMake(102.80367, 61.00134) controlPoint2:CGPointMake(103.13808, 61.00373)];
	[CombinedShapePath addLineToPoint:CGPointMake(105.44329, 59.03817)];
	[CombinedShapePath addCurveToPoint:CGPointMake(104.54046, 58.93238) controlPoint1:CGPointMake(105.14315, 59.00165) controlPoint2:CGPointMake(104.84232, 58.96616)];
	[CombinedShapePath addLineToPoint:CGPointMake(102.46549, 60.99895)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(108.47358, 61.04618)];
	[CombinedShapePath addCurveToPoint:CGPointMake(109.40451, 61.12398) controlPoint1:CGPointMake(108.759, 61.06085) controlPoint2:CGPointMake(109.06599, 61.08542)];
	[CombinedShapePath addLineToPoint:CGPointMake(110.49681, 60.0361)];
	[CombinedShapePath addCurveToPoint:CGPointMake(109.72144, 59.80337) controlPoint1:CGPointMake(110.23949, 59.95181) controlPoint2:CGPointMake(109.98081, 59.87333)];
	[CombinedShapePath addLineToPoint:CGPointMake(108.47358, 61.04618)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(110.2888, 61.24864)];
	[CombinedShapePath addCurveToPoint:CGPointMake(110.76711, 61.33224) controlPoint1:CGPointMake(110.4423, 61.27389) controlPoint2:CGPointMake(110.60025, 61.30119)];
	[CombinedShapePath addCurveToPoint:CGPointMake(111.11968, 61.42643) controlPoint1:CGPointMake(110.88395, 61.35988) controlPoint2:CGPointMake(111.00182, 61.39196)];
	[CombinedShapePath addLineToPoint:CGPointMake(111.93719, 60.61188)];
	[CombinedShapePath addCurveToPoint:CGPointMake(111.23754, 60.30373) controlPoint1:CGPointMake(111.70866, 60.50029) controlPoint2:CGPointMake(111.47465, 60.3986)];
	[CombinedShapePath addLineToPoint:CGPointMake(110.2888, 61.24864)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 29.51686)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 28.51155)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 32.99583)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 34.0008)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 29.51686)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 27.50649)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 26.50153)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 30.98547)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 31.99043)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 27.50649)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(53.64481, 48.30729)];
	[CombinedShapePath addLineToPoint:CGPointMake(63.47453, 38.51736)];
	[CombinedShapePath addCurveToPoint:CGPointMake(63.46836, 38.5136) controlPoint1:CGPointMake(63.47247, 38.51599) controlPoint2:CGPointMake(63.47042, 38.51463)];
	[CombinedShapePath addCurveToPoint:CGPointMake(62.85711, 38.12698) controlPoint1:CGPointMake(63.46767, 38.48767) controlPoint2:CGPointMake(63.24085, 38.3423)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.64481, 47.30199)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.64481, 48.30729)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 31.52719)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 30.52189)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 35.00617)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 36.01113)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 31.52719)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(53.64481, 36.24539)];
	[CombinedShapePath addLineToPoint:CGPointMake(54.79605, 35.09882)];
	[CombinedShapePath addCurveToPoint:CGPointMake(53.7637, 35.12168) controlPoint1:CGPointMake(54.41607, 35.06503) controlPoint2:CGPointMake(54.06865, 35.07049)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.64481, 35.24009)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.64481, 36.24539)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 33.53749)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 32.53219)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 37.01647)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 38.02143)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 33.53749)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 35.54779)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 34.54283)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 39.02676)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 40.03173)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 35.54779)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(96.18121, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(95.17182, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(90.95096, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(91.96035, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(96.18121, 62.232)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(26.04003, 109.97581)];
	[CombinedShapePath addCurveToPoint:CGPointMake(25.64771, 109.36123) controlPoint1:CGPointMake(25.93176, 109.75161) controlPoint2:CGPointMake(25.80156, 109.54447)];
	[CombinedShapePath addLineToPoint:CGPointMake(23.11225, 111.88643)];
	[CombinedShapePath addLineToPoint:CGPointMake(23.61695, 112.38908)];
	[CombinedShapePath addLineToPoint:CGPointMake(26.04003, 109.97581)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(25.14021, 108.86165)];
	[CombinedShapePath addLineToPoint:CGPointMake(24.63552, 108.35899)];
	[CombinedShapePath addLineToPoint:CGPointMake(22.10314, 110.88146)];
	[CombinedShapePath addLineToPoint:CGPointMake(22.60783, 111.38377)];
	[CombinedShapePath addLineToPoint:CGPointMake(25.14021, 108.86165)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(24.13096, 107.85648)];
	[CombinedShapePath addLineToPoint:CGPointMake(23.62627, 107.35383)];
	[CombinedShapePath addLineToPoint:CGPointMake(21.09389, 109.8763)];
	[CombinedShapePath addLineToPoint:CGPointMake(21.59858, 110.37861)];
	[CombinedShapePath addLineToPoint:CGPointMake(24.13096, 107.85648)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(26.47911, 111.54884)];
	[CombinedShapePath addCurveToPoint:CGPointMake(26.31053, 110.71176) controlPoint1:CGPointMake(26.44108, 111.26868) controlPoint2:CGPointMake(26.38626, 110.98612)];
	[CombinedShapePath addLineToPoint:CGPointMake(24.12147, 112.89162)];
	[CombinedShapePath addLineToPoint:CGPointMake(24.62616, 113.39428)];
	[CombinedShapePath addLineToPoint:CGPointMake(26.47911, 111.54884)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(84.0703, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(83.06091, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(78.84005, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(79.84943, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(84.0703, 62.232)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(23.12171, 106.85135)];
	[CombinedShapePath addLineToPoint:CGPointMake(22.61701, 106.34869)];
	[CombinedShapePath addLineToPoint:CGPointMake(20.08463, 108.87117)];
	[CombinedShapePath addLineToPoint:CGPointMake(20.58933, 109.37347)];
	[CombinedShapePath addLineToPoint:CGPointMake(23.12171, 106.85135)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(53.64481, 60.04483)];
	[CombinedShapePath addCurveToPoint:CGPointMake(53.69963, 60.31441) controlPoint1:CGPointMake(53.64481, 60.14038) controlPoint2:CGPointMake(53.66468, 60.23149)];
	[CombinedShapePath addLineToPoint:CGPointMake(70.19316, 43.88798)];
	[CombinedShapePath addCurveToPoint:CGPointMake(69.67545, 43.3983) controlPoint1:CGPointMake(70.02116, 43.72384) controlPoint2:CGPointMake(69.84847, 43.56073)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.64481, 59.36405)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.64481, 60.04483)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(82.05176, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(81.04237, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(76.82151, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(77.8309, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(82.05176, 62.232)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(80.03329, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(79.0239, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(74.80305, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(75.81243, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(80.03329, 62.232)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(19.25766, 100.64812)];
	[CombinedShapePath addCurveToPoint:CGPointMake(19.35052, 99.55034) controlPoint1:CGPointMake(19.25458, 100.27958) controlPoint2:CGPointMake(19.28439, 99.91206)];
	[CombinedShapePath addLineToPoint:CGPointMake(15.03852, 103.84523)];
	[CombinedShapePath addLineToPoint:CGPointMake(15.54287, 104.34789)];
	[CombinedShapePath addLineToPoint:CGPointMake(19.25766, 100.64812)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(19.85267, 98.04526)];
	[CombinedShapePath addCurveToPoint:CGPointMake(20.81101, 96.7028) controlPoint1:CGPointMake(20.09731, 97.5583) controlPoint2:CGPointMake(20.41596, 97.1041)];
	[CombinedShapePath addLineToPoint:CGPointMake(50.07574, 67.55686)];
	[CombinedShapePath addCurveToPoint:CGPointMake(51.15639, 66.86823) controlPoint1:CGPointMake(50.32962, 67.30434) controlPoint2:CGPointMake(50.72125, 67.06342)];
	[CombinedShapePath addLineToPoint:CGPointMake(55.81136, 62.2321)];
	[CombinedShapePath addLineToPoint:CGPointMake(54.80232, 62.2321)];
	[CombinedShapePath addLineToPoint:CGPointMake(14.02899, 102.84007)];
	[CombinedShapePath addLineToPoint:CGPointMake(14.53368, 103.34272)];
	[CombinedShapePath addLineToPoint:CGPointMake(19.85267, 98.04526)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(53.02739, 61.98927)];
	[CombinedShapePath addLineToPoint:CGPointMake(13.01984, 101.8349)];
	[CombinedShapePath addLineToPoint:CGPointMake(13.52454, 102.33755)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.80653, 62.21859)];
	[CombinedShapePath addCurveToPoint:CGPointMake(53.02739, 61.98927) controlPoint1:CGPointMake(53.48755, 62.18822) controlPoint2:CGPointMake(53.23057, 62.11007)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(22.11249, 105.84618)];
	[CombinedShapePath addLineToPoint:CGPointMake(21.6078, 105.34353)];
	[CombinedShapePath addLineToPoint:CGPointMake(19.07542, 107.866)];
	[CombinedShapePath addLineToPoint:CGPointMake(19.58011, 108.36831)];
	[CombinedShapePath addLineToPoint:CGPointMake(22.11249, 105.84618)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(19.53814, 102.37908)];
	[CombinedShapePath addCurveToPoint:CGPointMake(19.33976, 101.57136) controlPoint1:CGPointMake(19.45351, 102.11393) controlPoint2:CGPointMake(19.38567, 101.84435)];
	[CombinedShapePath addLineToPoint:CGPointMake(16.04777, 104.85036)];
	[CombinedShapePath addLineToPoint:CGPointMake(16.55212, 105.35301)];
	[CombinedShapePath addLineToPoint:CGPointMake(19.53814, 102.37908)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(21.10324, 104.84101)];
	[CombinedShapePath addLineToPoint:CGPointMake(20.81098, 104.54993)];
	[CombinedShapePath addCurveToPoint:CGPointMake(20.61534, 104.32164) controlPoint1:CGPointMake(20.74142, 104.47656) controlPoint2:CGPointMake(20.68009, 104.39808)];
	[CombinedShapePath addLineToPoint:CGPointMake(18.06617, 106.86083)];
	[CombinedShapePath addLineToPoint:CGPointMake(18.57086, 107.36314)];
	[CombinedShapePath addLineToPoint:CGPointMake(21.10324, 104.84101)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(20.183, 103.74719)];
	[CombinedShapePath addCurveToPoint:CGPointMake(19.82187, 103.10156) controlPoint1:CGPointMake(20.04767, 103.5387) controlPoint2:CGPointMake(19.9274, 103.32336)];
	[CombinedShapePath addLineToPoint:CGPointMake(17.05685, 105.85539)];
	[CombinedShapePath addLineToPoint:CGPointMake(17.56154, 106.35805)];
	[CombinedShapePath addLineToPoint:CGPointMake(20.183, 103.74719)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(92.14424, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(91.13485, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(86.91399, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(87.92338, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(92.14424, 62.232)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(111.91033, 62.6491)];
	[CombinedShapePath addCurveToPoint:CGPointMake(111.14216, 62.40921) controlPoint1:CGPointMake(111.66021, 62.5556) controlPoint2:CGPointMake(111.40187, 62.47472)];
	[CombinedShapePath addLineToPoint:CGPointMake(107.09912, 66.43587)];
	[CombinedShapePath addLineToPoint:CGPointMake(108.10816, 66.43587)];
	[CombinedShapePath addLineToPoint:CGPointMake(111.91033, 62.6491)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(110.28747, 62.2551)];
	[CombinedShapePath addCurveToPoint:CGPointMake(109.73035, 62.2319) controlPoint1:CGPointMake(110.09765, 62.23599) controlPoint2:CGPointMake(109.91057, 62.22712)];
	[CombinedShapePath addLineToPoint:CGPointMake(109.30138, 62.2319)];
	[CombinedShapePath addLineToPoint:CGPointMake(105.08051, 66.43568)];
	[CombinedShapePath addLineToPoint:CGPointMake(106.0899, 66.43568)];
	[CombinedShapePath addLineToPoint:CGPointMake(110.28747, 62.2551)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(113.25355, 63.32166)];
	[CombinedShapePath addCurveToPoint:CGPointMake(112.61317, 62.95448) controlPoint1:CGPointMake(113.0603, 63.19335) controlPoint2:CGPointMake(112.84479, 63.06982)];
	[CombinedShapePath addLineToPoint:CGPointMake(109.11766, 66.43584)];
	[CombinedShapePath addLineToPoint:CGPointMake(110.1267, 66.43584)];
	[CombinedShapePath addLineToPoint:CGPointMake(113.25355, 63.32166)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(108.29219, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(107.28281, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(103.06194, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(104.07133, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(108.29219, 62.232)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(50.35686, 1.32391)];
	[CombinedShapePath addLineToPoint:CGPointMake(49.92447, 0.7496)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82449, 2.84074)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82449, 3.84604)];
	[CombinedShapePath addLineToPoint:CGPointMake(50.35686, 1.32391)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(114.31447, 64.27533)];
	[CombinedShapePath addLineToPoint:CGPointMake(113.80977, 63.77268)];
	[CombinedShapePath addLineToPoint:CGPointMake(111.13589, 66.43575)];
	[CombinedShapePath addLineToPoint:CGPointMake(112.14527, 66.43575)];
	[CombinedShapePath addLineToPoint:CGPointMake(114.31447, 64.27533)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(106.27366, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(105.26427, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(101.0434, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(102.0528, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(106.27366, 62.232)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(49.40432, 0.26227)];
	[CombinedShapePath addCurveToPoint:CGPointMake(48.65807, 0.00019) controlPoint1:CGPointMake(49.1309, 0.0797) controlPoint2:CGPointMake(48.87838, -0.00459)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.89674, 0.75878)];
	[CombinedShapePath addCurveToPoint:CGPointMake(47.82445, 1.41738) controlPoint1:CGPointMake(47.8498, 0.94612) controlPoint2:CGPointMake(47.82342, 1.16417)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82445, 1.83574)];
	[CombinedShapePath addLineToPoint:CGPointMake(49.40432, 0.26227)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(104.25519, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(103.2458, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(99.02494, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(100.03432, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(104.25519, 62.232)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.34083, 60.66276)];
	[CombinedShapePath addLineToPoint:CGPointMake(12.01052, 100.82983)];
	[CombinedShapePath addLineToPoint:CGPointMake(12.51522, 101.33215)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.54504, 61.46468)];
	[CombinedShapePath addCurveToPoint:CGPointMake(52.34083, 60.66276) controlPoint1:CGPointMake(52.4306, 61.23775) controlPoint2:CGPointMake(52.36653, 60.96817)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(90.12574, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(89.11635, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(84.89548, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(85.90488, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(90.12574, 62.232)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(88.10723, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(87.09819, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(82.87733, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(83.88638, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(88.10723, 62.232)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(94.16274, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(93.15335, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(88.9325, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(89.94188, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(94.16274, 62.232)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(102.23669, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(101.22729, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(97.00644, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(98.01582, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(102.23669, 62.232)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(100.21822, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(99.20882, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(94.98797, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(95.99735, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(100.21822, 62.232)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(98.19971, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(97.19032, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(92.96947, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(93.97885, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(98.19971, 62.232)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(86.0888, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(85.07941, 62.232)];
	[CombinedShapePath addLineToPoint:CGPointMake(80.85855, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(81.86794, 66.43578)];
	[CombinedShapePath addLineToPoint:CGPointMake(86.0888, 62.232)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 51.63035)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 50.62505)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 55.10933)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 56.11429)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 51.63035)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 49.62005)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 48.61475)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 53.09903)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 54.10399)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 49.62005)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 47.60975)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 46.60445)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 51.08873)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 52.09369)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 47.60975)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 53.64069)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 52.63538)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 57.11966)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 58.12462)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 53.64069)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 45.59942)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 44.59412)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 49.0784)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 50.08336)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 45.59942)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(53.64481, 51.32279)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.64481, 52.32809)];
	[CombinedShapePath addLineToPoint:CGPointMake(65.88082, 40.14161)];
	[CombinedShapePath addCurveToPoint:CGPointMake(65.30143, 39.71335) controlPoint1:CGPointMake(65.68826, 39.99521) controlPoint2:CGPointMake(65.49502, 39.85257)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.64481, 51.32279)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(53.64481, 53.33312)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.64481, 54.33842)];
	[CombinedShapePath addLineToPoint:CGPointMake(67.00533, 41.03198)];
	[CombinedShapePath addCurveToPoint:CGPointMake(66.44821, 40.58154) controlPoint1:CGPointMake(66.81997, 40.8791) controlPoint2:CGPointMake(66.63426, 40.72895)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.64481, 53.33312)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 55.65102)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 54.64571)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 59.12999)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 60.13496)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 55.65102)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 43.58909)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 42.58379)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 47.06807)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 48.07302)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 43.58909)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(53.64481, 55.34342)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.64481, 56.34872)];
	[CombinedShapePath addLineToPoint:CGPointMake(68.09318, 41.95849)];
	[CombinedShapePath addCurveToPoint:CGPointMake(67.55319, 41.49133) controlPoint1:CGPointMake(67.91364, 41.80083) controlPoint2:CGPointMake(67.73376, 41.64523)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.64481, 55.34342)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(53.64481, 58.35889)];
	[CombinedShapePath addLineToPoint:CGPointMake(69.15362, 42.91319)];
	[CombinedShapePath addCurveToPoint:CGPointMake(68.62631, 42.43272) controlPoint1:CGPointMake(68.9782, 42.75144) controlPoint2:CGPointMake(68.80243, 42.59139)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.64481, 57.35358)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.64481, 58.35889)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 57.66135)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 56.65605)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 61.14033)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 61.95181)];
	[CombinedShapePath addCurveToPoint:CGPointMake(47.80951, 62.16031) controlPoint1:CGPointMake(47.8239, 62.01869) controlPoint2:CGPointMake(47.81499, 62.09035)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 57.66135)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 41.57875)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 40.57345)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 45.05773)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 46.06269)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 41.57875)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 39.56845)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 38.56315)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 43.04743)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82459, 44.05239)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 39.56845)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(53.64481, 49.31245)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.64481, 50.31776)];
	[CombinedShapePath addLineToPoint:CGPointMake(64.70868, 39.29833)];
	[CombinedShapePath addCurveToPoint:CGPointMake(64.10051, 38.89907) controlPoint1:CGPointMake(64.50653, 39.16115) controlPoint2:CGPointMake(64.30369, 39.02772)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.64481, 49.31245)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(47.82449, 41.03699)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82449, 42.0423)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32664, 37.55802)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32664, 36.55306)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.82449, 41.03699)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(53.64481, 37.25053)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.64481, 38.25583)];
	[CombinedShapePath addLineToPoint:CGPointMake(56.4883, 35.42351)];
	[CombinedShapePath addCurveToPoint:CGPointMake(55.67387, 35.22968) controlPoint1:CGPointMake(56.21043, 35.34809) controlPoint2:CGPointMake(55.93803, 35.28257)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.64481, 37.25053)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(10.03053, 93.75538)];
	[CombinedShapePath addCurveToPoint:CGPointMake(9.5553, 93.34009) controlPoint1:CGPointMake(9.86641, 93.62639) controlPoint2:CGPointMake(9.70675, 93.48956)];
	[CombinedShapePath addLineToPoint:CGPointMake(9.49706, 93.28174)];
	[CombinedShapePath addLineToPoint:CGPointMake(6.96433, 95.80386)];
	[CombinedShapePath addLineToPoint:CGPointMake(7.46903, 96.30652)];
	[CombinedShapePath addLineToPoint:CGPointMake(10.03053, 93.75538)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(8.99229, 92.77908)];
	[CombinedShapePath addLineToPoint:CGPointMake(8.4876, 92.27644)];
	[CombinedShapePath addLineToPoint:CGPointMake(5.95522, 94.7989)];
	[CombinedShapePath addLineToPoint:CGPointMake(6.45991, 95.30122)];
	[CombinedShapePath addLineToPoint:CGPointMake(8.99229, 92.77908)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(53.64481, 45.29182)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.64481, 46.29713)];
	[CombinedShapePath addLineToPoint:CGPointMake(62.20268, 37.77389)];
	[CombinedShapePath addCurveToPoint:CGPointMake(61.5349, 37.43367) controlPoint1:CGPointMake(61.99813, 37.66708) controlPoint2:CGPointMake(61.77508, 37.5531)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.64481, 45.29182)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(6.97382, 90.76878)];
	[CombinedShapePath addLineToPoint:CGPointMake(6.46913, 90.26614)];
	[CombinedShapePath addLineToPoint:CGPointMake(3.93675, 92.7886)];
	[CombinedShapePath addLineToPoint:CGPointMake(4.44145, 93.29092)];
	[CombinedShapePath addLineToPoint:CGPointMake(6.97382, 90.76878)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(15.11712, 94.72035)];
	[CombinedShapePath addCurveToPoint:CGPointMake(13.8929, 94.93431) controlPoint1:CGPointMake(14.71795, 94.83842) controlPoint2:CGPointMake(14.3068, 94.90667)];
	[CombinedShapePath addLineToPoint:CGPointMake(9.99205, 98.81937)];
	[CombinedShapePath addLineToPoint:CGPointMake(10.49675, 99.32201)];
	[CombinedShapePath addLineToPoint:CGPointMake(15.11712, 94.72035)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(11.29991, 94.50147)];
	[CombinedShapePath addCurveToPoint:CGPointMake(10.63144, 94.16194) controlPoint1:CGPointMake(11.07069, 94.40456) controlPoint2:CGPointMake(10.84832, 94.29025)];
	[CombinedShapePath addLineToPoint:CGPointMake(7.97365, 96.80896)];
	[CombinedShapePath addLineToPoint:CGPointMake(8.47835, 97.31161)];
	[CombinedShapePath addLineToPoint:CGPointMake(11.29991, 94.50147)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(12.90167, 94.91653)];
	[CombinedShapePath addCurveToPoint:CGPointMake(12.05229, 94.75751) controlPoint1:CGPointMake(12.61557, 94.88582) controlPoint2:CGPointMake(12.33187, 94.83156)];
	[CombinedShapePath addLineToPoint:CGPointMake(8.98301, 97.81437)];
	[CombinedShapePath addLineToPoint:CGPointMake(9.4877, 98.31668)];
	[CombinedShapePath addLineToPoint:CGPointMake(12.90167, 94.91653)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(7.98308, 91.77392)];
	[CombinedShapePath addLineToPoint:CGPointMake(7.47838, 91.27126)];
	[CombinedShapePath addLineToPoint:CGPointMake(4.946, 93.79374)];
	[CombinedShapePath addLineToPoint:CGPointMake(5.4507, 94.29604)];
	[CombinedShapePath addLineToPoint:CGPointMake(7.98308, 91.77392)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(53.64481, 39.26086)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.64481, 40.26616)];
	[CombinedShapePath addLineToPoint:CGPointMake(58.01677, 35.91156)];
	[CombinedShapePath addCurveToPoint:CGPointMake(57.26573, 35.6546) controlPoint1:CGPointMake(57.76562, 35.82079) controlPoint2:CGPointMake(57.51482, 35.73513)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.64481, 39.26086)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(53.64481, 41.27119)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.64481, 42.27649)];
	[CombinedShapePath addLineToPoint:CGPointMake(59.46336, 36.4815)];
	[CombinedShapePath addCurveToPoint:CGPointMake(58.74794, 36.18871) controlPoint1:CGPointMake(59.22797, 36.38186) controlPoint2:CGPointMake(58.98915, 36.28392)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.64481, 41.27119)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(53.64481, 43.28152)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.64481, 44.28683)];
	[CombinedShapePath addLineToPoint:CGPointMake(60.85546, 37.10502)];
	[CombinedShapePath addCurveToPoint:CGPointMake(60.16541, 36.78732) controlPoint1:CGPointMake(60.63344, 37.00026) controlPoint2:CGPointMake(60.40285, 36.89379)];
	[CombinedShapePath addLineToPoint:CGPointMake(53.64481, 43.28152)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(52.32675, 59.67162)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 58.66631)];
	[CombinedShapePath addLineToPoint:CGPointMake(47.46894, 63.50446)];
	[CombinedShapePath addCurveToPoint:CGPointMake(46.69905, 64.75443) controlPoint1:CGPointMake(47.26165, 64.0078) controlPoint2:CGPointMake(46.98549, 64.46642)];
	[CombinedShapePath addLineToPoint:CGPointMake(21.49243, 89.37617)];
	[CombinedShapePath addLineToPoint:CGPointMake(11.00144, 99.8247)];
	[CombinedShapePath addLineToPoint:CGPointMake(11.50614, 100.32701)];
	[CombinedShapePath addLineToPoint:CGPointMake(52.32675, 59.67162)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(4.86973, 88.8437)];
	[CombinedShapePath addCurveToPoint:CGPointMake(4.14713, 88.55807) controlPoint1:CGPointMake(4.64702, 88.7287) controlPoint2:CGPointMake(4.40273, 88.63519)];
	[CombinedShapePath addLineToPoint:CGPointMake(1.91832, 90.77821)];
	[CombinedShapePath addLineToPoint:CGPointMake(2.42267, 91.28085)];
	[CombinedShapePath addLineToPoint:CGPointMake(4.86973, 88.8437)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(5.96457, 89.76362)];
	[CombinedShapePath addLineToPoint:CGPointMake(5.61612, 89.41657)];
	[CombinedShapePath addCurveToPoint:CGPointMake(5.46399, 89.25721) controlPoint1:CGPointMake(5.56918, 89.36061) controlPoint2:CGPointMake(5.51744, 89.30806)];
	[CombinedShapePath addLineToPoint:CGPointMake(2.9275, 91.78344)];
	[CombinedShapePath addLineToPoint:CGPointMake(3.43219, 92.28575)];
	[CombinedShapePath addLineToPoint:CGPointMake(5.96457, 89.76362)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(3.32673, 88.37012)];
	[CombinedShapePath addCurveToPoint:CGPointMake(2.42356, 88.26433) controlPoint1:CGPointMake(3.02145, 88.31893) controlPoint2:CGPointMake(2.71514, 88.28515)];
	[CombinedShapePath addLineToPoint:CGPointMake(0.90879, 89.77296)];
	[CombinedShapePath addLineToPoint:CGPointMake(1.41349, 90.27562)];
	[CombinedShapePath addLineToPoint:CGPointMake(3.32673, 88.37012)];
	[CombinedShapePath closePath];
	[CombinedShapePath moveToPoint:CGPointMake(3.32673, 88.37012)];
	
	return CombinedShapePath;
}


@end