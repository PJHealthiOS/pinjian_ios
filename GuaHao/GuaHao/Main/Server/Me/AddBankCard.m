//
//  AddBankCard.m
//  GuaHao
//
//  Created by 123456 on 16/2/23.
//  Copyright © 2016年 pinjian. All rights reserved.
//
#import "BankListVO.h"
#import "KTActionSheet.h"
#import "AddBankCard.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"
#import "Validator.h"

@interface AddBankCard ()
@property (weak, nonatomic) IBOutlet UIScrollView * scrollViewQ;
@property (weak, nonatomic) IBOutlet UIView       * lastView;
@property (weak, nonatomic) IBOutlet UITextField  * nameTF;
@property (weak, nonatomic) IBOutlet UITextField  * cardIDTF;
@property (weak, nonatomic) IBOutlet UILabel      * bankNameTF;
@property (weak, nonatomic) IBOutlet UITextField  * cityTF;
@property (weak, nonatomic) IBOutlet UITextField  * otherTF;
@property (weak, nonatomic) IBOutlet UITextField *idcardTF;

@end

@implementation AddBankCard{
    NSMutableArray * banks;
    NSNumber       * bankID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    banks = [NSMutableArray new];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _scrollViewQ.contentSize = CGSizeMake(0, CGRectGetMaxY(_lastView.frame)+120);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)preserveBtn:(id)sender {
    if (_nameTF.text.length == 0) {
        [self inputToast:@"请填写姓名！"];
        return;
    }
    if (_nameTF.text.length > 8) {
        [self inputToast:@"名字长度不能大于8！"];
        return;
    }
    if (![Validator isValidIdentityCard:_idcardTF.text]) {
        [self inputToast:@"身份证格式不正确!"];
        return;
    }
    if (_cardIDTF.text.length == 0||_cardIDTF.text.length < 10) {
        [self inputToast:@"请填写正确银行卡号！"];
        return;
    }
    if (_bankNameTF.text.length == 0) {
        [self inputToast:@"请选择开户行！"];
        return;
    }
    if (_cityTF.text.length == 0) {
        [self inputToast:@"请填写所在城市！"];
        return;
    }
    if (_otherTF.text.length == 0) {
        [self inputToast:@"请填支行信息！"];
        return;
    }
    NSMutableDictionary* dic = [NSMutableDictionary new];
    dic[@"name"]       = _nameTF.text;
    dic[@"cardNo"]     = _cardIDTF.text;
    dic[@"bankId"]     = bankID;
    dic[@"cityName"]   = _cityTF.text;
    dic[@"branchBank"] = _otherTF.text;
    dic[@"idcard"] = _idcardTF.text;
   [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] withAddBankCard:dic andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg  = data[@"msg"];
            [self inputToast:msg];
            
            if (code.intValue == 0) {
                [self performSelector:@selector(onBack) withObject:nil afterDelay:1.0];

            }else{
                
            }
        }
        
    }];
   
        
        
}
-(void)onBack{
    [self.navigationController popViewControllerAnimated:YES];
    if (_delegate) {
        [_delegate BankListVODelegate];
    }
}
- (IBAction)chooseBranchBankAction:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if(banks.count==0){
        [self.view makeToastActivity:CSToastPositionCenter];
        [[ServerManger getInstance] getBankList:^(id data) {
            
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg  = data[@"msg"];
                if (code.intValue == 0) {
                    NSArray * arr = data[@"object"];
                    for (int i = 0; i<arr.count; i++) {
                        BankListVO *vo = [BankListVO mj_objectWithKeyValues:arr[i]];
                        [banks addObject:vo];
                    }
                    [self popBankListView];
                }else{
                    [self inputToast:msg];
                }
            }
        }];
    }else{
        [self popBankListView];
    }
}

-(void) popBankListView
{
    NSMutableArray * bankNames = [NSMutableArray new];
    for (int i=0; i<banks.count; i++) {
        BankListVO * vo = banks[i];
        [bankNames addObject:vo.name];
    }
    KTActionSheet *actionSheet = [[KTActionSheet alloc] initWithTitle:@"请选择银行卡" itemTitles:bankNames];
    actionSheet.delegate = self;
    actionSheet.tag = 50;
    
    __weak typeof(self) weakSelf = self;
    [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
        
        NSLog(@"block----%ld----%@", (long)index, title);
        BankListVO * vo = banks[index];
        bankID = vo.id;
        weakSelf.bankNameTF.text = [NSString stringWithFormat:@"%@", title];
    }];
}

- (void)sheetViewDidSelectIndex:(NSInteger)index title:(NSString *)title sender:(id)sender
{
    NSLog(@"tag:%ld----%ld----%@",(long)[(UIView *)sender tag], (long)index, title);
    NSLog(@"subviews:%lu",(unsigned long)self.view.subviews.count);
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (IBAction)button:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
