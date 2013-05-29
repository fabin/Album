//
//  WASettingViewController.m
//  WeddingAlbum
//
//  Created by Tonny on 5/28/13.
//  Copyright (c) 2013 SlowsLab. All rights reserved.
//

#import "WASettingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BundleHelper.h"
#import "UITableViewCell+BackgroundView.h"
#import "UIViewController+MMDrawerController.h"
#import "UIView+Addition.h"

@interface WASettingViewController ()

@end

@implementation WASettingViewController{
    NSDictionary     *_dataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"About" ofType:@"plist"];
    _dataSource = [NSDictionary dictionaryWithContentsOfFile:file];
    
    _imgView.image = [UIImage imageNamed:@"相册7.jpg"];
    
    NSString *cong = _dataSource[@"congratulation"];
    CGFloat height = [cong sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(self.view.width-20, MAXFLOAT)].height;
    _titleLbl.height = height;
    _titleLbl.text = [NSString stringWithFormat:cong, CONFIG(KeyCoupleBoy), CONFIG(KeyCoupleGirl)];
    
    NSString *appName = [BundleHelper bundleDisplayNameString];
    NSString *version = [BundleHelper bundleShortVersionString];
    _footerLbl.text = [NSString stringWithFormat:@"%@ %@", appName, version];
    
    
    _headerView.height = height+240; //270
    _tableView.tableHeaderView = _headerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;//[_dataSource[@"helper"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.backgroundColor = RGBCOLOR(250, 250, 250);
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    
    [cell setBackgroundViewWithtableView:tableView indexPath:indexPath];
    
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    
    
//    if (section == 0) {
//        NSDictionary *dic = _dataSource[@"helper"][indexPath.row];
//        cell.textLabel.text = dic[@"text"];
//        cell.imageView.image = [UIImage imageNamed:dic[@"img"]];
//    }else{
        if (row == 0) {
            cell.textLabel.text = @"  联系我们";
        }else if(row == 1){
            cell.textLabel.text = @"  应用推荐给好友";
        }
//    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UILabel  *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
//    lbl.backgroundColor = RGBCOLOR(250, 250, 250);
//    lbl.font = [UIFont boldSystemFontOfSize:14];
//    if (section == 0) {
////        lbl.text = @"   帮助";
////    }else if (section == 1) {
//        lbl.text = @"   关于";
//    }
//    return lbl;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 1) {
////        return 20.0;
//    }
//    
////    return 20.0;
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y*0.5;
    if (offset <= 0) {
        CGFloat width = scrollView.width-offset;
        CGFloat height = 210-offset;
        _imgView.frame = CGRectMake((scrollView.width-width)*0.5, offset*2, width, height);
    }
    
//    _imgView.layer.transform = CATransform3DScale(CATransform3DMakeTranslation(0, 0, 0), (100.0-offset)/100.0, (100.0-offset)/100.0, 0);
}

- (IBAction)showMenu:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)viewDidUnload {
    _footerLbl = nil;
    _imgView = nil;
    _titleLbl = nil;
    _headerView = nil;
    _tableView = nil;
    [super viewDidUnload];
}
@end
