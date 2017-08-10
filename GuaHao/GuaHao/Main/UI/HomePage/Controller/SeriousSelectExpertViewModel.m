//
//  SeriousSelectExpertViewModel.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/1.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "SeriousSelectExpertViewModel.h"

@implementation SeriousSelectExpertViewModel
-(instancetype)init{
    if (self = [super init]) {
        _items = [NSMutableArray array];
        _page = 1;
    }
    return self;
}
///返回分区数
-(NSInteger)getNumberSectionInTableView{
    return 1;
}
///返回行数
-(NSInteger)getNumberRowInSection{
    return self.items.count;
}
///返回行高
-(CGFloat)getHeightForRow{
    return 140;
}
///请求数据
-(void)getDataAction:(HospitalDataAction)action{
    if (!self.isMore) {
        [self.items removeAllObjects];
    }else{
        self.page ++;
    }
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance] getExpertDoctorList:self.hosID departmentID:self.depID filterDate:nil apm:nil type:nil keywords:nil size:6 page:self.page andCallback:^(id data) {
        
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    if (arr&&arr.count>0) {
                        for (int i = 0; i<arr.count; i++) {
                            DoctorVO *vo = [DoctorVO mj_objectWithKeyValues:arr[i]];
                            [weakSelf.items addObject:vo];
                        }
                    }
                    action(weakSelf.items,YES);
                    if (weakSelf.items.count ==0) {
//                        [self inputToast:@"没有搜索到相关医生！"];
                    }
                }
                
            }else{
//                [weakSelf inputToast:msg];
                weakSelf.page --;
                action(weakSelf.items,NO);
            }
        }
    }];
}
///返回某行对应的model
-(DoctorVO *)getModelWithIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.items.count) {
        return [self.items objectAtIndex:indexPath.row];
    }else{
        return nil;
    }
}

@end
