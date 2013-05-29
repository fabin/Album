//
//  UIViewController+ResultTips.m
//  WeddingAlbum
//
//  Created by Tonny on 13-3-8.
//  Copyright (c) 2013年 SlowsLab. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIViewController+ResultTips.h"
#import "UIView+Addition.h"

@implementation UIViewController (ResultTips)

- (void)showSuccessTips1:(NSString *)text{
    [self showTipsWithImage1:[UIImage imageNamed:@"tip_yes.png"] text:text hidden:YES];
}

- (void)showFailTips1:(NSString *)text{
    [self showTipsWithImage1:[UIImage imageNamed:@"tip_sorry.png"] text:text hidden:YES];
}

- (void)showFailTips1:(NSString *)text hidden:(BOOL)hidden{
    [self showTipsWithImage1:[UIImage imageNamed:@"tip_sorry.png"] text:text hidden:hidden];
}

- (void)showTipsWithImage1:(UIImage *)image text:(NSString *)text hidden:(BOOL)hidden {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *view = [window subviewWithTag:12321];
    if (view) return;
    
    UIFont *font = [UIFont boldSystemFontOfSize:16];
    CGFloat height = [text sizeWithFont:font
                     constrainedToSize:CGSizeMake(115, MAXFLOAT)].height;
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 115+50, height+20)];
    view.layer.cornerRadius = 3;
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    view.tag = 12321;
    CGPoint center = self.view.center;
    center.y = center.y-(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)?100:50);
    view.center = center;
    view.alpha = 0;
    
    UIImageView *logView = [[UIImageView alloc] initWithImage:image];
    logView.center = CGPointMake(21, view.height*0.5);
    [view addSubview:logView];
    
    UILabel *textLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 115, height)];
    textLbl.numberOfLines = 0;
    textLbl.textAlignment = NSTextAlignmentLeft;
    textLbl.backgroundColor = [UIColor clearColor];
    textLbl.text = text;
    textLbl.textColor = [UIColor whiteColor];
    textLbl.font = font;
    [view addSubview:textLbl];
    
    [window addSubview:view];
    
    CATransform3D transform0 = CATransform3DMakeScale(0.001, 0.001, 1.0);
	view.layer.transform = transform0;
	CATransform3D transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
    
    view.layer.opacity = 0.0;
    [UIView animateWithDuration:.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         view.layer.transform = transform;
                         view.layer.opacity = 1;
                     } completion:^(BOOL finished) {
                         if (hidden) {
                             [UIView animateWithDuration:0.3
                                                   delay:1.9
                                                 options:UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  view.layer.transform = transform0;
                                                  view.layer.opacity = 0;
                                              } completion:^(BOOL finished) {
                                                  [view removeFromSuperview];
                                              }];
                         }
                     }];
}

@end
