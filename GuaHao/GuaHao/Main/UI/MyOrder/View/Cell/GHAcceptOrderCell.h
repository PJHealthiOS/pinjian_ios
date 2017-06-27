//
//  GHAcceptOrderCell.h
//  GuaHao
//
//  Created by PJYL on 16/8/30.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AcceptVO.h"

typedef void(^BlockAcceptCell)(int,NSNumber*);
typedef  void(^EndCountdownBlock)(BOOL end,NSIndexPath *indexpath);
typedef void (^CertificateBlock)(AcceptVO *vo);
@interface GHAcceptOrderCell : UITableViewCell

-(void)setCell:(AcceptVO *) vo type:(int) type indexPath:(NSIndexPath *)indexPath;
-(void)setWJCell:(AcceptVO *) vo indexPath:(NSIndexPath *)indexPath;
@property (nonatomic, copy)EndCountdownBlock endBlock;
@property (nonatomic, copy) BlockAcceptCell onBlockAccept;
@property (nonatomic, copy)CertificateBlock certificateBlock;
-(void)countdownEnd:(EndCountdownBlock)block;
-(void)certificateBlock:(CertificateBlock)block;
@end
