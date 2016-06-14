//
//  DYHorizontalLine.m
//  DYKlineTest
//
//  Created by 黄德玉 on 16/6/1.
//  Copyright © 2016年 黄德玉. All rights reserved.
//

#import "DYHorizontalLine.h"
#import "DYKlineCommon.h"
#import <Masonry.h>

@interface DYHorizontalLine()
@property(nonatomic,strong)UIView * firstSegment;
@property(nonatomic,strong)UIView * secondSegment;
@property(nonatomic,strong)UILabel * label;
@end

@implementation DYHorizontalLine
-(instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.label];
        [self addSubview:self.firstSegment];
        [self addSubview:self.secondSegment];
        [self layout];
    }
    return self;
}
-(void)loadText:(NSString *)text{
    _label.text = text;
}
-(void)layout{
    [self.firstSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(@20);
        make.height.equalTo(@0.5);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstSegment.mas_right);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.secondSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.label.mas_right);
        make.width.equalTo(self);
        make.height.equalTo(@0.5);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

#pragma mark - 初始化
-(UIView *)firstSegment{
    if (!_firstSegment) {
        _firstSegment = [UIView new];
        _firstSegment.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    }
    return _firstSegment;
}
-(UIView *)secondSegment{
    if (!_secondSegment) {
        _secondSegment = [UIView new];
        _secondSegment.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    }
    return _secondSegment;
}
-(UILabel *)label{
    if (!_label) {
        _label  = [[UILabel alloc ]initWithFrame:CGRectMake(20, 0, 30, self.frame.size.height)];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        [_label setFont:[UIFont systemFontOfSize:12]];
    }
    return _label;
}
@end
