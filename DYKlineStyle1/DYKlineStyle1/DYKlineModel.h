//
//  DYKlineModel.h
//  DYKlineStyle1
//
//  Created by huangdeyu on 16/6/15.
//  Copyright © 2016年 hdy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYKlineModel : NSObject

@property(nonatomic,copy) NSString * date;
@property(nonatomic,assign) float value;
@property(nonatomic,assign)float xValue;    //这个是根据点间距计算出来的X轴的位置。
@end
