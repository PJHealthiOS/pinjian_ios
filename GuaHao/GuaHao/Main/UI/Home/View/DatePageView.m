//
//  GuaHao
//
//  Created by qiye on 16/2/15.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "DatePageView.h"
#import "UIViewController+Toast.h"
#import "ServerManger.h"
#import "FilterDateVO.h"
#import "DateDayCell.h"
@interface DatePageView ()<DateDayCellDelegate>
@end

@implementation DatePageView{
    NSMutableArray * cells;
    FilterDateVO   * dateVO;
    __weak IBOutlet UIImageView *imgLeft;
    __weak IBOutlet UIView *bgView;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        UIView * containerView = [[[UINib nibWithNibName:@"DatePageView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
        [self performSelector:@selector(initView) withObject:nil afterDelay:0.2f];
    }
    return self;
}

-(void) initView{
    float width = (bgView.width - imgLeft.width)/7;
    cells = [NSMutableArray new];
    for (int i = 0; i<7; i++) {
        DateDayCell * cell = [[DateDayCell alloc] initWithFrame:CGRectMake(i*width+imgLeft.width, 0, width, 146)];
        if (_allDays.count>i) {
            cell.dayVO = _allDays[i];
            cell.delegate = self;
        }
        [cell setCell];
        [self addSubview:cell];
        [cells addObject:cell];
    }
}

-(void) delegateDateDayCell:(ScheduleDateVO*) vo
{
    if(_delegate){
        [_delegate datePageViewDelegate:vo];
    }
}

@end
