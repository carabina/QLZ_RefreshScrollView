//
//  NSObject+QLZ_MethodExchange.m
//  QLZ_RefreshScrollView
//
//  Created by 张庆龙 on 16/8/2.
//  Copyright © 2016年 张庆龙. All rights reserved.
//

#import "NSObject+QLZ_MethodExchange.h"
#import <objc/runtime.h>

@implementation NSObject (QLZ_MethodExchange)

+ (void)methodExchangeWithOldMethod:(SEL)oldSelect newSelect:(SEL)newSelect {
    Method oldMethod = class_getInstanceMethod([self class], oldSelect);
    Method newMethod = class_getInstanceMethod([self class], newSelect);
    class_addMethod([self class], newSelect, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    newMethod = class_getInstanceMethod([self class], newSelect);
    method_exchangeImplementations(oldMethod, newMethod);
}

@end
