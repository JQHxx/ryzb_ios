//
//  AfterSaleCell.h
//  JMBaseProject
//
//  Created by Liuny on 2019/6/27.
//  Copyright © 2019 liuny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AfterSaleModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol AfterSaleCellDelegate <NSObject>

-(void)clickOperationButton:(NSInteger)index title:(NSString *)buttonTitle;

@end
@interface AfterSaleCell : UITableViewCell
@property (assign, nonatomic) NSInteger index;
@property (weak, nonatomic) id<AfterSaleCellDelegate>delegate;
@property (strong, nonatomic) AfterSaleModel *cellData;
@end

NS_ASSUME_NONNULL_END
