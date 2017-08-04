//
//  NormalUploadViewController.h
//  GuaHao
//
//  Created by PJYL on 2017/6/5.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AcceptOrderVO.h"
typedef void (^NormalUploadSuccessBlock)(UIImage *image);
@interface NormalUploadViewController : UIViewController
@property (nonatomic,strong)    AcceptOrderVO *postOrderVO;;
@property (nonatomic,copy) NormalUploadSuccessBlock myblock;
@property (nonatomic, assign)BOOL isNormal;
-(void)uploadSuccessAction:(NormalUploadSuccessBlock)block;
@end
