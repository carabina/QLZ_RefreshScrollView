//
//  UIScrollView+QLZ_Refresh.m
//  QLZ_RefreshScrollView
//
//  Created by 张庆龙 on 16/2/3.
//  Copyright © 2016年 张庆龙. All rights reserved.
//

#import "UIScrollView+QLZ_Refresh.h"
#import "UIView+QLZ_Frame.h"
#import "UIScrollView+QLZ_Frame.h"
#import "QLZ_RefreshStatus.h"
#import "QLZ_RefreshView.h"
#import "QLZ_LoadMoreView.h"
#import "QLZ_KeyboardManager.h"
#import "NSObject+QLZ_MethodExchange.h"
#import <objc/runtime.h>

@interface UIScrollView ()

@property (nonatomic, strong) UIView *qlzRefreshView;
@property (nonatomic, strong) UIView *qlzLoadMoreView;
@property (nonatomic, strong) UIView *qlzShadeView;

@property (nonatomic, assign) UIEdgeInsets originEdgeInsets;

@property (nonatomic, assign) QLZ_RefreshStatus refreshStatus;
@property (nonatomic, assign) QLZ_LoadMoreStatus loadMoreStatus;
@property (nonatomic, assign) QLZ_ComponentScrollType refreshScrollType;
@property (nonatomic, assign) QLZ_ComponentScrollType loadMoreScrollType;

@property (nonatomic, assign) BOOL isAddObserver;

@property (nonatomic, copy) void(^refreshCompletionBlock)(void);
@property (nonatomic, copy) void(^loadMoreCompletionBlock)(void);

@property (nonatomic, copy) void(^refreshNormalStatusBlock)(void);
@property (nonatomic, copy) void(^releaseToRefreshStatusBlock)(void);
@property (nonatomic, copy) void(^refreshingStatusBlock)(void);
@property (nonatomic, copy) void(^refreshScrollPercentBlock)(float percent);

@property (nonatomic, copy) void(^loadMoreNormalStatusBlock)(void);
@property (nonatomic, copy) void(^releaseToLoadMoreStatusBlock)(void);
@property (nonatomic, copy) void(^loadingMoreStatusBlock)(void);
@property (nonatomic, copy) void(^noMoreToLoadStatusBlock)(void);
@property (nonatomic, copy) void(^loadMoreScrollPercentBlock)(float percent);

@end

@implementation UIScrollView (QLZ_Refresh)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] methodExchangeWithOldMethod:@selector(initWithFrame:) newSelect:@selector(qlz_initWithFrame:)];
    });
}

- (id)qlz_initWithFrame:(CGRect)frame {
    self.refreshPullingPercent = 1.0f;
    self.loadMorePullingPercent = 1.0f;
    return [self qlz_initWithFrame:frame];
}

- (void)createShadowView {
    if (self.qlzShadeView || (!self.qlzRefreshView && !self.qlzLoadMoreView)) {
        return;
    }
    self.qlzShadeView = [[UIView alloc] initWithFrame:self.bounds];
    if ([self isKindOfClass:[UICollectionView class]]) {
        self.qlzShadeView.backgroundColor = [UIColor clearColor];
        self.qlzShadeView.hidden = YES;
    }
    else {
        self.qlzShadeView.backgroundColor = [UIColor whiteColor];
        self.qlzShadeView.hidden = NO;
        UIView *superView = self;
        while (superView && [superView.backgroundColor isEqual:[UIColor clearColor]]) {
            superView = superView.superview;
        }
        if (![superView.backgroundColor isEqual:[UIColor clearColor]]) {
            self.qlzShadeView.backgroundColor = superView.backgroundColor;
        }
    }
    if (self.qlzRefreshView) {
        [self insertSubview:self.qlzShadeView aboveSubview:self.qlzRefreshView];
    }
    else if (self.qlzLoadMoreView) {
        [self insertSubview:self.qlzShadeView aboveSubview:self.qlzLoadMoreView];
    }
}

- (void)addRefreshViewWithRefreshingCompletionBlock:(void (^)(void))completion {
    [self addRefreshViewWithScrollType:QLZ_ComponentScrollType_ScrollWithView viewBlock:nil refreshingCompletionBlock:completion];
}

