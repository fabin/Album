//
//  WAAlbumViewController.h
//  WeddingAlbum
//
//  Created by Tonny on 5/28/13.
//  Copyright (c) 2013 SlowsLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface WAAlbumViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    
    __weak IBOutlet UILabel *_titleLbl;
    __weak IBOutlet UITableView *_tableView;
    
    __weak IBOutlet UIButton *_shareBtn;
}

@property (nonatomic, copy) NSString *albumKey;


//- (void)update;
@end
