//
//  DYKlineView.m
//  DYKlineStyle1
//
//  Created by huangdeyu on 16/6/15.
//  Copyright © 2016年 hdy. All rights reserved.
//

#import "DYKlineView.h"
#import "DYKlineModel.h"
#import "DYCommon.h"
#import "DYLongPressView.h"

@interface DYKlineView()
{
    CGPoint _currentLongPressPoint;
    DYKlineModel * _currentLongPressData;
}
@property(nonatomic,strong)CAShapeLayer * sharpLayer;               //这是那根线
@property(nonatomic,strong)CAGradientLayer * gradientLayer;         //这是线包含的渐变
@property(nonatomic,strong)UIBezierPath * bezierPath;
@property(nonatomic,assign)CGFloat pathOffset;          //每次更新path 后有一个偏移量
@property(nonatomic,strong)NSArray<DYKlineModel *> * currentDatas;      //当前展示的数据
@property(nonatomic,strong)NSMutableArray<NSNumber *> * yValues;        //所有数据对应的Y轴的值
@property(nonatomic,assign)CGFloat  lastestOffset;     //每次translate后的偏移量
@property(nonatomic,strong)NSMutableArray<UILabel *> * labels;
@property(nonatomic,strong)UILongPressGestureRecognizer * longPressGesture;
@property(nonatomic,strong)DYLongPressView * longPressView;
@property(nonatomic,strong)CAShapeLayer * currentPointLayer;
@end

@implementation DYKlineView
-(instancetype)init{
    if (self = [super init]) {
        [self.layer addSublayer:self.gradientLayer];
        self.labels = [NSMutableArray array];
        [self addGestureRecognizer:self.longPressGesture];
        self.yValues = [NSMutableArray array];
    }
    return self;
}
-(void)reset{
    [self.bezierPath removeAllPoints];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.sharpLayer.transform = CATransform3DIdentity;
    [CATransaction commit];
    [self.labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    self.labels = [NSMutableArray array];
    self.yValues = [NSMutableArray array];
}
-(void)updatePathWithDatas:(NSArray<DYKlineModel *> *)datas offset:(CGFloat)offset maxValue:(float)maxValue minValue:(float)minValue{
    self.pathOffset = offset;
    self.currentDatas = datas;
    self.lastestOffset = self.pathOffset;
    [self reset];
    [datas enumerateObjectsUsingBlock:^(DYKlineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat yValue = (maxValue - obj.value) / (maxValue - minValue) * (self.frame.size.height - (TOP_MARGIN + BOTTOM_MARGIN)) + TOP_MARGIN;//映射到指定范围内。
        [self.yValues addObject:[NSNumber numberWithFloat:yValue]];
        CGPoint startPoint = CGPointMake(obj.xValue - offset, yValue);
        if (idx == 0) {
            [self.bezierPath moveToPoint:startPoint];
        }else{
            [self.bezierPath addLineToPoint:startPoint];
        }
        [self addLabelsWithPoint:startPoint andText:obj.date];
        UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(startPoint.x -3, startPoint.y - 3, 6, 6)];
        [self.bezierPath appendPath:path];
        [self.bezierPath addLineToPoint:startPoint];
    }];
    self.sharpLayer.path = self.bezierPath.CGPath;
    self.gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.gradientLayer.mask = self.sharpLayer;
}
-(void)updateTranslationWithOffset:(CGFloat)offset{
    self.lastestOffset = offset;        //最新的偏移量
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.sharpLayer.transform = CATransform3DMakeTranslation(self.pathOffset - offset, 0, 0);
    [CATransaction commit];
    [self.labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.transform = CGAffineTransformMakeTranslation(self.pathOffset-offset,0);
        obj.transform = CGAffineTransformRotate(obj.transform, - M_PI  / 4);
    }];
}
-(void)addLabelsWithPoint:(CGPoint)point andText:(NSString *)text{
    UILabel * label = [[UILabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:13]];
    label.textColor = [UIColor blackColor];
    label.frame = CGRectMake(0, 0, 80, 20);
    label.textAlignment = NSTextAlignmentCenter;
    label.center = CGPointMake(point.x, self.frame.size.height - 40);
    label.transform = CGAffineTransformMakeRotation(- M_PI  / 4);
    [self.labels addObject:label];
    label.text = text;
    [self addSubview:label];
}

