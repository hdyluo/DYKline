//
//  DYKlineView.h
//  DYKlineStyle1
//
//  Created by huangdeyu on 16/6/15.
//  Copyright © 2016年 hdy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYKlineModel.h"

@interface DYKlineView : UIView
-(void)updatePathWithDatas:(NSArray<DYKlineModel *> *)datas offset:(CGFloat)offset maxValue:(float)maxValue minValue:(float)minValue;
@end
