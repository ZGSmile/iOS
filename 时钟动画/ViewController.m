//
//  ViewController.m
//  时钟动画
//
//  Created by apple on 13-12-31.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "ViewController.h"

// 记录时钟刷新帧数
static long steps;

@interface ViewController ()
{
    CADisplayLink   *_timer;
}

@end

@implementation ViewController
/*
 按照一定的时间频率，重复某一个动作，时钟
 
 1.
 [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
 
 NSTimer不能精准的确定触发的时间点，使用NSTimer只能控制不需要精确处理的操作。
 
 2. CADisplayLink就是在每次屏幕刷新时，通知系统

 CADisplayLink
 
 最大的好处就是可以精准的在每次屏幕刷新时，设置屏幕的重绘！
 
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
//    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(100, 100, 60, 60);
    [btn setTitle:@"按钮" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor orangeColor]];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:btn];
    
}
- (void)click
{
    _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTimer)];
    // 将时钟添加到主运行循环，才能够在每次屏幕刷新时工作
    [_timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}
#pragma mark 时钟触发方法
- (void)updateTimer
{
    // 间隔某一段事件去执行方法
    // 每刷新60次，当做1秒
    steps++;
    
    // 每隔0.5秒执行一次Log
    if (steps % (10) == 0) {
        NSLog(@"come here");
        [self drawSnow];
    }
}

#pragma mark 绘制雪花
- (void)drawSnow
{
    /**
     1. 下落的太快
     2. 太少 多
     3. 太大
     4. 五颜六色
     5. 下落变小
     */
    // 雪花的图像
    UIImage *image = [UIImage imageNamed:@"雪花"];
    
    // 雪花的图像视图
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CGFloat x = arc4random_uniform(320);
    CGFloat y = - imageView.bounds.size.height / 2;
    // 设置形变参数
    // 随机大小
    CGFloat size = arc4random_uniform(20) / 100.0f + 0.2;
    [imageView setTransform:CGAffineTransformScale(imageView.transform, size, size)];
    
    imageView.center = CGPointMake(x, y);
    
    [self.view addSubview:imageView];
    
    // 块动画让雪花飘落
    [UIView animateWithDuration:5.0f animations:^{
        CGFloat x = arc4random_uniform(320);
        CGFloat y = self.view.bounds.size.height + imageView.bounds.size.height / 2;
        
        imageView.center = CGPointMake(x, y);
        imageView.transform = CGAffineTransformRotate(imageView.transform, M_PI);
        imageView.alpha = 0.5f;
    } completion:^(BOOL finished) {
        // 从根视图中删除
        [imageView removeFromSuperview];
    }];
}

@end