#pragma mark - 手势
-(void)longPressAction:(UILongPressGestureRecognizer *)gesture{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self addSubview:self.longPressView];
            [self getCurrentLongPressPointAndDataWithPoint:[gesture locationInView:self]];
            self.longPressView.frame = CGRectMake(_currentLongPressPoint.x - 20, 0, 40, self.frame.size.height);
            [self.longPressView loadUIWithPoint:_currentLongPressPoint data:_currentLongPressData];
            //获取后，绘制一个扩散layer
            [self.layer insertSublayer:self.currentPointLayer atIndex:0];
            UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_currentLongPressPoint.x - 10, _currentLongPressPoint.y - 10, 20, 20)];
            self.currentPointLayer.path = path.CGPath;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self getCurrentLongPressPointAndDataWithPoint:[gesture locationInView:self]];
            self.longPressView.frame = CGRectMake(_currentLongPressPoint.x - 20, 0, 40, self.frame.size.height);
            [self.longPressView loadUIWithPoint:_currentLongPressPoint data:_currentLongPressData];
            UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_currentLongPressPoint.x - 10, _currentLongPressPoint.y - 10, 20, 20)];
            self.currentPointLayer.path = path.CGPath;
        }
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            [self.longPressView removeFromSuperview];
            [self.currentPointLayer removeFromSuperlayer];
            break;
        default:
            break;
    }
}
-(void)getCurrentLongPressPointAndDataWithPoint:(CGPoint)point{
    __block CGPoint toPoint = point;
    [self.currentDatas enumerateObjectsUsingBlock:^(DYKlineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat tp = obj.xValue - self.lastestOffset;
        if (idx < _currentDatas.count - 1) {
            CGFloat t1 = _currentDatas[idx + 1].xValue - self.lastestOffset;
            if (point.x - tp >= 0 && t1 - point.x >= 0) {
                if (point.x - tp < t1 - point.x) {
                    toPoint.x = tp;
                    toPoint.y = [self.yValues[idx] floatValue];
                    _currentLongPressData = self.currentDatas[idx];
                    _currentLongPressPoint = toPoint;
                }else{
                    toPoint.x = t1;
                    toPoint.y = [self.yValues[idx + 1] floatValue];
                    _currentLongPressData = self.currentDatas[idx + 1];
                    _currentLongPressPoint = toPoint;
                }
                *stop = YES;
            }
        }else{
            toPoint.x = tp;
            toPoint.y = [self.yValues[idx] floatValue];
            _currentLongPressData = self.currentDatas[idx];
            _currentLongPressPoint = toPoint;
        }
    }];
   
    
}
#pragma mark - 初始化
-(CAShapeLayer *)sharpLayer{
    if (!_sharpLayer) {
        _sharpLayer = [CAShapeLayer layer];
        _sharpLayer.strokeColor = [UIColor greenColor].CGColor;
        _sharpLayer.fillColor = [UIColor clearColor].CGColor;
        _sharpLayer.lineWidth = 3.0;
        _sharpLayer.lineJoin = kCALineJoinRound;
    }
    return _sharpLayer;
}
-(UIBezierPath *)bezierPath{
    if (!_bezierPath) {
        _bezierPath = [UIBezierPath bezierPath];
        _bezierPath.lineJoinStyle = kCGLineJoinRound;
    }
    return _bezierPath;
}
-(CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.startPoint = CGPointMake(0.5, 1);
        _gradientLayer.endPoint = CGPointMake(0.5, 0);
        UIColor * targetColor = HexRGB(0x4889db);
        UIColor * startColor = HexRGB(0x00FFFF);
        _gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)targetColor.CGColor];
        _gradientLayer.locations = @[@0.2,@0.7];
        
    }
    return _gradientLayer;
}
-(DYLongPressView *)longPressView{
    if (!_longPressView) {
        _longPressView = [[DYLongPressView alloc] init];
    }
    return _longPressView;
}
-(UILongPressGestureRecognizer *)longPressGesture{
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    }
    return _longPressGesture;
}
-(CAShapeLayer *)currentPointLayer{
    if (!_currentPointLayer) {
        _currentPointLayer = [CAShapeLayer layer];
        _currentPointLayer.fillColor = HexRGBAlpha(0x4889db, 0.4).CGColor;
    }
    return _currentPointLayer;
}
@end
