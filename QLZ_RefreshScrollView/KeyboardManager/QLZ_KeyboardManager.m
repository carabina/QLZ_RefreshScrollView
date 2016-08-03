//
//  QLZ_KeyboardManager.m
//  QLZ_RefreshScrollView
//
//  Created by 张庆龙 on 16/2/4.
//  Copyright © 2016年 张庆龙. All rights reserved.
//

#import "QLZ_KeyboardManager.h"

static QLZ_KeyboardManager *keyboardManager = nil;

@implementation QLZ_KeyboardManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keyboardManager = [[QLZ_KeyboardManager alloc] init];
    });
    return keyboardManager;
}

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification  object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *dict = notification.userInfo;
    self.keyboardHeight = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.keyboardAppear = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.keyboardHeight = 0;
    self.keyboardAppear = NO;
}

@end
