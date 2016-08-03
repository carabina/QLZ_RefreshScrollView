//
//  QLZ_KeyboardManager.h
//  QLZ_RefreshScrollView
//
//  Created by 张庆龙 on 16/2/4.
//  Copyright © 2016年 张庆龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLZ_KeyboardManager : NSObject

@property (nonatomic, assign) BOOL keyboardAppear;
@property (nonatomic, assign) CGFloat keyboardHeight;

+ (instancetype)sharedManager;

@end
