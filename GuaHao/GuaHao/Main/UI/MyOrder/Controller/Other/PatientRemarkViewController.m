//
//  PatientRemarkViewController.m
//  GuaHao
//
//  Created by PJYL on 2016/10/24.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "PatientRemarkViewController.h"
#import "UIButton+WebCache.h"
#import "HtmlAllViewController.h"
#import "ImageViewController.h"
@interface PatientRemarkViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *imageS;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewheight;
@end

@implementation PatientRemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看病情备注";
    self.textView.text = self.str;
    self.textViewheight.constant = 20 + [self boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, 0) str: self.str fount:14].height;
    self.textView.userInteractionEnabled = NO;
    if (self.arrStr.length > 2) {
        
        NSArray *arr = [self.arrStr componentsSeparatedByString:@","];
        _imageS = [NSMutableArray arrayWithArray: arr];
        [self layoutImageViews:arr];
    }
    
    // Do any additional setup after loading the view.
}
-(void)layoutImageViews:(NSArray *)arr{
    CGFloat originX = 10;
    for (int i = 0; i < arr.count; i++) {
        NSString *urlStr = [arr objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(originX, 5, 60, 60);
        button.tag = 1980 +i;
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(lookAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        originX = originX + i*(60 + 10);

    }
    self.scrollView.contentSize = CGSizeMake(originX + 80, 80);
}
-(void)lookAction:(UIButton *)sender{
//    HtmlAllViewController * view = [[HtmlAllViewController alloc] init];
//    view.mTitle = @"查看图片详情";
//    view.mUrl = [_imageS objectAtIndex:sender.tag - 1980];
    //    [self.navigationController pushViewController:view animated:YES]; ImageViewController * view = [[ImageViewController alloc]init];
    ImageViewController * view = [[ImageViewController alloc]init];
    view.image = sender.currentBackgroundImage;
    [self.navigationController pushViewController:view animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGSize)boundingRectWithSize:(CGSize)size str:(NSString *)str fount:(CGFloat)fount
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fount]};
    
    CGSize retSize = [str boundingRectWithSize:size
                                       options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    
    return retSize;
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
