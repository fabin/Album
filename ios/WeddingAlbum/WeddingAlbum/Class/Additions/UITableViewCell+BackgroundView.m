//
//  UITableViewCell+BackgroundView.m
//  traffictickets
//
//  Created by Tonny on 5/25/13.
//
//

#import "UITableViewCell+BackgroundView.h"

@implementation UITableViewCell (BackgroundView)

- (void)setBackgroundViewWithtableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    UIImage *img = nil;
    NSUInteger row = indexPath.row;
    if (row == 0) {
        if (row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            img = [UIImage imageNamed:@"cell.png"];
        }else{
            img = [UIImage imageNamed:@"cell_top.png"];
        }
    }else if(row == [tableView numberOfRowsInSection:indexPath.section]-1){
        img = [UIImage imageNamed:@"cell_bottom.png"];
    }else{
        img = [UIImage imageNamed:@"cell_mid.png"];
    }
    
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(22, 156, 22, 156)];
    UIImageView *tempView = [[UIImageView alloc] initWithImage:img];
    tempView.backgroundColor = [UIColor clearColor];
    [self setBackgroundView:tempView];
}

@end
