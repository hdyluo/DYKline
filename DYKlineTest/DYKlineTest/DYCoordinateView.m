//
//  DYCoordinateView.m
//  DYKlineTest
//
//  Created by 黄德玉 on 16/5/30.
//  Copyright © 2016年 黄德玉. All rights reserved.
//

#import "DYCoordinateView.h"
#import "DYKlineCommon.h"
#import "DYHorizontalLine.h"
#import <Masonry.h>
@interface DYCoordinateView()
@property(nonatomic,strong) NSMutableArray<DYHorizontalLine *> * lines;
@end

@implementation DYCoordinateView
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.lines = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            [self addLines];
        }
    }
    return self;
}
-(void)loadDataWithMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue{
    [self.lines[0] loadText:[NSString stringWithFormat:@"%d",(int)maxValue]];
    [self.lines[1] loadText:[NSString stringWithFormat:@"%d",(int)((maxValue + minValue) * 0.5)]];
    [self.lines[2] loadText:[NSString stringWithFormat:@"%d",(int)(minValue)]];
}

-(void)addLines{
    DYHorizontalLine * line = [[DYHorizontalLine alloc] init];
    [self addSubview:line];
    [self.lines addObject:line];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.lines[0].frame = CGRectMake(0, TOP_MARGIN - 15, self.frame.size.width, 30);
    self.lines[1].frame = CGRectMake(0, TOP_MARGIN - 15 + (self.frame.size.height - BOTTOM_MARGIN - TOP_MARGIN) * 0.5, self.frame.size.width, 30);
    self.lines[2].frame = CGRectMake(0, self.frame.size.height - BOTTOM_MARGIN - 15, self.frame.size.width, 30);
}
@end
