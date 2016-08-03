//
//  UIScrollView+QLZ_Frame.h
//  QLZ_RefreshScrollView
//
//  Created by 张庆龙 on 16/8/2.
//  Copyright © 2016年 张庆龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (QLZ_Frame)

@property (assign, nonatomic) CGFloat insetTop;
@property (assign, nonatomic) CGFloat insetBottom;
@property (assign, nonatomic) CGFloat insetLeft;
@property (assign, nonatomic) CGFloat insetRight;

@property (assign, nonatomic) CGFloat offsetX;
@property (assign, nonatomic) CGFloat offsetY;

@property (assign, nonatomic) CGFloat contentWidth;
@property (assign, nonatomic) CGFloat contentHeight;

@end
