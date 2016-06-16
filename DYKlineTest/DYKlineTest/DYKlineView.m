//
//  DYKlineView.m
//  DYKlineTest
//
//  Created by 黄德玉 on 16/5/30.
//  Copyright © 2016年 黄德玉. All rights reserved.
//

#import "DYKlineView.h"
#import "DYKlineModel.h"
#import "DYKlineCommon.h"
#import "DYLongPressView.h"


@interface DYKlineView()
{
    NSArray<DYKlineModel *> * _currentDatas ;
}
@property(nonatomic,strong)CAShapeLayer * sharpLayer;               //这是那根线
@property(nonatomic,strong)CAGradientLayer * gradientLayer;         //这是线包含的渐变
@property(nonatomic,strong)NSMutableArray<CAShapeLayer *> * pointLayers;   //这是要画的每个点
@property(nonatomic,strong)UIBezierPath * bezierPath;
@property(nonatomic,assign) CGFloat currentOffset;      //每次复位时的偏移量
@property(nonatomic,assign) CGFloat lastestOffset;      //没有更新数据的时候，滑动时，实时的偏移量。
@property(nonatomic,strong) NSMutableArray<NSNumber *>* allyValues;     //这是所有计算出来的Y轴的点
@property(nonatomic,assign)NSInteger currentIndex;               //长按手势时，对应的当前点的索引
@property(nonatomic,strong)NSMutableArray<UILabel *> * labels;      //要显示的横坐标的点
@property(nonatomic,strong)UILongPressGestureRecognizer * longPressGesture;
@property(nonatomic,strong)DYLongPressView * longPressView;
@end
@implementation DYKlineView

-(instancetype)init{
    if (self = [super init]) {
        [self.layer addSublayer:self.gradientLayer];
    //    [self.layer addSublayer:self.sharpLayer];
        [self addGestureRecognizer:self.longPressGesture];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.longPressView.frame = self.bounds;
}
-(void)reset{
    [self.bezierPath removeAllPoints];
    [self.labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.pointLayers enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    self.labels = [NSMutableArray array];
    self.pointLayers = [NSMutableArray array];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.sharpLayer.transform = CATransform3DIdentity;
    [CATransaction commit];
}

/**
 *  根据当前给定的数据
 *
 *  @param datas    当前可见数据
 *  @param minValue 坐标最小值
 *  @param maxValue 坐标最大值
 */
-(void)addLinesWithDatas:(NSArray<DYKlineModel *> * ) datas minValue:(CGFloat )minValue maxValue:(CGFloat)maxValue offset:(CGFloat)offset withSpace:(CGFloat)space{
    _currentDatas = datas;
    self.currentOffset = offset;
    self.lastestOffset = offset;
    self.allyValues = [NSMutableArray array];
    [self reset];
    __block CGFloat lastX = 0;
    __block CGFloat lastY = 0;
    [datas enumerateObjectsUsingBlock:^(DYKlineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat yValue = (maxValue - obj.value) / (maxValue - minValue) * (self.frame.size.height - (TOP_MARGIN + BOTTOM_MARGIN)) + TOP_MARGIN;//映射到指定范围内。
        [self.allyValues addObject:@(yValue)];
        if (idx == 0) {
            CGPoint startPoint = CGPointMake(-space * 2, self.frame.size.height + 1);
            [self.bezierPath moveToPoint:startPoint];
            CGFloat dis = obj.xValue - offset + space * 2;
            CGPoint firstPoint = CGPointMake(obj.xValue - offset, yValue);
            CGPoint cp1 = CGPointMake(-space * 2 + dis * CURVE_PERCENT, self.frame.size.height + 1);
            CGPoint cp2 = CGPointMake(obj.xValue-offset - dis * CURVE_PERCENT, yValue);
            [self.bezierPath addCurveToPoint:firstPoint controlPoint1:cp1 controlPoint2:cp2];
            [self addCircleWithPoint:firstPoint];
            
        }else{
            CGFloat distance = obj.xValue - offset - lastX;
            CGPoint cp1 = CGPointMake(lastX + distance * CURVE_PERCENT, lastY);
            CGPoint cp2 = CGPointMake(obj.xValue - offset - distance * CURVE_PERCENT, yValue);
            CGPoint curPnt = CGPointMake(obj.xValue - offset, yValue);
            [self.bezierPath addCurveToPoint:curPnt controlPoint1:cp1 controlPoint2:cp2];
            [self addLabels:obj centerPoint:curPnt];
            [self addCircleWithPoint:curPnt];
        }
        if (idx == datas.count -1) {
            CGPoint lastPoint = CGPointMake(self.frame.size.width + space * 2, yValue);
            [self.bezierPath addLineToPoint:lastPoint];
            CGPoint endPoint = CGPointMake(self.frame.size.width + space * 2, self.frame.size.height+1);
            [self.bezierPath addLineToPoint:endPoint];
            [self.bezierPath closePath];
        }
        lastX = obj.xValue - offset;
        lastY = yValue;
     }];
    self.sharpLayer.path = self.bezierPath.CGPath;
    self.gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.gradientLayer.mask = self.sharpLayer;
}
/**
 *  为每个点添加圆
 *
 *  @param point 当前点的位置
 */
-(void)addCircleWithPoint:(CGPoint) point{
    CAShapeLayer * layer = [CAShapeLayer layer];
    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x - POINT_RADIUS , point.y - POINT_RADIUS , POINT_RADIUS * 2, POINT_RADIUS * 2)];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:layer];
    [self.pointLayers addObject:layer];
}
/**
 *  添加横坐标
 *
 *  @param model 当前数据
 *  @param point 当前数据对应的位置
 */
