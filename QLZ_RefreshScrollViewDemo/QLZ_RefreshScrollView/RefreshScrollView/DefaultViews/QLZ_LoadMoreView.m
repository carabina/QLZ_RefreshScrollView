//
//  QLZ_LoadMoreView.m
//  QLZ_Refresh
//
//  Created by 张庆龙 on 16/1/15.
//  Copyright © 2016年 张庆龙. All rights reserved.
//

#import "QLZ_LoadMoreView.h"
#import "QLZ_RefreshConst.h"
#import "QLZ_RefreshStatus.h"

@interface QLZ_LoadMoreView () {
    UIActivityIndicatorView *activityView;
    UILabel *titleLabel;
}

@end

@implementation QLZ_LoadMoreView

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, CGRectGetWidth(self.bounds) - 100, CGRectGetHeight(self.bounds))];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.center = CGPointMake(40, CGRectGetMidY(self.bounds));
        [self addSubview:activityView];
        
//        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void)setStatus:(int)status {
    if (status == QLZ_LoadMoreStatus_Normal) {
        [activityView stopAnimating];
        titleLabel.text = QLZ_LoadMoreNormalText;
    }
    else if (status == QLZ_LoadMoreStatus_ReleaseToLoadMore) {
        [activityView stopAnimating];
        titleLabel.text = QLZ_LoadMoreReleaseToLoadMoreText;
    }
    else if (status == QLZ_LoadMoreStatus_LoadingMore) {
        [activityView startAnimating];
        titleLabel.text = QLZ_LoadMoreLoadingMoreText;
    }
    else if (status == QLZ_LoadMoreStatus_NoMoreToLoad) {
        [activityView stopAnimating];
        titleLabel.text = QLZ_LoadMoreNoMoreToDataText;
    }
}

@end