- (void)addRefreshViewWithScrollType:(QLZ_ComponentScrollType)scrollType viewBlock:(UIView *(^)(void))refreshView refreshingCompletionBlock:(void (^)(void))completion {
    if (self.qlzRefreshView) {
        return;
    }
    self.refreshScrollType = scrollType;
    self.alwaysBounceVertical = YES;
    if (refreshView) {
        self.qlzRefreshView = refreshView();
    }
    else {
        self.qlzRefreshView = [[QLZ_RefreshView alloc] init];
    }
    if (scrollType == QLZ_ComponentScrollType_AlwaysFixed || scrollType == QLZ_ComponentScrollType_OnlyScrollWhenMoveCertainDistance) {
        self.qlzRefreshView.y = 0;
    }
    else {
        self.qlzRefreshView.y = -self.qlzRefreshView.height;
    }
    if (self.qlzLoadMoreView) {
        [self insertSubview:self.qlzRefreshView belowSubview:self.qlzLoadMoreView];
    }
    else {
        [self insertSubview:self.qlzRefreshView atIndex:0];
    }
    [self createShadowView];
    self.refreshCompletionBlock = completion;
    self.refreshStatus = QLZ_RefreshStatus_Normal;
}

- (void)addLoadMoreViewWithLoadingMoreCompletionBlock:(void (^)(void))completion {
    [self addLoadMoreViewWithScrollType:QLZ_ComponentScrollType_ScrollWithView viewBlock:nil loadingMoreCompletionBlock:completion];
}

- (void)addLoadMoreViewWithScrollType:(QLZ_ComponentScrollType)scrollType viewBlock:(UIView *(^)(void))loadMoreView loadingMoreCompletionBlock:(void (^)(void))completion {
    if (self.qlzLoadMoreView) {
        return;
    }
    self.loadMoreScrollType = scrollType;
    self.alwaysBounceVertical = YES;
    if (loadMoreView) {
        self.qlzLoadMoreView = loadMoreView();
    }
    else {
        self.qlzLoadMoreView = [[QLZ_LoadMoreView alloc] init];
    }
    if (scrollType == QLZ_ComponentScrollType_AlwaysFixed || scrollType == QLZ_ComponentScrollType_OnlyScrollWhenMoveCertainDistance) {
        self.qlzLoadMoreView.y = self.contentHeight - self.qlzLoadMoreView.height;
    }
    else {
        self.qlzLoadMoreView.y = self.contentHeight + [QLZ_KeyboardManager sharedManager].keyboardHeight;
    }
    if (self.qlzRefreshView) {
        [self insertSubview:self.qlzLoadMoreView belowSubview:self.qlzRefreshView];
    }
    else {
        [self insertSubview:self.qlzLoadMoreView atIndex:0];
    }
    [self createShadowView];
    self.loadMoreCompletionBlock = completion;
    self.loadMoreStatus = QLZ_LoadMoreStatus_Normal;
}

- (void)beginRefresh {
    [self performSelector:@selector(beginToRefresh) withObject:nil afterDelay:0.5f];
}

- (void)beginToRefresh {
    if (self.refreshScrollType == QLZ_ComponentScrollType_AlwaysFixed) {
        self.qlzRefreshView.y = MIN(0, self.offsetY + self.originEdgeInsets.top);
    }
    else if (self.refreshScrollType == QLZ_ComponentScrollType_OnlyScrollWhenMoveCertainDistance) {
        self.qlzRefreshView.y = -MIN(self.qlzRefreshView.height, -MIN(0, self.offsetY + self.originEdgeInsets.top));
    }
    else if (self.refreshScrollType == QLZ_ComponentScrollType_OnlyFixedWhenMoveCertainDistance) {
        self.qlzRefreshView.y = -MAX(self.qlzRefreshView.height, -MIN(0, self.offsetY + self.originEdgeInsets.top));
    }
    else if (self.refreshScrollType == QLZ_ComponentScrollType_ScrollWithView) {
        self.qlzRefreshView.y = -self.qlzRefreshView.height;
    }
    self.refreshStatus = QLZ_RefreshStatus_Refreshing;
}

