//
//  ConditionRemarksVC.h
//  GuaHao
//
//  Created by 123456 on 16/4/11.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConditionRemarksDelegate <NSObject>
-(void) delegateConditionRemark:(NSMutableDictionary*) value;
@end

@interface ConditionRemarksVC : UIViewController
@property (weak, nonatomic) NSNumber *depID;
@property (nonatomic) NSInteger type;
@property(assign) id<ConditionRemarksDelegate> delegate;
@property (nonatomic) NSMutableDictionary *selectDic;
-(void) setDepIDs:(NSNumber *)depID;
@end
