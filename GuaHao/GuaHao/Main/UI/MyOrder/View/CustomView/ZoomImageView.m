//
//  ZoomImageView.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/2/10.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "ZoomImageView.h"

@interface ZoomImageView (){
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

@end
@implementation ZoomImageView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[UINib nibWithNibName:@"ZoomImageView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        CGRect fr = frame;
        fr.origin.y = 0;
        fr.size.width = SCREEN_WIDTH;
        [self setFrame:fr];
    }return self;
}
-(void)zoomImageWith:(NSString *)imageStr{
    self.imageWidth.constant = SCREEN_WIDTH *0.618;
    self.imageHeight.constant = SCREEN_WIDTH *0.618;
    self.imageView.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0 -20);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
    
}
- (IBAction)backAction:(UITapGestureRecognizer *)sender {
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
