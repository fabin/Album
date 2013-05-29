//
//  WASettingViewController.m
//  WeddingAlbum
//
//  Created by Tonny on 5/28/13.
//  Copyright (c) 2013 SlowsLab. All rights reserved.
//

#import "WASettingViewController.h"
#import "BundleHelper.h"

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
    
    
    NSString *version = [BundleHelper bundleShortVersionString];
    _footerLbl.text = version;
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
    }
    
    NSDictionary *dic = _dataSource[indexPath.row];
    cell.textLabel.text = dic[@"text"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
