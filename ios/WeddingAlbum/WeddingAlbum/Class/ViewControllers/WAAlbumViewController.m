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

@interface WAAlbumViewController () <UIActionSheetDelegate>

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
        _shareBtn.hidden = YES;
        _tableView.hidden = YES;
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_welcome.png"]];
        imgView.tag = 100;
        imgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        imgView.frame = CGRectMake(0, 100, 320, 287);
        [self.view addSubview:imgView];
    }
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStatusBar:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

#pragma mark - Actions

- (IBAction)showMenu:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)share:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享到微信", nil];
    [sheet showInView:self.view];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *pictures = _dataSource[@"pictures"];
    NSUInteger row = (pictures.count+1)/[WAAlbumCell countForOneRowWithOritation:self.interfaceOrientation];
    
    SLLog(@"row %d", [WAAlbumCell countForOneRowWithOritation:self.interfaceOrientation]);
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier0 = @"CellPotrait";
    static NSString *CellIdentifier1 = @"CellLandScape";
    NSString *CellIdentifier = (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight?CellIdentifier1:CellIdentifier0);
    
    WAAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WAAlbumCell alloc] initWithOritation:self.interfaceOrientation reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger row = indexPath.row;
    NSArray *pictures = _dataSource[@"pictures"];
    
    NSUInteger count = [WAAlbumCell countForOneRowWithOritation:self.interfaceOrientation];
    
    NSUInteger start = row*count;
    
    [cell setData:[pictures subarrayWithRange:NSMakeRange(start, MIN(pictures.count-start, count))]];
    
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

//- (void)update{
//    _titleLbl.text = self.title;
//    [self retrieveData];
//    
//    _tableView.hidden = NO;
//    
//    UIView *imgView = [self.view viewWithTag:100];
//    [imgView removeFromSuperview];
//}


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
    _shareBtn = nil;
    [super viewDidUnload];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else{
        
    }
}



@end
