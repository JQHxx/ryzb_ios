//
//  MyCouponCenterViewController.m
//  JMBaseProject
//
//  Created by 潘传标 on 2019/9/6.
//  Copyright © 2019 liuny. All rights reserved.
//

#import "MyCouponCenterViewController.h"
#import "MyCouponPageViewController.h"

@interface MyCouponCenterViewController ()

@property (nonatomic, strong) MyCouponPageViewController *pageVC;

@end

@implementation MyCouponCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)initControl
{
    self.title = @"我的优惠劵";
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"MyCouponPageViewController"]){
        self.pageVC = (MyCouponPageViewController *)segue.destinationViewController;
    }
}

@end
