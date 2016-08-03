//
//  QLZ_RefreshStatus.h
//  QLZ_Refresh
//
//  Created by 张庆龙 on 16/1/16.
//  Copyright © 2016年 张庆龙. All rights reserved.
//

typedef NS_ENUM(NSUInteger, QLZ_RefreshStatus) {
    QLZ_RefreshStatus_None,
    QLZ_RefreshStatus_Normal,
    QLZ_RefreshStatus_ReleaseToRefresh,
    QLZ_RefreshStatus_Refreshing,
};

typedef NS_ENUM(NSUInteger, QLZ_LoadMoreStatus) {
    QLZ_LoadMoreStatus_None,
    QLZ_LoadMoreStatus_Normal,
    QLZ_LoadMoreStatus_ReleaseToLoadMore,
    QLZ_LoadMoreStatus_LoadingMore,
    QLZ_LoadMoreStatus_NoMoreToLoad
};
