//
//  DYCoordinateView.m
//  DYKlineStyle1
//
//  Created by huangdeyu on 16/6/15.
//  Copyright © 2016年 hdy. All rights reserved.
//

#import "DYCoordinateView.h"
#import "DYCommon.h"

@interface DYCoordinateView()
@property(nonatomic,strong)NSMutableArray<UIView *> * lineViews;
@property(nonatomic,strong)NSMutableArray<UILabel *> * labels;
@end

@implementation DYCoordinateView

-(instancetype)init{
    if (self = [super init]) {
        self.lineViews = [NSMutableArray array];
        self.labels = [NSMutableArray array];
        [self loadUIComponent];
        self.userInteractionEnabled = NO;
    }
    return self;
}
-(void)loadUIComponent{
    for (int i = 0 ; i < 4; i++) {
        UIView * lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
        [self addSubview:lineView];
        [self.lineViews addObject:lineView];
        UILabel * label = [[UILabel alloc] init];
        label.textColor = [UIColor blackColor];
        [label setFont:[UIFont systemFontOfSize:13]];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [self.labels addObject:label];
    }
}
-(void)drawWithMax:(NSInteger)maxValue min:(NSInteger)minValue{
    NSInteger length = (maxValue - minValue) / 3;
    self.labels[3].text = [NSString stringWithFormat:@"%ld",(long)minValue];
    self.labels[2].text = [NSString stringWithFormat:@"%ld",minValue + length];
    self.labels[1].text = [NSString stringWithFormat:@"%ld",minValue + length * 2];
    self.labels[0].text = [NSString stringWithFormat:@"%ld",maxValue];
}
-(void)layoutSubviews{
    CGFloat distance = (self.frame.size.height - TOP_MARGIN - BOTTOM_MARGIN) / 3;
    [self.labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(0, TOP_MARGIN + distance * idx - 10, 13 * obj.text.length, 20);
    }];
    [self.lineViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(40, TOP_MARGIN + distance * idx, self.frame.size.width - 40, 0.5);
    }];
}
@end
