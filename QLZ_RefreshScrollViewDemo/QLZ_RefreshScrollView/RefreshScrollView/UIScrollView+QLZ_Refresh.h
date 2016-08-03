//
//  UIScrollView+QLZ_Refresh.h
//  QLZ_RefreshScrollView
//
//  Created by 张庆龙 on 16/2/3.
//  Copyright © 2016年 张庆龙. All rights reserved.
//

#import <UIKit/UIKit.h>

//元件滑动样式
typedef NS_ENUM(NSUInteger, QLZ_ComponentScrollType) {
    QLZ_ComponentScrollType_ScrollWithView, //跟着scrollView滑动 默认样式
    QLZ_ComponentScrollType_OnlyFixedWhenMoveCertainDistance, //开始跟随scrollView滚动，当滚动超过一定距离时固定
    QLZ_ComponentScrollType_OnlyScrollWhenMoveCertainDistance, //开始时固定，当滚动超过一定距离时跟随scrollView滑动
    QLZ_ComponentScrollType_AlwaysFixed //不跟着scrollView滑动，永远固定
};

@interface UIScrollView (QLZ_Refresh)

@property (nonatomic, assign) float refreshPullingPercent;  //默认 1
@property (nonatomic, assign) float loadMorePullingPercent;  //默认 1

//用自带样式返回Refresh和LoadMore block:刷新时调取的方法
- (void)addRefreshViewWithRefreshingCompletionBlock:(void (^)(void))completion;
- (void)addLoadMoreViewWithLoadingMoreCompletionBlock:(void (^)(void))completion;

//用自己的样式返回Refresh和LoadMore block:刷新时调取的方法 view可以传nil则用自带样式返回
- (void)addRefreshViewWithScrollType:(QLZ_ComponentScrollType)scrollType viewBlock:(UIView * (^)(void))refreshView refreshingCompletionBlock:(void (^)(void))completion;
- (void)addLoadMoreViewWithScrollType:(QLZ_ComponentScrollType)scrollType viewBlock:(UIView *(^)(void))loadMoreView loadingMoreCompletionBlock:(void (^)(void))completion;

- (void)beginRefresh;

//Refresh不同状态展示的样式返回
//如果使用自己的样式则必须实现不用样式的返回 否则只能展示默认样式
- (void)addRefreshNormalStatusBlock:(void (^)(void))refreshNormal;
- (void)addReleaseToRefreshStatusBlock:(void (^)(void))releaseToRefresh;
- (void)addRefreshingStatusBlock:(void (^)(void))refreshing;
//返回下拉刷新时拉动的比例 可能大于1 最小是0
//当滑动是需要有动画效果时使用
- (void)addRefreshScrollPercentBlock:(void (^)(float percent))percent;

//LoadMore不同状态展示的样式返回
//如果使用自己的样式则必须实现不用样式的返回 否则只能展示默认样式
- (void)addLoadMoreNormalStatusBlock:(void (^)(void))loadMoreNormal;
- (void)addReleaseToLoadMoreStatusBlock:(void (^)(void))releaseToLoadMore;
- (void)addLoadingMoreStatusBlock:(void (^)(void))loadingMore;
- (void)addNoMoreToLoadStatusBlock:(void (^)(void))noMoreToLoad;
//返回上拉时拉动的比例 可能大于1 最小是0
//当滑动是需要有动画效果时使用
- (void)addLoadMoreScrollPercentBlock:(void (^)(float percent))percent;

//当加载完成之后重置状态的方法
- (void)refreshCompletion;
- (void)loadMoreCompletion;
- (void)allLoadCompletion;
- (void)noMoreToLoad;

@end
