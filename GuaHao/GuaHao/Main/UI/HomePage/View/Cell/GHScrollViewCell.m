//
//  GHScrollViewCell.m
//  GuaHao
//
//  Created by PJYL on 16/10/8.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHScrollViewCell.h"
#import "UIButton+WebCache.h"
#import "HealthTestVO.h"
#import "SpecialDepartmentVO.h"
#import "SpecialHomeCell.h"
@interface GHScrollViewCell (){
    
}
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
@implementation GHScrollViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)moreAction:(id)sender {
    self.myBlock(1111);
}
-(void)layoutSubviews:(NSArray *)array title:(NSString *)title type:(int)type{
    self.typeLabel.text = title;
    CGFloat originX = 5;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (type == 1) {
        for (int i = 0 ; i < array.count;i++) {
            SpecialDepartmentVO *vo = [array objectAtIndex:i];
            SpecialHomeCell *cell = [[[UINib nibWithNibName:@"SpecialHomeCell" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
            cell.frame = CGRectMake(originX, 8, SCREEN_WIDTH/3.0, (SCREEN_WIDTH - 20.0)/3.0/(352.0/160.0));
            [cell layoutWithIcon:vo.imageUrl title:vo.name];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellTap:)];
            cell.tag = 3100+i;
            originX = originX + SCREEN_WIDTH/3.0;
            cell.userInteractionEnabled = YES;
            [cell addGestureRecognizer:tap];
            [self.scrollView addSubview:cell];
            

        }
    }else if (type == 2) {
        for (int i = 0 ; i < array.count;i++) {
            HealthTestVO *vo = [array objectAtIndex:i];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(originX, 8, SCREEN_WIDTH/2.0 - 10, (SCREEN_WIDTH - 20.0)/2.0/(352.0/200.0));
            [button addTarget:self action:@selector(cellClick:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor clearColor];
            [button setAdjustsImageWhenHighlighted:NO];
            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:vo.coverUrl] forState:UIControlStateNormal placeholderImage:nil];
            button.tag = 3100+i;
            originX = originX + SCREEN_WIDTH/2.0;
            [self.scrollView addSubview:button];
            
        }
    }
    self.scrollView.contentSize = CGSizeMake(originX , CGRectGetHeight(self.scrollView.frame));
    self.scrollView.showsHorizontalScrollIndicator = YES;
}
-(void)cellTap:(UITapGestureRecognizer *)tap{
    self.cellBlock(tap.view.tag - 3100);
}
-(void)cellClick:(UIButton *)button{

    if (self.cellBlock) {
        self.cellBlock(button.tag - 3100);
    }
}

-(void)clickCellReturn:(ClickCellActionBlock)block{
    self.cellBlock = block;
}
-(void)clickButtonReturn:(ClickReturnBlock)block{
    self.myBlock = block;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
