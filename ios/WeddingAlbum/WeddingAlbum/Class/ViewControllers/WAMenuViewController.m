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
#import "WASettingViewController.h"
#import "UIView+Indicator.h"
#import "MBProgressHUD.h"

@interface WAMenuViewController ()

@end

@implementation WAMenuViewController{
    NSUInteger          _selectedRow;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = RGBCOLOR(67, 67, 67);
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;

    NSString *title = CONFIG(KeyCouple);
    
    _titleLbl.text = title?title:@"新郎&新娘";
    _imgView.image = [UIImage imageNamed:@"profile_head.jpg"];
    _imgView.backgroundColor = [UIColor redColor];
    _imgView.layer.cornerRadius = 34;
    
    _dataSource = [WADataEnvironment cachedAlbumeListForName:title];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retrieveDataNeedCheck:) name:@"NOTI_RETRIEVE_ALBUMS_NEEDCHECK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retrieveData:) name:@"NOTI_RETRIEVE_ALBUMS" object:nil];
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
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_menucell.png"]];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_cell_acc.png"]];
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.textLabel.shadowOffset = CGSizeMake(0, 1);
        cell.textLabel.shadowColor = [UIColor blackColor];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 14, 14)];
        imgView.tag = 1;
        [cell.contentView addSubview:imgView];
        
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_menucell_tapped.png"]];
    }
    
    NSUInteger row = indexPath.row;
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:1];
    imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%d.png", row%10+1]];
    
    NSDictionary *dic = _dataSource[indexPath.row];
    NSString *title = dic[@"name"];
    cell.textLabel.text = [NSString stringWithFormat:@"      %@", title];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedRow = indexPath.row;
    
    NSDictionary *dic = _dataSource[indexPath.row];
    
    WAAlbumViewController *albumVC = [[WAAlbumViewController alloc] initWithNibName:@"WAAlbumViewController" bundle:nil];
    albumVC.albumKey = dic[@"key"];
    albumVC.title = dic[@"name"];
    
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:albumVC];
    [self.mm_drawerController setCenterViewController:nv
                                   withCloseAnimation:YES
                                           completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 23.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_section.png"]];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 290, 20)];
    lbl.text = @"相册";
    lbl.textColor = RGBCOLOR(157, 157, 157);
    lbl.shadowColor = [UIColor blackColor];
    lbl.shadowOffset = CGSizeMake(1, 1);
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont boldSystemFontOfSize:12];
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
    _isLoading = YES;
    
    UIView *view = self.mm_drawerController.view;
//    [view showIndicatorView];
    
    [MBProgressHUD showHUDAddedTo:view animated:YES];
    [WAHTTPClient albumListSuccess:^(id obj) {
        [MBProgressHUD hideHUDForView:view animated:YES];
        
//        [view hideIndicatorView];
        _dataSource = obj;
        [self.tableView reloadData];
        
        NSString *title = CONFIG(KeyCouple);
        [WADataEnvironment cacheAlbumList:obj forName:title];
        _isLoading = NO;
    } failure:^(NSError *err) {
        [MBProgressHUD hideHUDForView:view animated:YES];
        
//        [view hideIndicatorView];
        _isLoading = NO;
    }];
}

- (IBAction)about:(id)sender {
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedRow inSection:0] animated:YES];
    
    WASettingViewController *vc = [[WASettingViewController alloc] initWithNibName:@"WASettingViewController" bundle:nil];
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
    
    UIImage *image = [UIImage imageNamed:@"bg_nav.png"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [nv.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [self.mm_drawerController setCenterViewController:nv
                                   withCloseAnimation:YES
                                           completion:nil];
}

- (IBAction)showWelcome:(id)sender {
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedRow inSection:0] animated:YES];
    
    WAAlbumViewController *vc = [[WAAlbumViewController alloc] initWithNibName:@"WAAlbumViewController" bundle:nil];
    vc.title = CONFIG(KeyCouple);
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
    //    nv.navigationBarHidden = YES;
    UIImage *image = [UIImage imageNamed:@"bg_nav.png"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [nv.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [self.mm_drawerController setCenterViewController:nv
                                   withCloseAnimation:YES
                                           completion:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ((orientation == UIInterfaceOrientationPortrait) ||
        (orientation == UIInterfaceOrientationLandscapeRight))
        return YES;
    
    return NO;
}

#pragma mark - Notifications

- (void)retrieveDataNeedCheck:(NSNotification *)noti{
    if (!_dataSource && !_isLoading) {
        [self retrieveData];
    }
}

- (void)retrieveData:(NSNotification *)noti{
    [self retrieveData];
}

@end
