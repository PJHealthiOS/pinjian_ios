//
//  ApplyForWithdrawCash.m
//  GuaHao
//
//  Created by 123456 on 16/2/23.
//  Copyright © 2016年 pinjian. All rights reserved.
//
#import "TestEnterAPassword.h"
#import "UIViewController+Toast.h"
#import "ApplyForWithdrawCash.h"
#import "KTActionSheet.h"
#import "ServerManger.h"
#import "AddBankCard.h"
#import "DataManager.h"
#import "Utils.h"
@interface ApplyForWithdrawCash ()<TestEnterAPasswordDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView * scrollViewQ;
@property (weak, nonatomic) IBOutlet UIButton     * lastBtn;
@property (weak, nonatomic) IBOutlet UITextField  * inMoneyTF;
@property (weak, nonatomic) IBOutlet UILabel      * bankName;
@property (weak, nonatomic) IBOutlet UILabel      * moneyLab;

@end

@implementation ApplyForWithdrawCash{
    BankNameVO     * bankNameVO;
    NSMutableArray * bankNames;
    NSNumber       * bankID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    bankNames = [NSMutableArray new];
    _moneyLab.text = [NSString stringWithFormat:@"可提现金额：¥ %.2f",_hasMoney.floatValue];
    [_inMoneyTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
-(void)viewWillAppear:(BOOL)animated{
    [self getBankList];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(void) getBankList{
    [bankNames removeAllObjects];
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] getBankListName:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
//            NSString * msg  = data[@"msg"];
            
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    for (int i = 0; i<arr.count; i++) {
                        BankNameVO * vo = [BankNameVO mj_objectWithKeyValues:arr[i]];
                        //                        1.截取字符串
                        NSString * string = vo.cardNo;
                        string = [string substringWithRange:NSMakeRange(string.length-4,4)];
                        
                        NSString * str = [NSString stringWithFormat:@"%@ (%@)",vo.bankAlias,string];
                        _bankName.text = str;
                        bankID = vo.id;
                        [bankNames addObject:vo];
                    }
                }
            }else{
//                [self inputToast:msg];
            }
        }
        
    }];
    
    
    
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    if ( _inMoneyTF.text.floatValue > _hasMoney.floatValue) {
        [self inputToast:@"输入金额超出收入！"];
        return;
    }
}
- (IBAction)nextStepBtn:(id)sender {

    if (_bankName.text.length == 0) {
        [self inputToast:@"请添加银行卡！"];
        return;
    }
    
    if (_inMoneyTF.text.length == 0) {
        [self inputToast:@"请输入金额！"];
        return;
    }
    if ( _inMoneyTF.text.floatValue < 50.00) {
        [self inputToast:@"单笔最小金额为50.00元！"];
        return;
    }
    if ( _inMoneyTF.text.floatValue > _hasMoney.floatValue) {
        [self inputToast:@"输入金额超出收入！"];
        return;
    }



    TestEnterAPassword * TestEnt = [[TestEnterAPassword alloc]init];
    TestEnt.delegate = self; 
    [self.navigationController pushViewController:TestEnt animated:YES];
}

-(void)testEnterAPasswordDelegate{
    
    float value = _inMoneyTF.text.floatValue;
    NSLog(@">>>>>>>> %f",value);
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] withdrawCrash:bankID amount:value andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 100024) {
                [self inputToast:@"为了保住您的账户安全，请到设置里面设置支付密码，方可提现！"];
                return ;
            }
            if (code.intValue == 0) {
                if(_delegate){
                    [_delegate applyForMoneyDelegate];
                }
                [self inputToast:@"申请提现成功"];
                [self performSelector:@selector(button:) withObject:nil afterDelay:1.0];
            }else{
                [self inputToast:msg];

            }
        }
    }];

    
}

- (IBAction)chooseBankAction:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self popBankListView];
}
-(void) popBankListView{
    
    NSMutableArray * bankNames1 = [NSMutableArray new];
    for (int i=0; i<bankNames.count; i++) {
        BankNameVO * vo = bankNames[i];
        //  1.截取字符串
        NSString * string = vo.cardNo;
        string=[string substringWithRange:NSMakeRange(string.length-4,4)];
        
        NSString * str = [NSString stringWithFormat:@"%@ (%@)",vo.bankAlias,string];
        [bankNames1 addObject:str];
    }
    KTActionSheet * actionSheet = [[KTActionSheet alloc] initWithTitle:@"请选择银行卡" itemTitles:bankNames1];
    actionSheet.delegate = self;
    actionSheet.tag = 50;
    
    __weak typeof(self) weakSelf = self;
    [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
        
        NSLog(@"block----%ld----%@", (long)index, title);
        BankNameVO * vo = bankNames[index];
        bankID = vo.id;
        weakSelf.bankName.text = [NSString stringWithFormat:@"%@", title];
    }];

}
- (void)sheetViewDidSelectIndex:(NSInteger)index title:(NSString *)title sender:(id)sender
{
        NSLog(@"tag:%ld----%ld----%@",(long)[(UIView *)sender tag], (long)index, title);
        NSLog(@"subviews:%lu",(unsigned long)self.view.subviews.count);
}
- (IBAction)addBankBtn:(id)sender {

    AddBankCard * AddB = [[AddBankCard alloc]init];
    [self.navigationController pushViewController:AddB animated:YES];
}



- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _scrollViewQ.contentSize = CGSizeMake(0, CGRectGetMaxY(_lastBtn.frame)+50);
}
- (IBAction)button:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
