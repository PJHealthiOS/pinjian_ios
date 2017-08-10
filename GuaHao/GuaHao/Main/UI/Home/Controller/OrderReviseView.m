//
//  OrderSureView.m
//  GuaHao
//
//  Created by 123456 on 16/2/17.
//  Copyright © 2016年 pinjian. All rights reserved.
//
#import "OrderReviseView.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"
#import "Validator.h"
#import "UUDatePicker.h"
#import "CustomUIActionSheet.h"

@interface OrderReviseView ()

@property (weak, nonatomic) IBOutlet UIButton *btnSure;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *controlSex;
@property (weak, nonatomic) IBOutlet UILabel *labDate;

@end

@implementation OrderReviseView{
    PatientVO * patient;
    int   type;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        UIView * containerView = [[[UINib nibWithNibName:@"OrderReviseView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
        type = 0;
        UITapGestureRecognizer * tapGuesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(func1:)];
        [_bgView setUserInteractionEnabled:YES];
        [_bgView addGestureRecognizer:tapGuesture1];
        [_controlSex addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

-(void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    NSLog(@"Index %li", (long)Index);
    type = (int) Index;
}

-(void)setPatient:(PatientVO*) _patient
{
    patient = _patient;
    if(patient.sex){
        _controlSex.selectedSegmentIndex = type = patient.sex.intValue;
    }
    _labDate.text = patient.birthday?[patient.birthday substringWithRange:NSMakeRange(0,10)]:@"";
}

- (IBAction)onSure:(id)sender {
    if (_tfName.text.length == 0) {
        [self makeToast:@"请填写姓名！" duration:1.0 position:CSToastPositionCenter style:nil];
        return;
    }
    if (_tfName.text.length == 1) {
        [self makeToast:@"姓名长度至少为2位！" duration:1.0 position:CSToastPositionCenter style:nil];
        return;
    }
    if (_tfName.text.length > 8) {
        [self makeToast:@"名字长度不能大于8！" duration:1.0 position:CSToastPositionCenter style:nil];
        return;
    }
    if (![Validator isValidName:_tfName.text]) {
        [self makeToast:@"请填写正确的姓氏！" duration:1.0 position:CSToastPositionCenter style:nil];
        return;
    }
    if (_labDate.text.length == 0 || [_labDate.text isEqualToString:@""]) {
        [self makeToast:@"请选择出生日期！" duration:1.0 position:CSToastPositionCenter style:nil];
        return;
    }
    NSMutableDictionary* dic = [NSMutableDictionary new];
    dic[@"name"] = _tfName.text;
    dic[@"sex"]  = type==0?@"0":@"1";
    dic[@"birthday"] = [NSString stringWithFormat:@"%@ 00:00:00",_labDate.text];
    [self makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance]editPatient:patient.id patient:dic andCallback:^(id data) {
        [self hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg  = data[@"msg"];
            [self makeToast:msg duration:1.0 position:CSToastPositionCenter style:nil];
            if(data[@"object"]){
                patient = [PatientVO mj_objectWithKeyValues:data[@"object"]];
            }
            if (_delegate) {
                [_delegate orderReviseDelegate:patient];
            }
            if (code.intValue == 0) {
                [self performSelector:@selector(func1:) withObject:nil afterDelay:1.0];
                
            }
        }
        
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (IBAction)onDate:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    UUDatePicker *datePicker2
    = [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 200)
                             PickerStyle:1
                             didSelected:^(NSString *year,
                                           NSString *month,
                                           NSString *day,
                                           NSString *hour,
                                           NSString *minute,
                                           NSString *weekDay) {
                                 _labDate.text = [year isEqualToString:@""]?@"":[NSString stringWithFormat:@"%@-%@-%@",year,month,day];
                                 NSLog(@"%@",[NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute]);
                             }];
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    [comps setYear:1850];
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date2 = [calendar dateFromComponents:comps];
    datePicker2.minLimitDate = date2;
    datePicker2.maxLimitDate = [[NSDate date] dateByAddingTimeInterval:2222];
    CustomUIActionSheet * sheet = [[CustomUIActionSheet alloc] init];
    [sheet setActionView:datePicker2];
    datePicker2.sheet = sheet;
    [sheet showInView:self];
}

-(void) func1:(UITapGestureRecognizer *) tap{
    [self removeFromSuperview];
}

@end
