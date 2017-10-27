//
//  FeedbackVC.m
//  GuaHao
//
//  Created by 123456 on 16/5/25.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "FeedbackVC.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"
#import "Utils.h"
#import "NavigationTabView.h"

@interface FeedbackVC ()<UITextViewDelegate,NavigationTabViewDelegate>{
    NSInteger mType;
    NSInteger mstate;
    NSInteger mstate1;
    NSInteger mstate2;
    NSArray * btnArr;
    UIButton * btn1 ;
}
@property (weak, nonatomic) IBOutlet UILabel * mPlaceholder;
@property (weak, nonatomic) IBOutlet UITextView * textView;
@property (weak, nonatomic) IBOutlet UIScrollView *contView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLab;
@property (weak, nonatomic) IBOutlet NavigationTabView *tabView;

@end

@implementation FeedbackVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.textView becomeFirstResponder];
    mType =1;
    _tabView.itemTitles = @[@"建议",@"咨询",@"投诉"];
    _tabView.delegate = self;
    [_tabView reloadData];
    [_tabView setSelectedIndex:0];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _contView.contentSize = CGSizeMake(0, CGRectGetMaxY(_bottomLab.frame)+30);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _textView.delegate = self;
    //    手势
    UITapGestureRecognizer * Guesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GuestureTap:)];
    [_contView setUserInteractionEnabled:YES];
    [_contView addGestureRecognizer:Guesture];
}

- (void)GuestureTap:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}

- (void)didSelectTabAtIndex:(NSInteger)index
{
    mType =index+1;
}

- (IBAction)onSubmit:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if(_textView.text.length==0){
        return [self inputToast:@"您还没有输入您的意见反馈！"];
    }else {
        [self.view makeToastActivity:CSToastPositionCenter];
        [[ServerManger getInstance] feedback:(int)mType msg:_textView.text andCallback:^(id data) {
            [self.view hideToastActivity];
            if (data != [NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                
                if (code.intValue == 0) {
                    [self inputToast:@"感谢您的宝贵意见！"];
                    [self performSelector:@selector(onBack) withObject:nil afterDelay:1.0];
                }else{
                    [self inputToast:msg];
                }
            }
        }];

    }
    
}
-(void)onBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.mPlaceholder.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length < 1) {
        self.mPlaceholder.hidden = NO;
    }
}
- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
