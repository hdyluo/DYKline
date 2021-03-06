//
//  DYCommon.h
//  DYKlineStyle1
//
//  Created by huangdeyu on 16/6/15.
//  Copyright © 2016年 hdy. All rights reserved.
//

#ifndef DYCommon_h
#define DYCommon_h


#define JOINT_SPACE 80
#define MAX_SCALE  1.5    //60 * 1.5 = 90
#define MIN_SCALE 0.5     //30
#define KLINE_OFFSET 60     //起始点距离X轴的距离
#define SCROLLCONTENT_SIZE_EXTENT 200   //滚动结束，K线距离最右边的距离

#define TOP_MARGIN 10
#define BOTTOM_MARGIN 100


#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]
#endif /* DYCommon_h */
