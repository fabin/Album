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
#import "MWPhotoBrowser.h"
#import "UIView+Indicator.h"
#import "UIView+Addition.h"
#import "AFImageRequestOperation.h"
#import "MBProgressHUD.h"
#import "BundleHelper.h"
#import "WASettingViewController.h"

@interface WAAlbumViewController () <UIActionSheetDelegate, MWPhotoBrowserDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, MFMessageComposeViewControllerDelegate>

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
        _dataSource = [WADataEnvironment cachedPhotoListForName:_albumKey];
        
        if (!_dataSource) {
            [self retrieveData];
        }
    }else{
        _tableView.hidden = YES;
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_welcome.png"]];
        imgView.tag = 100;
        imgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        imgView.frame = CGRectMake(self.view.width-250, self.view.height-250, 250, 250);
        [self.view addSubview:imgView];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *pictures = _dataSource[@"pictures"];
    NSUInteger count = [WAAlbumCell countForOneRowWithOritation:self.interfaceOrientation];
    NSUInteger row = (pictures.count+count-1)/count;
    
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier0 = @"CellPotrait";
    static NSString *CellIdentifier1 = @"CellLandScape";
    NSString *CellIdentifier = (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight?CellIdentifier1:CellIdentifier0);
    
    WAAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WAAlbumCell alloc] initWithController:self reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger row = indexPath.row;
    NSArray *pictures = _dataSource[@"pictures"];
    
    NSUInteger count = [WAAlbumCell countForOneRowWithOritation:self.interfaceOrientation];
    
    NSUInteger start = row*count;
    
    SLLog(@"[%d %d]", start, MIN(pictures.count-start, count));
    [cell setData:[pictures subarrayWithRange:NSMakeRange(start, MIN(pictures.count-start, count))]];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 175.0;
}

#pragma mark - Actions

- (IBAction)showMenu:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)share:(UIButton *)button {
    UIActionSheet *sheet;
    if([MFMessageComposeViewController canSendText]){
        sheet = [[UIActionSheet alloc] initWithTitle:@"告诉朋友" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"邮件分享", @"短信分享", nil];
    }else{
        sheet = [[UIActionSheet alloc] initWithTitle:@"告诉朋友" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"邮件分享", nil];
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [sheet showFromRect:button.frame inView:self.view animated:YES];
    } else {
        [sheet showInView:self.view];
    }
}

- (void)tapPicture:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:_tableView];
    CGFloat height = [self tableView:_tableView heightForRowAtIndexPath:nil];
    
    NSUInteger count = [_tableView numberOfRowsInSection:0];
    NSUInteger row = point.y/height;
    
    if (row < count) {
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = YES;
        [browser setInitialPageIndex:row*[WAAlbumCell countForOneRowWithOritation:self.interfaceOrientation]+gesture.view.tag];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentModalViewController:browser animated:YES];
    }
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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)retrieveData{
    NSString *title = self.title;
    CGFloat width = [title sizeWithFont:_titleLbl.font].width;
    
    CGFloat left = width*0.5+self.view.width*0.5+10;
    if (_dataSource.count==0 || left > _titleLbl.width+50) {
        [self.view showIndicatorView];
    }else{
        [self.view showIndicatorViewAtPoint:CGPointMake(left, 12) indicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    
    [WAHTTPClient photoListForKey:self.albumKey
                          success:^(NSDictionary *dic) {
                              [self.view hideIndicatorView];
                              
                              _dataSource = dic;
                              [_tableView reloadData];
                              
                              [WADataEnvironment cachePhotoList:dic forName:_albumKey];
                              SLLog(@"count %d", [_dataSource[@"pictures"] count]);
                          } failure:^(NSError *err) {
                              _dataSource = [WADataEnvironment cachedPhotoListForName:_albumKey];
                              if(_dataSource){
                                  [_tableView reloadData];
                              }
                              
                              [self.view hideIndicatorView];
                          }];
}

- (void)viewDidUnload {
    _titleLbl = nil;
    _shareBtn = nil;
    [super viewDidUnload];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"邮件分享"]) {
        if ([MFMailComposeViewController canSendMail]){
            if (_albumKey) {
                [self shareAlbumViaEmail];
            }else{
                [self shareAppViaEmail];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能发送邮件，请设置好邮件帐号。" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }else if ([title isEqualToString:@"短信分享"]) {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        
        if (_albumKey) {
            NSString *name = [_dataSource valueForKeyPath:@"album.name"];
            if (!name) {
                controller.body = @"分享结婚相册";
            }else{
                controller.body = [NSString stringWithFormat:@"分享结婚相册 [%@]", name];;
            }
        }else{
            controller.body = [NSString stringWithFormat:@"分享app [%@] %@", [BundleHelper bundleDisplayNameString], CONFIG(KeyAppUrl)];;
        }
        
        controller.messageComposeDelegate = self;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentModalViewController:controller animated:YES];
    }
}

- (void)shareAlbumViaEmail{
    NSString *url = [_dataSource valueForKeyPath:@"album.cover"];
    if (!url) {
        NSArray *albums = _dataSource[@"pictures"];
        if(albums.count > 0){
            NSDictionary *dic = albums[0];
            url = dic[@"url"];
        }
    }
    
    SLObjectBlock sendMailBlock = ^(UIImage *image){
        MFMailComposeViewController *emailer = [[MFMailComposeViewController alloc] init];
        emailer.mailComposeDelegate = self;
        NSString *name = [_dataSource valueForKeyPath:@"album.name"];
        if (!name) {
            name = @"结婚相册";
        }
        
        NSString *des = [_dataSource valueForKeyPath:@"album.description"];
        if (!des) {
            des = @"";
        }
        
        NSString *sub = [NSString stringWithFormat:@"分享结婚相册 [%@]", name];
        [emailer setSubject:sub];
        
        NSString *body = [NSString stringWithFormat:@"\n\n%@ \n%@", des, url?url:@""];
        [emailer setMessageBody:body isHTML:NO];
        
        if (image) {
            [emailer addAttachmentData:UIImageJPEGRepresentation(image, 0.8) mimeType:@"png" fileName:@"Photo.png"];
        }
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            emailer.modalPresentationStyle = UIModalPresentationPageSheet;
        }
        [[UIApplication sharedApplication].keyWindow.rootViewController presentModalViewController:emailer animated:YES];
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request
                                                                              imageProcessingBlock:nil
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                               sendMailBlock(image);
                                                                                           } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                               
                                                                                               sendMailBlock(nil);
                                                                                           }];
    [[WAHTTPClient sharedWAHTTPClient] enqueueHTTPRequestOperation:operation];
}

- (void)shareAppViaEmail{
    [WASettingViewController shareAppViaEmail:self];
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissModalViewControllerAnimated:YES];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return [_dataSource[@"pictures"] count];
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    NSArray *pictures = _dataSource[@"pictures"];
    if (index < pictures.count){
        NSDictionary *dic = pictures[index];
        return [MWPhoto photoWithURL:[NSURL URLWithString:dic[@"url"]]];
    }
    return nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ((orientation == UIInterfaceOrientationPortrait) ||
        (orientation == UIInterfaceOrientationLandscapeRight))
        return YES;
    
    return NO;
}

@end
