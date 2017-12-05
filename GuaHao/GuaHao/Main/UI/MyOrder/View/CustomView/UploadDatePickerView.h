//
//  UploadDatePickerView.h
//  GuaHao
//
//  Created by PJYL on 2017/11/9.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^UploadDateBlock)(NSString *selectStr);
@interface UploadDatePickerView : UIView
@property(nonatomic,copy)UploadDateBlock myBlock;
-(void)selectDateAction:(UploadDateBlock)block;

@end
