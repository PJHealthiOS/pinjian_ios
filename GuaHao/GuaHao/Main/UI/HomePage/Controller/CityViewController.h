//
//  CityViewController.h
//  GuaHao
//
//  Created by qiye on 16/9/14.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CityVO;
typedef void(^CityBlock)(CityVO*);
@interface CityViewController : UIViewController
@property (nonatomic, copy)CityBlock myBlock;
@property (weak, nonatomic) IBOutlet UILabel *currentCityLabel;

@end
