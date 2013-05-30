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
        return (oritation == UIInterfaceOrientationLandscapeRight?4:3);//5:4);
    }
}

- (id)initWithController:(UIViewController *)vc reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        UIInterfaceOrientation oritation = vc.interfaceOrientation;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGSize size = vc.view.frame.size;//[UIApplication sharedApplication].keyWindow.frame.size;
        CGFloat w = size.width;
        CGFloat h = size.height;
        
        NSUInteger count = [WAAlbumCell countForOneRowWithOritation:oritation];
        
        CGFloat s = (oritation == UIInterfaceOrientationLandscapeRight?MAX(w, h):MIN(w, h));
        CGFloat width = (s-(count+1)*10.0)/count;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, s, 175)];
        view.backgroundColor = RGBCOLOR(250, 250, 250);

        
        _imgViews = [NSMutableArray arrayWithCapacity:count];
        for (int i=0; i<count; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10+(width+10)*i, 10, width, 165)];
            imgView.userInteractionEnabled = YES;
            imgView.tag = i;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.clipsToBounds = YES;
            [view addSubview:imgView];
            
            [_imgViews addObject:imgView];
            
            UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:vc action:@selector(tapPicture:)];
            [imgView addGestureRecognizer:gest];
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
            imgView.hidden = NO;
            NSDictionary *dic = arr[idx];
            NSString *url0 = [NSString stringWithFormat:@"%@=s304", dic[@"url"]];
            
//            [imgView setImageWithURL:[NSURL URLWithString:url0]];
            //如果失败，使用备用服务器
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url0]];
            [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
            
            __weak UIImageView *weakImgView = imgView;
            [imgView setImageWithURLRequest:request
                           placeholderImage:nil
                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                        weakImgView.image = image;
                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                        NSURL *URL = [request URL];
                                        NSString *host = [URL host];
                                        
                                        NSString *optionServer = CONFIG(KeyOptionServer);
                                        if ([optionServer hasPrefix:@"http://"] && optionServer.length>7) {
                                            optionServer = [optionServer substringWithRange:NSMakeRange(7, optionServer.length-7)];
                                        }
                                        
                                        NSString *url = [URL absoluteString];
                                        NSMutableString *muUrl = [NSMutableString stringWithString:url];
                                        [muUrl replaceOccurrencesOfString:host withString:optionServer options:0 range:NSMakeRange(0, url.length)];
                                        
                                        NSMutableURLRequest *request1 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:muUrl]];
                                        [request1 addValue:@"image/*" forHTTPHeaderField:@"Accept"];
                                        
                                        [weakImgView setImageWithURLRequest:request1
                                                       placeholderImage:nil
                                                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                    weakImgView.image = image;
                                                                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                    weakImgView.image = nil;
                                                                }];
                                    }];
        }else{
            imgView.hidden = YES;
        }
    }];
}

@end
