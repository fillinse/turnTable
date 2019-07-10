//
//  FTurntableBackView.m
//  TurnTable
//
//  Created by fillinse on 2019/7/5.
//  Copyright © 2019 fillinse. All rights reserved.
//

#import "FTurntableBackView.h"
#import "FPieItemView.h"
#define k_COLOR_STOCK @[[UIColor colorWithRed:244/255.0 green:161/255.0 blue:100/255.0 alpha:1],[UIColor colorWithRed:87/255.0 green:255/255.0 blue:191/255.0 alpha:1],[UIColor colorWithRed:254/255.0 green:224/255.0 blue:90/255.0 alpha:1],[UIColor colorWithRed:240/255.0 green:58/255.0 blue:63/255.0 alpha:1],[UIColor colorWithRed:147/255.0 green:111/255.0 blue:255/255.0 alpha:1],[UIColor colorWithRed:255/255.0 green:255/255.0 blue:199/255.0 alpha:1],[UIColor colorWithRed:90/255.0 green:159/255.0 blue:229/255.0 alpha:1],[UIColor colorWithRed:100/255.0 green:230/255.0 blue:95/255.0 alpha:1],[UIColor colorWithRed:33/255.0 green:255/255.0 blue:255/255.0 alpha:1],[UIColor colorWithRed:249/255.0 green:110/255.0 blue:176/255.0 alpha:1],[UIColor colorWithRed:192/255.0 green:168/255.0 blue:250/255.0 alpha:1],[UIColor colorWithRed:166/255.0 green:134/255.0 blue:54/255.0 alpha:1],[UIColor colorWithRed:217/255.0 green:221/255.0 blue:228/255.0 alpha:1],[UIColor colorWithRed:99/255.0 green:106/255.0 blue:192/255.0 alpha:1]]
@interface FTurntableBackView ()<CAAnimationDelegate>
@property (nonatomic,strong) NSMutableArray * angleArr;

@property (nonatomic,strong) NSMutableArray * countPreAngeleArr;
@property (nonatomic,strong) NSMutableArray * lastCountPreAngeleArr;
@property (nonatomic, assign) NSInteger deleteIndex;

@property (nonatomic, strong) NSMutableArray *indexArray;//动画顺序数组
@property (nonatomic, strong) NSMutableArray *anglesArray;//每个动画偏移量数组

@property (nonatomic,strong) NSMutableArray * layersArr;
@property (nonatomic,strong) NSMutableArray * subLayersArray;

@property (nonatomic, copy) dispatch_source_t timer;

@property (nonatomic, assign) CGFloat lastAngle;
@end

@implementation FTurntableBackView
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        _colorArr = k_COLOR_STOCK;
        self.deleteIndex = 10000;
    }
    return self;
}

- (void)countAllAngleDataArr{
    _angleArr = [NSMutableArray array];
    for (NSString *obj in _valueArr) {
        [_angleArr addObject:[NSNumber numberWithDouble:M_PI * 2 * (1.0 / _valueArr.count)]];
    }
    _countPreAngeleArr = [NSMutableArray array];
    for (NSInteger i = 0; i<_angleArr.count; i++) {
        if (i==0) {
            //计算起始位置 每次最上面的中心角度为 M_PI_2 然后减去本身角度的一般
            CGFloat angle = - M_PI_2;
            [_countPreAngeleArr addObject:[NSNumber numberWithFloat:angle]];
        }
        CGFloat angle = [_countPreAngeleArr[i] floatValue] + [_angleArr[i] floatValue];
        [_countPreAngeleArr addObject:[NSNumber numberWithFloat:angle]];
    }
    if (!_lastCountPreAngeleArr) {
        _lastCountPreAngeleArr = [_countPreAngeleArr mutableCopy];
    }
}
-(void)showAnimation{
    if (_valueArr.count>0) {
        [self countAllAngleDataArr];
        if (!_subLayersArray) {
            _subLayersArray = [NSMutableArray array];
        }else{
            [_subLayersArray enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj removeFromSuperview];
            }];
            [_subLayersArray removeAllObjects];
        }
        if (!_layersArr) {
            _layersArr = [NSMutableArray array];
        }else{
            [_subLayersArray addObjectsFromArray:_layersArr];
            [_layersArr removeAllObjects];
            [_subLayersArray enumerateObjectsUsingBlock:^(FPieItemView* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj clearHeder];
            }];
        }
        
        CGFloat wid = self.frame.size.width;
        NSArray *colors = _colorArr;
        CGFloat width = wid/2;
        CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.width/2);
        if (_subLayersArray.count > 0) {
            FPieItemView *itemsView = _subLayersArray[0];
            width = itemsView.frame.size.width;
            center = itemsView.center;
        }
        for (NSInteger i = 0; i<_countPreAngeleArr.count-1; i++) {
            FPieItemView *itemsView = [[FPieItemView alloc] initWithFrame:CGRectMake(0, 0, width, width) andBeginAngle:[_countPreAngeleArr[i] floatValue] andEndAngle:[_countPreAngeleArr[i+1] floatValue] andFillColor:colors[i]];
            itemsView.center = center;
            NSLog(@"itemsView.frame--%@",NSStringFromCGRect(itemsView.frame));
            itemsView.tag = i;
            itemsView.animationDuration = _animationDuration;
            NSArray *lastAngleArray = self.lastCountPreAngeleArr;
            if (i < self.deleteIndex) {
                itemsView.lastEndAngle = [lastAngleArray[i + 1] floatValue];
                itemsView.lastStartAngle = [lastAngleArray[i] floatValue];
            }else{
                itemsView.lastEndAngle = [lastAngleArray[i + 1 + 1] floatValue];
                itemsView.lastStartAngle = [lastAngleArray[i + 1] floatValue];
            }
            [_layersArr addObject:itemsView];
            [itemsView setHeaderWithUrl:_valueArr[i]];
            [self addSubview:itemsView];
        }
        __weak typeof(self) weakSelf = self;
        for ( int i = 0; i < weakSelf.layersArr.count; i ++) {
            FPieItemView *itemsView = weakSelf.layersArr[i];
            [itemsView showAnimation];
        }
        _lastCountPreAngeleArr = [_countPreAngeleArr mutableCopy];
    }
    [self setNeedsDisplay];
}
- (void)startWithIndexs:(NSArray *)indexArray
{
    _indexArray = [indexArray mutableCopy];
    _colorArr = k_COLOR_STOCK;
    [self circleAnimation];
}
- (void)circleAnimation
{
    _deleteIndex = [_indexArray[0] integerValue];
    [_indexArray removeObjectAtIndex:0];
    NSMutableArray *arr = [self.valueArr mutableCopy];
    [arr removeObjectAtIndex:_deleteIndex];
    self.valueArr = arr;
    NSMutableArray *colors = [self.colorArr mutableCopy];
    [colors removeObjectAtIndex:self.deleteIndex];
    self.colorArr = colors;
    [self showAnimation];
    __block typeof(&*self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.valueArr.count != 1) {
            [self circleAnimation];
        }else{
            weakSelf.deleteIndex = 1000;
            weakSelf.lastCountPreAngeleArr = nil;
            weakSelf.colorArr = k_COLOR_STOCK;
        }
    });
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
