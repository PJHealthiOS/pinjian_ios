//
//  AccompanyServiceCell.h
//  GuaHao
//
//  Created by PJYL on 16/10/10.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClickReturnBlock)(BOOL select);
typedef void(^ExplainBlock)(BOOL select);
@interface AccompanyServiceCell : UITableViewCell
@property (nonatomic,copy)ClickReturnBlock myBlock;
@property (nonatomic,copy)ExplainBlock explainBlock;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

-(void)clickButtonReturn:(ClickReturnBlock)block;
-(void)explainAction:(ExplainBlock)block;
-(void)layoutSubviewsWithPriceStr:(NSString *)priceStr price:(NSNumber*)price  description:(NSString *)description hiddenButton:(BOOL)hidden;
@end
