//
//  NSObject+QLZ_MethodExchange.h
//  QLZ_RefreshScrollView
//
//  Created by 张庆龙 on 16/8/2.
//  Copyright © 2016年 张庆龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (QLZ_MethodExchange)

+ (void)methodExchangeWithOldMethod:(SEL)oldSelect newSelect:(SEL)newSelect;

@end
