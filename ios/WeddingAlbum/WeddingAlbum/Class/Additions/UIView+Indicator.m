//
//  UIView+Indicator.m
//  DoubanAlbum
//
//  Created by Tonny on 12-12-17.
//  Copyright (c) 2012年 SlowsLab. All rights reserved.
//

#import "UIView+Indicator.h"
#import "UIView+Addition.h"

typedef enum {
    kTagIndicatorView = 1988,
}kUIViewIndicatorTags;

@implementation UIView (Indicator)

- (void)showIndicatorView{
    [self showIndicatorViewAtPoint:CGPointMake((self.width-20)/2, (self.height-20)/2)];
}

- (void)showIndicatorViewAtPoint:(CGPoint)point{
    UIActivityIndicatorViewStyle style = UIActivityIndicatorViewStyleGray;
    [self showIndicatorViewAtPoint:point indicatorStyle:style];
}

- (void)showIndicatorViewWithStyle:(UIActivityIndicatorViewStyle)style{
    [self showIndicatorViewAtPoint:CGPointMake((self.width-20)/2, (self.height-20)/2) indicatorStyle:style];
}

- (void)showIndicatorViewAtPoint:(CGPoint)point indicatorStyle:(UIActivityIndicatorViewStyle)style{
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self subviewWithTag:kTagIndicatorView];
    
    if (!indicator) {
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
        indicator.frame = CGRectMake(point.x, point.y, 20, 20);
        indicator.tag = kTagIndicatorView;
        indicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:indicator];
        [indicator startAnimating];
    }
    
    [indicator startAnimating];
}

- (void)hideIndicatorView{
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self subviewWithTag:kTagIndicatorView];
    
    if(indicator){
        if ([indicator isMemberOfClass:[UIActivityIndicatorView class]]) {
            [indicator stopAnimating];
            [indicator removeFromSuperview]; indicator = nil;
            return;
        }
        
        NSAssert([indicator isMemberOfClass:[UIActivityIndicatorView class]], @"indicator view错误,重复tag");
    }
}


@end
