//
//  MyCouponDetailController.h
//  JMBaseProject
//
//  Created by 潘传标 on 2019/9/6.
//  Copyright © 2019 liuny. All rights reserved.
//

#import "JMBaseViewController.h"
#import "MyCouponModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCouponDetailController : JMBaseViewController
@property (nonatomic, strong)MyCouponModel *couponData;

@property (nonatomic, assign) BOOL canUse;//是否可用


@end

NS_ASSUME_NONNULL_END
