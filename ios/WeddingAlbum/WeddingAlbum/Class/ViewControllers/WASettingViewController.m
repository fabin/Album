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
#import "UIImageView+WebCache.h"

@interface WASettingViewController () <MFMailComposeViewControllerDelegate, UIActionSheetDelegate, MFMessageComposeViewControllerDelegate>

@end

@implementation WASettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"appCongratulation"];
    if (url){
        [_imgView setImageWithURL:[NSURL URLWithString:url]];
    }else{
        _imgView.image = [UIImage imageNamed:@"pic_couple.jpg"];
    }
    
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
    
    self.title = @"关于";
    
    BOOL isIphone = is_iPhone;
    CGRect frame = CGRectMake(0, 0, 50, self.navigationController.navigationBar.height);;
    if (isIphone) {
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = frame;
        leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, (isIphone?-5:-7), 0, (isIphone?5:7));
        leftBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [leftBtn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn setImage:[UIImage imageNamed:@"btn_side.png"] forState:UIControlStateNormal];
        [leftBtn setImage:[UIImage imageNamed:@"btn_side_tapped.png"] forState:UIControlStateHighlighted];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, [UIColor colorWithWhite:0 alpha:0.3], UITextAttributeTextShadowColor, [NSValue valueWithCGSize:CGSizeMake(0, 0.5)], UITextAttributeTextShadowOffset, [UIFont boldSystemFontOfSize:18], UITextAttributeFont, nil];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_RETRIEVE_ALBUMS" object:nil];
        
        [cell performSelector:@selector(hideIndicatorView) withObject:nil afterDelay:1.0];
    }else if (row == 1) {
        if(NSClassFromString(@"MFMailComposeViewController") && [MFMailComposeViewController canSendMail]){
            MFMailComposeViewController *emailer = [[MFMailComposeViewController alloc] init];
            emailer.mailComposeDelegate = self;
            NSString *email = CONFIG(KeyEmail);
            if (email) {
                [emailer setToRecipients:@[email]];
            }
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                emailer.modalPresentationStyle = UIModalPresentationFormSheet;
            }
            [self presentModalViewController:emailer animated:YES];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能发送邮件，请设置好邮件帐号。" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }else if(row == 2){
        if([MFMessageComposeViewController canSendText]){
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"告诉朋友" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"邮件分享", @"短信分享", nil];
            [sheet showInView:self.view];
        }else{
            if (NSClassFromString(@"MFMailComposeViewController") && [MFMailComposeViewController canSendMail]){
                [WASettingViewController shareAppViaEmail:self];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能发送邮件，请设置好邮件帐号。" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }
        }
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
        emailer.modalPresentationStyle = UIModalPresentationFormSheet;
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
