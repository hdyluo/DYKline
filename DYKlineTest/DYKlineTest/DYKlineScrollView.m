//
//  DYKlineScrollView.m
//  DYKlineTest
//
//  Created by 黄德玉 on 16/5/30.
//  Copyright © 2016年 黄德玉. All rights reserved.
//

#import "DYKlineScrollView.h"
#import "DYKlineView.h"
#import "DYCoordinateView.h"
#import "DYLongPressView.h"
#import "DYKlineModel.h"

#import "DYKlineCommon.h"
typedef NS_OPTIONS(NSInteger,DYKlineType){
    DYKlineTypeKline = 1<<0,
    DYKlineTypeCoordinate = 1<<1,
};


@interface DYKlineScrollView()<UIScrollViewDelegate>
{
    NSArray<DYKlineModel *> * _datas;
  //  CGFloat  _space;
}
@property(nonatomic ,strong)DYKlineView * klineView;
@property(nonatomic,strong)DYCoordinateView * coordinateView;

@property(nonatomic,assign) CGFloat viewPortWitdh;  //当前视口的宽
@property(nonatomic,assign) CGFloat viewPortHeight; //当前视口的高度
@property(nonatomic,assign) DYKlineType contentType;

@property(nonatomic,assign) NSRange visiblePointRange;      //当前显示的点的范围
@property(nonatomic,strong) NSMutableArray<DYKlineModel *> * currentVisibleDatas;//当前可见数据。
@property(nonatomic,assign) CGFloat minValue;                   //Y轴最小值
@property(nonatomic,assign) CGFloat maxValue;                   //y轴最大值

@property(nonatomic,strong) UIView * zoomingView;               //透明的View用于响应缩放手势的
@property(nonatomic,assign) CGFloat space;                      //间距
@end

@implementation DYKlineScrollView

-(instancetype)initWithDatas:(NSArray *)datas{
    if (self = [super init]) {
        self.alwaysBounceHorizontal = YES;
        self.showsVerticalScrollIndicator = NO;
      //  self.showsHorizontalScrollIndicator = NO;  如果设置这两个属性的话屏幕旋转的时候，不会触发 layoutSubViews，蛋疼
        self.delegate = self;
        self.maximumZoomScale = 1.0;
        self.minimumZoomScale = 0.5;
        self.bouncesZoom = NO;
        self.backgroundColor = [UIColor whiteColor];
        _datas = datas;
        _space = DEFAULT_SPACE;
        [self caculteDatasXPos];//根据当前数据间距，计算所有数据的横坐标
        self.contentType = DYKlineTypeKline | DYKlineTypeCoordinate;
        [self setup];
    }
    return self;
}
-(void)setup{
    if (self.contentType & DYKlineTypeKline) {
        [self addSubview:self.klineView];
    }
    if (self.contentType & DYKlineTypeCoordinate) {
         [self addSubview:self.coordinateView];
    }
    [self addSubview:self.zoomingView];//这个用于手势的视图可以不用添加到scrollView中~~，邪门吧~
}
-(void)reset{
    if (self.contentType & DYKlineTypeKline) {
        [self.klineView removeFromSuperview];
    }
    if (self.contentType & DYKlineTypeCoordinate) {
        [self.coordinateView removeFromSuperview];
    }
 }
/**
 *  根据间距计算当前数据的X轴的坐标位置
 */
-(void)caculteDatasXPos{
    [_datas enumerateObjectsUsingBlock:^(DYKlineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.xValue = _space * idx;
    }];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.viewPortHeight = self.frame.size.height;
    self.viewPortWitdh = self.frame.size.width;//会执行setter函数，第一次获得宽高，和屏幕旋转会执行其他操作
    if (self.contentType & DYKlineTypeKline) {
        self.klineView.frame = CGRectMake(self.contentOffset.x, 0, self.viewPortWitdh, self.viewPortHeight);
    }
    if (self.contentType & DYKlineTypeCoordinate) {
        self.coordinateView.frame = CGRectMake(self.contentOffset.x, 0, self.viewPortWitdh, self.viewPortHeight);
    }
    [self caculateDisplayPoints];//计算当前可见的点
}
/**
 *  计算当前contentOffset下显示的所有的点
 */
