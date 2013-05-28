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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 175)];
        view.backgroundColor = RGBCOLOR(250, 250, 250);
        
        _imgView0 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 145, 165)];
        _imgView0.contentMode = UIViewContentModeScaleAspectFill;
        _imgView0.clipsToBounds = YES;
        [view addSubview:_imgView0];
        
        _imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(165, 10, 145, 165)];
        _imgView1.contentMode = UIViewContentModeScaleAspectFill;
        _imgView1.clipsToBounds = YES;
        [view addSubview:_imgView1];
        
        [self.contentView addSubview:view];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setData:(NSDictionary *)dic0 :(NSDictionary *)dic1{
    _dic0 = dic0;
    _dic1 = dic1;
    
    NSString *url0 = dic0[@"url"];
    [_imgView0 setImageWithURL:[NSURL URLWithString:url0]];
    
    if (dic1) {
        NSString *url1 = dic1[@"url"];
        
        _imgView1.hidden = NO;
        [_imgView1 setImageWithURL:[NSURL URLWithString:url1]];
    }else{
        _imgView1.hidden = YES;
    }
}

@end
