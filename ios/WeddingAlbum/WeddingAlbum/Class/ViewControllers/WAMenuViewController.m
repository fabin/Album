//
//  WAMenuViewController.m
//  WeddingAlbum
//
//  Created by Tonny on 5/28/13.
//  Copyright (c) 2013 SlowsLab. All rights reserved.
//

#import "WAMenuViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "UIImageView+AFNetworking.h"
#import "WAHTTPClient.h"
#import "WAAlbumViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "WAAlbumViewController.h"
#import "WASettingViewController.h"
#import "UIView+Indicator.h"

@interface WAMenuViewController ()

@end

@implementation WAMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = RGBCOLOR(67, 67, 67);
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;

    NSString *title = CONFIG(KeyCouple);
    
    _titleLbl.text = title?title:@"新郎&新娘";
//    _imgView.image = [UIImage imageNamed:@"Icon.png"];
    _imgView.backgroundColor = [UIColor redColor];
    
    _imgView.layer.cornerRadius = 34.5;
    
    _dataSource = [WADataEnvironment cachedAlbumeListForName:title];
    [self retrieveData];
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
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_menucell.png"]];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_cell_acc.png"]];
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    
    NSUInteger row = indexPath.row;
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%d.png", row%10+1]];
    
    NSDictionary *dic = _dataSource[indexPath.row];
    NSString *title = dic[@"name"];
    cell.textLabel.text = title;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _dataSource[indexPath.row];
    
//    if (!_albumVC) {
        WAAlbumViewController *albumVC = [[WAAlbumViewController alloc] initWithNibName:@"WAAlbumViewController" bundle:nil];
        albumVC.albumKey = dic[@"key"];
        albumVC.title = dic[@"name"];
        
        [self.mm_drawerController setCenterViewController:albumVC
                                       withCloseAnimation:YES
                                               completion:nil];
//    }else{
//        _albumVC.albumKey = dic[@"key"];
//        _albumVC.title = dic[@"name"];
//        
//        [_albumVC update];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 23.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_section.png"]];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 20)];
    lbl.text = @"相册";
    lbl.textColor = [UIColor whiteColor];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont boldSystemFontOfSize:14];
    [imgView addSubview:lbl];
    
    return imgView;
}

- (void)viewDidUnload {
    _titleLbl = nil;
    _imgView = nil;
    [super viewDidUnload];
}

#pragma mark - DataRequest

- (void)retrieveData{
    UIView *headerView = self.tableView.tableHeaderView;
    [headerView showIndicatorViewAtPoint:CGPointMake(self.tableView.frame.size.width*0.5-10, 220) indicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    [WAHTTPClient albumListSuccess:^(id obj) {
        [headerView hideIndicatorView];
        
        _dataSource = obj;
        [self.tableView reloadData];
        
        NSString *title = CONFIG(KeyCouple);
        [WADataEnvironment cacheAlbumList:obj forName:title];
    } failure:^(NSError *err) {
        [headerView hideIndicatorView];
    }];
}

- (IBAction)about:(id)sender {
    WASettingViewController *albumVC = [[WASettingViewController alloc] initWithNibName:@"WASettingViewController" bundle:nil];
    
    [self.mm_drawerController setCenterViewController:albumVC
                                   withCloseAnimation:YES
                                           completion:nil];
}


@end
