//
//  AdvertisementCell.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/7.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "AdvertisementCell.h"

@interface AdvertisementCell ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *page;
@property (nonatomic, strong)NSTimer *timer;

@end

@implementation AdvertisementCell

- (void)setArray:(NSArray *)array{
    _array = array;
    
    [self.timer invalidate];
    
    self.page.currentPageIndicatorTintColor = mAppMainColor;
    self.page.pageIndicatorTintColor = [UIColor whiteColor];
    self.page.numberOfPages = array.count;
    
    self.scrollView.contentSize = CGSizeMake((array.count + 2) * mScreenWidth, 0);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentOffset = CGPointMake(mScreenWidth, 0);
    for (UIButton *btn in self.scrollView.subviews) {
        [btn removeFromSuperview];
    }
    for (int i = 0; i < array.count; i++) {
        NSLog(@"--%d---%@",i,array[i]);
//        if ([array[i] isKindOfClass:[NSDictionary class]]) {
//            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:array[i][@"content"]] forState:UIControlStateNormal];
//        }else{
//            [btn setBackgroundImage:[UIImage imageNamed: array[count]] forState:UIControlStateNormal];
//        }
        
        NSInteger count = array.count - 1;
        if (0 == i) {
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, self.height)];
            
            if ([array[i] isKindOfClass:[NSDictionary class]]) {
                [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:array[count][@"content"]] forState:UIControlStateNormal];
            }else{
                [btn setBackgroundImage:[UIImage imageNamed: array[count]] forState:UIControlStateNormal];
            }
        
            btn.tag = count + 1;
            [btn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:btn];
        }
        if (count == i) {
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((count + 2) * mScreenWidth, 0, mScreenWidth, self.height)];
            
            if ([array[i] isKindOfClass:[NSDictionary class]]) {
                [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:array[0][@"content"]] forState:UIControlStateNormal];
            }else{
                [btn setBackgroundImage:[UIImage imageNamed: array[0]] forState:UIControlStateNormal];
            }
            
            btn.tag = 1;
            [btn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:btn];
        }
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((i + 1) * mScreenWidth, 0, mScreenWidth, self.height)];
    
        if ([array[i] isKindOfClass:[NSDictionary class]]) {
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:array[i][@"content"]] forState:UIControlStateNormal];
        }else{
            [btn setBackgroundImage:[UIImage imageNamed: array[i]] forState:UIControlStateNormal];
        }
        
        btn.tag = i + 1;
        [btn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
        
    }
    if (array.count>1){
        [self addTimer];
        self.page.hidden = NO;
    }else{
        self.page.hidden = YES;
        self.scrollView.contentSize = CGSizeMake( mScreenWidth, 0);
    }
    
    
}

- (void)imageBtnClick:(UIButton *)sender{
    self.returnTapAdIndex(sender.tag - 1);
}

- (void)addTimer{
    
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(nextTimer) userInfo:nil repeats:YES];
    
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

- (void)nextTimer{
    
    NSInteger page = self.scrollView.contentOffset.x / mScreenWidth;
    page ++;
    
    [UIView animateWithDuration:1.0 animations:^{
        self.scrollView.contentOffset = CGPointMake(page * mScreenWidth, 0);
    }];
    if (page == 0 ) {
        self.scrollView.contentOffset = CGPointMake(mScreenWidth * self.array.count, 0);
    }else if (page == self.array.count + 1){
        self.scrollView.contentOffset = CGPointMake(mScreenWidth, 0);
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger page = self.scrollView.contentOffset.x/mScreenWidth;
    if (page == 0 ) {
        
        self.scrollView.contentOffset = CGPointMake(mScreenWidth * self.array.count, 0);
        
    }else if (self.array.count + 1 == page){
        
        self.scrollView.contentOffset = CGPointMake(mScreenWidth, 0);
        
    }
    
}

#pragma mark - scrollView delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger page = self.scrollView.contentOffset.x/mScreenWidth;
    
    if (page == 0) {
        self.page.currentPage = self.array.count;
    }else if (page == self.array.count + 1){
        self.page.currentPage = 0;
    }else{
        self.page.currentPage = page-1;
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}

@end
