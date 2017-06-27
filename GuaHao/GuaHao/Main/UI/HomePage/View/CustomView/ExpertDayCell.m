//
//  ExpertDayCell.m
//  GuaHao
//
//  Created by PJYL on 2016/11/10.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "ExpertDayCell.h"
#import "Utils.h"
#import "UIViewBorders.h"


@interface ExpertDayCell (){
    
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;


@property (weak, nonatomic) IBOutlet UIView *midView;
@property (weak, nonatomic) IBOutlet UILabel *midLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addImage;



@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImage;




@end
@implementation ExpertDayCell



-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        
        

    }
    return self;
}
-(void)loadCell{
            [self updatePage];
}
-(void)updatePage{
    self.dateLabel.text = [Utils formateStrToMMDD:_dayVO.scheduleDate];
    self.weekLabel.text = [Utils formateStrToWeek:_dayVO.scheduleDate];
    ///type 1专家 2特需  3约满 4 约满加
    DayVO * AM = _dayVO.upDay;
    DayVO * PM = _dayVO.downDay;
    if ([AM.apm isEqualToString:@"上午"]) {
        switch (AM.type.intValue) {
            case 1:{///专家
                [self fillCellAM:YES hiddenAddImage:YES bgColor:UIColorFromRGB(0x45c768) tintColor:[UIColor whiteColor] title:[NSString stringWithFormat:@"%@  %@",AM.clinicType,((AM.price.intValue == 0) ? @"" :  AM.price)]];
            }
                break;
            case 2:{///特需
                [self fillCellAM:YES hiddenAddImage:YES bgColor:UIColorFromRGB(0xfc885f) tintColor:[UIColor whiteColor] title:[NSString stringWithFormat:@"%@  %@",AM.clinicType,((AM.price.intValue == 0) ? @"" :  AM.price)]];
            }
                break;
            case 3:{//约满
                [self fillCellAM:YES hiddenAddImage:YES bgColor:UIColorFromRGB(0xf4f4f4) tintColor:UIColorFromRGB(0xbcbcbc) title:[NSString stringWithFormat:@"%@  %@",AM.clinicType,((AM.price.intValue == 0) ? @"" :  AM.price)]];
            }
                break;
            case 4:{///加号
                [self fillCellAM:YES hiddenAddImage:NO bgColor:UIColorFromRGB(0xf4f4f4) tintColor:UIColorFromRGB(0xbcbcbc) title:[NSString stringWithFormat:@"%@  %@",AM.clinicType,((AM.price.intValue == 0) ? @"" :  AM.price)]];
            }
                break;
            default:{
                
            }
                break;
        }
    }
    if ([PM.apm isEqualToString:@"下午"]) {
        switch (PM.type.intValue) {
            case 1:{///专家
                [self fillCellAM:NO hiddenAddImage:YES bgColor:UIColorFromRGB(0x45c768) tintColor:[UIColor whiteColor] title:[NSString stringWithFormat:@"%@  %@",PM.clinicType,((PM.price.intValue == 0) ? @"" :  PM.price)]];
            }
                break;
            case 2:{///特需
                [self fillCellAM:NO hiddenAddImage:YES bgColor:UIColorFromRGB(0xfc885f) tintColor:[UIColor whiteColor] title:[NSString stringWithFormat:@"%@  %@",PM.clinicType,((PM.price.intValue == 0) ? @"" :  PM.price)]];
            }
                break;
            case 3:{//约满
                [self fillCellAM:NO hiddenAddImage:YES bgColor:UIColorFromRGB(0xf4f4f4) tintColor:UIColorFromRGB(0xbcbcbc) title:[NSString stringWithFormat:@"%@  %@",PM.clinicType,((PM.price.intValue == 0) ? @"" :  PM.price)]];
            }
                break;
            case 4:{///加号
                [self fillCellAM:NO hiddenAddImage:NO bgColor:UIColorFromRGB(0xf4f4f4) tintColor:UIColorFromRGB(0xbcbcbc) title:[NSString stringWithFormat:@"%@  %@",PM.clinicType,((PM.price.intValue == 0) ? @"" :  PM.price)]];
            }
                break;
            default:{
                
            }
                break;
        }

    }
    
    
}

-(void)fillCellAM:(BOOL)isAM hiddenAddImage:(BOOL)hidden bgColor:(UIColor *)bgColor tintColor:(UIColor *)tintColor title:(NSString *)title{
    if (isAM) {
        if (bgColor)self.midLabel.backgroundColor = bgColor;
        self.midLabel.text = title;
        self.midLabel.textColor = tintColor;
        self.addImage.hidden = hidden;
        
    }else{
        if (bgColor)self.bottomLabel.backgroundColor = bgColor;
        self.bottomLabel.text = title;
        self.bottomLabel.textColor = tintColor;
        self.bottomImage.hidden = hidden;
    }
}

-(void)clickAction:(CellClickActionBlock)block{
    self.myBlock = block;
}






- (IBAction)topTapGasture:(id)sender {
}
//点击上午
- (IBAction)midTapGasture:(id)sender {
    if (_dayVO.upDay.type.intValue == 1 || _dayVO.upDay.type.intValue == 2 || _dayVO.upDay.type.intValue == 4) {
        self.myBlock(_dayVO.upDay);
    }
    
}
///点击下午
- (IBAction)bottomTapGasture:(id)sender {
    if (_dayVO.downDay.type.intValue == 1 || _dayVO.downDay.type.intValue == 2 || _dayVO.downDay.type.intValue == 4) {
        self.myBlock(_dayVO.downDay);
    }

}







/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