-(void)caculateDisplayPoints{
    NSInteger beginIdx =  self.contentOffset.x / _space;
    NSInteger length = self.viewPortWitdh / _space + 3;
    if (self.contentOffset.x < 0) {
        //需要处理当前偏移量小于0的情况
        beginIdx = 0;
    }
    if (length + beginIdx > _datas.count) {
        //需要处理当前偏移量大于最大偏移量的情况。
        length = _datas.count - beginIdx;
    }
    self.currentVisibleDatas  = [[_datas subarrayWithRange:NSMakeRange(beginIdx, length)] mutableCopy];
    self.visiblePointRange = NSMakeRange(beginIdx, length);//会执行setter函数
}

/**
 *  计算y轴的最大和最小值。8 */
-(void)caculateRange{
    self.maxValue = 0;
    self.minValue = 0;
    [self.currentVisibleDatas enumerateObjectsUsingBlock:^(DYKlineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            self.maxValue = obj.value;
            self.minValue = obj.value;
        }
        if (obj.value >= self.maxValue) {
            self.maxValue = obj.value;
        }else if (obj.value <= self.minValue) {
            self.minValue = obj.value;
        }
    }];
    [self.coordinateView loadDataWithMinValue:self.minValue maxValue:self.maxValue];
}

/**
 *  第一次进入页面，或者屏幕旋转后，需要重新计算contentSize
 */
-(void)viewPortDidChanged{
    CGFloat tempContentWidth = _space * (_datas.count - 1);
    if (tempContentWidth < self.viewPortWitdh) {
        tempContentWidth = self.viewPortWitdh;
    }
    self.contentSize = CGSizeMake(tempContentWidth, self.viewPortHeight);
    self.zoomingView.frame = CGRectMake(0, 0, self.contentSize.width, self.frame.size.height);
}

/**
 *  每次可见点发生改变都会调用这个函数。
 */
-(void)updateUI{
    if (self.currentVisibleDatas.count > 0) {
            [self.klineView addLinesWithDatas:self.currentVisibleDatas minValue:self.minValue maxValue:self.maxValue offset:self.contentOffset.x withSpace:_space];
    }
}

#pragma mark - delegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.zoomingView;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view{
    NSLog(@"开始整的时候的偏移量是%f",self.contentOffset.x);
}
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    self.contentSize = CGSizeMake(self.contentSize.width, self.viewPortHeight);
    CGFloat tempCurrentSpace = self.contentSize.width / (_datas.count - 1);//新的间距。
    self.space = tempCurrentSpace;//获取最新的间距,执行setter函数
    
}
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    NSLog(@"结束的时候偏移量是%f",self.contentOffset.x);
}
/**
 *  根据当前缩放比例，计算当前偏移量,当前锁定的点距离X轴的距离，当前点的Index, index * space - X = offset
 */
-(void)caculateOffset{
    
}


#pragma mark - setter
-(void)setViewPortWitdh:(CGFloat)viewPortWitdh{
    if (_viewPortWitdh != viewPortWitdh) {
        _viewPortWitdh = viewPortWitdh;
        [self viewPortDidChanged];
    }
}
-(void)setViewPortHeight:(CGFloat)viewPortHeight{
    if (_viewPortHeight != viewPortHeight) {
        _viewPortHeight = viewPortHeight;
        [self viewPortDidChanged];
    }
}
-(void)setVisiblePointRange:(NSRange)visiblePointRange{
    if (_visiblePointRange.location == visiblePointRange.location && _visiblePointRange.length == visiblePointRange.length) {
        //如果数据范围没有改变 需要更新位置
        [self.klineView layerMoveWithOffset:self.contentOffset.x];
        return;
    }
    _visiblePointRange = visiblePointRange;
    [self caculateRange];
    [self updateUI];    //如果数据范围被改变，需要更新线的路径
}
/**
 *  缩放手势进行时，需要动态改变空间大小
 *
 *  @param space 间距
 */
-(void)setSpace:(CGFloat)space{
    _space = space;
    [self caculteDatasXPos];  //重新计算所有数据的X轴坐标
    [self setNeedsLayout];     //重新再刷一次UI
}
#pragma mark - 初始化
-(DYKlineView *)klineView{
    if (!_klineView) {
        _klineView = [[DYKlineView alloc] init];
        _klineView.backgroundColor = [UIColor blackColor];
    }
    return _klineView;
}
-(DYCoordinateView *)coordinateView{
    if (!_coordinateView) {
        _coordinateView = [[DYCoordinateView alloc] init];
        _coordinateView.userInteractionEnabled = NO;
    }
    return _coordinateView;
}
-(UIView *)zoomingView{
    if(!_zoomingView){
        _zoomingView = [[UIView alloc] init];
        _zoomingView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    }
    return _zoomingView;
}
@end
