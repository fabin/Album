//
//  UIView+Indicator.h
//  DoubanAlbum
//
//  Created by Tonny on 12-12-17.
//  Copyright (c) 2012年 SlowsLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Indicator)

- (void)showIndicatorView;

- (void)showIndicatorViewAtPoint:(CGPoint)point;

- (void)showIndicatorViewWithStyle:(UIActivityIndicatorViewStyle)style;

- (void)showIndicatorViewAtPoint:(CGPoint)point indicatorStyle:(UIActivityIndicatorViewStyle)style;

- (void)hideIndicatorView;
@end
