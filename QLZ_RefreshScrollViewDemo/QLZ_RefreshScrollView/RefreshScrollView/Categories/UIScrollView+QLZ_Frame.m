//
//  UIScrollView+QLZ_Frame.m
//  QLZ_RefreshScrollView
//
//  Created by 张庆龙 on 16/8/2.
//  Copyright © 2016年 张庆龙. All rights reserved.
//

#import "UIScrollView+QLZ_Frame.h"

@implementation UIScrollView (QLZ_Frame)

- (void)setInsetTop:(CGFloat)insetTop {
    UIEdgeInsets inset = self.contentInset;
    inset.top = insetTop;
    self.contentInset = inset;
}

- (CGFloat)insetTop {
    return self.contentInset.top;
}

- (void)setInsetBottom:(CGFloat)insetBottom {
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = insetBottom;
    self.contentInset = inset;
}

- (CGFloat)insetBottom {
    return self.contentInset.bottom;
}

- (void)setInsetLeft:(CGFloat)insetLeft {
    UIEdgeInsets inset = self.contentInset;
    inset.left = insetLeft;
    self.contentInset = inset;
}

- (CGFloat)insetLeft {
    return self.contentInset.left;
}

- (void)setInsetRight:(CGFloat)insetRight {
    UIEdgeInsets inset = self.contentInset;
    inset.right = insetRight;
    self.contentInset = inset;
}

- (CGFloat)insetRight {
    return self.contentInset.right;
}

- (void)setOffsetX:(CGFloat)offsetX {
    CGPoint offset = self.contentOffset;
    offset.x = offsetX;
    self.contentOffset = offset;
}

- (CGFloat)offsetX {
    return self.contentOffset.x;
}

- (void)setOffsetY:(CGFloat)offsetY {
    CGPoint offset = self.contentOffset;
    offset.y = offsetY;
    self.contentOffset = offset;
}

- (CGFloat)offsetY {
    return self.contentOffset.y;
}

- (void)setContentWidth:(CGFloat)contentWidth {
    CGSize size = self.contentSize;
    size.width = contentWidth;
    self.contentSize = size;
}

- (CGFloat)contentWidth {
    return self.contentSize.width;
}

- (void)setContentHeight:(CGFloat)contentHeight {
    CGSize size = self.contentSize;
    size.height = contentHeight;
    self.contentSize = size;
}

- (CGFloat)contentHeight {
    return self.contentSize.height;
}

@end
