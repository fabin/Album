//
//  WAAlbumCell.h
//  WeddingAlbum
//
//  Created by Tonny on 5/28/13.
//  Copyright (c) 2013 SlowsLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAAlbumCell : UITableViewCell{
    UIImageView         *_imgView0;
    UIImageView         *_imgView1;
    
    NSDictionary        *_dic0;
    NSDictionary        *_dic1;
}

- (void)setData:(NSDictionary *)dic0 :(NSDictionary *)dic1;

@end
