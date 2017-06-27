#import "Validator.h"

@implementation Validator

+ (BOOL)isValidPassword:(NSString *)password
{
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:password]) {
        return YES ;
    } else {
        return NO;
    }
}
+ (BOOL)isValidMobile:(NSString *)mobile
{
    if (mobile.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
     * 电信号段: 133,149,153,170,173,177,180,181,189
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,155,156,170,171,175,176,185,186
     */
    NSString *CU = @"^1(3[0-2]|4[5]|5[56]|7[0156]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,149,153,170,173,177,180,181,189
     */
    NSString *CT = @"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobile] == YES)
        || ([regextestcm evaluateWithObject:mobile] == YES)
        || ([regextestct evaluateWithObject:mobile] == YES)
        || ([regextestcu evaluateWithObject:mobile] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
+ (BOOL)isValidSMSCode:(NSString *)code
{
    return code.length == 6;
}
+ (BOOL)isValidEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+(NSString *)birthdayStrFromIdentityCard:(NSString *)numberStr
{
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    NSString *year = nil;
    NSString *month = nil;
    
    BOOL isAllNumber = YES;
    NSString *day = nil;
    if([numberStr length]<14)
        return result;
    
    //**截取前14位
    NSString *fontNumer = [numberStr substringWithRange:NSMakeRange(0, 13)];
    
    //**检测前14位否全都是数字;
    const char *str = [fontNumer UTF8String];
    const char *p = str;
    while (*p!='\0') {
        if(!(*p>='0'&&*p<='9'))
            isAllNumber = NO;
        p++;
    }
    if(!isAllNumber)
        return result;
    
    year = [numberStr substringWithRange:NSMakeRange(6, 4)];
    month = [numberStr substringWithRange:NSMakeRange(10, 2)];
    day = [numberStr substringWithRange:NSMakeRange(12,2)];
    
    [result appendString:year];
    [result appendString:@"-"];
    [result appendString:month];
    [result appendString:@"-"];
    [result appendString:day];
    
    return result;

}

+ (BOOL)isValidIdentityCard:(NSString *)ID
{
    if (ID.length <= 0) {
        return NO;
    }
    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [identityCardPredicate evaluateWithObject:ID];
}

+ (NSInteger)isValidIdentityCard:(NSString *)ID birthDate:(NSDate *)birthDate gender:(NSString *)gender
{
    if (![self isValidIdentityCard:ID]) {
        return 1;
    }
    NSString *birth = nil;
    NSString *orderCode = nil;
    if (ID.length == 15) {
        birth = [ID substringWithRange:NSMakeRange(6, 6)];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyMMdd"];
        orderCode = [ID substringWithRange:NSMakeRange(12, 3)];
    } else {
        birth = [ID substringWithRange:NSMakeRange(6, 8)];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyyMMdd"];
        orderCode = [ID substringWithRange:NSMakeRange(14, 3)];
    }
    if (birthDate && ![birthDate isEqualToDate:[NSDate date]]) {
        NSString *birthDay = nil;
        if (ID.length == 15) {
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyMMdd"];
            birthDay = [format stringFromDate:birthDate];
        } else {
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyyMMdd"];
            birthDay = [format stringFromDate:birthDate];
        }
        if (![birthDay isEqualToString:birth]) {
            return 2;
        }
    }
    if (gender) {
        if (!([orderCode integerValue] % 2) != [gender isEqualToString:@"1"]) {
            return 3;
        }
    }
    
    return 0;
}

+(BOOL)getSexWithIDCardNumber:(NSString *)cardNumber{
    NSString *orderCode = @"";
    if (cardNumber.length == 15) {
        
        orderCode = [cardNumber substringWithRange:NSMakeRange(12, 3)];
    } else {
        
        orderCode = [cardNumber substringWithRange:NSMakeRange(14, 3)];
    }
    if (orderCode.integerValue % 2 == 1) {
        return YES;
    }else{
        return NO;
    }
}
+ (BOOL)isValidSexWithCard:(NSString *)ID sex:(NSString*)sex
{
    NSString *orderCode = nil;
    if (ID.length == 15) {

        orderCode = [ID substringWithRange:NSMakeRange(12, 3)];
    } else {

        orderCode = [ID substringWithRange:NSMakeRange(14, 3)];
    }

    if (sex) {
        if (!([orderCode integerValue] % 2) != [sex isEqualToString:@"男"]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isValidPassport:(NSString *)ID
{
    if(ID&&ID.length>6){
        return YES;
    }
    return NO;
}

+ (BOOL)isValidMedicareCard:(NSString *)medicare
{
    return [medicare isEqualToString:@"社保卡"]||medicare.length == 0 || medicare.length >= 10;
}
+ (BOOL)isValidDoctorCertificate:(NSString *)certificate
{
    return YES;
}

+(BOOL)isValidCardNumber:(NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length < 18)
    {
        flag = NO;
        return flag;
    }
    
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    flag = [identityCardPredicate evaluateWithObject:identityCard];
    
    
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(flag)
    {
        if(identityCard.length==18)
        {
            //将前17位加权因子保存在数组里
            NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
            
            //这是除以11后，可能产生的11位余数、验证码，也保存成数组
            NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
            
            //用来保存前17位各自乖以加权因子后的总和
            
            NSInteger idCardWiSum = 0;
            for(int i = 0;i < 17;i++)
            {
                NSInteger subStrIndex = [[identityCard substringWithRange:NSMakeRange(i, 1)] integerValue];
                NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
                
                idCardWiSum+= subStrIndex * idCardWiIndex;
                
            }
            
            //计算出校验码所在数组的位置
            NSInteger idCardMod=idCardWiSum%11;
            
            //得到最后一位身份证号码
            NSString * idCardLast= [identityCard substringWithRange:NSMakeRange(17, 1)];
            
            //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
            if(idCardMod==2)
            {
                if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
                {
                    return flag;
                }else
                {
                    flag =  NO;
                    return flag;
                }
            }else
            {
                //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
                if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
                {
                    return flag;
                }
                else
                {
                    flag =  NO;
                    return flag;
                }
            }
        }
        else
        {
            flag =  NO;
            return flag;
        }
    }
    else
    {
        return flag;
    }

}

+ (BOOL)isValidName:(NSString *)name
{
    NSArray* arr = @[@"赵",@"钱",@"孙",@"李",@"周",@"吴",@"郑",@"王",@"冯",@"陈",@"褚",@"卫",@"蒋",@"沈",@"韩",@"杨",@"朱",@"秦",@"尤",@"许",@"何",@"吕",@"施",@"张",@"孔",@"曹",@"严",@"华",@"金",@"魏",@"陶",@"姜",@"戚",@"谢",@"邹",@"喻",@"柏",@"水",@"窦",@"章",@"云",@"苏",@"潘",@"葛",@"奚",@"范",@"彭",@"郎",@"鲁",@"韦",@"昌",@"马",@"苗",@"凤",@"花",@"方",@"俞",@"任",@"袁",@"柳",@"酆",@"鲍",@"史",@"唐",@"费",@"廉",@"岑",@"薛",@"雷",@"贺",@"倪",@"汤",@"滕",@"殷",@"罗",@"毕",@"郝",@"邬",@"安",@"常",@"乐",@"于",@"时",@"傅",@"皮",@"卞",@"齐",@"康",@"伍",@"余",@"元",@"卜",@"顾",@"孟",@"平",@"黄",@"和",@"穆",@"萧",@"尹",@"姚",@"邵",@"湛",@"汪",@"祁",@"毛",@"禹",@"狄",@"米",@"贝",@"明",@"臧",@"计",@"伏",@"成",@"戴",@"谈",@"宋",@"茅",@"庞",@"熊",@"纪",@"舒",@"屈",@"项",@"祝",@"董",@"梁",@"杜",@"阮",@"蓝",@"闵",@"席",@"季",@"麻",@"强",@"贾",@"路",@"娄",@"危",@"江",@"童",@"颜",@"郭",@"梅",@"盛",@"林",@"刁",@"锺",@"徐",@"邱",@"骆",@"高",@"夏",@"蔡",@"田",@"樊",@"胡",@"凌",@"霍",@"虞",@"万",@"支",@"柯",@"昝",@"管",@"卢",@"莫",@"经",@"房",@"裘",@"缪",@"干",@"解",@"应",@"宗",@"丁",@"宣",@"贲",@"邓",@"郁",@"单",@"杭",@"洪",@"包",@"诸",@"左",@"石",@"崔",@"吉",@"钮",@"龚",@"程",@"嵇",@"邢",@"滑",@"裴",@"陆",@"荣",@"翁",@"荀",@"羊",@"於",@"惠",@"甄",@"麴",@"家",@"封",@"芮",@"羿",@"储",@"靳",@"汲",@"邴",@"糜",@"松",@"井",@"段",@"富",@"巫",@"乌",@"焦",@"巴",@"弓",@"牧",@"隗",@"山",@"谷",@"车",@"侯",@"宓",@"蓬",@"全",@"郗",@"班",@"仰",@"秋",@"仲",@"伊",@"宫",@"宁",@"仇",@"栾",@"暴",@"甘",@"钭",@"历",@"戎",@"祖",@"武",@"符",@"刘",@"景",@"詹",@"束",@"龙",@"叶",@"幸",@"司",@"韶",@"郜",@"黎",@"蓟",@"溥",@"印",@"宿",@"白",@"怀",@"蒲",@"邰",@"从",@"鄂",@"索",@"咸",@"籍",@"赖",@"卓",@"蔺",@"屠",@"蒙",@"池",@"乔",@"阳",@"郁",@"胥",@"能",@"苍",@"双",@"闻",@"莘",@"党",@"翟",@"谭",@"贡",@"劳",@"逄",@"姬",@"申",@"扶",@"堵",@"冉",@"宰",@"郦",@"雍",@"却",@"璩",@"桑",@"桂",@"濮",@"牛",@"寿",@"通",@"边",@"扈",@"燕",@"冀",@"h",@"浦",@"尚",@"农",@"温",@"别",@"庄",@"晏",@"柴",@"瞿",@"阎",@"充",@"慕",@"连",@"茹",@"习",@"宦",@"艾",@"鱼",@"容",@"向",@"古",@"易",@"慎",@"戈",@"廖",@"庾",@"终",@"暨",@"居",@"衡",@"步",@"都",@"耿",@"满",@"弘",@"匡",@"国",@"文",@"寇",@"广",@"禄",@"阙",@"东",@"欧",@"殳",@"沃",@"利",@"蔚",@"越",@"夔",@"隆",@"师",@"巩",@"厍",@"聂",@"晁",@"勾",@"敖",@"融",@"冷",@"訾",@"辛",@"阚",@"那",@"简",@"饶",@"空",@"曾",@"毋",@"沙",@"乜",@"养",@"鞠",@"须",@"丰",@"巢",@"关",@"蒯",@"相",@"查",@"后",@"荆",@"红",@"游",@"竺",@"权",@"逮",@"盍",@"益",@"桓",@"公",@"万俟",@"司马",@"上官",@"欧阳",@"夏侯",@"诸葛",@"闻人",@"东方",@"赫连",@"皇甫",@"尉迟",@"公羊",@"澹台",@"公冶",@"宗政",@"濮阳",@"淳于",@"单于",@"太叔",@"申屠",@"公孙",@"仲孙",@"轩辕",@"令狐",@"钟离",@"宇文",@"长孙",@"慕容",@"司徒",@"空",@"召",@"有",@"舜",@"叶赫那拉",@"丛",@"岳",@"寸",@"贰",@"皇",@"侨",@"彤",@"竭",@"端",@"赫",@"实",@"甫",@"集",@"象",@"翠",@"狂",@"辟",@"典",@"良",@"函",@"芒",@"苦",@"其",@"京",@"中",@"夕",@"之",@"章佳",@"那拉",@"冠",@"宾",@"香",@"果",@"依尔根觉罗",@"依尔觉罗",@"萨嘛喇",@"赫舍里",@"额尔德特",@"萨克达",@"钮祜禄",@"他塔喇",@"喜塔腊",@"讷殷富察",@"叶赫那兰",@"库雅喇",@"瓜尔佳",@"舒穆禄",@"爱新觉罗",@"索绰络",@"纳喇",@"乌雅",@"范姜",@"碧鲁",@"张廖",@"张简",@"图门",@"太史",@"公叔",@"乌孙",@"完颜",@"马佳",@"佟",@"富察",@"费莫",@"蹇",@"称",@"诺",@"来",@"多",@"繁",@"戊",@"朴",@"回",@"毓",@"税",@"荤",@"靖",@"绪",@"愈",@"硕",@"牢",@"买",@"但",@"巧",@"枚",@"撒",@"泰",@"秘",@"亥",@"绍",@"以",@"壬",@"森",@"斋",@"释",@"奕",@"姒",@"朋",@"求",@"羽",@"用",@"占",@"真",@"穰",@"翦",@"闾",@"漆",@"贵",@"代",@"贯",@"旁",@"崇",@"栋",@"告",@"休",@"褒",@"谏",@"锐",@"皋",@"闳",@"在",@"歧",@"禾",@"示",@"是",@"委",@"钊",@"频",@"嬴",@"呼",@"大",@"威",@"昂",@"律",@"冒",@"保",@"系",@"抄",@"定",@"化",@"莱",@"校",@"么",@"抗",@"祢",@"綦",@"悟",@"宏",@"功",@"庚",@"务",@"敏",@"捷",@"拱",@"兆",@"丑",@"丙",@"畅",@"苟",@"随",@"类",@"卯",@"俟",@"友",@"答",@"乙",@"允",@"甲",@"留",@"尾",@"佼",@"玄",@"乘",@"裔",@"延",@"植",@"环",@"矫",@"赛",@"昔",@"侍",@"度",@"旷",@"遇",@"偶",@"前",@"由",@"咎",@"塞",@"敛",@"受",@"泷",@"袭",@"衅",@"叔",@"圣",@"御",@"夫",@"仆",@"镇",@"藩",@"邸",@"府",@"掌",@"首",@"员",@"焉",@"戏",@"可",@"智",@"尔",@"凭",@"悉",@"进",@"笃",@"厚",@"仁",@"业",@"肇",@"资",@"合",@"仍",@"九",@"衷",@"哀",@"刑",@"俎",@"仵",@"圭",@"夷",@"徭",@"蛮",@"汗",@"孛",@"乾",@"帖",@"罕",@"洛",@"淦",@"洋",@"邶",@"郸",@"郯",@"邗",@"邛",@"剑",@"虢",@"隋",@"蒿",@"茆",@"菅",@"苌",@"树",@"桐",@"锁",@"钟",@"机",@"盘",@"铎",@"斛",@"玉",@"线",@"针",@"箕",@"庹",@"绳",@"磨",@"蒉",@"瓮",@"弭",@"刀",@"疏",@"牵",@"浑",@"恽",@"势",@"世",@"仝",@"同",@"蚁",@"止",@"戢",@"睢",@"冼",@"种",@"涂",@"肖",@"己",@"泣",@"潜",@"卷",@"脱",@"谬",@"蹉",@"赧",@"浮",@"顿",@"说",@"次",@"错",@"念",@"夙",@"斯",@"完",@"丹",@"表",@"聊",@"源",@"姓",@"吾",@"寻",@"展",@"出",@"不",@"户",@"闭",@"才",@"无",@"书",@"学",@"愚",@"本",@"性",@"雪",@"霜",@"烟",@"寒",@"少",@"字",@"桥",@"板",@"斐",@"独",@"千",@"诗",@"嘉",@"扬",@"善",@"揭",@"祈",@"析",@"赤",@"紫",@"青",@"柔",@"刚",@"奇",@"拜",@"佛",@"陀",@"弥",@"阿",@"素",@"长",@"僧",@"隐",@"仙",@"隽",@"宇",@"祭",@"酒",@"淡",@"塔",@"琦",@"闪",@"始",@"星",@"南",@"天",@"接",@"波",@"碧",@"速",@"禚",@"腾",@"潮",@"镜",@"似",@"澄",@"潭",@"謇",@"纵",@"渠",@"奈",@"风",@"春",@"濯",@"沐",@"茂",@"英",@"兰",@"檀",@"藤",@"枝",@"检",@"生",@"折",@"登",@"驹",@"骑",@"貊",@"虎",@"肥",@"鹿",@"雀",@"野",@"禽",@"飞",@"节",@"宜",@"鲜",@"粟",@"栗",@"豆",@"帛",@"官",@"布",@"衣",@"藏",@"宝",@"钞",@"银",@"门",@"盈",@"庆",@"喜",@"及",@"普",@"建",@"营",@"巨",@"望",@"希",@"道",@"载",@"声",@"漫",@"犁",@"力",@"贸",@"勤",@"革",@"改",@"兴",@"亓",@"睦",@"修",@"信",@"闽",@"北",@"守",@"坚",@"勇",@"汉",@"练",@"尉",@"士",@"旅",@"五",@"令",@"将",@"旗",@"军",@"行",@"奉",@"敬",@"恭",@"仪",@"母",@"堂",@"丘",@"义",@"礼",@"慈",@"孝",@"理",@"伦",@"卿",@"问",@"永",@"辉",@"位",@"让",@"尧",@"依",@"犹",@"介",@"承",@"市",@"所",@"苑",@"杞",@"剧",@"第",@"零",@"谌",@"招",@"续",@"达",@"忻",@"六",@"鄞",@"战",@"迟",@"候",@"宛",@"励",@"粘",@"萨",@"邝",@"覃",@"辜",@"初",@"楼",@"城",@"区",@"局",@"台",@"原",@"考",@"妫",@"纳",@"泉",@"老",@"清",@"德",@"卑",@"过",@"麦",@"曲",@"竹",@"百",@"福",@"言",@"第五",@"佟",@"爱",@"年",@"笪",@"谯",@"哈",@"墨",@"南宫",@"赏",@"伯",@"佴",@"佘",@"牟",@"商",@"西门",@"东门",@"左丘",@"梁丘",@"琴",@"后",@"况",@"亢",@"缑",@"帅",@"微生",@"羊舌",@"海",@"归",@"呼延",@"南门",@"东郭",@"百里",@"钦",@"鄢",@"汝",@"法",@"闫",@"楚",@"晋",@"谷梁",@"宰父",@"夹谷",@"拓跋",@"壤驷",@"乐正",@"漆雕",@"公西",@"巫马",@"端木",@"颛孙",@"子车",@"督",@"仉",@"司寇",@"亓官",@"鲜于",@"锺离",@"盖",@"逯",@"库",@"郏",@"逢",@"阴",@"薄",@"厉",@"稽",@"闾丘",@"公良",@"段干",@"开",@"光",@"操",@"瑞",@"眭",@"泥",@"运",@"摩",@"伟",@"铁",@"欧阳",@"太史",@"端木",@"上官",@"司马",@"东方",@"独孤",@"南宫",@"万俟",@"闻人",@"夏侯",@"诸葛",@"尉迟",@"公羊",@"赫连",@"澹台",@"皇甫",@"宗政",@"濮阳",@"公冶",@"太叔",@"申屠",@"公孙",@"慕容",@"仲孙",@"钟离",@"长孙",@"宇文",@"司徒",@"鲜于",@"司空",@"闾丘",@"子车",@"亓官",@"司寇",@"巫马",@"公西",@"颛孙",@"壤驷",@"公良",@"漆雕",@"乐正",@"宰父",@"谷梁",@"拓跋",@"夹谷",@"轩辕",@"令狐",@"段干",@"百里",@"呼延",@"东郭",@"南门",@"羊舌",@"微生",@"公户",@"公玉",@"公仪",@"梁丘",@"公仲",@"公上",@"公门",@"公山",@"公坚",@"左丘",@"公伯",@"西门",@"公祖",@"第五",@"公乘",@"贯丘",@"公皙",@"南荣",@"东里",@"东宫",@"仲长",@"子书",@"子桑",@"即墨",@"达奚",@"褚师",@"吴铭",@"迮"];
    for(int i= 0;i<arr.count;i++){
        NSString* xx = arr[i];
        if(xx.length > name.length) continue;
        NSString* namex = [name substringWithRange:NSMakeRange(0,xx.length)];
        if ([xx isEqualToString:namex]) {
            return YES;
        }
    }
    return NO;
}

@end
