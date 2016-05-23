//
//  ViewController.m
//  BannerScrollView
//
//  Created by Leejack on 16/5/23.
//  Copyright © 2016年 jack. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    BannerScrollView* _bannerView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    CGSize size = self.view.frame.size;

    _bannerView = [[BannerScrollView alloc] initWithFrame:CGRectMake(0, 100, size.width, 150)];
    _bannerView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_bannerView];

    NSArray* array = @[@"http://g.hiphotos.baidu.com/zhidao/pic/item/8326cffc1e178a823f2331f0f703738da977e847.jpg", @"http://imgsrc.baidu.com/forum/pic/item/d833c895d143ad4bf8e5b06c82025aafa50f0656.jpg", @"http://h.hiphotos.baidu.com/zhidao/pic/item/f703738da97739123c6dc373fe198618367ae25d.jpg"];
    [_bannerView setImage:array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
