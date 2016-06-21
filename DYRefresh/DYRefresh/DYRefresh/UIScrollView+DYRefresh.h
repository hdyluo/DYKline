//
//  UIScrollView+DYRefresh.h
//  DYRefresh
//
//  Created by huangdeyu on 16/6/20.
//  Copyright © 2016年 hdy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYBaseRefreshHeader.h"
@interface UIScrollView (DYRefresh)
@property(nonatomic,strong) DYBaseRefreshHeader * dy_refreshHeaderView;
@property(nonatomic,strong) UIView * dy_refreshFooterView;
@end
