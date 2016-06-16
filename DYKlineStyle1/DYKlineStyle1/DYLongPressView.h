//
//  DYLongPressView.h
//  DYKlineStyle1
//
//  Created by huangdeyu on 16/6/16.
//  Copyright © 2016年 hdy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYKlineModel.h"
@interface DYLongPressView : UIView
-(void)loadUIWithPoint:(CGPoint) point data:(DYKlineModel *)data;
@end
