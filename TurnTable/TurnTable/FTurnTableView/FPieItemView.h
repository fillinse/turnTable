//
//  FPieItemView.h
//  TurnTable
//
//  Created by fillinse on 2019/7/5.
//  Copyright © 2019 fillinse. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FPieItemView;
@protocol FPieItemViewDelegate <NSObject>

@optional

- (void)pieChart:(FPieItemView *)pieChart animationDidEnd:(BOOL)flag;

@end
@interface FPieItemView : UIView

@property (nonatomic , assign)NSTimeInterval animationDuration ;
@property (nonatomic, assign) CGFloat lastEndAngle;
@property (nonatomic, assign) CGFloat lastStartAngle;
@property (nonatomic , weak)id<FPieItemViewDelegate> delegate;

/**
 Each initialization method of pie chart

 @param frame frame
 @param beginAngle beginAngle
 @param endAngle endAngle
 @param fillColor fillColor
 @return FPieItemView
 */
- (FPieItemView *)initWithFrame:(CGRect)frame
                  andBeginAngle:(CGFloat)beginAngle
                    andEndAngle:(CGFloat)endAngle
                   andFillColor:(UIColor *)fillColor;

- (void)showAnimation;
- (void)setHeaderWithUrl:(NSString *)url;
- (void)clearHeder;

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
