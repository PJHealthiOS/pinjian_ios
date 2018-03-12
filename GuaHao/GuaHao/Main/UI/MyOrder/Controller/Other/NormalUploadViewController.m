//
//  NormalUploadViewController.m
//  GuaHao
//
//  Created by PJYL on 2017/6/5.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "NormalUploadViewController.h"
#import "ImageViewController.h"
#import "camera.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface NormalUploadViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate>{
    UIActionSheet *actionSheet1;
    BOOL isChangeImage;

}
@property (weak, nonatomic) IBOutlet UITextField *serialNoTextField;
@property (weak, nonatomic) IBOutlet UILabel *currentDateLabel;
@property (weak, nonatomic) IBOutlet UITextField *currentSerialNoTextField;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *certificateViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *certificateButtonHeight;


@property (nonatomic, strong)UIPickerView *datePicker;
@property (nonatomic, strong)NSArray *hourArr;
@property (nonatomic, strong)NSMutableArray *minuteArray;
@property (nonatomic, copy) NSString *hourStr;
@property (nonatomic, copy) NSString *minuteStr;
@property (nonatomic, copy) NSString *selectStr;
@property (nonatomic, strong) UIImage *selectImage;

@property (strong, nonatomic) IBOutlet UIView *pickBackView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation NormalUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传凭证";
    isChangeImage = NO;
    self.hourArr = @[@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20"];
    self.hourStr = [self.hourArr objectAtIndex:0];
    self.minuteArray = [NSMutableArray array];
    for (int i = 0; i <60; i++) {
        [self.minuteArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    self.pickBackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 0);
    self.minuteStr = [self.minuteArray objectAtIndex:0];

    self.pickBackView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    [self.view addSubview:self.pickBackView];
    
    NSDateFormatter *forMatter = [[NSDateFormatter alloc]init];
    [forMatter setDateFormat:@"HH:mm:ss yyyy-MM-dd"];
    NSString *dateStr = [[forMatter stringFromDate:[NSDate date]] substringToIndex:5];
    self.currentDateLabel.text = dateStr;
    self.selectStr = dateStr;

    NSLog(@"dateStr------%@",dateStr);
    
    ///643*312
    self.certificateViewHeight.constant = 94 + (SCREEN_WIDTH - 40)*312.0/643.0;
    self.certificateButtonHeight.constant = (SCREEN_WIDTH - 40)*312.0/643.0;
    NSString *str = _postOrderVO.visitSeq.stringValue;
    if (str.length > 0) {
        self.serialNoTextField.text = str;
    }
    if (_postOrderVO.ticketImgUrl.length > 2) {
        [self.uploadButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_postOrderVO.ticketImgUrl] forState:UIControlStateNormal];
        self.selectImage = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_postOrderVO.ticketImgUrl]]];
        
        
    }
    // Do any additional setup after loading the view.
}
- (IBAction)dateCancelAction:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.pickBackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}
- (IBAction)dateSureAction:(id)sender {
    self.selectStr = [NSString stringWithFormat:@"%@:%@",self.hourStr,self.minuteStr];
    self.currentDateLabel.text = self.selectStr;
    [UIView animateWithDuration:0.5 animations:^{
        self.pickBackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.hourArr.count;
    }else{
        return self.minuteArray.count;
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return [self.hourArr objectAtIndex:row];
    }else{
        return [self.minuteArray objectAtIndex:row];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.hourStr = [self.hourArr objectAtIndex:row];
    }else{
        self.minuteStr = [self.minuteArray objectAtIndex:row];
    }
    
    NSLog(@"%@----------------------%@",self.hourStr,self.minuteStr);
}








- (IBAction)serialNoInputAction:(UITextField *)sender {
}

- (IBAction)tapDateAction:(id)sender {
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    [self.pickerView selectRow:0 inComponent:1 animated:YES];

    [UIView animateWithDuration:0.5 animations:^{
        self.pickBackView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}

- (IBAction)currentSerialNoInputAction:(UITextField *)sender {
}

- (IBAction)upLoadAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if(_postOrderVO.ticketImgUrl.length > 2){
        ///重新上传
        actionSheet1=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"重新上传(拍照)", @"重新上传（从相册选取）",@"查看凭证", nil];
        [actionSheet1 showInView:self.view];
        actionSheet1.tag = 6000;
    }else{
        //直接上传
        actionSheet1=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选取", nil];
        [actionSheet1 showInView:self.view];
        actionSheet1.tag = 7000;
        
    }
    

}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 6000){
        if(buttonIndex == 3) return;
        if(buttonIndex == 2){
            ImageViewController * view = [[ImageViewController alloc]init];
            view.image =  self.uploadButton.currentBackgroundImage;
            [self.navigationController pushViewController:view animated:YES];
        }
        if (buttonIndex==0) {
            //拍照
            PresentPhotoCamera(self, self, NO);
        }else if (buttonIndex==1){
            PresentPhotoLibrary(self, self, NO);
        }
        
    }else if (actionSheet.tag == 7000){
        if(buttonIndex == 2) return;
        
        if (buttonIndex==0) {
            //拍照
            PresentPhotoCamera(self, self, NO);
        }else if (buttonIndex==1){
            PresentPhotoLibrary(self, self, NO);
        }
        
    }
    
}
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    isChangeImage = YES;
    NSLog(@"您选择了图片");
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        //UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        //image = [Utils reSizeImage:image toSize:CGSizeMake(100, 100)];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self.uploadButton setBackgroundImage:image forState:UIControlStateNormal];
        self.selectImage = image;
        
    }
}






- (IBAction)cancelAction:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)commitAction:(id)sender {
    [self.view endEditing:YES];

    if (self.serialNoTextField.text.length < 1) {
            [self inputToast:@"请上填写就诊序号！"];
            return;
    }
    if (self.currentDateLabel.text.length < 1) {
        [self inputToast:@"请选择当前时间！"];
        return;
    }
//    if (self.currentSerialNoTextField.text.length < 1) {
//        [self inputToast:@"请上填当前就诊号！"];
//        return;
//    }
    
    
    [self.view makeToastActivity:CSToastPositionCenter];
    UIImage *image = self.selectImage;

    image = [Utils image:image rotation:UIImageOrientationRight];
    
        //上传凭证
        [[ServerManger getInstance] normalOrderUploadTicket:_postOrderVO.id visitSeq:self.serialNoTextField.text currentVisitSeq:self.currentSerialNoTextField.text currentVisitTime:self.selectStr front:isChangeImage?self.selectImage:nil isNormalOrder:self.isNormal  andCallback:^(id data) {
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                [self inputToast:msg];
                
                
                if (code.intValue == 0) {
                    if (self.myblock) {
                        self.myblock(image);
                    }
                }else{
                    
                }
                [self.navigationController popViewControllerAnimated:YES];

            }
        }];
  
    

}

-(void)uploadSuccessAction:(NormalUploadSuccessBlock)block{
    self.myblock = block;
}












-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
