//
//  QLZ_RefreshView.m
//  QLZ_Refresh
//
//  Created by 张庆龙 on 16/1/15.
//  Copyright © 2016年 张庆龙. All rights reserved.
//

#import "QLZ_RefreshView.h"
#import "QLZ_RefreshConst.h"
#import "QLZ_RefreshStatus.h"

@interface QLZ_RefreshView () {
    UILabel *titleLabel;
    UIActivityIndicatorView *activityView;
    UIImageView *arrowImageView;
}

@end

@implementation QLZ_RefreshView

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, (CGRectGetHeight(self.bounds) - 40) / 2, 15, 40)];
        arrowImageView.image = [UIImage imageNamed:@"QLZ_Refresh.bundle/arrow.png"];
        [self addSubview:arrowImageView];
        
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.center = arrowImageView.center;
        [self addSubview:activityView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(arrowImageView.frame) + 20, (CGRectGetHeight(self.bounds) - 40) / 2, CGRectGetWidth(self.bounds) - 140, 40)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
    }
    return self;
}

- (void)setStatus:(int)status {
    if (status == QLZ_RefreshStatus_Normal) {
        arrowImageView.hidden = NO;
        [activityView stopAnimating];
        [UIView animateWithDuration:0.2f animations:^{
            CGAffineTransform transform = CGAffineTransformMakeRotation(0);
            arrowImageView.transform = transform;
        }];
        titleLabel.text = QLZ_RefreshNormalText;
    }
    else if (status == QLZ_RefreshStatus_ReleaseToRefresh) {
        arrowImageView.hidden = NO;
        [activityView stopAnimating];
        [UIView animateWithDuration:0.2f animations:^{
            CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
            arrowImageView.transform = transform;
        }];
        titleLabel.text = QLZ_RefreshReleaseToReleaseText;
    }
    else if (status == QLZ_RefreshStatus_Refreshing) {
        arrowImageView.hidden = YES;
        [activityView startAnimating];
        titleLabel.text = QLZ_RefreshRefreshingText;
    }
}

@end
