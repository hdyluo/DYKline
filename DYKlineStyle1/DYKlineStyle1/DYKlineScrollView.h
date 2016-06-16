//
//  DYKlineScrollView.h
//  DYKlineStyle1
//
//  Created by huangdeyu on 16/6/15.
//  Copyright © 2016年 hdy. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_OPTIONS(NSInteger,DYKlineInteractiveType){
    DYKlineInteractiveZoom = 1<<0,
    DYKlineInteractiveLongPress = 1<<1,
    DYKlineInteractiveNone = 1<<2
};

@interface DYKlineScrollView : UIScrollView

-(instancetype)initWithDatas:(NSArray *)datas InteractiveType:(DYKlineInteractiveType)type;
@end
