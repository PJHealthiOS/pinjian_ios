//
//  GHAcceptOrderViewController.h
//  GuaHao
//
//  Created by PJYL on 16/8/30.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ContentType){
    ContentType_order_Wait = 1,
    ContentType_order_Normal,
    ContentType_order_Expert,
    ContentType_order_Finish,
    ContentType_order_Wanjia,
    ContentType_order_Company
    
};
@interface GHAcceptOrderViewController : UIViewController
@property (strong, nonatomic) HospitalVO *hospital;
@property (assign, nonatomic) ContentType contentType;
@property (copy  , nonatomic) NSString *titleStr;
@end
