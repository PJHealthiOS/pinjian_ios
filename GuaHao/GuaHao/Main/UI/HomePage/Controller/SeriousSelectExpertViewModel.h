//
//  SeriousSelectExpertViewModel.h
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/1.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DoctorVO.h"
typedef void(^HospitalDataAction)(NSArray *array,BOOL error);
@interface SeriousSelectExpertViewModel : NSObject
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int count;
@property (nonatomic, assign) BOOL isMore;
@property (nonatomic, strong) NSNumber *hosID;
@property (nonatomic, strong) NSNumber *depID;
///返回分区数
-(NSInteger)getNumberSectionInTableView;
///返回行数
-(NSInteger)getNumberRowInSection;
///返回行高
-(CGFloat)getHeightForRow;
///请求数据
-(void)getDataAction:(HospitalDataAction)action;
///返回某行对应的model
-(DoctorVO *)getModelWithIndexPath:(NSIndexPath *)indexPath;
///
///
@end
