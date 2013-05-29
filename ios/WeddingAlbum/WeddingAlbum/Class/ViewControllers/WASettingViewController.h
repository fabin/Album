//
//  WASettingViewController.h
//  WeddingAlbum
//
//  Created by Tonny on 5/28/13.
//  Copyright (c) 2013 SlowsLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MFMailComposeViewControllerDelegate;

@interface WASettingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UIView *_headerView;
    __weak IBOutlet UIImageView *_imgView;
    __weak IBOutlet UILabel *_titleLbl;
    
    __weak IBOutlet UILabel *_footerLbl;
}

+ (void)shareAppViaEmail:(id<MFMailComposeViewControllerDelegate>)vc;

@end