-(void)addLabels:(DYKlineModel *)model centerPoint:(CGPoint)point{
    if (model.isYaxis) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        label.text = model.date;
        label.textColor =[UIColor whiteColor];
        label.center = CGPointMake(point.x, self.frame.size.height - 20);
        label.textAlignment = NSTextAlignmentCenter;
        [label setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:label];
        [self.labels addObject:label];
    }
}

/**
 *  如果移动的时候所有的可见点没有发生改变，则不需要重新绘制path，只需要设置layer的偏移量就可以。
 *
 *  @param offset 当前scrollView的偏移量
 */
-(void)layerMoveWithOffset:(CGFloat)offset{
    self.lastestOffset = offset;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.sharpLayer.transform = CATransform3DMakeTranslation(self.currentOffset - offset, 0, 0);
    [self.pointLayers enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.transform = CATransform3DMakeTranslation(self.currentOffset - offset, 0, 0);
    }];
    [CATransaction commit];
    
    [self.labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.transform = CGAffineTransformMakeTranslation(self.currentOffset - offset, 0);
    }];
}

-(CGPoint)caculateNearestPoint:(CGPoint)point{
   __block CGPoint toPoint = point;
    [_currentDatas enumerateObjectsUsingBlock:^(DYKlineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat tp = obj.xValue - self.lastestOffset;
        if (idx < _currentDatas.count - 1) {
            CGFloat t1 = _currentDatas[idx + 1].xValue - self.lastestOffset;
            if (point.x - tp > 0 && t1 - point.x > 0) {
                if (point.x - tp < t1 - point.x) {
                    toPoint.x = tp;
                    toPoint.y = [self.allyValues[idx] floatValue];
                    self.currentIndex = idx;
                }else{
                    toPoint.x = t1;
                    toPoint.y = [self.allyValues[idx + 1] floatValue];
                    self.currentIndex = idx + 1;
                }
                *stop = YES;
            }
        }else{
            toPoint.x = tp;
            toPoint.y = [self.allyValues[idx] floatValue];
            self.currentIndex = idx;
        }
    }];
    return toPoint;
}
#pragma mark - 手势
-(void)longPressAction:(UILongPressGestureRecognizer *)gesture{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self addSubview:self.longPressView];
            CGPoint currentPoint = [gesture locationInView:self];
            currentPoint = [self caculateNearestPoint:currentPoint];
            [self.longPressView reloadUIWithPoint:currentPoint andValue:_currentDatas[self.currentIndex].value];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint currentPoint = [gesture locationInView:self];
            currentPoint = [self caculateNearestPoint:currentPoint];
            [self.longPressView reloadUIWithPoint:currentPoint andValue:_currentDatas[self.currentIndex].value];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
            [self.longPressView removeFromSuperview];
            break;
        default:
            break;
    }
}
#pragma mark - 初始化
-(CAShapeLayer *)sharpLayer{
    if (!_sharpLayer) {
        _sharpLayer = [CAShapeLayer layer];
        _sharpLayer.strokeColor = [UIColor whiteColor].CGColor;
        _sharpLayer.fillColor = [UIColor clearColor].CGColor;
        _sharpLayer.lineWidth = 1.0;
    }
    return _sharpLayer;
}
-(UIBezierPath *)bezierPath{
    if (!_bezierPath) {
        _bezierPath = [UIBezierPath bezierPath];
    }
    return _bezierPath;
}
-(CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.startPoint = CGPointMake(0.5, 1);
        _gradientLayer.endPoint = CGPointMake(0.5, 0);
        _gradientLayer.colors = @[(__bridge id)[UIColor whiteColor].CGColor, (__bridge id)[UIColor orangeColor].CGColor];
        _gradientLayer.locations = @[@0.0,@1.0];
        
    }
    return _gradientLayer;
}
-(UILongPressGestureRecognizer *)longPressGesture{
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    }
    return _longPressGesture;
}
-(DYLongPressView *)longPressView{
    if (!_longPressView) {
        _longPressView = [[DYLongPressView alloc] init];
        _longPressView.userInteractionEnabled = NO;
    }
    return _longPressView;
}
@end
