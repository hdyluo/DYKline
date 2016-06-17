//
//  DYKlineScrollView.m
//  DYKlineStyle1
//
//  Created by huangdeyu on 16/6/15.
//  Copyright © 2016年 hdy. All rights reserved.
//

#import "DYKlineScrollView.h"
#import "DYCommon.h"
#import "DYKlineModel.h"
#import "DYKlineView.h"
#import "DYCoordinateView.h"

@interface DYKlineScrollView()<UIScrollViewDelegate>
{
    NSArray<DYKlineModel *> * _datas;
    DYKlineInteractiveType _type;
    NSInteger   _maxValue;
    NSInteger   _minValue;
    
}
@property(nonatomic,assign) float jointSpace;   //节点之间的距离
@property(nonatomic,assign) float viewPortWidth;//视口的宽度,屏幕旋转时，执行setter函数。
@property(nonatomic,assign) float viewPortHeight;
@property(nonatomic,assign) NSRange visibleRange;//可见区域里的所有点的范围。可见范围改变，需要重新绘图。

@property(nonatomic,strong) DYKlineView * klineView;
@property(nonatomic,strong) UIView * zoomingView;
@property(nonatomic,strong) DYCoordinateView * coordinateView;

@end

@implementation DYKlineScrollView

-(instancetype)initWithDatas:(NSArray *)datas InteractiveType:(DYKlineInteractiveType)type{
    if (self = [super init]) {
        _type = type;
        [self _commonInit];
        [self _resetWithDatas:datas];
    }
    return self;
}
-(void)_commonInit{
    self.alwaysBounceHorizontal = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.bouncesZoom = NO;
    if (_type & DYKlineInteractiveZoom) {
        _jointSpace = JOINT_SPACE;
        self.maximumZoomScale = MAX_SCALE;
        self.minimumZoomScale = MIN_SCALE;
        self.delegate = self;
    }else{
        _jointSpace = JOINT_SPACE * MIN_SCALE;
    }
    self.backgroundColor = [UIColor whiteColor];//for test
    [self addSubview:self.klineView];
    [self addSubview:self.coordinateView];
    [self addSubview:self.zoomingView];//for test
}
/**
 *  初始化数据
 *
 *  @param datas 根据数据，计算数据对应的x轴坐标
 */
-(void)_resetWithDatas:(NSArray *)datas{
    _datas = datas;
    [self _caculateXpos];
}
-(void)_caculateXpos{
    [_datas enumerateObjectsUsingBlock:^(DYKlineModel * obj, NSUInteger idx, BOOL * stop) {
        obj.xValue = self.jointSpace * idx;
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.viewPortHeight = self.frame.size.height;
    self.viewPortWidth = self.frame.size.width;//执行setter函数
    self.klineView.frame = CGRectMake(self.contentOffset.x, 0, self.frame.size.width, self.frame.size.height);
    self.coordinateView.frame = self.klineView.frame;
    [self _caculateCurrentPoints];
}
/**
 *  计算当前显示点的范围。
 */
-(void)_caculateCurrentPoints{
    NSInteger beginIdx =  self.contentOffset.x / self.jointSpace - 1;
    NSInteger length = self.viewPortWidth / self.jointSpace + 3;
    if (self.contentOffset.x < 0 || beginIdx < 0) {
        beginIdx = 0;
    }
    if (length + beginIdx > _datas.count) {
        length = _datas.count - beginIdx;
    }
    self.visibleRange = NSMakeRange(beginIdx, length);//可见范围改变后需要重新画图。
}
#pragma mark - delegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.zoomingView;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view{
}
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    self.contentSize = CGSizeMake(self.contentSize.width,0);
    CGFloat tempCurrentSpace = JOINT_SPACE * scrollView.zoomScale;//新的间距。
    self.contentOffset = CGPointMake(self.contentOffset.x, 0);
    if (self.contentOffset.x < 0) {
        self.contentOffset = CGPointMake(0,0);
    }
    self.jointSpace = tempCurrentSpace;//获取最新的间距,执行setter函数
    
}
#pragma mark - 第一次初始化宽高或屏幕旋转
-(void)_viewPortDidChanged{
    CGFloat tempContentWidth = self.jointSpace * (_datas.count - 1);
    if (tempContentWidth > self.viewPortWidth) {
         tempContentWidth += SCROLLCONTENT_SIZE_EXTENT;
    }
    self.contentSize = CGSizeMake(tempContentWidth, self.viewPortHeight);//需要重新计算contentSize
    self.zoomingView.frame = CGRectMake(0, 0, self.contentSize.width, self.frame.size.height);//重新计算需要放大缩小的视图的宽高。
    self.klineView.frame = CGRectMake(self.contentOffset.x, 0, self.frame.size.width, self.frame.size.height);
    
    //再次更新可见范围内的数据,如果数据较少时，屏幕旋转，K线会出问题,因为我们不需要屏幕旋转，所以可以把它注释掉
    //NSArray<DYKlineModel *> * array = [_datas subarrayWithRange:self.visibleRange];
    //[self.klineView updatePathWithDatas:array offset:self.contentOffset.x maxValue:_maxValue minValue:_minValue];
}
#pragma mark - 计算可见范围内的最大值，最小值
-(void)caculateRange{
    NSArray<DYKlineModel *> * array = [_datas subarrayWithRange:self.visibleRange];
    _maxValue = 0;
    _minValue = 0;
   [array enumerateObjectsUsingBlock:^(DYKlineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       if (idx == 0) {
           _maxValue = obj.value;
           _minValue = obj.value;
       }else{
           if (_maxValue < obj.value) {
               _maxValue = obj.value;
           }
           if (_minValue > obj.value) {
               _minValue = obj.value;
           }
       }
   }];
    _maxValue += 1000 - _maxValue % 1000;
    _minValue -= _minValue % 1000;
    //计算完成后更新坐标值
    [self.coordinateView drawWithMax:_maxValue min:_minValue];
}
#pragma mark - setter
-(void)setViewPortWidth:(float)viewPortWidth{
    if (_viewPortWidth != viewPortWidth) {
        _viewPortWidth = viewPortWidth;
        [self _viewPortDidChanged];
    }
}
-(void)setJointSpace:(float)jointSpace{
    _jointSpace = jointSpace;
    [self _caculateXpos];//计算所有数据对应的坐标
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
-(void)setVisibleRange:(NSRange)visibleRange{
    if (_visibleRange.length == visibleRange.length && _visibleRange.location == visibleRange.location && !self.isZooming) { //缩放的时候，不能更新偏移量，否则缩放会抖动的厉害
        [self.klineView updateTranslationWithOffset:self.contentOffset.x];
        return;
    }
    _visibleRange = visibleRange;
    [self caculateRange];
    NSArray<DYKlineModel *> * array = [_datas subarrayWithRange:self.visibleRange];
    [self.klineView updatePathWithDatas:array offset:self.contentOffset.x maxValue:_maxValue minValue:_minValue];
}

#pragma mark - 初始化

-(DYKlineView *)klineView{
    if (!_klineView) {
        _klineView = [[DYKlineView alloc] init];
        _klineView.backgroundColor = [UIColor whiteColor];
    }
    return _klineView;
}
-(UIView *)zoomingView{
    if(!_zoomingView){
        _zoomingView = [[UIView alloc] init];
        _zoomingView.backgroundColor = [UIColor clearColor];
        _zoomingView.userInteractionEnabled = NO;
    }
    return _zoomingView;
}
-(DYCoordinateView *)coordinateView{
    if (!_coordinateView) {
        _coordinateView = [[DYCoordinateView alloc] init];
    }
    return _coordinateView;
}
@end
