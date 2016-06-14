//
//  ViewController.m
//  DYKlineTest
//
//  Created by 黄德玉 on 16/5/30.
//  Copyright © 2016年 黄德玉. All rights reserved.
//

#import "ViewController.h"
#import "DYKlineScrollView.h"
#import <Masonry.h>
#import "DYKlineModel.h"

@interface ViewController ()
@property(nonatomic,strong) DYKlineScrollView * klineScrollView;
@property(nonatomic,strong) NSArray<DYKlineModel *> * models;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.models = [[self generateRandomData] mutableCopy];
    [self.view addSubview:self.klineScrollView];
    [self layout];
}

-(void)layout{
    __weak typeof(self) weakSelf = self;
    [self.klineScrollView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
}

#pragma mark - 初始化

-(DYKlineScrollView *)klineScrollView{
    if (!_klineScrollView) {
        _klineScrollView = [[DYKlineScrollView alloc] initWithDatas:self.models];
    }
    return _klineScrollView;
}


-(NSArray *)generateRandomData{
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0; i < 100; i++) {
        DYKlineModel * tempModel = [[DYKlineModel alloc] init];
        tempModel.date = [NSString stringWithFormat:@"DAY%d",i];
        if (i%3 == 0) {
            tempModel.isYaxis = YES;
        }else{
            tempModel.isYaxis = NO;
        }
        tempModel.value = arc4random() % 300 + 10;
        [array addObject:tempModel];
    }
    return array;
}

@end
