//
//  PonitTableViewCell.m
//  GuaHao
//
//  Created by qiye on 16/6/15.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "PonitTableViewCell.h"
#import "BeanDayCell.h"
#import "SignDateVO.h"
#import "UIViewController+Toast.h"
#import "ServerManger.h"
#import "DataManager.h"

@implementation PonitTableViewCell{
    
    __weak IBOutlet UIButton *btnOpen;
    __weak IBOutlet UILabel *labPoint;
    __weak IBOutlet UILabel *labContinue;
    __weak IBOutlet UILabel *labTip;
    __weak IBOutlet UILabel *labDay;
    __weak IBOutlet UIImageView *imgRect;
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIImageView *logoBg;
    PointVO * pointVO;
    BeanDayCell * firstCell;
    BOOL  isInit;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setCell:(PointVO*)vo
{
    pointVO = vo;
    btnOpen.selected = vo.openSignWarn;
    labPoint.text = vo.point.stringValue;
    if(vo.signDates.count>0){
        SignDateVO * dateVO = vo.signDates[0];
        labContinue.hidden = !dateVO.sign;
        labTip.hidden = !dateVO.sign;
        imgRect.hidden = !dateVO.sign;
        labTip.text = [NSString stringWithFormat:@"明天签到可领%@个挂号豆哦～连续签到有更多惊喜",vo.tomorrowPoint];
        labDay.text = dateVO.sign?[NSString stringWithFormat:@"%@",vo.serialSignCount]:@"";
        [logoBg setImage:[UIImage imageNamed:dateVO.sign?@"point_mini_white.png":@"point_mini_white2.png"]];
    }
    if(isInit&&firstCell){
        firstCell.dateVO = vo.signDates[0];
        [firstCell setCell];
        return;
    }
    float width = self.width/7;
    for (int i = 0; i<7; i++) {
        BeanDayCell * cell = [[BeanDayCell alloc] initWithFrame:CGRectMake(i*width, 0, width, 75)];
        if (vo.signDates.count>i) {
            cell.dateVO = vo.signDates[i];
            [cell setCell];
        }
        if(i==0) firstCell = cell;
        [scrollView addSubview:cell];
    }
    isInit = YES;
    
}

- (IBAction)onPoint:(id)sender {
    SignDateVO * dateVO = pointVO.signDates[0];
    if (dateVO.sign) {
        return;
    }
    [MobClick event:@"click39"];
    [self makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] signBean:^(id data) {
        [self hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            [self makeToast:msg duration:1.0 position:CSToastPositionCenter style:nil];
            if (code.intValue == 0) {
                pointVO.point = [NSNumber numberWithInt:pointVO.point.intValue + dateVO.presentedPointNum.intValue];
                [DataManager getInstance].user.point = pointVO.point;
                dateVO.sign = YES;
                pointVO.serialSignCount = [NSNumber numberWithInt:pointVO.serialSignCount.intValue + 1];
                [self setCell:pointVO];
            }else{
                
            }
        }
    }];
}

- (IBAction)onOpen:(id)sender {
    btnOpen.selected = !btnOpen.selected;
    [self makeToastActivity:CSToastPositionCenter];
    NSString* isOpen = btnOpen.selected?@"1":@"0";
    [[ServerManger getInstance]  setSignWarn:isOpen andCallback:^(id data) {
        [self hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                pointVO.openSignWarn = !pointVO.openSignWarn;
                [self makeToast:pointVO.openSignWarn?@"打开提醒成功":@"取消提醒成功" duration:1.0 position:CSToastPositionCenter style:nil];
            }else{
                [self makeToast:msg duration:1.0 position:CSToastPositionCenter style:nil];
            }
        }
    }];
}
@end
