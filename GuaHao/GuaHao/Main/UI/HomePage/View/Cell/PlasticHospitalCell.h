//
//  PlasticHospitalCell.h
//  GuaHao
//
//  Created by PJYL on 2018/6/13.
//  Copyright © 2018年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlasticHospitalModel.h"

typedef void(^OperationAction)(NSIndexPath *indexPath);


@interface PlasticHospitalCell : UITableViewCell
@property (nonatomic , copy) OperationAction myAction;

-(void)setCell:(PlasticHospitalModel*)hospital indexPath:(NSIndexPath *)indexPath operationStr:(NSString *)operationStr;

-(void)operationClick:(OperationAction)action;

@end
