//
//  DYLongPressToastView.m
//  DYKlineStyle1
//
//  Created by huangdeyu on 16/6/16.
//  Copyright © 2016年 hdy. All rights reserved.
//

#import "DYLongPressToastView.h"
#import "DYCommon.h"

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
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    //UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.height - 4) cornerRadius:4];
    self.bgLayer.path = [self creatPath].CGPath;
    self.dateLabel.frame = CGRectMake(3, 3, self.frame.size.width - 6, 20);
    self.priceTitleLabel.frame = CGRectMake(3, 25, 45, 20);
    self.priceLabel.frame = CGRectMake(40, 25, self.frame.size.width - 40, 20);
}
-(void)loadWithDate:(NSString *)date price:(NSString *)price{
    self.dateLabel.text = date;
    self.priceLabel.text = price;
}
-(UIBezierPath *)creatPath{
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(3, 2)];
    [path addArcWithCenter:CGPointMake(3, 3) radius:1 startAngle:M_PI * 1.5 endAngle:M_PI  clockwise:NO];
    [path addLineToPoint:CGPointMake(2, self.frame.size.height - 5)];
    [path addArcWithCenter:CGPointMake(3, self.frame.size.height - 6) radius:1 startAngle:M_PI endAngle:M_PI * 0.5 clockwise:NO];
    [path addLineToPoint:CGPointMake(self.frame.size.width * 0.5 - 2.5, self.frame.size.height - 5)];
    [path addLineToPoint:CGPointMake(self.frame.size.width * 0.5, self.frame.size.height)];
    [path addLineToPoint:CGPointMake(self.frame.size.width * 0.5 + 2.5, self.frame.size.height - 5)];
    [path addLineToPoint:CGPointMake(self.frame.size.width - 3, self.frame.size.height - 5)];
    [path addArcWithCenter:CGPointMake(self.frame.size.width - 3, self.frame.size.height - 6) radius:1 startAngle:M_PI_2 endAngle:0 clockwise:NO];
    [path addLineToPoint:CGPointMake(self.frame.size.width - 2, 3)];
    [path addArcWithCenter:CGPointMake(self.frame.size.width - 3, 3) radius:1 startAngle:0 endAngle:-M_PI_2 clockwise:NO];
    [path closePath];
    return path;
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