- (void)addRefreshNormalStatusBlock:(void (^)(void))refreshNormal {
    self.refreshNormalStatusBlock = refreshNormal;
    if (refreshNormal) {
        refreshNormal();
    }
}

- (void)addReleaseToRefreshStatusBlock:(void (^)(void))releaseToRefresh {
    self.releaseToRefreshStatusBlock = releaseToRefresh;
}

- (void)addRefreshingStatusBlock:(void (^)(void))refreshing {
    self.refreshingStatusBlock = refreshing;
}

- (void)addLoadMoreNormalStatusBlock:(void (^)(void))loadMoreNormal {
    self.loadMoreNormalStatusBlock = loadMoreNormal;
    if (loadMoreNormal) {
        loadMoreNormal();
    }
}

- (void)addReleaseToLoadMoreStatusBlock:(void (^)(void))releaseToLoadMore {
    self.releaseToLoadMoreStatusBlock = releaseToLoadMore;
}

- (void)addRefreshScrollPercentBlock:(void (^)(float))percent {
    self.refreshScrollPercentBlock = percent;
}

- (void)addLoadingMoreStatusBlock:(void (^)(void))loadingMore {
    self.loadingMoreStatusBlock = loadingMore;
}

- (void)addNoMoreToLoadStatusBlock:(void (^)(void))noMoreToLoad {
    self.noMoreToLoadStatusBlock = noMoreToLoad;
}

- (void)addLoadMoreScrollPercentBlock:(void (^)(float))percent {
    self.loadMoreScrollPercentBlock = percent;
}

- (void)refreshCompletion {
    if (self.refreshStatus != QLZ_RefreshStatus_None) {
        self.refreshStatus = QLZ_RefreshStatus_Normal;
    }
    [self resetLoadMoreNormal];
}

- (void)loadMoreCompletion {
    if (self.loadMoreStatus != QLZ_LoadMoreStatus_None && self.loadMoreStatus != QLZ_LoadMoreStatus_NoMoreToLoad) {
        self.loadMoreStatus = QLZ_LoadMoreStatus_Normal;
    }
}

- (void)allLoadCompletion {
    [self refreshCompletion];
    [self loadMoreCompletion];
}

- (void)resetLoadMoreNormal {
    if (self.loadMoreStatus == QLZ_LoadMoreStatus_NoMoreToLoad) {
        self.loadMoreStatus = QLZ_LoadMoreStatus_Normal;
        self.insetBottom = self.originEdgeInsets.bottom - self.qlzLoadMoreView.height;
    }
}

- (void)noMoreToLoad {
    if (self.loadMoreStatus != QLZ_LoadMoreStatus_None) {
        self.loadMoreStatus = QLZ_LoadMoreStatus_NoMoreToLoad;
    }
}

