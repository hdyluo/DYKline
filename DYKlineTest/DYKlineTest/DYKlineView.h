//
//  DYKlineView.h
//  DYKlineTest
//
//  Created by 黄德玉 on 16/5/30.
//  Copyright © 2016年 黄德玉. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DYKlineModel;
@interface DYKlineView : UIView
-(void)addLinesWithDatas:(NSArray<DYKlineModel *> * ) datas minValue:(CGFloat )minValue maxValue:(CGFloat)maxValue offset:(CGFloat)offset  withSpace:(CGFloat)space;

-(void)layerMoveWithOffset:(CGFloat)offset;
@end
