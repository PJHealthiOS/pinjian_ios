//
//  UploadImageViewController.m
//  GuaHao
//
//  Created by PJYL on 2016/10/20.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "UploadImageViewController.h"
#import "camera.h"
#import "ImageViewController.h"
@interface UploadImageViewController ()<UITextViewDelegate,UIActionSheetDelegate,UIScrollViewDelegate>{
    BOOL isPhoto;
    CGFloat originX;
}
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *imageArr;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@end

@implementation UploadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    originX = 10;
    self.title = @"添加备注";
    self.imageArr = [NSMutableArray array];
    // Do any additional setup after loading the view.
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length >0) {
        self.placeLabel.hidden = YES;
    }else{
        self.placeLabel.hidden = NO;
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length > 0) {
        
    }
}
- (IBAction)addButtonAction:(id)sender {
    [self.view endEditing:YES];
    if (_imageArr.count>=9) {
        [self inputToast:@"最多上传9张图片"];
        return ;
    }
    _actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
    [_actionSheet showInView:self.view];
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
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
        //image = [Utils reSizeImage:image toSize:CGSizeMake(100, 100)];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        [_imageArr addObject:image];
        [self reloadScrollView:image];
        
    }
}
-(void)reloadScrollView:(UIImage *)image{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(originX , 5, 60, 60);
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(lookAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];
    
    
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(originX , 5, 60, 60)];
//        imageView.image = image;
//        [self.scrollView addSubview:imageView];
    
    
        originX = originX + 5 + 60;
        self.scrollView.contentSize = CGSizeMake(originX + 80, CGRectGetHeight(self.scrollView.frame));
}
- (IBAction)sureAction:(id)sender {
    self.myBlock(self.imageArr,(self.textView.text.length > 0 ? self.textView.text:@"无"));
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)returnDataBlock:(RemarkDescriptionBlock)block{
    self.myBlock = block;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)lookAction:(UIButton *)sender{
    ImageViewController * view = [[ImageViewController alloc]init];
    view.image = sender.currentBackgroundImage;
    [self.navigationController pushViewController:view animated:YES];
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