#pragma mark superMethods
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview && !self.isAddObserver) {
        [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        if ([self isKindOfClass:[UITableView class]]) {
            [self addObserver:self forKeyPath:@"tableHeaderView" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        }
        self.isAddObserver = YES;
    }
    else if (!newSuperview && self.isAddObserver) {
        [self removeObserver:self forKeyPath:@"contentSize"];
        [self removeObserver:self forKeyPath:@"contentOffset"];
        [self removeObserver:self forKeyPath:@"contentInset"];
        if ([self isKindOfClass:[UITableView class]]) {
            [self removeObserver:self forKeyPath:@"tableHeaderView"];
        }
        self.isAddObserver = NO;
    }
}

- (void)returnPercentBlock {
    if (self.offsetY + self.insetTop < 0 || (self.refreshStatus == QLZ_RefreshStatus_Refreshing && self.offsetY + self.insetTop <= 0)) { // 下拉刷新区域
        float percent = (-(self.offsetY + self.insetTop)) / (self.qlzRefreshView.height * self.refreshPullingPercent);
        percent = MAX(percent, 0);
        if (self.refreshStatus == QLZ_RefreshStatus_Refreshing) {
            if (self.refreshScrollPercentBlock) {
                self.refreshScrollPercentBlock(MAX(percent, 0) + 1);
            }
        }
        else {
            if (self.refreshScrollPercentBlock) {
                self.refreshScrollPercentBlock(percent);
            }
        }
    }
    else if (self.offsetY + self.height > self.contentHeight || (self.loadMoreStatus == QLZ_LoadMoreStatus_LoadingMore && self.offsetY + self.height >= self.contentHeight)) { //上拉加载区域
        float percent = 0;
        if (self.contentHeight >= self.height - self.insetTop) {
            percent = (self.offsetY + self.height - self.contentHeight) / (self.qlzLoadMoreView.height * self.loadMorePullingPercent);
        }
        else {
            percent = (self.offsetY + self.insetTop) / (self.qlzLoadMoreView.height * self.loadMorePullingPercent);
        }
        percent = MAX(percent, 0);
        if (self.loadMoreStatus == QLZ_LoadMoreStatus_LoadingMore) {
            if (self.loadMoreScrollPercentBlock) {
                self.loadMoreScrollPercentBlock(MAX(percent, 0) + 1);
            }
        }
        else {
            if (self.loadMoreScrollPercentBlock) {
                self.loadMoreScrollPercentBlock(percent);
            }
        }
    }
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    id newValue = change[@"new"];
    if ([keyPath isEqualToString:@"contentSize"]) {
        if (self.contentHeight < self.height - self.insetTop - self.insetBottom) {
            self.contentHeight = self.height - self.insetTop - self.insetBottom;
            return;
        }
        self.qlzShadeView.width = self.width;
        self.qlzShadeView.height = self.contentHeight;
    }
    else if ([keyPath isEqualToString:@"contentOffset"]) {
        if (self.refreshScrollType == QLZ_ComponentScrollType_AlwaysFixed) {
            self.qlzRefreshView.y = MIN(0, self.offsetY + self.originEdgeInsets.top);
        }
        else if (self.refreshScrollType == QLZ_ComponentScrollType_OnlyScrollWhenMoveCertainDistance) {
            self.qlzRefreshView.y = -MIN(self.qlzRefreshView.height, -MIN(0, self.offsetY + self.originEdgeInsets.top));
        }
        else if (self.refreshScrollType == QLZ_ComponentScrollType_OnlyFixedWhenMoveCertainDistance) {
            self.qlzRefreshView.y = -MAX(self.qlzRefreshView.height, -MIN(0, self.offsetY + self.originEdgeInsets.top));
        }
        else if (self.refreshScrollType == QLZ_ComponentScrollType_ScrollWithView) {
            self.qlzRefreshView.y = -self.qlzRefreshView.height;
        }
        
        if (self.loadMoreScrollType == QLZ_ComponentScrollType_AlwaysFixed) {
            self.qlzLoadMoreView.y = MAX(self.contentHeight - self.qlzLoadMoreView.height, self.offsetY + self.height - self.qlzLoadMoreView.height);
        }
        else if (self.loadMoreScrollType == QLZ_ComponentScrollType_OnlyScrollWhenMoveCertainDistance) {
            self.qlzLoadMoreView.y = MIN(self.contentHeight, MAX(self.contentHeight - self.qlzLoadMoreView.height, self.offsetY + self.height - self.qlzLoadMoreView.height));
        }
        else if (self.loadMoreScrollType == QLZ_ComponentScrollType_OnlyFixedWhenMoveCertainDistance) {
            self.qlzLoadMoreView.y = MAX(self.contentHeight, MAX(self.contentHeight - self.qlzLoadMoreView.height, self.offsetY + self.height - self.qlzLoadMoreView.height)) + [QLZ_KeyboardManager sharedManager].keyboardHeight;
        }
        else if (self.loadMoreScrollType == QLZ_ComponentScrollType_ScrollWithView) {
            self.qlzLoadMoreView.y = self.contentHeight + [QLZ_KeyboardManager sharedManager].keyboardHeight;
        }
        [self returnPercentBlock];
        if (self.refreshStatus == QLZ_RefreshStatus_Refreshing || self.loadMoreStatus == QLZ_LoadMoreStatus_LoadingMore) {
            return;
        }
        if (self.offsetY + self.insetTop < 0) { // 下拉刷新区域
            if (self.refreshStatus == QLZ_RefreshStatus_None) {
                return;
            }
            if (fabs(self.offsetY + self.insetTop) > self.qlzRefreshView.height * self.refreshPullingPercent) { //下拉释放刷新区域
                if (self.isDragging) {
                    self.refreshStatus = QLZ_RefreshStatus_ReleaseToRefresh;
                }
                else if (self.refreshStatus == QLZ_RefreshStatus_ReleaseToRefresh) {
                    self.refreshStatus = QLZ_RefreshStatus_Refreshing;
                }
            }
            else {
                self.refreshStatus = QLZ_RefreshStatus_Normal;
            }
        }
        else if (self.offsetY + self.height > self.contentHeight) { //上拉加载区域
            if (self.loadMoreStatus == QLZ_LoadMoreStatus_None || self.loadMoreStatus == QLZ_LoadMoreStatus_NoMoreToLoad) {
                return;
            }
            if (self.offsetY + self.height > self.contentHeight + self.qlzLoadMoreView.height * self.loadMorePullingPercent) { //上拉释放加载区域
                if (self.isDragging) {
                    self.loadMoreStatus = QLZ_LoadMoreStatus_ReleaseToLoadMore;
                }
                else if (self.loadMoreStatus == QLZ_LoadMoreStatus_ReleaseToLoadMore) {
                    self.loadMoreStatus = QLZ_LoadMoreStatus_LoadingMore;
                }
            }
            else {
                self.loadMoreStatus = QLZ_LoadMoreStatus_Normal;
            }
        }
    }
    else if ([keyPath isEqualToString:@"contentInset"]) {
        UIEdgeInsets newContentInset = ((NSValue *)newValue).UIEdgeInsetsValue;
        if (self.refreshStatus != QLZ_RefreshStatus_Refreshing && self.loadMoreStatus != QLZ_LoadMoreStatus_LoadingMore) {
            self.originEdgeInsets = UIEdgeInsetsMake(newContentInset.top, newContentInset.left, newContentInset.bottom, newContentInset.right);
            self.qlzShadeView.width = self.width;
            self.qlzShadeView.height = self.contentHeight;
            if (self.loadMoreScrollType == QLZ_ComponentScrollType_AlwaysFixed || self.loadMoreScrollType == QLZ_ComponentScrollType_OnlyScrollWhenMoveCertainDistance) {
                self.qlzLoadMoreView.y = MAX(self.contentHeight - self.qlzLoadMoreView.height, self.offsetY + self.height - self.qlzLoadMoreView.height);
            }
        }
    }
    else if ([keyPath isEqualToString:@"tableHeaderView"]) {
        UIView *headerView = (UIView *)newValue;
        if ([headerView isKindOfClass:[UISearchBar class]]) {
            UIView *view = [[UIView alloc] initWithFrame:headerView.frame];
            ((UITableView *)self).tableHeaderView = nil;
            [view addSubview:headerView];
            ((UITableView *)self).tableHeaderView = view;
        }
    }
}

#pragma mark SetAndGetMethods
- (void)setRefreshStatus:(QLZ_RefreshStatus)refreshStatus {
    if (refreshStatus == self.refreshStatus) {
        return;
    }
    objc_setAssociatedObject(self, @"QLZ_Refresh_RefreshStatus", [NSNumber numberWithInteger:refreshStatus], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (refreshStatus == QLZ_RefreshStatus_Normal) {
        [UIView animateWithDuration:0.2f animations:^{
            self.insetTop = self.originEdgeInsets.top;
        } completion:^(BOOL finished) {
            if (self.refreshStatus != refreshStatus) {
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.refreshNormalStatusBlock) {
                    self.refreshNormalStatusBlock();
                }
            });
        }];
    }
    else if (refreshStatus == QLZ_RefreshStatus_ReleaseToRefresh) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.releaseToRefreshStatusBlock) {
                self.releaseToRefreshStatusBlock();
            }
        });
    }
    else if (refreshStatus == QLZ_RefreshStatus_Refreshing) {
        [UIView animateWithDuration:0.2f animations:^{
            self.insetTop = self.originEdgeInsets.top + self.qlzRefreshView.height;
//            self.contentOffset = CGPointMake(0, -self.insetTop);
            if (self.refreshScrollType == QLZ_ComponentScrollType_AlwaysFixed || self.refreshScrollType == QLZ_ComponentScrollType_OnlyScrollWhenMoveCertainDistance) {
                self.qlzRefreshView.y = -self.qlzRefreshView.height;
            }
        } completion:^(BOOL finished) {
            if (self.refreshStatus != refreshStatus) {
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.refreshingStatusBlock) {
                    self.refreshingStatusBlock();
                }
                if (self.refreshCompletionBlock) {
                    self.refreshCompletionBlock();
                }
            });
        }];
    }
    if ([self.qlzRefreshView isKindOfClass:[QLZ_RefreshView class]]) {
        ((QLZ_RefreshView *)self.qlzRefreshView).status = refreshStatus;
    }
}

