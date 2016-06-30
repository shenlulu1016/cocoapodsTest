//
//  ViewController.m
//  cocoapodsTest
//
//  Created by 申露露 on 16/6/30.
//  Copyright © 2016年 申露露. All rights reserved.
//

#import "ViewController.h"
#import "iCarousel.h"


@interface ViewController ()<iCarouselDelegate, iCarouselDataSource>

@property (nonatomic, strong) iCarousel * carousel;
@property (nonatomic, assign) CGSize taskSize;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat taskWidth = [UIScreen mainScreen].bounds.size.width*5.0f/7.0f;
    self.taskSize = CGSizeMake(taskWidth, taskWidth*16.0f/9.0f);
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    self.carousel = [[iCarousel alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.carousel];
    [self.carousel setDelegate:self];
    [self.carousel setDataSource:self];
    [self.carousel setType:iCarouselTypeCustom];
    [self.carousel setBounceDistance:0.1f];
}
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return 7;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    UIView * taskView = view;
    if (!taskView) {
        taskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.taskSize.width, self.taskSize.height)];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:taskView.bounds];
        [taskView addSubview:imageView];
        [imageView setContentMode:UIViewContentModeScaleToFill];
        [imageView setBackgroundColor:[UIColor whiteColor]];
        
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"image%d",index+1]];
        [imageView setImage:image];
        
        UILabel * label = [[UILabel alloc] initWithFrame:taskView.frame];
        [label setText:[@(index) stringValue]];
        [label setFont:[UIFont systemFontOfSize:50]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [taskView addSubview:label];
        
        [taskView.layer setShadowPath:[UIBezierPath bezierPathWithRoundedRect:imageView.frame cornerRadius:5.0f].CGPath];
        [taskView.layer setShadowRadius:3.0f];
        [taskView.layer setShadowColor:[UIColor blackColor].CGColor];
        [taskView.layer setShadowOffset:CGSizeZero];
        
        CAShapeLayer * layer = [CAShapeLayer layer];
        layer.frame = imageView.bounds;
        [layer setPath:[UIBezierPath bezierPathWithRoundedRect:imageView.frame cornerRadius:5.0f].CGPath];
        [imageView.layer setMask:layer];
    }
    return taskView;
}
//卡片叠压
//计算缩放
- (CGFloat)calcScaleWithOffset:(CGFloat)offset{
    return offset * 0.04f + 1.0f;
}
//计算位移
- (CGFloat)calcTranslationWithOffset:(CGFloat)offset{
    CGFloat z = 5.0f/4.0f;
    CGFloat a = 5.0f/8.0f;
    
    //移出屏幕
    if (offset >= z/a) {
        return 2.0f;
    }
    return 1/(z-a*offset)-1/z;
}
//滑动偏移
- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{
    CGFloat scale = [self calcScaleWithOffset:offset];
    CGFloat translation = [self calcTranslationWithOffset:offset];
    return CATransform3DScale(CATransform3DTranslate(transform, translation*self.taskSize.width, 0, offset), scale, scale, 0);
    //return CATransform3DTranslate(transform, offset*self.taskSize.width, 0, 0);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
