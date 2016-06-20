//
//  ViewController.m
//  DYKlineStyle1
//
//  Created by huangdeyu on 16/6/15.
//  Copyright © 2016年 hdy. All rights reserved.
//

#import "ViewController.h"
#import "DYKlineScrollView.h"
#import <Masonry.h>
#import "DYKlineModel.h"

@interface ViewController ()
@property(nonatomic,strong)DYKlineScrollView * klineScrollView;
@property(nonatomic,strong)NSArray<DYKlineModel *> * models;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.models = [[self generateRandomData] mutableCopy];
    self.klineScrollView  = [[DYKlineScrollView alloc] initWithDatas:self.models InteractiveType:DYKlineInteractiveNone | DYKlineInteractiveZoom];
    [self.view addSubview:self.klineScrollView];
    [self layout];
}
-(void)layout{
    [self.klineScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(NSArray *)generateRandomData{
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0; i < 70; i++) {
        DYKlineModel * tempModel = [[DYKlineModel alloc] init];
        tempModel.date = [NSString stringWithFormat:@"2016-%d-%d",i,i];
        tempModel.value = arc4random() % 5000 + 2000;
        [array addObject:tempModel];
    }
    return array;
}
@end
