//
//  FTurntableBackView.h
//  TurnTable
//
//  Created by fillinse on 2019/7/5.
//  Copyright © 2019 fillinse. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define weakSelf(weakSelf)  __weak typeof(self) weakself = self;

@interface FTurntableBackView : UIView

/*!
 * if animationDuration <= 0,this chart will display without animation.Default is 2.0;
 */
@property (nonatomic , assign)NSTimeInterval animationDuration;

@property (nonatomic, strong) NSArray * valueArr;

/**
 *  An array of colors for each section of the pie
 */
@property (nonatomic, strong) NSArray * colorArr;
/**
 *  Start drawing chart.
 */
- (void)showAnimation;

- (void)startWithIndexs:(NSArray *)indexArray;

@end

NS_ASSUME_NONNULL_END