- (QLZ_RefreshStatus)refreshStatus {
    NSNumber *number = objc_getAssociatedObject(self, @"QLZ_Refresh_RefreshStatus");
    return number.integerValue;
}

- (void)setLoadMoreStatus:(QLZ_LoadMoreStatus)loadMoreStatus {
    if (loadMoreStatus == self.loadMoreStatus) {
        return;
    }
    objc_setAssociatedObject(self, @"QLZ_Refresh_LoadMoreStatus", [NSNumber numberWithInteger:loadMoreStatus], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (loadMoreStatus == QLZ_LoadMoreStatus_Normal) {
        [UIView animateWithDuration:0.2f animations:^{
            self.insetBottom = self.originEdgeInsets.bottom;
        } completion:^(BOOL finished) {
            if (self.loadMoreStatus != loadMoreStatus) {
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.loadMoreNormalStatusBlock) {
                    self.loadMoreNormalStatusBlock();
                }
            });
        }];
    }
    else if (loadMoreStatus == QLZ_LoadMoreStatus_ReleaseToLoadMore) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.releaseToLoadMoreStatusBlock) {
                self.releaseToLoadMoreStatusBlock();
            }
        });
    }
    else if (loadMoreStatus == QLZ_LoadMoreStatus_LoadingMore) {
        [UIView animateWithDuration:0.2f animations:^{
            self.insetBottom = self.originEdgeInsets.bottom + self.qlzLoadMoreView.height;
            if (self.loadMoreScrollType == QLZ_ComponentScrollType_AlwaysFixed || self.loadMoreScrollType == QLZ_ComponentScrollType_OnlyScrollWhenMoveCertainDistance) {
                self.qlzLoadMoreView.y = MAX(self.contentHeight - self.qlzLoadMoreView.height, self.offsetY + self.height - self.qlzLoadMoreView.height);
            }
        } completion:^(BOOL finished) {
            if (self.loadMoreStatus != loadMoreStatus) {
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.loadingMoreStatusBlock) {
                    self.loadingMoreStatusBlock();
                }
                if (self.loadMoreCompletionBlock) {
                    self.loadMoreCompletionBlock();
                }
            });
        }];
    }
    else if (loadMoreStatus == QLZ_LoadMoreStatus_NoMoreToLoad) {
        [UIView animateWithDuration:0.2f animations:^{
            self.insetBottom = self.originEdgeInsets.bottom + self.qlzLoadMoreView.height;
            if (self.loadMoreScrollType == QLZ_ComponentScrollType_AlwaysFixed || self.loadMoreScrollType == QLZ_ComponentScrollType_OnlyScrollWhenMoveCertainDistance) {
                self.qlzLoadMoreView.y = MAX(self.contentHeight - self.qlzLoadMoreView.height, self.offsetY + self.height - self.qlzLoadMoreView.height);
            }
        } completion:^(BOOL finished) {
            if (self.loadMoreStatus != loadMoreStatus) {
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.noMoreToLoadStatusBlock) {
                    self.noMoreToLoadStatusBlock();
                }
            });
        }];
    }
    if ([self.qlzLoadMoreView isKindOfClass:[QLZ_LoadMoreView class]]) {
        ((QLZ_LoadMoreView *)self.qlzLoadMoreView).status = loadMoreStatus;
    }
}

