//
//  BannerScrollView.m
//  BannerScrollView
//
//  Created by Leejack on 16/5/23.
//  Copyright © 2016年 jack. All rights reserved.
//

#import "BannerScrollView.h"

@interface BannerScrollView()<UIScrollViewDelegate>
{
    UIScrollView *bannerView;
    UIPageControl *pageControl;
    NSTimer *bannerTimer;

    UIImageView* leftView;
    UIImageView* centerView;
    UIImageView* rightView;

    NSArray* imageDataArray;

    //View 宽度
    CGFloat _pageWidth;

    //当前image 游标
    long _currentImage;

    //当前手指是否在屏幕上滑动
    BOOL isDragging;

    //滑动方向:向左（+), 向右(-)
    NSInteger pageOffset;

    long _imageCount;

}

@end

@implementation BannerScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    _pageWidth = frame.size.width;

    CGFloat h = frame.size.height;

    bannerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _pageWidth, h)];
    bannerView.showsHorizontalScrollIndicator = NO;
    bannerView.showsVerticalScrollIndicator = NO;
    bannerView.pagingEnabled = YES;
    bannerView.directionalLockEnabled=YES;
    bannerView.bounces = NO;
    bannerView.pagingEnabled = YES;
    bannerView.delegate = self;
    bannerView.showsHorizontalScrollIndicator = NO;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onBannerClick)];
    [bannerView addGestureRecognizer:tapGesture];
    [self addSubview:bannerView];


    pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(0, h - 20, _pageWidth, 20);
    pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    [self addSubview:pageControl];

    [self initImageView];

    return self;
}

- (UIImageView*)createImageView:(CGRect)frame
{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:frame];
    return imageView;
}

- (void)initImageView
{
    CGSize size = self.frame.size;

    leftView = [self createImageView:CGRectMake(0, 0, size.width, size.height)];
    centerView = [self createImageView:CGRectMake(_pageWidth, 0, size.width, size.height)];
    rightView = [self createImageView:CGRectMake(_pageWidth * 2, 0, size.width, size.height)];

    [bannerView addSubview:leftView];
    [bannerView addSubview:centerView];
    [bannerView addSubview:rightView];


    centerView.backgroundColor = [UIColor grayColor];
}

- (void)setImage:(NSArray *)array
{
    _currentImage = 0;
    imageDataArray = array;
    _imageCount = [imageDataArray count];

    if (_imageCount > 1) {
        bannerView.contentSize = CGSizeMake(_pageWidth * 3, 0);
        bannerView.contentOffset = CGPointMake(_pageWidth, 0);
    } else {
        bannerView.contentSize = CGSizeMake(_pageWidth, 0);
        bannerView.contentOffset = CGPointMake(0, 0);
    }

    [self addTimer];
}

- (void)onBannerClick
{
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark 拖拉图片的时候关闭计时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    isDragging = YES;
    [bannerTimer invalidate]; //停止计时器
    bannerTimer = nil;
    //NSLog(@"%s", __FUNCTION__);
}

// bannerView滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    CGFloat x = bannerView.contentOffset.x;

    if (0 == x) {

        pageOffset = -1;
        scrollView.contentOffset = CGPointMake(_pageWidth, 0);

    } else if (_pageWidth * 2 == x) {

        pageOffset = 1;
        scrollView.contentOffset = CGPointMake(_pageWidth, 0);

    } else if (_pageWidth == x) {

        [self didPageChanged:pageOffset];
        pageOffset = 0;
    }
}

#pragma mark 结束拖拉的时候开启计时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    isDragging = NO;
    //NSLog(@"%s", __FUNCTION__);
}

#pragma mark 结束拖拉,视图位置确定以后
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self addTimer];
}

#pragma mark 添加计时器
- (void)addTimer
{
    [bannerTimer invalidate]; //停止计时器
    bannerTimer = nil;
    if ([imageDataArray count] != 1) {
        bannerTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    }
}

- (void)nextImage
{
    CGFloat x = bannerView.contentOffset.x;
    x += _pageWidth;
    if (x > _pageWidth * 2) {
        x = 0.0f;
    }
    [bannerView setContentOffset:CGPointMake(x, 0) animated:YES];
    NSLog(@"%s  %@", __FUNCTION__, @(_currentImage));
}

- (void)didPageChanged:(NSInteger)offsetPage
{
    NSLog(@"----------> %@", @(pageOffset));
    if (0 == offsetPage) {
        return;
    }
    _currentImage += offsetPage;
    if (_currentImage >= _imageCount) {
        _currentImage = 0;
    }
    if (_currentImage < 0) {
        _currentImage = _imageCount - 1;
    }

    //TODO
    NSLog(@"currentPage: %@", @(_currentImage));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
