//
//  PlasticInfoView.h
//  GuaHao
//
//  Created by PJYL on 2018/6/12.
//  Copyright © 2018年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlasticTypeVO.h"
@interface PlasticInfoView : UIView
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

-(instancetype)initWithFrame:(CGRect)frame order:(PlasticTypeVO *)order;
-(void)changeInfo:(PlasticTypeVO *)order;
@end
