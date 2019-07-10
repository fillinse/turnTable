//
//  FPieItemView.m
//  TurnTable
//
//  Created by fillinse on 2019/7/5.
//  Copyright © 2019 fillinse. All rights reserved.
//

#import "FPieItemView.h"
@interface FPieItemView ()<CAAnimationDelegate>

@property (nonatomic,assign) CGFloat beginAngle;
@property (nonatomic,assign) CGFloat endAngle;
@property (nonatomic,strong) UIColor * fillColor;
@property (nonatomic,strong) CAShapeLayer * shapeLayer;

@property (nonatomic, strong) UIImageView *headerImageView;
@end
@implementation FPieItemView
-(FPieItemView *)initWithFrame:(CGRect)frame andBeginAngle:(CGFloat)beginAngle andEndAngle:(CGFloat)endAngle andFillColor:(UIColor *)fillColor{
    if (self = [super initWithFrame:frame]) {
        //初始化起始角度
        _beginAngle = beginAngle;
        _endAngle = endAngle;
        _fillColor = fillColor;
        _shapeLayer = [CAShapeLayer layer];
    }
    return self;
}
- (void)clearHeder
{
    [_headerImageView.layer removeFromSuperlayer];
}
- (void)setHeaderWithUrl:(NSString *)url
{
    //设置头像
    self.headerImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    /// *******************************************************************
    /// *******************************************************************
    /// *******************************************************************

    //这里特别需要注意 这里的画法，是以自身中心为原点，以自身宽度(本身是正方形)为半径，画一段圆弧，然后填充颜色，就成了一个扇形。注意 圆弧的线的宽度是
    CGFloat R = self.frame.size.width;
    CGFloat r = R/3.0;
    CGFloat longLine = R - r/2 - 10;
    CGFloat angle = (_beginAngle + _endAngle)/2;
    CGFloat width = cos(angle) * longLine;
    CGFloat height = sin(-angle) * longLine;
    
    CGFloat x = width + R/2 - r/2;
    CGFloat y = R/2 - height - r/2;
    self.headerImageView.frame = CGRectMake(x, y, r, r);
    self.headerImageView.layer.cornerRadius = r/2;
    self.headerImageView.clipsToBounds = YES;
    _shapeLayer = [CAShapeLayer layer];
    [_shapeLayer addSublayer:self.headerImageView.layer];
    /// *******************************************************************
    /// *******************************************************************
    /// *******************************************************************
}

- (void)configBaseLayer{
    _shapeLayer.lineWidth = self.frame.size.width;
    _shapeLayer.strokeColor = _fillColor.CGColor;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    //
    _shapeLayer.borderColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:_shapeLayer];
    CGFloat all = _endAngle - _beginAngle;
    CGFloat from = 0;
    CGFloat to = 0;
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (_lastEndAngle < _endAngle) {
        //正向
        from = (_lastEndAngle - _beginAngle)/all;
        to = 1;
        if (from == to) {
            from = 0;
        }
        [path addArcWithCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:self.frame.size.width/2 startAngle:_beginAngle endAngle:_endAngle clockwise: YES];
    }else{
        to = 1;
        from = (_endAngle - _lastStartAngle)/all;
        if (from == to) {
            from = 0;
        }
        [path addArcWithCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:self.frame.size.width/2 startAngle:_endAngle endAngle:_beginAngle clockwise: NO];
    }
    
    NSLog(@"%f---%f  _beginAngle-%f--_lastStartAngle-%f",from,to,_beginAngle,_lastStartAngle);
    _shapeLayer.path = path.CGPath;
    
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basic.duration = _animationDuration;
    basic.fromValue = @(from);
    basic.toValue = @(to);
    basic.removedOnCompletion = NO;
    basic.delegate = self;
    basic.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];;
    [_shapeLayer addAnimation:basic forKey:@"basic"];
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = _animationDuration;
    pathAnimation.repeatCount = 0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CGFloat end = (_endAngle + _beginAngle)/2;
    CGFloat start = (_lastStartAngle + _lastEndAngle)/2;
    if (end == start) {
        start = _beginAngle;
    }
    CGFloat R = self.frame.size.width;
    CGFloat r = R/3.0;
    CGFloat longLine = R - r/2 - 10;
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 addArcWithCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:longLine startAngle:start endAngle:end clockwise: _lastStartAngle <= _beginAngle];
    pathAnimation.path = path2.CGPath;
    [_headerImageView.layer addAnimation:pathAnimation forKey:@"header"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        
    }
    if (_delegate) {
        //            [_delegate pieChart:self animationDidEnd:flag];
    }
}

- (void)showAnimation{
    [self configBaseLayer];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touch%ld",self.tag);
    
}

- (UIImageView *)headerImageView
{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.backgroundColor = [UIColor redColor];
    }
    return _headerImageView;
}
@end
