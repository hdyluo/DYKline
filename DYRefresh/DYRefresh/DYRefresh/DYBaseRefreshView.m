//
//  DYBaseRefreshView.m
//  DYRefresh
//
//  Created by huangdeyu on 16/6/20.
//  Copyright © 2016年 hdy. All rights reserved.
//

#import "DYBaseRefreshView.h"

@interface DYBaseRefreshView()

@end

@implementation DYBaseRefreshView
-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (![newSuperview isKindOfClass:[UIScrollView class]]) {
        return;
    }
    if (newSuperview) {
        _scrollView = (UIScrollView *)newSuperview;
        _scrollView.alwaysBounceVertical = YES;
        [self addObservers];
    }
}
#pragma mark - protocol
-(void)beginRefresh{
}
-(void)endRefresh{
}
-(void)autoRefresh{
}

#pragma mark KVO
-(void)addObservers{
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewContentOffsetDidChange:change];
    }
}
-(void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    
}
#pragma mark - setter
-(void)setRefreshState:(DYRrefreshState)refreshState{
    _refreshState = refreshState;
}

@end
