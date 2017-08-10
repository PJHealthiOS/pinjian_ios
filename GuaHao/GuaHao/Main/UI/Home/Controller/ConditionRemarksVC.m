//
//  ConditionRemarksVC.m
//  GuaHao
//
//  Created by 123456 on 16/4/11.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "ConditionRemarksVC.h"
#import "UIViewController+Toast.h"
#import "Utils.h"
#import "ServerManger.h"
#define MAX_STARWORDS_LENGTH 50
@interface ConditionRemarksVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView * tablVie;
@property (weak, nonatomic) IBOutlet UIButton     * bottomBtn;
@property (weak, nonatomic) IBOutlet UITextView   * textView;
@property (weak, nonatomic) IBOutlet UILabel      * mPlaceholder;
@property (weak, nonatomic) IBOutlet UILabel      * textLength;
@property (nonatomic ,weak) UIButton * btn;
//@property BOOL isSelected;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;
@property (weak, nonatomic) IBOutlet UIButton *btn7;
@property (weak, nonatomic) IBOutlet UIButton *btn8;

@end

@implementation ConditionRemarksVC{
    NSArray * tagArr;
    NSArray * btnArr;
    BOOL isInit;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"病情备注";
    _textView.delegate = self;
    if (_selectDic==nil) {
        _selectDic = [NSMutableDictionary new];
    }
    isInit = YES;
    [self setDepIDs:_depID];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:)name:@"UITextViewTextDidChangeNotification" object:_textView];

}
//** 键盘输入监听通知
-(void)textViewEditChanged:(NSNotification *)obj
{
    UITextView *textField = (UITextView *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"])// 简体中文输入
    {
        
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > MAX_STARWORDS_LENGTH)
            {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
                if (rangeIndex.length == 1)
                {
                    textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
        
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else
    {
        if (toBeString.length > MAX_STARWORDS_LENGTH)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

-(void) setDepIDs:(NSNumber *)depID
{
    if (!depID) return;
    if(depID.intValue == _depID.intValue&&!isInit){
        return;
    }else{
        if(_depID.intValue!=depID.intValue){
            _textView.text = @"";
        }
        _depID =depID;
        if(_selectDic) [_selectDic removeAllObjects];
         _selectDic = [NSMutableDictionary new];
    }
    isInit = NO;
    btnArr = @[_btn1,_btn2,_btn3,_btn4,_btn5,_btn6,_btn7,_btn8];
    for (int i = 0; i<btnArr.count; i++) {
        UIButton *btns = btnArr[i];
        [btns setTitle:@"" forState:UIControlStateNormal];
        btns.titleLabel.text = @"";
        [btns setBackgroundImage:[UIImage imageNamed:@"home_edit_btn_bag_2.png"] forState:UIControlStateNormal];
    }
    [self getTags];
}

-(void)getTags
{
    if (!_depID) {
        return;
    }
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] getExpOrderTags:_depID andCallback:^(id data) {
        [self callBack:data];
    }];
}

-(void)callBack:(id) data
{
    [self.view hideToastActivity];
    if (data!=[NSNull class]&&data!=nil) {
        NSNumber * code = data[@"code"];
        NSString * msg = data[@"msg"];
        if (code.intValue == 0) {
            if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                NSString * tags = data[@"object"];
                tagArr = [tags componentsSeparatedByString:@";"];
                if (tags.length == 0) {
                    return;
                }
                for (int i = 0; i<tagArr.count; i++) {
                    if(i>7)break;
                    UIButton *btns = btnArr[i];
                    [btns setTitle:tagArr[i] forState:UIControlStateNormal];
                    NSString  *tag = [NSString stringWithFormat:@"%ld",(long)btns.tag];
                    NSObject  *object = [_selectDic objectForKey:tag];
                    if (object == nil) {
                        [btns setBackgroundImage:[UIImage imageNamed:@"home_edit_btn_bag_2.png"] forState:UIControlStateNormal];
                        [btns setTitleColor:[UIColor colorWithRed:139.0f/255.0f green:139.0f /255.0f blue:139.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
                    }else{
                        [btns setBackgroundImage:[UIImage imageNamed:@"home_edit_btn_bg_1.png"] forState:UIControlStateNormal];
                        [btns setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }
                }
                if ([_selectDic objectForKey:@"textView"]) {
                    _textView.text = [_selectDic objectForKey:@"textView"];
                    self.mPlaceholder.hidden = YES;
                }
            }
        }else{
            [self inputToast:msg];
        }
    }
}

- (IBAction)button:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _tablVie.contentSize = CGSizeMake(0, CGRectGetMaxY(_bottomBtn.frame)+30);
}
- (IBAction)certainBtn:(id)sender {
    if (_textView.text.length > 50) {
        return [self inputToast:@"内容不能多于50个字！"];
    }
    NSString * contents = @"";
    BOOL isBegin = YES;
    for (id akey in [_selectDic allKeys]) {
        if ([akey isEqualToString:@"textView"]||[akey isEqualToString:@"allText"]) {
            continue;
        }
        NSString *theCard= [_selectDic objectForKey:akey];
        contents = isBegin?theCard:[NSString stringWithFormat:@"%@,%@",contents,theCard];
        isBegin = NO;
    }
    if (_textView.text.length>0) {
        contents =[contents isEqualToString:@""]?_textView.text:[NSString stringWithFormat:@"%@,%@",contents,_textView.text];
        [_selectDic setObject:_textView.text forKey:@"textView"];
    }
    [_selectDic setObject:contents forKey:@"allText"];
    if (_delegate) {
        [_delegate delegateConditionRemark:_selectDic];
    }
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)fastRemarkBtn:(UIButton *)sender {
    NSString  *tag = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    if (!_selectDic) {
        _selectDic = [NSMutableDictionary new];
    }
    NSObject  *object = [_selectDic objectForKey:tag];
    
    if (object != nil) {
        
        [_selectDic removeObjectForKey:tag];
        [sender setBackgroundImage:[UIImage imageNamed:@"home_edit_btn_bag_2.png"] forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor colorWithRed:139.0f/255.0f green:139.0f /255.0f blue:139.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    }else{
        
        if (sender.titleLabel.text.length==0) return;
        [_selectDic setObject:sender.titleLabel.text forKey:tag];
        [sender setBackgroundImage:[UIImage imageNamed:@"home_edit_btn_bg_1.png"] forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}      

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.mPlaceholder.hidden = YES;
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView{

           
    NSString * str = [NSString stringWithFormat:@"%lu",(unsigned long)_textView.text.length];
    _textLength.attributedText = [Utils attributeString:@[str, @"/50个字"] attributes:@[@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:13], NSForegroundColorAttributeName:[UIColor colorWithRed:169.0f/255.0f green:169.0f /255.0f blue:169.0f/255.0f alpha:1.0f]},  @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:13], NSForegroundColorAttributeName:[UIColor colorWithRed:169.0f/255.0f green:169.0f /255.0f blue:169.0f/255.0f alpha:1.0f]}]];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length < 1) {
        self.mPlaceholder.hidden = NO;
    }
}

@end
