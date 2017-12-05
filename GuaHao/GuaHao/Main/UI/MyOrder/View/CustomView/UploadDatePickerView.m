//
//  UploadDatePickerView.m
//  GuaHao
//
//  Created by PJYL on 2017/11/9.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "UploadDatePickerView.h"

@interface UploadDatePickerView()<UIPickerViewDelegate,UIPickerViewDataSource>{
    
}
@property (strong, nonatomic)  UIPickerView *pickerView;
@property (strong, nonatomic)NSArray *sourceArr;
@property (copy, nonatomic)NSString *selectStr;
@end


@implementation UploadDatePickerView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.selectStr = @"07:00 ~ 07:30";
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
         self.sourceArr = @[@"07:00 ~ 07:30",@"07:30 ~ 08:00",@"08:00 ~ 08:30",@"08:30 ~ 09:00",@"09:00 ~ 09:30",@"09:30 ~ 10:00",@"10:00 ~ 10:30",@"10:30 ~ 11:00",@"11:00 ~ 11:30",@"11:30 ~ 12:00",@"12:00 ~ 12:30",@"12:30 ~ 13:00",@"13:00 ~ 13:30",@"13:30 ~ 14:00",@"14:00 ~ 14:30",@"14:30 ~ 15:00",@"15:00 ~ 15:30",@"15:30 ~ 16:00",@"16:00 ~ 16:30"];
        
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 180, SCREEN_WIDTH, 180)];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.pickerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.pickerView];
        
        UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, CGRectGetMinY(self.pickerView.frame) - 0, 60, 40);
        [leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftButton];
        
        UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(SCREEN_WIDTH - 60, CGRectGetMinY(self.pickerView.frame) - 0, 60, 40);
        [rightButton setTitle:@"确定" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightButton];
        
    }
    return self;
}


#pragma mark - UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.sourceArr.count;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 33;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.sourceArr objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    self.selectStr =[self.sourceArr objectAtIndex:row];
}



-(void)selectDateAction:(UploadDateBlock)block{
    self.myBlock = block;
}
- (void)cancelAction:(id)sender {
    [self removeFromSuperview];
}

- (void)sureAction:(id)sender {
    
    if (self.myBlock) {
        self.myBlock(self.selectStr);
    }
    
    [self removeFromSuperview];

    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
