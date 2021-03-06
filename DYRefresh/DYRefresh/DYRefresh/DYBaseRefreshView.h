//
//  DYBaseRefreshView.h
//  DYRefresh
//
//  Created by huangdeyu on 16/6/20.
//  Copyright © 2016年 hdy. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger,DYRrefreshState) {
    DYRefreshStateIdle = 0, //闲置状态
    DYRefreshStateReady,    //表示可以刷新了，下拉到一定程度
    DYRefreshStateIng,      //刷新中
    DYRefreshStateEnd
};

@interface DYBaseRefreshView : UIView
{
    __weak UIScrollView * _scrollView;
}
@property(nonatomic,assign) DYRrefreshState refreshState;
@property(nonatomic,weak,readonly) UIScrollView * scrollView;
@property(nonatomic,assign)CGFloat limit;

-(void)beginRefresh;
-(void)endRefresh;
-(void)scrollViewContentOffsetDidChange:(NSDictionary *)change;
@end
