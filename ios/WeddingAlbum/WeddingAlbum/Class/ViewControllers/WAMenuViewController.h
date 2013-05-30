//
//  WAMenuViewController.h
//  WeddingAlbum
//
//  Created by Tonny on 5/28/13.
//  Copyright (c) 2013 SlowsLab. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class WAAlbumViewController;

@interface WAMenuViewController : UITableViewController{
    NSMutableArray          *_dataSource;
    
    __weak IBOutlet UIImageView *_imgView;
    __weak IBOutlet UILabel     *_titleLbl;
    
    BOOL                    _isLoading;
}

//@property (strong, nonatomic) WAAlbumViewController *detailViewController;

@end
