//
//  WASettingViewController.m
//  WeddingAlbum
//
//  Created by Tonny on 5/28/13.
//  Copyright (c) 2013 SlowsLab. All rights reserved.
//

#import "WASettingViewController.h"
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import "BundleHelper.h"
#import "UITableViewCell+BackgroundView.h"
#import "UIViewController+MMDrawerController.h"
#import "UIView+Addition.h"
#import "UIView+Indicator.h"

@interface WASettingViewController () <MFMailComposeViewControllerDelegate, UIActionSheetDelegate, MFMessageComposeViewControllerDelegate>

@end

@implementation WASettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _imgView.image = [UIImage imageNamed:@"pic_couple.jpg"];
    
    NSString *girlName = CONFIG(KeyCoupleGirl);
    NSString *boyName = CONFIG(KeyCoupleBoy);
    NSString *cong = [NSString stringWithFormat:@"       恭祝%@和%@喜结连理。愿你们的爱情生活，如同无花果树的果子渐渐成熟；又如葡萄树开花放香，作基督馨香的见证，与诸天穹苍一同地每日每夜述说着神的荣耀！", girlName, boyName];
    
    CGFloat height = [cong sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(self.view.width-20, MAXFLOAT)].height;
    _titleLbl.height = height;
    _titleLbl.text = cong;
    
    NSString *appName = [BundleHelper bundleDisplayNameString];
    NSString *version = [BundleHelper bundleShortVersionString];
    _footerLbl.text = [NSString stringWithFormat:@"App Name: %@\nVersion: %@", appName, version];
    
    _headerView.height = height+230; //270
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.backgroundColor = RGBCOLOR(250, 250, 250);
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.textLabel.textColor = RGBCOLOR(57, 57, 57);
    }
    
    [cell setBackgroundViewWithtableView:tableView indexPath:indexPath];
    
    NSUInteger row = indexPath.row;
    
    if (row == 0) {
        cell.textLabel.text = @"  清空本地缓存";
    }else if(row == 1){
        cell.textLabel.text = @"  联系我们";
    }else if(row == 2){
        cell.textLabel.text = @"  推荐给好友";
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    if(row == 0){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [cell showIndicatorViewAtPoint:CGPointMake(cell.width-50, cell.height*0.5-10)];
        [WADataEnvironment cleanCache];
        
        [cell performSelector:@selector(hideIndicatorView) withObject:nil afterDelay:1.0];
    }else if (row == 1) {
        MFMailComposeViewController *emailer = [[MFMailComposeViewController alloc] init];
        emailer.mailComposeDelegate = self;
        NSArray *toRecipients = [NSArray arrayWithObject:CONFIG(KeyEmail)];
        [emailer setToRecipients:toRecipients];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            emailer.modalPresentationStyle = UIModalPresentationPageSheet;
        }
        [self presentModalViewController:emailer animated:YES];
    }else if(row == 2){
        UIActionSheet *sheet;
        if([MFMessageComposeViewController canSendText]){
            sheet = [[UIActionSheet alloc] initWithTitle:@"告诉朋友" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"邮件分享", @"短信分享", nil];
        }else{
            sheet = [[UIActionSheet alloc] initWithTitle:@"告诉朋友" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"邮件分享", nil];
        }
        
        [sheet showInView:self.view];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"邮件分享"]) {
        if ([MFMailComposeViewController canSendMail]){
            [WASettingViewController shareAppViaEmail:self];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能发送邮件，请设置好邮件帐号。" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }else if ([title isEqualToString:@"短信分享"]) {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        NSString *server = CONFIG(KeyServer);
        if (![server hasPrefix:@"http://"]) {
            server = [NSString stringWithFormat:@"http://%@", server];
        }
        controller.body = [NSString stringWithFormat:@"专属相册《%@》的下载地址：%@/downloads", [BundleHelper bundleDisplayNameString], server];
        
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }
}

+ (void)shareAppViaEmail:(id<MFMailComposeViewControllerDelegate>)vc{
    MFMailComposeViewController *emailer = [[MFMailComposeViewController alloc] init];
    emailer.mailComposeDelegate = vc;
    
    [emailer setSubject:[NSString stringWithFormat:@"分享应用 [%@]", [BundleHelper bundleDisplayNameString]]];
    
    NSString *server = CONFIG(KeyServer);
    if (![server hasPrefix:@"http://"]) {
        server = [NSString stringWithFormat:@"http://%@", server];
    }
    NSString *body = [NSString stringWithFormat:@"\n\n\n专属相册《%@》的下载地址：%@/downloads", [BundleHelper bundleDisplayNameString], server];
    [emailer setMessageBody:body isHTML:NO];
    
    [emailer addAttachmentData:UIImageJPEGRepresentation([UIImage imageNamed:@"Icon.png"], 0.8) mimeType:@"png" fileName:@"Icon.png"];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        emailer.modalPresentationStyle = UIModalPresentationPageSheet;
    }
    
    [(UIViewController *)vc presentModalViewController:emailer animated:YES];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissModalViewControllerAnimated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissModalViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y*0.5;
    if (offset <= 0) {
        CGFloat width = scrollView.width-offset;
        CGFloat height = 210-offset;
        _imgView.frame = CGRectMake((scrollView.width-width)*0.5, offset*2, width, height);
    }
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
