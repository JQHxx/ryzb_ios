//
//  JMNotificationMacro.h
//  JMBaseProject
//
//  Created by liuny on 2018/7/14.
//  Copyright © 2018年 liuny. All rights reserved.
//

/*
 *存放Notificaiton宏
 */

#ifndef JMNotificationMacro_h
#define JMNotificationMacro_h


//用户更新头像
#define kNotificationUserUpdateHead          @"UserUpdateHead"
#define kNotificationUserUpdateName           @"UserUpdateName"

#define kNotificationLiveOnlinePeopleChange     @"LiveOnlinePeopleChange"
#define kNotificationLoginOtherDevice           @"LoginOtherDevice"
#define kNotificationLiveAttentionChange        @"LiveAttentionChange"

#define kNotificationOrderRefresh               @"OrderRefresh"

#define kNotificationSystemNotice              @"SystemNotice" //系统新消息

#define kNotificationOrderPaying               @"OrderPaying" //支付中
#define kNotificationOrderPaySuccess           @"OrderPaySuccess" //支付成功

#define kNotificationLiveRoomBanned          @"LiveRoomBanned" //直播间禁言

#define kNotificationMarketTypeChange        @"MarketTypeChange" //首页直播商城切换通知 0直播 1商城

#define kNotificationLiveError          @"LiveError"//直播异常中断
#endif /* JMNotificationMacro_h */