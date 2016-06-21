//
//  UIScrollView+DYRefresh.m
//  DYRefresh
//
//  Created by huangdeyu on 16/6/20.
//  Copyright © 2016年 hdy. All rights reserved.
//

#import "UIScrollView+DYRefresh.h"
#import <objc/runtime.h>

@implementation UIScrollView (DYRefresh)

#pragma mark - 关联对象
static char * dyHeaderKey;
-(DYBaseRefreshHeader *)dy_refreshHeaderView{
    return objc_getAssociatedObject(self, dyHeaderKey);
}
-(void)setDy_refreshHeaderView:(UIView *)dy_refreshHeaderView{
    [self insertSubview:dy_refreshHeaderView atIndex:0];
    objc_setAssociatedObject(self, dyHeaderKey, dy_refreshHeaderView, OBJC_ASSOCIATION_ASSIGN);
}
static char * dyFooterKey;
-(UIView *)dy_refreshFooterView{
    return objc_getAssociatedObject(self, dyFooterKey);
}
-(void)setDy_refreshFooterView:(UIView *)dy_refreshFooterView{
    [self addSubview:dy_refreshFooterView];
    objc_setAssociatedObject(self, dyFooterKey, dy_refreshFooterView, OBJC_ASSOCIATION_ASSIGN);
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.dy_refreshHeaderView.frame = CGRectMake(0, -self.dy_refreshHeaderView.limit, self.frame.size.width, self.dy_refreshHeaderView.limit);
}
@end
