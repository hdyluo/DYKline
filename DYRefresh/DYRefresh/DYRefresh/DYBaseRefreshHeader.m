//
//  DYBaseRefreshHeader.m
//  DYRefresh
//
//  Created by huangdeyu on 16/6/21.
//  Copyright © 2016年 hdy. All rights reserved.
//

#import "DYBaseRefreshHeader.h"

@interface DYBaseRefreshHeader()
@property(nonatomic,strong) UIActivityIndicatorView * refreshCtrl;
@end

@implementation DYBaseRefreshHeader
-(instancetype)init{
    if (self = [super init]) {
        self.limit = 50;
        self.refreshState = DYRefreshStateIdle;
        [self addSubview:self.refreshCtrl];
        
    }
    return self;
}
-(void)layoutSubviews{
    self.refreshCtrl.center = CGPointMake(self.bounds.size.width  * .5, self.bounds.size.height * .5);
}
-(void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    NSValue * newPointString = [change objectForKey:@"new"];
    CGPoint newPoint =  [newPointString CGPointValue];
    if (newPoint.y <= -self.limit && self.refreshState == DYRefreshStateIdle) {
        self.refreshState = DYRefreshStateReady;
        return;
    }
    if (newPoint.y > -self.limit && self.refreshState == DYRefreshStateReady) {
        self.refreshState = DYRefreshStateIdle;
        return;
    }
    if (self.refreshState == DYRefreshStateReady && !self.scrollView.isDragging) {//处于准备状态，且已经没有拖动了
        self.refreshState = DYRefreshStateIng;
        return;
    }
}
-(void)setRefreshState:(DYRrefreshState)refreshState{
    [super setRefreshState:refreshState];
    switch (refreshState) {
        case DYRefreshStateIdle:
            NSLog(@"当前处于闲置状态");
            break;
        case DYRefreshStateReady:
            NSLog(@"当前处于准备状态");
            break;
        case DYRefreshStateIng:
        {
            if (![self.refreshCtrl isAnimating]) {
                [self.refreshCtrl startAnimating];
            }
            [self.scrollView setContentOffset: CGPointMake(0, - self.limit) animated:YES];
            //for test
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.refreshState = DYRefreshStateEnd;
            });
            NSLog(@"当前处于正在刷新状态");
        }
            break;
        case DYRefreshStateEnd:
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.scrollView.contentOffset = CGPointMake(0, 0);
            }completion:^(BOOL finished) {
                if (finished) {
                    self.refreshState = DYRefreshStateIdle;
                }
            }];
            [self.refreshCtrl stopAnimating];
        }
            NSLog(@"当前处于刷新结束状态");
            break;
        default:
            break;
    }
}


-(void)beginRefresh{
    self.refreshState = DYRefreshStateIng;
}
-(void)endRefresh{
    self.refreshState = DYRefreshStateEnd;
}
#pragma mark - 初始化
-(UIActivityIndicatorView *)refreshCtrl{
    if (!_refreshCtrl) {
        _refreshCtrl = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _refreshCtrl.hidesWhenStopped = NO;
    }
    return _refreshCtrl;
}
@end
