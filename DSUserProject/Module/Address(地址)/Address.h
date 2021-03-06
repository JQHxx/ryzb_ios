//
//  Address.h
//  JMBaseProject
//
//  Created by Liuny on 2019/1/23.
//  Copyright © 2019 liuny. All rights reserved.
//

#ifndef Address_h
#define Address_h

#define kUrlAddressList         fPinUrl(@"api/address/list")//用户地址列表
#define kUrlAddressAdd          fPinUrl(@"api/address/add")//新增用户地址
#define kUrlAddressEdit         fPinUrl(@"api/address/edit")//修改地址
#define kUrlAddressDelte        fPinUrl(@"api/address/del")//删除收货地址


/*
 *通知
 */
#define kNotificationAddressAddSuccess  @"AddressAddSuccess"
#define kNotificationAddressEditSuccess @"AddressEditSuccess"


#import "AddressModel.h"

#endif /* Address_h */
