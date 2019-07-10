//
//  ViewController.m
//  TurnTable
//
//  Created by fillinse on 2019/7/5.
//  Copyright © 2019 fillinse. All rights reserved.
//

#import "ViewController.h"
#import "FTurnTableView/FTurntableBackView.h"

@interface ViewController ()
@property (nonatomic, strong) FTurntableBackView *turnView;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (nonatomic, strong) NSArray *userArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _userArray = @[@"http://img4q.duitang.com/uploads/item/201408/08/20140808171354_XkhfE.jpeg",@"http://b-ssl.duitang.com/uploads/item/201809/24/20180924092018_zjgut.jpg",@"http://cdn.duitang.com/uploads/blog/201404/22/20140422142715_8GtUk.thumb.600_0.jpeg",@"http://cdn.duitang.com/uploads/item/201410/16/20141016202155_5ycRZ.thumb.700_0.jpeg",@"http://cdn.duitang.com/uploads/item/201407/24/20140724190906_MCkXs.thumb.700_0.jpeg",@"http://cdn.duitang.com/uploads/item/201601/08/20160108194244_JxGRy.thumb.700_0.jpeg",@"http://b-ssl.duitang.com/uploads/item/201612/08/20161208204750_rS8N4.jpeg",@"http://b-ssl.duitang.com/uploads/item/201812/07/20181207173003_zdddw.jpg"];
    [self.view addSubview:self.turnView];

}
- (IBAction)checkBtnClick:(id)sender {
    _checkBtn.enabled = NO;
    _turnView.valueArr = _userArray;
    [_turnView showAnimation];
    __block typeof(&*self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //组合一个被选中数组索引
        int count = 8;
        NSMutableArray *arr = [NSMutableArray array];
        while (count > 0) {
            NSInteger index = arc4random()%count;
            [arr addObject:@(index)];
            count --;
        }
        [weakSelf.turnView startWithIndexs:arr];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((weakSelf.turnView.animationDuration * (weakSelf.userArray.count - 1) + 3) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.checkBtn.enabled = YES;
            [weakSelf checkBtnClick:weakSelf.checkBtn];
        });
    });
}

- (FTurntableBackView *)turnView
{
    if (!_turnView) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _turnView = [[FTurntableBackView alloc] initWithFrame:CGRectMake(20, 100, width - 40, width - 40)];
        _turnView.animationDuration = 2;
        _turnView.backgroundColor = [UIColor clearColor];
    }
    return _turnView;
}
@end
