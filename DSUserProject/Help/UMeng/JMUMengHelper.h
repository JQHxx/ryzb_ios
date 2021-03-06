//
//  JMUMengHelper.h
//  iOSProject
//
//  Created by HuXuPeng on 2017/12/29.
//  Copyright © 2017年 HuXuPeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMessage.h"
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import <UMShare/UMShare.h>

@interface JMUMengHelper : NSObject
/*!
 * 启动友盟统计功能
 */
+ (void)UMAnalyticStart;

/**
 初始化第三方登录和分享
 */
+ (void)UMSocialStart;


#pragma mark - UM第三方登录
+ (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType completion:(void(^)(UMSocialUserInfoResponse *result, NSError *error))completion;


+ (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType shareTitle:(NSString *)title subTitle:(NSString *)subTitle thumbImage:(id)thumbImage shareURL:(NSString *)shareURL;
#pragma mark - UM统计

/// 在viewWillAppear调用,才能够获取正确的页面访问路径、访问深度（PV）的数据
+ (void)beginLogPageView:(__unsafe_unretained Class)pageView;

/// 在viewDidDisappeary调用，才能够获取正确的页面访问路径、访问深度（PV）的数据
+ (void)endLogPageView:(__unsafe_unretained Class)pageView;


/*!
 * 自定义名称
 */
/// 在viewWillAppear调用,才能够获取正确的页面访问路径、访问深度（PV）的数据
+(void)beginLogPageViewName:(NSString *)pageViewName;

/// 在viewDidDisappeary调用，才能够获取正确的页面访问路径、访问深度（PV）的数据
+(void)endLogPageViewName:(NSString *)pageViewName;
@end
