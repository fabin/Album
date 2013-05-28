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


@interface WASettingViewController ()

@end

@implementation WASettingViewController{
    NSArray     *_dataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"help" ofType:@"plist"];
    _dataSource = [NSArray arrayWithContentsOfFile:file];
    
    _imgView.image = [UIImage imageNamed:@"相册7.jpg"];
    
    NSString *appName = [BundleHelper bundleDisplayNameString];
    NSString *version = [BundleHelper bundleShortVersionString];
    _footerLbl.text = [NSString stringWithFormat:@"%@ %@", appName, version];
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
        cell.textLabel.backgroundColor = RGBCOLOR(250, 250, 250);
    }
    
    [cell setBackgroundViewWithtableView:tableView indexPath:indexPath];
    NSDictionary *dic = _dataSource[indexPath.row];
    cell.textLabel.text = dic[@"text"];
    cell.imageView.image = [UIImage imageNamed:dic[@"img"]];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y*0.5;
    if (offset <= 0) {
        CGFloat width = 320-offset;
        CGFloat height = 210-offset;
        _imgView.frame = CGRectMake((320-width)*0.5, offset*2, width, height);
    }
    
//    _imgView.layer.transform = CATransform3DScale(CATransform3DMakeTranslation(0, 0, 0), (100.0-offset)/100.0, (100.0-offset)/100.0, 0);
}

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    _footerLbl = nil;
    _imgView = nil;
    _titleLbl = nil;
    [super viewDidUnload];
}
@end
