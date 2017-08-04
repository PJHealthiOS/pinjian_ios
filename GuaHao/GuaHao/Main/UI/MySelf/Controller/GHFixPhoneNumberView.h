//
//  GHFixPhoneNumberView.h
//  GuaHao
//
//  Created by PJYL on 2016/11/7.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^FixPhoneNumberBlock) (NSString *phoneNumber);

@interface GHFixPhoneNumberView : UIView
@property(nonatomic, copy)FixPhoneNumberBlock myBlock;
@property (strong, nonatomic) NSString *patientID;

-(void)fixPhoneNumber:(FixPhoneNumberBlock)block;
@end
