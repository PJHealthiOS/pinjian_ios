//
//  GHUploadCertificateViewController.h
//  GuaHao
//
//  Created by PJYL on 16/9/13.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AcceptOrderVO.h"
typedef void (^UploadSuccessBlock)(UIImage *image);
@interface GHUploadCertificateViewController : UIViewController
@property (nonatomic,strong)    AcceptOrderVO *postOrderVO;;
@property (nonatomic,copy) UploadSuccessBlock myblock;
@property (nonatomic,assign)BOOL isNormal;
-(void)uploadSuccessAction:(UploadSuccessBlock)block;
@end
