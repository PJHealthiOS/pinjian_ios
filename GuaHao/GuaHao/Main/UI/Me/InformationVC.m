//
//  InformationVC.m
//  GuaHao
//
//  Created by 123456 on 16/5/23.
//  Copyright © 2016年 pinjian. All rights reserved.
//
#import "UIViewBorders.h"
#import "InformationVC.h"
#import "DataManager.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"
#import "camera.h"
#import "NewnameView.h"
#import "UIImageView+WebCache.h"
//#import "UIViewBorders.h"
@interface InformationVC ()<UIActionSheetDelegate,NewnameDelegate>{
    UIActionSheet     * typeSheet;
    NewnameView *     newnameView;
}
@property (weak, nonatomic) IBOutlet UILabel * sexLab;
@property (weak, nonatomic) IBOutlet UITextField * nicknameTF;
@property (weak, nonatomic) IBOutlet UIView   * contView;
@property (weak, nonatomic) IBOutlet UIButton * gotoRealnameBtn;
@property (weak, nonatomic) IBOutlet UIImageView * photoImag;
@property (weak, nonatomic) IBOutlet UITextField * nameTF;
@property (weak, nonatomic) IBOutlet UIButton *gotoName;
@property (weak, nonatomic) IBOutlet UIButton *sexBtn1;

@end

@implementation InformationVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getInfom];
    _user = [DataManager getInstance].user;
    if (_user.verifyStatus.intValue == 1 ||_user.verifyStatus.intValue == 2) {
        _sexBtn1.enabled = NO;
        _sexBtn1.hidden = YES;
        
    }else if (_user.verifyStatus.intValue == 0|| _user.verifyStatus.intValue == 3){
        _sexBtn1.enabled = YES;
        _sexBtn1.hidden = NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
}
- (void)getInfom{
    _user = [DataManager getInstance].user;
    if(_user.verifyStatus.intValue == 2){
        [_gotoRealnameBtn setTitle:@"已实名认证" forState:UIControlStateNormal];
        _gotoRealnameBtn.enabled = YES;
    }else if(_user.verifyStatus.intValue == 1){
        [_gotoRealnameBtn setTitle:@"审核中" forState:UIControlStateNormal];
//        _gotoRealnameBtn.enabled = NO;
    }else if (_user.verifyStatus.intValue == 3){
        [_gotoRealnameBtn setTitle:@"重新认证" forState:UIControlStateNormal];
        _gotoRealnameBtn.enabled = YES;
    }
    
    [_photoImag roundView];
    _nameTF.text   = _user.nickName;
    _sexLab.text    = _user.sex.intValue == 0 ?@"男":@"女";
    if(self.user.avatar != nil) {
        NSString * url = self.user.avatar;
        [_photoImag sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@" "]];
    }

}
- (IBAction)SelectPhotoBtn:(id)sender {
    [self onSelectPhoto];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (void)onSelectPhoto{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选取", nil];
    [actionSheet showInView:self.view];
    actionSheet.tag = 5000;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 4000) {
        if(buttonIndex == 2) return;
        _sexLab.text = buttonIndex == 0 ? @"男":@"女";
        [self btnlxzxm];
    }else{
        if(buttonIndex == 2) return;

        if (buttonIndex==0) {
            //拍照
            PresentPhotoCamera(self, self, YES);
        }else if (buttonIndex==1){
            PresentPhotoLibrary(self, self, YES);
        }
    }
    
}
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"您选择了图片");
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        //UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        //image = [Utils reSizeImage:image toSize:CGSizeMake(100, 100)];
        [picker dismissViewControllerAnimated:YES completion:nil];
        [_photoImag setImage:image];
        [self sendServer];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)sendServer{
    [self.view makeToastActivity:CSToastPositionCenter];
    NSMutableDictionary* dic = [NSMutableDictionary new];
    dic[@"nickname"]   = _nameTF.text;
    dic[@"sex"]    = [_sexLab.text isEqualToString:@"男"]?@"0":@"1";
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance]editUser:dic front:_photoImag.image andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
//            NSString * msg  = data[@"msg"];
//            [self inputToast:msg];
            if (code.intValue == 0) {
                UserVO * vo = [UserVO mj_objectWithKeyValues:data[@"object"]];
                [[DataManager getInstance] setLogin:vo];
                [self getInfom];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UserInfoUpdate" object:nil];
            }
        }
    }];

}
-(void) popRevise
{
    if (!newnameView) {
        CGRect frame = self.view.frame;
        newnameView = [[NewnameView alloc] initWithFrame:frame];
        newnameView.delegate = self;
    }
    [newnameView setUser:_user];
    [self.view addSubview:newnameView];
}
-(void)informationDelegate:(UserVO *)vo
{
    _user = vo;
    _nameTF.text = _user.nickName;
}
- (IBAction)gotoNameBtn:(id)sender {
    [MobClick event:@"click40"];
    [self popRevise];
}
-(void)btnlxzxm{
    NSMutableDictionary* dic = [NSMutableDictionary new];
    dic[@"sex"]   = [_sexLab.text isEqualToString:@"男"]?@"0":@"1";
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance]editUserView:dic andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
//            NSString * msg  = data[@"msg"];
            if(data[@"object"]){
                _user  = [UserVO mj_objectWithKeyValues:data[@"object"]];
            }
            if (code.intValue == 0) {
                [DataManager getInstance].user = [UserVO mj_objectWithKeyValues:data[@"object"]];
                 [[DataManager getInstance] setLogin:[DataManager getInstance].user];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UserInfoUpdate" object:nil];
                
            }
        }
        
    }];

}

- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)sexBtn:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"男",@"女",nil];
    actionSheet.tag = 4000;
    [actionSheet showInView:self.view];
}

@end
