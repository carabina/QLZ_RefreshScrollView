//
//  NormalTableViewController.h
//  QLZ_RefreshScrollView
//
//  Created by 张庆龙 on 16/2/4.
//  Copyright © 2016年 张庆龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NormalTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate> {
    UITableView *mainTableView;
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
    NSMutableArray *array;
}

- (id)initWithRefreshType:(int)type title:(NSString *)title;

@end