- (QLZ_LoadMoreStatus)loadMoreStatus {
    NSNumber *number = objc_getAssociatedObject(self, @"QLZ_Refresh_LoadMoreStatus");
    return number.integerValue;
}

- (void)setRefreshScrollType:(QLZ_ComponentScrollType)refreshScrollType {
    objc_setAssociatedObject(self, @"QLZ_Refresh_RefreshScrollType", [NSNumber numberWithInteger:refreshScrollType], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QLZ_ComponentScrollType)refreshScrollType {
    NSNumber *number = objc_getAssociatedObject(self, @"QLZ_Refresh_RefreshScrollType");
    return number.integerValue;
}

- (void)setLoadMoreScrollType:(QLZ_ComponentScrollType)loadMoreScrollType {
    objc_setAssociatedObject(self, @"QLZ_Refresh_LoadMoreScrollType", [NSNumber numberWithInteger:loadMoreScrollType], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QLZ_ComponentScrollType)loadMoreScrollType {
    NSNumber *number = objc_getAssociatedObject(self, @"QLZ_Refresh_LoadMoreScrollType");
    return number.integerValue;
}

- (void)setRefreshPullingPercent:(float)refreshPullingPercent {
    objc_setAssociatedObject(self, @"QLZ_Refresh_RefreshPullingPercent", [NSNumber numberWithFloat:refreshPullingPercent], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (float)refreshPullingPercent {
    NSNumber *number = objc_getAssociatedObject(self, @"QLZ_Refresh_RefreshPullingPercent");
    return number.floatValue;
}

- (void)setLoadMorePullingPercent:(float)loadMorePullingPercent {
    objc_setAssociatedObject(self, @"QLZ_Refresh_LoadMorePullingPercent", [NSNumber numberWithFloat:loadMorePullingPercent], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (float)loadMorePullingPercent {
    NSNumber *number = objc_getAssociatedObject(self, @"QLZ_Refresh_LoadMorePullingPercent");
    return number.floatValue;
}

- (void)setQlzRefreshView:(UIView *)qlzRefreshView {
    objc_setAssociatedObject(self, @"QLZ_Refresh_RefreshView", qlzRefreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)qlzRefreshView {
    return objc_getAssociatedObject(self, @"QLZ_Refresh_RefreshView");
}

- (void)setQlzLoadMoreView:(UIView *)qlzLoadMoreView {
    objc_setAssociatedObject(self, @"QLZ_Refresh_LoadMoreView", qlzLoadMoreView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)qlzLoadMoreView {
    return objc_getAssociatedObject(self, @"QLZ_Refresh_LoadMoreView");
}

- (void)setQlzShadeView:(UIView *)qlzShadeView {
    objc_setAssociatedObject(self, @"QLZ_Refresh_ShadeView", qlzShadeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)qlzShadeView {
    return objc_getAssociatedObject(self, @"QLZ_Refresh_ShadeView");
}

- (void)setOriginEdgeInsets:(UIEdgeInsets)originEdgeInsets {
    objc_setAssociatedObject(self, @"QLZ_Refresh_OriginEdgeInsets", [NSValue valueWithUIEdgeInsets:originEdgeInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)originEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, @"QLZ_Refresh_OriginEdgeInsets");
    return value.UIEdgeInsetsValue;
}

- (void)setIsAddObserver:(BOOL)isAddObserver {
    objc_setAssociatedObject(self, @"QLZ_Refresh_IsAddObserver", [NSNumber numberWithBool:isAddObserver], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isAddObserver {
    NSNumber *number = objc_getAssociatedObject(self, @"QLZ_Refresh_IsAddObserver");
    return number.boolValue;
}

- (void)setRefreshCompletionBlock:(void (^)(void))refreshCompletionBlock {
    objc_setAssociatedObject(self, @"QLZ_Refresh_RefreshCompletionBlock", refreshCompletionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))refreshCompletionBlock {
    return objc_getAssociatedObject(self, @"QLZ_Refresh_RefreshCompletionBlock");
}

- (void)setLoadMoreCompletionBlock:(void (^)(void))loadMoreCompletionBlock {
    objc_setAssociatedObject(self, @"QLZ_Refresh_LoadMoreCompletionBlock", loadMoreCompletionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))loadMoreCompletionBlock {
    return objc_getAssociatedObject(self, @"QLZ_Refresh_LoadMoreCompletionBlock");
}

- (void)setRefreshNormalStatusBlock:(void (^)(void))refreshNormalStatusBlock {
    objc_setAssociatedObject(self, @"QLZ_Refresh_RefreshNormalStatusBlock", refreshNormalStatusBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))refreshNormalStatusBlock {
    return objc_getAssociatedObject(self, @"QLZ_Refresh_RefreshNormalStatusBlock");
}

- (void)setReleaseToRefreshStatusBlock:(void (^)(void))releaseToRefreshStatusBlock {
    objc_setAssociatedObject(self, @"QLZ_Refresh_ReleaseToRefreshStatusBlock", releaseToRefreshStatusBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))releaseToRefreshStatusBlock {
    return objc_getAssociatedObject(self, @"QLZ_Refresh_ReleaseToRefreshStatusBlock");
}

- (void)setRefreshingStatusBlock:(void (^)(void))refreshingStatusBlock {
    objc_setAssociatedObject(self, @"QLZ_Refresh_RefreshingStatusBlock", refreshingStatusBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))refreshingStatusBlock {
    return objc_getAssociatedObject(self, @"QLZ_Refresh_RefreshingStatusBlock");
}

- (void)setRefreshScrollPercentBlock:(void (^)(float))refreshScrollPercentBlock {
    objc_setAssociatedObject(self, @"QLZ_Refresh_RefreshScrollPercentBlock", refreshScrollPercentBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(float))refreshScrollPercentBlock {
    return objc_getAssociatedObject(self, @"QLZ_Refresh_RefreshScrollPercentBlock");
}

- (void)setLoadMoreNormalStatusBlock:(void (^)(void))loadMoreNormalStatusBlock {
    objc_setAssociatedObject(self, @"QLZ_Refresh_LoadMoreNormalStatusBlock", loadMoreNormalStatusBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))loadMoreNormalStatusBlock {
    return objc_getAssociatedObject(self, @"QLZ_Refresh_LoadMoreNormalStatusBlock");
}

- (void)setReleaseToLoadMoreStatusBlock:(void (^)(void))releaseToLoadMoreStatusBlock {
    objc_setAssociatedObject(self, @"QLZ_Refresh_ReleaseToLoadMoreStatusBlock", releaseToLoadMoreStatusBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))releaseToLoadMoreStatusBlock {
    return objc_getAssociatedObject(self, @"QLZ_Refresh_ReleaseToLoadMoreStatusBlock");
}

- (void)setLoadingMoreStatusBlock:(void (^)(void))loadingMoreStatusBlock {
    objc_setAssociatedObject(self, @"QLZ_Refresh_LoadingMoreStatusBlock", loadingMoreStatusBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))loadingMoreStatusBlock {
    return objc_getAssociatedObject(self, @"QLZ_Refresh_LoadingMoreStatusBlock");
}

- (void)setNoMoreToLoadStatusBlock:(void (^)(void))noMoreToLoadStatusBlock {
    objc_setAssociatedObject(self, @"QLZ_Refresh_NoMoreToLoadStatusBlock", noMoreToLoadStatusBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))noMoreToLoadStatusBlock {
    return objc_getAssociatedObject(self, @"QLZ_Refresh_NoMoreToLoadStatusBlock");
}

- (void)setLoadMoreScrollPercentBlock:(void (^)(float))loadMoreScrollPercentBlock {
    objc_setAssociatedObject(self, @"QLZ_Refresh_LoadMoreScrollPercentBlock", loadMoreScrollPercentBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(float))loadMoreScrollPercentBlock {
    return objc_getAssociatedObject(self, @"QLZ_Refresh_LoadMoreScrollPercentBlock");
}

@end
