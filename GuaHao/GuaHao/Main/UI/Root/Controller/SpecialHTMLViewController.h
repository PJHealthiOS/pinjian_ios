//
//  SpecialHTMLViewController.h
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/7.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialHTMLViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (copy, nonatomic) NSString *_url;
@property (copy, nonatomic) NSString *_title;
@property (copy, nonatomic) NSAttributedString *content;
;
@end
