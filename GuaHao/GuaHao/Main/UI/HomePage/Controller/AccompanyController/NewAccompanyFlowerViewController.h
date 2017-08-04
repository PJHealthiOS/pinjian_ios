//
//  NewAccompanyFlowerViewController.h
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/7.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,AccompanyType){
    wholeAccompany = 0,
    reportAccompany,
    medicineAccompany,
    
};
@interface NewAccompanyFlowerViewController : UIViewController
@property (nonatomic,assign)AccompanyType accompanyType;

@end
