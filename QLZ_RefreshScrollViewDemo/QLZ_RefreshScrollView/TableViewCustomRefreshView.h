//
//  TableViewCustomRefreshView.h
//  QLZ_Refresh
//
//  Created by 张庆龙 on 16/1/18.
//  Copyright © 2016年 张庆龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCustomRefreshView : UIView {
    UIImageView *backgroundImageView;
    UIImageView *logoImageView;
}

- (void)moveSquareWithPercent:(float)percent;
- (void)normalStatus;
- (void)releaseToRefreshStatus;
- (void)refreshingStatus;

@end
