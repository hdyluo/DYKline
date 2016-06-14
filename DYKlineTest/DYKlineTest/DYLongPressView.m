//
//  DYLongPressView.m
//  DYKlineTest
//
//  Created by 黄德玉 on 16/5/30.
//  Copyright © 2016年 黄德玉. All rights reserved.
//

#import "DYLongPressView.h"

@interface DYLongPressView()
@property(nonatomic,strong)UIView * horizontalLine;
@property(nonatomic,strong)UIView * verticalLine;
@property(nonatomic,strong)UILabel * label;
@property(nonatomic,assign)CGPoint  currentPoint;
@end

@implementation DYLongPressView
-(instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.horizontalLine];
        [self addSubview:self.verticalLine];
        [self addSubview:self.label];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.horizontalLine.frame = CGRectMake(0, self.currentPoint.y, self.frame.size.width, 1);
    self.verticalLine.frame = CGRectMake(self.currentPoint.x, 0, 1, self.frame.size.height);
    self.label.frame = CGRectMake(self.frame.size.width - 30, self.currentPoint.y - 8, 30, 16);
}

-(void)reloadUIWithPoint:(CGPoint)point andValue:(CGFloat)value{
    self.currentPoint = point;
    NSNumber * temp = [NSNumber numberWithFloat:value];
    self.label.text = [NSString stringWithFormat:@"%@",[temp stringValue]];
    [self setNeedsLayout];
}

#pragma mark - 初始化
-(UIView *)horizontalLine{
    if (!_horizontalLine) {
        _horizontalLine = [[UIView alloc] init];
        _horizontalLine.backgroundColor = [UIColor whiteColor];
    }
    return _horizontalLine;
}
-(UIView *)verticalLine{
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc] init];
        _verticalLine.backgroundColor = [UIColor whiteColor];
    }
    return _verticalLine;
}
-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        _label.textColor = [UIColor blackColor];
        [_label setFont:[UIFont systemFontOfSize:14]];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}
@end
