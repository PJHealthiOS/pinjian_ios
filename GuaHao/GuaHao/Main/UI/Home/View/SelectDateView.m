//
//  GuaHao
//
//  Created by qiye on 16/2/15.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "SelectDateView.h"
#import "UIViewController+Toast.h"
#import "ServerManger.h"
#import "PageScrollView.h"
#import "DatePageView.h"
#import "FilterDateVO.h"

@interface SelectDateView ()<PageScrollViewDelegate,DatePageViewDelegate>
@end

@implementation SelectDateView{
    
    __weak IBOutlet PageScrollView *scrollView;
    __weak IBOutlet UIButton *btnExpert;
    __weak IBOutlet UIButton *btnSpeical;
    __weak IBOutlet UIButton *btnAll;
    
    FilterDateVO   * dateVO;
    int type;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        UIView * containerView = [[[UINib nibWithNibName:@"SelectDateView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
        btnAll.selected = YES;
        type = 3;
    }
    return self;
}

-(void)updateView
{
    [self initView];
}

-(void) initView{
    
    [[ServerManger getInstance] getListFilterDates:_hospitalID departmentID: _departmentID andCallback:^(id data) {
        
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
//            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    dateVO = [FilterDateVO mj_objectWithKeyValues:data[@"object"]];
                    [self initScroll];
                }
                
            }else{
                //                [self inputToast:msg];
            }
        }
    }];
    

}

-(void)initScroll
{
    NSMutableArray * bannerImages =[[NSMutableArray alloc]init];
    NSArray * arr = [dateVO getDays:type];
    int num = ceil(arr.count / 7.0);
    for (int i = 0; i<num; i++) {
        DatePageView * page = [[DatePageView alloc]init];
        NSArray *smallArray ;
        if (i==num-1) {
            smallArray = [arr subarrayWithRange:NSMakeRange(i*7, arr.count-i*7)];
        }else{
            smallArray = [arr subarrayWithRange:NSMakeRange(i*7, 7)];
        }
        page.allDays = smallArray;
        page.delegate = self;
        [bannerImages addObject:page];
    }
    scrollView.itemImages = bannerImages;
    [scrollView reloadData];

}

- (IBAction)onClick:(id)sender {
    btnExpert.selected = NO;
    btnSpeical.selected = NO;
    btnAll.selected = NO;
    UIButton * btn = (UIButton *) sender;
    type = (int)btn.tag - 100;
    btn.selected = YES;
    [self initScroll];
}

-(void) datePageViewDelegate:(ScheduleDateVO*) vo
{
    if(_delegate){
        [_delegate selectDateViewDelegate:vo];
    }
}

@end
