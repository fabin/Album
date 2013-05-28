//
//  WAAlbumViewController.m
//  WeddingAlbum
//
//  Created by Tonny on 5/28/13.
//  Copyright (c) 2013 SlowsLab. All rights reserved.
//

#import "WAAlbumViewController.h"
#import "WAHTTPClient.h"
#import "UIViewController+MMDrawerController.h"
#import "WAAlbumCell.h"

@interface WAAlbumViewController ()

@end

@implementation WAAlbumViewController{
    NSDictionary          *_dataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.title) {
        _titleLbl.text = self.title;
    }else{
        _titleLbl.text = CONFIG(KeyCouple);
    }
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGBCOLOR(250, 250, 250);
    
    if (_albumKey) {
        [self retrieveData];
    }else{
        _tableView.hidden = YES;
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_welcome.png"]];
        imgView.frame = CGRectMake(0, 100, 320, 287);
        [self.view addSubview:imgView];
    }
}

#pragma mark - Actions

- (IBAction)showMenu:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)share:(id)sender {
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *pictures = _dataSource[@"pictures"];
    return (pictures.count+1)/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    WAAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WAAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger row = indexPath.row;
    NSArray *pictures = _dataSource[@"pictures"];
    
    NSDictionary *dic0 = pictures[row*2];
    NSDictionary *dic1 = nil;
    
    if (row*2+1 < pictures.count) {
        dic1 = pictures[row*2+1];
    }
    
    [cell setData:dic0 :dic1];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 175.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    view.backgroundColor = RGBCOLOR(250, 250, 250);
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *dic = _dataSource[indexPath.row];
//    
//    WAAlbumViewController *albumVC = [[WAAlbumViewController alloc] initWithNibName:@"WAAlbumViewController" bundle:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)retrieveData{
    [WAHTTPClient photoListForKey:self.albumKey
                          success:^(id obj) {
                              _dataSource = obj;
                              [_tableView reloadData];
                          } failure:^(NSError *err) {
                              
                          }];
}

- (void)viewDidUnload {
    _titleLbl = nil;
    [super viewDidUnload];
}
@end
