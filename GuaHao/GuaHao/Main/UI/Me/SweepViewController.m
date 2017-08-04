#import "SweepViewController.h"
#import "QRCodeGenerator.h"
#import <AVFoundation/AVFoundation.h>
#import "UIViewController+Toast.h"
#import "ServerManger.h"
#import "OrderVO.h"
#import "AcceptOrderVO.h"

@interface SweepViewController ()<AVCaptureMetadataOutputObjectsDelegate>{
     NSTimer *_timer;
}
@property (weak, nonatomic) IBOutlet UIImageView *scrollLineView;

@end

@implementation SweepViewController{
    AVCaptureDevice * _device;
    AVCaptureDeviceInput * _input;
    AVCaptureMetadataOutput *_output;
    AVCaptureSession          *_session;
    AVCaptureVideoPreviewLayer  *_preview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rollingAction) userInfo:nil repeats:NO];
    [_timer fire];
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                if (granted) {
                    [self setupCamera];
                }else{
                    //用户拒绝
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            // 已经开启授权，可继续
            [self setupCamera];
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            
            break;
        default:
            break;
    }
}
-(void)rollingAction{
    
    //UIView基础动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 2;
    animation.autoreverses = true;
    animation.repeatCount = MAXFLOAT;
    animation.fromValue = [NSValue valueWithCGPoint:_scrollLineView.layer.position];
    CGPoint point = _scrollLineView.layer.position;
    point.y += 204;
    animation.toValue = [NSValue valueWithCGPoint:point];
    
    [_scrollLineView.layer addAnimation:animation forKey:@"move-layer"];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_session && ![_session isRunning]) {
        [_session startRunning];
    }
    self.navigationController.navigationBarHidden = YES;
}

- (void)setupCamera
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        // Device
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        // Input
        _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
        
        // Output
        _output = [[AVCaptureMetadataOutput alloc]init];
        //    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        // Session
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([_session canAddInput:_input])
        {
            [_session addInput:_input];
        }
        
        if ([_session canAddOutput:_output])
        {
            [_session addOutput:_output];
        }
        
        // 条码类型 AVMetadataObjectTypeQRCode
        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            // Preview
            _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
            _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
//          _preview.frame =CGRectMake(20,110,280,280);
            _preview.frame = self.view.bounds;
            [self.view.layer insertSublayer:_preview atIndex:0];
            // Start
            [_session startRunning];
        });
    });
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        [_timer invalidate];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    NSLog(@"%@",stringValue);

    if (stringValue.length>0) {
        //管理员扫描
        NSArray *array1 = [stringValue componentsSeparatedByString:@";"];
        if(array1&&array1.count == 2&&[array1[1] isEqualToString:@"getTicket"]){
            [self.view makeToastActivity:CSToastPositionCenter];
            [[ServerManger getInstance] getScaninfo:array1[0] longitude:@"" latitude:@"" andCallback:^(id data) {
                [self.view hideToastActivity];
                if (data!=[NSNull class]&&data!=nil) {
                    NSNumber * code = data[@"code"];
                    NSString * msg = data[@"msg"];
                    if (code.intValue == 0) {
                        AcceptOrderVO *orderVO = [AcceptOrderVO mj_objectWithKeyValues:data[@"object"]];
                        GHAcceptDetailViewController *view = [GHViewControllerLoader GHAcceptDetailViewController];
                        view.acceptVO = orderVO;
                        view.isSweep = YES;
                        [self.navigationController pushViewController:view animated:YES];
                    }else{
                        [self inputToast:msg];
                    }
                }
            }];
            return;
        }
        
        //分享扫描
        NSArray *array = [stringValue componentsSeparatedByString:@"?"];
        if (array.count>1) {
            NSString * content = array[array.count-1];
            if(content.length>0){
                NSArray *arr2 = [content componentsSeparatedByString:@";"];
                if(arr2.count == 2 ){
                    NSString * str1 = arr2[0];
                    NSString * str2 = arr2[1];
                    if (str1.length>5&str2.length>5&&[[str1 substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"type"]&&[[str2 substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"data"]) {
                        NSString * type = [str1 substringWithRange:NSMakeRange(5, str1.length-5)];
                        NSString * data = [str2 substringWithRange:NSMakeRange(5, str2.length-5)];
                        if ([type isEqualToString:@"1"]) {
                            [self.view makeToastActivity:CSToastPositionCenter];
                            [[ServerManger getInstance] fillInvitationCode:data andCallback:^(id data) {
                                
                                [self.view hideToastActivity];
                                if (data!=[NSNull class]&&data!=nil) {
                                    NSNumber * code = data[@"code"];
                                    NSString * msg = data[@"msg"];
                                    [self inputToast:msg];
                                    if (code.intValue == 0) {
                                        
                                    }else{
                                        
                                    }
                                    [self performSelector:@selector(onBack:) withObject:nil afterDelay:1.0f];
                                    return ;
                                }
                            }];
                        }else{
                            [self inputToast:@"无效的二维码～"];
                            [self performSelector:@selector(onBack:) withObject:nil afterDelay:1.0f];
                        }
                    }else{
                        [self inputToast:@"无效的二维码～"];
                        [self performSelector:@selector(onBack:) withObject:nil afterDelay:1.0f];
                    }
                }else{
                    [self inputToast:@"无效的二维码～"];
                    [self performSelector:@selector(onBack:) withObject:nil afterDelay:1.0f];
                }
            }else{
                [self inputToast:@"无效的二维码～"];
                [self performSelector:@selector(onBack:) withObject:nil afterDelay:1.0f];
            }
        }else{
            [self inputToast:@"无效的二维码～"];
            [self performSelector:@selector(onBack:) withObject:nil afterDelay:1.0f];
        }
    }else{
        [self inputToast:@"无效的二维码～"];
        [self performSelector:@selector(onBack:) withObject:nil afterDelay:1.0f];
    }
    

}

- (void)dealloc
{
    _timer = nil;
}
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
