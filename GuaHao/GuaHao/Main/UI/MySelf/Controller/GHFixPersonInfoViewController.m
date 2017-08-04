//
//  GHFixPersonInfoViewController.m
//  GuaHao
//
//  Created by PJYL on 2016/11/29.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHFixPersonInfoViewController.h"
#import "camera.h"




@interface GHFixPersonInfoViewController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic)int sex;

@end

@implementation GHFixPersonInfoViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    self.user = [DataManager getInstance].user;
    if (self.user.avatar) {
        [self.iconImageView sd_setImageWithURL: [NSURL URLWithString:self.user.avatar]];
        self.nameLabel.text = self.user.nickName;
        self.sexLabel.text = self.user.sex.intValue == 0 ?@"男":@"女";
        self.name = self.user.nickName;
        self.sex = self.user.sex.intValue;
        
    }
    
    
    
    // Do any additional setup after loading the view.
}
///修改name
- (IBAction)nameAction:(UITapGestureRecognizer *)sender {
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"修改昵称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(alertControl) wAlert = alertControl;
    __weak typeof(self) weakSelf = self;
    [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        // 点击确定按钮的时候, 会调用这个block
        
        NSString *str = [wAlert.textFields.firstObject text];
        if (str.length >1) {
            weakSelf.nameLabel.text = str;
            [weakSelf btnlxzxm];
        }
        
        //        socialSecurityCardStr = [wAlert.textFields.firstObject text];
    }]];
    
    [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    // 添加文本框(只能添加到UIAlertControllerStyleAlert的样式，如果是preferredStyle:UIAlertControllerStyleActionSheet则会崩溃)
    [alertControl addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        textField.placeholder = @"请输入昵称";
        //监听文字改变的方法
        //        [textField addTarget:self action:@selector(textFieldsValueDidChange:) forControlEvents:UIControlEventEditingChanged];
    }];
    [self presentViewController:alertControl animated:YES completion:nil];
    
}

///修改性别
- (IBAction)sexAction:(UITapGestureRecognizer *)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    UIActionSheet * actionSheet = [[UIActionSheet alloc]
                                   initWithTitle:nil
                                   delegate:self
                                   cancelButtonTitle:@"取消"
                                   destructiveButtonTitle:nil
                                   otherButtonTitles:@"男",@"女",nil];
    actionSheet.tag = 50001;
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 50001) {
        NSString *str = @"";
        if (buttonIndex == 0) {
            str = @"男";
        }else if (buttonIndex == 1){
            str = @"女";
        }else{
            return;
        }
        self.sexLabel.text = str;
        [self btnlxzxm];
    }else if (actionSheet.tag == 50002){
        if (buttonIndex == 0) {
            PresentPhotoCamera(self, self, YES);
        }else if (buttonIndex == 1){
            PresentPhotoLibrary(self, self, YES);
            
        }else{
            return;
        }
        
    }
    
    
}

///修改昵称和性别
-(void)btnlxzxm{
    NSMutableDictionary* dic = [NSMutableDictionary new];
    dic[@"sex"]   = [self.sexLabel.text isEqualToString:@"男"]?@"0":@"1";
    dic[@"nickname"]   = self.nameLabel.text;
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] editUserr:dic andCallback:^(id data) {
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



///选择头像
- (IBAction)iconAction:(UITapGestureRecognizer *)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选取", nil];
    [actionSheet showInView:self.view];
    actionSheet.tag = 50002;
    
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
        [self.iconImageView setImage:image];
        [self sendServer];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
///修改头像
-(void)sendServer{
    [self.view makeToastActivity:CSToastPositionCenter];
    NSMutableDictionary* dic = [NSMutableDictionary new];
    dic[@"nickname"]   = self.nameLabel.text;
    dic[@"sex"]    = [self.sexLabel.text isEqualToString:@"男"]?@"0":@"1";
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance]editUser:dic front:self.iconImageView.image andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            //            NSString * msg  = data[@"msg"];
            //            [self inputToast:msg];
            if (code.intValue == 0) {
                UserVO * vo = [UserVO mj_objectWithKeyValues:data[@"object"]];
                [[DataManager getInstance] setLogin:vo];
//                [self getInfom];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UserInfoUpdate" object:nil];
            }
        }
    }];
    
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
