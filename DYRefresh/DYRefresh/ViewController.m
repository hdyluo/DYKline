//
//  ViewController.m
//  DYRefresh
//
//  Created by huangdeyu on 16/6/20.
//  Copyright © 2016年 hdy. All rights reserved.
//

#import "ViewController.h"
#import "DYRefreshHeader.h"

@interface ViewController ()
@property(nonatomic,strong)UIScrollView * scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.scrollView.dy_refreshHeaderView beginRefresh];
}
#pragma mark - 初始化
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        DYBaseRefreshHeader *header = [[DYBaseRefreshHeader alloc] init];
        _scrollView.dy_refreshHeaderView = header;
        header.backgroundColor = [UIColor whiteColor];
        _scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 100);
        _scrollView.backgroundColor = [UIColor orangeColor];
        _scrollView.contentSize = CGSizeMake(0, self.view.frame.size.height-100);
    }
    return _scrollView;
}

@end
