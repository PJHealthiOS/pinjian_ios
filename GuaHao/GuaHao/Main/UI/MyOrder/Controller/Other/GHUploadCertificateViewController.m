//
//  GHUploadCertificateViewController.m
//  GuaHao
//
//  Created by PJYL on 16/9/13.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHUploadCertificateViewController.h"
#import "ImageViewController.h"
#import "camera.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface GHUploadCertificateViewController ()<UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
        UIActionSheet *actionSheet1;
    BOOL isUpload;
    BOOL isPhoto;
    NSString *_numberStr;
}
@property (strong, nonatomic) IBOutlet UIView *pickBackView;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *certificateButton;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic)NSArray *sourceArr;
@property (strong, nonatomic)UIImage *selectImage;

@end

@implementation GHUploadCertificateViewController
-(void)viewWillDisappear:(BOOL)animated{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addPickerView];
    self.sourceArr = @[@"8:00 ~ 9:00",@"9:00 ~ 10:00",@"10:00 ~ 11:00",@"13:00 ~ 14:00",@"14:00 ~ 15:00",@"15:00 ~ 16:00",];
    if (_postOrderVO.ticketImgUrl.length > 2) {
        [self.certificateButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_postOrderVO.ticketImgUrl] forState:UIControlStateNormal];
        self.selectImage = self.certificateButton.currentBackgroundImage;
    }
    if (_postOrderVO.visitSeq) {
        _textField.text = [NSString stringWithFormat:@"%@", _postOrderVO.visitSeq];
    }
    if (_postOrderVO.visitType.intValue == 0) {///挂号
        _textField.hidden = NO;
        _dateButton.hidden = YES;
        
    }else{
        _textField.hidden = YES;
        _dateButton.hidden = NO;
    }
    self.title = @"上传凭证";
    // Do any additional setup after loading the view.
}


- (IBAction)pickerCancelAction:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.pickBackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
    
   
}

- (IBAction)pickerSureAction:(id)sender {
    if (_numberStr.length > 2) {
        [self.dateButton setTitle:_numberStr forState:UIControlStateNormal] ;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.pickBackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}

///选择图片
- (IBAction)selectImageButton:(id)sender {
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
- (IBAction)dateAction:(id)sender {
    if (_postOrderVO.visitType.intValue == 1) {///挂号
        _numberStr = @"10:00 ~ 11:00";
        [UIView animateWithDuration:0.5 animations:^{
            self.pickBackView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 0);
            self.pickBackView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
            [self.pickerView selectRow:2 inComponent:0 animated:YES];
            [self.view addSubview:self.pickBackView];
        }];
        
        
    }

}
- (IBAction)removePickerBackView:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.pickBackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 0);
    }];

}

-(void)addPickerView{
    self.pickBackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 0);
    _numberStr = @"10:00 ~ 11:00";
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 6;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
  return [self.sourceArr objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    _numberStr =[self.sourceArr objectAtIndex:row];
}





#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 6000){
        if(buttonIndex == 3) return;
        if(buttonIndex == 2){
            ImageViewController * view = [[ImageViewController alloc]init];
            view.image =  self.certificateButton.currentBackgroundImage;
            [self.navigationController pushViewController:view animated:YES];
        }
        if (buttonIndex==0) {
            //拍照
            isPhoto = YES;
            PresentPhotoCamera(self, self, NO);
        }else if (buttonIndex==1){
            isPhoto = NO;
            PresentPhotoLibrary(self, self, NO);
        }
        
    }else if (actionSheet.tag == 7000){
        if(buttonIndex == 2) return;
        
        if (buttonIndex==0) {
            //拍照
            isPhoto = YES;
            PresentPhotoCamera(self, self, NO);
        }else if (buttonIndex==1){
            isPhoto = NO;
            PresentPhotoLibrary(self, self, NO);
        }
        
    }
    
}
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"您选择了图片");
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        //UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.selectImage = image;
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self.certificateButton setBackgroundImage:image forState:UIControlStateNormal];
        
    }
}
-(void)sendServer
{
    if (_postOrderVO.visitType.intValue == 0) {
        if (_textField.text.length < 1) {
            [self inputToast:@"请上填写就诊序号！"];
            return;
        }
    }else{
        if (_numberStr.length < 2) {
            [self inputToast:@"请选择就诊时间！"];
            return;
        }
    }
    
    if (!self.certificateButton.currentBackgroundImage) {
        [self inputToast:@"请上传凭证图片！"];
        return;
    }else{
        [self.certificateButton setTitle:@"" forState:UIControlStateNormal];
    }
    [self.view makeToastActivity:CSToastPositionCenter];
    UIImage *image = self.selectImage;
    if(isPhoto){
        image = [Utils image:image rotation:UIImageOrientationRight];
    }
    
    if (self.isNormal) {
        //上传凭证
        [[ServerManger getInstance] normalOrderUploadTicket:_postOrderVO.id visitSeq:_textField.text currentVisitSeq:@"" currentVisitTime:@"" front:image isNormalOrder:YES andCallback:^(id data) {
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                [self inputToast:msg];
                if (self.myblock) {
                    self.myblock(image);
                }
                [self.navigationController popViewControllerAnimated:YES];
                if (code.intValue == 0) {
                    isUpload = YES;
                    
                }else{
                    
                }
            }
        }];
    }else{
        //上传凭证
        [[ServerManger getInstance] ExpertUploadTicket:_postOrderVO.id visitSeq:_textField.text front:image andCallback:^(id data) {
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                [self inputToast:msg];
                if (self.myblock) {
                    self.myblock(image);
                }
                [self.navigationController popViewControllerAnimated:YES];
                if (code.intValue == 0) {
                    isUpload = YES;
                    
                }else{
                    
                }
            }
        }];
    }
    
   
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
///取消  就返回
- (IBAction)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
///上提交 成功就返回
- (IBAction)uploadAction:(id)sender {
    [self sendServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)uploadSuccessAction:(UploadSuccessBlock)block{
    self.myblock = block;
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
