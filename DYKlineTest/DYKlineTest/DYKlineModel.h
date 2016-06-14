//
//  DYKlineModel.h
//  DYKlineTest
//
//  Created by 黄德玉 on 16/5/31.
//  Copyright © 2016年 黄德玉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYKlineModel : NSObject
@property(nonatomic,copy) NSString * date;         
@property(nonatomic,assign) float value;            //这个可以看做是纵坐标的位置
@property(nonatomic,assign) float xValue;           //这个根据点间距算出来的横坐标的位置。
@property(nonatomic,assign) BOOL isYaxis;
@end
