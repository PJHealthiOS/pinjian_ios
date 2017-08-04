//
//  PackageCell.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/2/28.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "PackageCell.h" 
#import "SeriousPackageAlterView.h"
@interface PackageCell ()<UIAlertViewDelegate>{
    
}
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageLabel;
@property (strong, nonatomic)PackageVO *_vo;
@end

@implementation PackageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviewWithVO:(PackageVO *)vo{
    self._vo = vo;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:vo.img] placeholderImage:nil];
    self.typeLabel.text = vo.title;
    self.packageLabel.text = vo.name;
}
-(void)packageSelectAction:(SelectActionBlock)block{
    self.myBlock = block;
}
- (IBAction)selectAction:(UIButton *)sender {
    self.myBlock(self._vo);
}
- (IBAction)explainAction:(id)sender {
    SeriousPackageAlterView *alter = [[SeriousPackageAlterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [alter layoutSubviewWithVO:self._vo];
    [alter selectImmediately:^(BOOL result) {
        if (result) {
            self.myBlock(self._vo);
        }
    }];
    [[self getCurrentVC].view addSubview:alter];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else{//
        self.myBlock(self._vo);
    }
    
}
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
