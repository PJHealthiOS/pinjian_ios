//
//  OrderDetailPriceView.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/10.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "OrderDetailPriceView.h"
#import "OrderDetailPriceCell.h"
@interface OrderDetailPriceView ()<UITableViewDataSource,UITableViewDelegate>{
    
}
@property (strong, nonatomic) UITableView *tableView;

@end
@implementation OrderDetailPriceView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.tableView.delegate =self;
        self.tableView.scrollEnabled = NO;
        self.tableView.separatorStyle = NO;
        self.tableView.dataSource =self;
        [self addSubview:self.tableView];
        [self.tableView registerNib:[UINib nibWithNibName:@"OrderDetailPriceCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OrderDetailPriceCell"];
    }
    return self;
}

-(void)reloadTableViewWithSourceArr:(NSArray *)sourceArr{
    self.sourceArr = sourceArr;
    [self.tableView reloadData];
    NSLog(@"sourceArr-------%@",sourceArr);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [self.sourceArr objectAtIndex:indexPath.row];
    
    OrderDetailPriceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"OrderDetailPriceCell"];
    [cell loadCellWith:[dic objectForKey:@"type"] valueStr:[NSString stringWithFormat:@"%@",[dic objectForKey:@"value"]] hidden:[[dic objectForKey:@"hidden"] isEqualToString:@"0"] gary:[[dic objectForKey:@"gary"] isEqualToString:@"1"]];
    return cell;
}










/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
