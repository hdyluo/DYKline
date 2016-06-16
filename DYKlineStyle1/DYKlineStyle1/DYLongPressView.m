//
//  DYLongPressView.m
//  DYKlineStyle1
//
//  Created by huangdeyu on 16/6/16.
//  Copyright © 2016年 hdy. All rights reserved.
//

#import "DYLongPressView.h"
#import "DYCommon.h"
#import "DYKlineModel.h"
#import "DYLongPressToastView.h"

@interface DYLongPressView()
@property(nonatomic,strong)CAShapeLayer * bgLayer;
@property(nonatomic,strong)DYLongPressToastView * toastView;
@end

@implementation DYLongPressView
-(instancetype)init{
    if (self = [super init]) {
        self.clipsToBounds = NO;
        [self.layer addSublayer:self.bgLayer];
        [self addSubview:self.toastView];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.bgLayer.path = path.CGPath;
}

-(void)loadUIWithPoint:(CGPoint) point data:(DYKlineModel *)data{
    CGFloat  dis =(120 - self.frame.size.width) * 0.5;
    self.toastView.frame = CGRectMake(- dis, point.y - 60, 120, 50);
    NSInteger value = (NSInteger)data.value;
    [self.toastView loadWithDate:data.date price:[NSString stringWithFormat:@"%ld元",value]];
    [self layoutIfNeeded];
}

#pragma mark - 初始化
-(CAShapeLayer *)bgLayer{
    if (!_bgLayer) {
        _bgLayer = [CAShapeLayer layer];
        _bgLayer.fillColor = [UIColor colorWithWhite:0.8 alpha:0.2].CGColor;
    }
    return _bgLayer;
}
-(DYLongPressToastView *)toastView{
    if (!_toastView) {
        _toastView = [[DYLongPressToastView alloc] init];
    }
    return _toastView;
}
@end
