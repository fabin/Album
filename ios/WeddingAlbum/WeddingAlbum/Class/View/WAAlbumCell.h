//
//  WAAlbumCell.h
//  WeddingAlbum
//
//  Created by Tonny on 5/28/13.
//  Copyright (c) 2013 SlowsLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAAlbumCell : UITableViewCell{
    NSMutableArray      *_imgViews;
    
    NSDictionary        *_dic0;
    NSDictionary        *_dic1;
    NSDictionary        *_dic2;
}

- (id)initWithController:(UIViewController *)vc reuseIdentifier:(NSString *)reuseIdentifier;

+ (NSUInteger)countForOneRowWithOritation:(UIInterfaceOrientation)oritation;

- (void)setData:(NSArray *)arr;
@end
