//
//  BindPhoneViewController.h
//  JMBaseProject
//
//  Created by Liuny on 2018/11/7.
//  Copyright © 2018 liuny. All rights reserved.
//

#import "JMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BindPhoneViewController : JMBaseViewController
@property (nonatomic, copy) void(^completeBlock)(JMBaseResponse *response);
@property(nonatomic,copy)NSString *ids;
@property(nonatomic,copy)NSString *typeStr;
@end

NS_ASSUME_NONNULL_END
