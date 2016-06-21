//
//  DYLongPressToastView.m
//  DYKlineStyle1
//
//  Created by huangdeyu on 16/6/16.
//  Copyright © 2016年 hdy. All rights reserved.
//

#import "DYLongPressToastView.h"
#import "DYCommon.h"
#define RADIUS 2

@interface DYLongPressToastView()
@property(nonatomic,strong)CAShapeLayer * bgLayer;
@property(nonatomic,strong)UILabel * dateLabel;
@property(nonatomic,strong)UILabel * priceTitleLabel;
@property(nonatomic,strong)UILabel * priceLabel;
@end

@implementation DYLongPressToastView

-(instancetype)init{
    if (self = [super init]) {
        [self.layer addSublayer:self.bgLayer];
        [self addSubview:self.priceLabel];
        [self addSubview:self.priceTitleLabel];
        [self addSubview:self.dateLabel];
        _arrowOn = NO;
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.arrowOn) {
        self.bgLayer.path = [self createReversePath].CGPath;
    }else{
        self.bgLayer.path = [self creatPath].CGPath;
    }
    self.dateLabel.frame = CGRectMake(5, 3, self.frame.size.width - 6, 20);
    self.priceTitleLabel.frame = CGRectMake(5, 25, 45, 20);
    self.priceLabel.frame = CGRectMake(45, 25, self.frame.size.width - 45, 20);
}
-(void)loadWithDate:(NSString *)date price:(NSString *)price{
    self.dateLabel.text = date;
    self.priceLabel.text = price;
}
-(UIBezierPath *)creatPath{
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(4, 2)];
    [path addArcWithCenter:CGPointMake(4, 4) radius:2 startAngle:M_PI * 1.5 endAngle:M_PI  clockwise:NO];
    [path addLineToPoint:CGPointMake(2, self.frame.size.height - 7)];
    [path addArcWithCenter:CGPointMake(4, self.frame.size.height - 7) radius:2 startAngle:M_PI endAngle:M_PI * 0.5 clockwise:NO];
    [path addLineToPoint:CGPointMake(self.frame.size.width * 0.5 - 2.5, self.frame.size.height - 5)];
    [path addLineToPoint:CGPointMake(self.frame.size.width * 0.5, self.frame.size.height)];
    [path addLineToPoint:CGPointMake(self.frame.size.width * 0.5 + 2.5, self.frame.size.height - 5)];
    [path addLineToPoint:CGPointMake(self.frame.size.width - 4, self.frame.size.height - 5)];
    [path addArcWithCenter:CGPointMake(self.frame.size.width - 4, self.frame.size.height - 7) radius:2 startAngle:M_PI_2 endAngle:0 clockwise:NO];
    [path addLineToPoint:CGPointMake(self.frame.size.width - 2, 4)];
    [path addArcWithCenter:CGPointMake(self.frame.size.width - 4, 4) radius:2 startAngle:0 endAngle:-M_PI_2 clockwise:NO];
    [path closePath];
    return path;
}
-(UIBezierPath *)createReversePath{
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(4, 5)];
    [path addArcWithCenter:CGPointMake(4, 7) radius:2 startAngle:-M_PI_2 endAngle:-M_PI clockwise:NO];
    [path addLineToPoint:CGPointMake(2, self.frame.size.height - 4)];
    [path addArcWithCenter:CGPointMake(4, self.frame.size.height - 4) radius:2 startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
    [path addLineToPoint:CGPointMake(self.frame.size.width - 4, self.frame.size.height - 2)];
    [path addArcWithCenter:CGPointMake(self.frame.size.width - 4, self.frame.size.height - 4) radius:2 startAngle:M_PI_2 endAngle:0 clockwise:NO];
    [path addLineToPoint:CGPointMake(self.frame.size.width - 2, 7)];
    [path addArcWithCenter:CGPointMake(self.frame.size.width - 4, 7) radius:2 startAngle:0 endAngle:-M_PI_2 clockwise:NO];
    [path addLineToPoint:CGPointMake(self.frame.size.width * .5 + 2.5, 5)];
    [path addLineToPoint:CGPointMake(self.frame.size.width * .5, 0)];
    [path addLineToPoint:CGPointMake(self.frame.size.width *.5 -2.5, 5)];
    [path closePath];
    return path;
}
#pragma mark - setter
-(void)setArrowOn:(BOOL)arrowOn{
    if (_arrowOn != arrowOn) {
        _arrowOn = arrowOn;
        [self layoutSubviews];
    }
}
#pragma mark - 初始化
-(CAShapeLayer *)bgLayer{
    if (!_bgLayer) {
        _bgLayer = [CAShapeLayer layer];
        _bgLayer.fillColor = [UIColor colorWithWhite:1.0 alpha:0.8].CGColor;
        _bgLayer.strokeColor = HexRGB(0x4889db).CGColor;
    }
    return _bgLayer;
}
-(UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = [UIColor lightGrayColor];
        [_dateLabel setFont:[UIFont systemFontOfSize:15]];
    }
    return _dateLabel;
}
-(UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = [UIColor redColor];
        [_priceLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return _priceLabel;
}
-(UILabel *)priceTitleLabel{
    if (!_priceTitleLabel) {
        _priceTitleLabel = [[UILabel alloc ] init];
        _priceTitleLabel.textColor = [UIColor lightGrayColor];
        [_priceTitleLabel setFont:[UIFont systemFontOfSize:14]];
        _priceTitleLabel.text = @"价格：";
    }
    return _priceTitleLabel;
}

@end
