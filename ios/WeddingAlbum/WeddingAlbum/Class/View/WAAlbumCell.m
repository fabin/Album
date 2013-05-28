//
//  WAAlbumCell.m
//  WeddingAlbum
//
//  Created by Tonny on 5/28/13.
//  Copyright (c) 2013 SlowsLab. All rights reserved.
//

#import "WAAlbumCell.h"
#import "UIImageView+AFNetworking.h"

@implementation WAAlbumCell

+ (NSUInteger)countForOneRowWithOritation:(UIInterfaceOrientation)oritation{
    if (is_iPhone) {
        return (oritation == UIInterfaceOrientationLandscapeRight?3:2);
    }else{
        return (oritation == UIInterfaceOrientationLandscapeRight?5:4);
    }
}

- (id)initWithOritation:(UIInterfaceOrientation)oritation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 175)];
        view.backgroundColor = RGBCOLOR(250, 250, 250);
        
        NSUInteger count = [WAAlbumCell countForOneRowWithOritation:oritation];
        
        CGFloat w = [UIApplication sharedApplication].keyWindow.frame.size.width;
        CGFloat h = [UIApplication sharedApplication].keyWindow.frame.size.height;
        
        CGFloat s = (oritation == UIInterfaceOrientationLandscapeRight?MAX(w, h):MIN(w, h));
        CGFloat width = (s-(count-1)*10.0)/count;
        
        _imgViews = [NSMutableArray arrayWithCapacity:count];
        for (int i=0; i<count; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10+(width+10)*i, 10, width, 165)];
            imgView.tag = 0;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.clipsToBounds = YES;
            [view addSubview:imgView];
            
            [_imgViews addObject:imgView];
        }
        
        [self.contentView addSubview:view];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setData:(NSArray *)arr{
    [_imgViews enumerateObjectsUsingBlock:^(UIImageView *imgView, NSUInteger idx, BOOL *stop) {
        if (idx < arr.count) {
            NSDictionary *dic = arr[idx];
            NSString *url0 = dic[@"url"];
            [imgView setImageWithURL:[NSURL URLWithString:url0]];
        }else{
            imgView.hidden = YES;
        }
    }];
}

@end
