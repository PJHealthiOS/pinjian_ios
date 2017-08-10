//
//  EditorInformationVC.h
//  GuaHao
//
//  Created by 123456 on 16/2/14.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientVO.h"

@protocol EditorInformationDelegate <NSObject>
-(void)editorInformationDelegate;
@end

@interface EditorInformationVC : UIViewController
@property(assign) id<EditorInformationDelegate> delegate;
@property (nonatomic) PatientVO * patientVO;

@end







