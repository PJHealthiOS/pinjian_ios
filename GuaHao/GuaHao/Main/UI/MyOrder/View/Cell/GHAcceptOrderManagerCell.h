//
//  GHAcceptOrderManagerCell.h
//  GuaHao
//
//  Created by PJYL on 16/8/30.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AcceptOrderVO.h"
typedef void(^UploadcertificateBlock) (int type);
@interface GHAcceptOrderManagerCell : UITableViewCell
@property (nonatomic, copy) UploadcertificateBlock myblock;
-(void)uploadcertificate:(UploadcertificateBlock)block;
-(instancetype)renderCell:(GHAcceptOrderManagerCell *)cell order:(AcceptOrderVO *)order;
@end
