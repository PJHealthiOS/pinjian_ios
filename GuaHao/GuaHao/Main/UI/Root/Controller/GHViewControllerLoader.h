//
//  GHViewControllerLoader.h
//  Guahao
//
//  Created by 123456 on 16/7/25.
//  Copyright © 2016年 lihu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GHTabBarController.h"              

#import "GHMySelfViewController.h"          ///个人中心
#import "GHSettingViewController.h"         ///设置
#import "GHFamilyMemberViewController.h"    ///家庭成员
#import "GHPersonInfoViewController.h"      ///家庭成员个人信息
#import "GHRechargeViewController.h"        ///支付界面
#import "GHBankStatementController.h"       ///银行流水
#import "GHNormalOrderDetialViewController.h"     ///普通订单详情页
#import "GHExpertOrderDetialViewController.h"     ///专家订单详情页
#import "GHOrderTypeChooseController.h"
#import "HomePageVC.h"///首页2.0
#import "GHSearchViewController.h" ///搜索
#import "GHHospitalChangeViewController.h" ///医院选择页
#import "AppointmentViewController.h"
#import "GHAcceptDetailViewController.h"///接单详情
#import "GHSettingPayPasswordViewController.h"///设置支付密码
#import "GHUploadCertificateViewController.h"///上传凭证
#import "AccompanyOrderViewController.h"///创建陪诊订单
#import "HealthTestListViewController.h"///健康评测列表
#import "GHShareViewController.h"///分享
#import "GHAcceptOrderViewController.h"//我的陪诊订单
#import "CreateOrderNormalViewController.h"///创建普通号订单
#import "GHOrderController.h"//我的订单
#import "GHOrderTypeViewController.h"///个人订单分类页面
#import "CreateOrderExpertViewController.h"///创建专家号订单
#import "UploadImageViewController.h"//上传图片
#import "ChildBannerController.h"
#import "PatientRemarkViewController.h"///查看病情备注
#import "AccOrderListViewController.h"///陪诊列表
#import "AccOrderDetailViewController.h"///陪诊详情
#import "ExpertInfomationViewController.h"///专家介绍详情页
#import "SpecialDepViewController.h"///特色科室
#import "SpecialListViewController.h"///特色科室列表
#import "SpecialDoctorInfoViewController.h"///特色科室医生详情
#import "SpecialDoctorSelectViewController.h"///特色科室医生选择页面
#import "SpecialSearchDoctorViewController.h"///特色科室医生搜索页面
#import "ChooseDepartmentsVC.h"///选择科室
#import "GHFixPersonInfoViewController.h"///修改用户信息
#import "SeriousFlowViewController.h"///重疾介绍页
#import "CreateSeriousOrderController.h"///重疾创建订单页
#import "PackageViewController.h"///重疾套餐说明页
#import "SeriousExpertSelectVC.h"///重疾选择医生页
#import "SeriousOrderListViewController.h"///重疾订单列表
#import "SeriousOrderDetailViewController.h"///重疾详情
#import "SeriousExpertInfoViewController.h"///重疾医生详情页
#import "AccompanyMenuViewController.h"///陪诊菜单页
#import "NewAccompanyFlowerViewController.h"///陪诊引导页
#import "AccompanyMedicineViewController.h"///陪诊取药页
#import "AccompanyReportViewController.h"///陪诊报告页
#import "AccNewOrderDetailViewController.h"///陪诊新的详情页
#import "EvaluateViewController.h"///评价页
#import "EvaluateOKViewController.h"///已经评价页
#import "CityViewController.h"///首页城市页
#import "GHAcceptTypeViewController.h"///接单类型页面
#import "GHAcceptWJDetailViewController.h"///万家详情
#import "HealthManagerViewController.h"///健康管理首页
#import "HealthBasicFlowViewController.h"///健康管理基础套餐介绍页
#import "HealthCustomFlowViewController.h"///健康管理定制化介绍页
#import "HealthBasicOrderViewController.h"///健康管理基础套餐订单
#import "HealthCustomOrderViewController.h"///健康管理定制化订单
#import "HealthManagerOrderViewController.h"///健康管理订单列表页
#import "HealthManagerOrderDetailViewController.h"///健康管理订单详情页
#import "HealthManagerReportDetailViewController.h"///健康管理我的报告详情页
#import "PayViewController.h"///支付界面
#import "GHDisdcountListViewController.h"///优惠券页面
#import "PacketInfoViewController.h"///红包介绍页面
#import "MessageViewController.h"///消息列表页面
#import "NormalUploadViewController.h"///自费挂号
#import "MemberCenterViewController.h"///会员中心
#import "SpecialPayViewController.h"///专家号支付页面
#import "SpecialDiscountListViewController.h"///专家号优惠券
#import "ExpertSelectViewController.h"///搜索专家号
#import "ChooseHospitalVC.h"///选择医院
#import "MessageTakeOrderController.h"///消息新订单接单页面
#import "TestViewController.h"///
#import "GHAcceptCompanyDetailViewController.h"///企业订单详情页
#import "LoginViewController.h"///登录页面页
#import "NormalOrderPayViewController.h"///普通号支付页面页
#import "NormalDiscountListViewController.h"///普通号优惠券页面
#import "NewNormalAcceptViewController.h"///普通号接单详情页面
#import "NewNormalCardAcceptViewController.h"///普通号预约接单详情页面






@interface GHViewControllerLoader : NSObject



+(GHTabBarController *)baseTabBarController;
+(GHMySelfViewController *)GHMySelfViewController;
+(GHSettingViewController *)GHSettingViewController;
+(GHFamilyMemberViewController *)GHFamilyMemberViewController;
+(GHPersonInfoViewController *)GHPersonInfoViewController;
+(GHRechargeViewController *)GHRechargeViewController;
+(GHBankStatementController *)GHBankStatementController;
+(GHAcceptOrderViewController *)GHAcceptOrderViewController;
+(GHOrderController *)GHOrderController;
+(GHOrderTypeViewController *)GHOrderTypeViewController;
+(GHOrderTypeChooseController *)GHOrderTypeChooseController;
+(GHSearchViewController *)GHSearchViewController;
+(GHHospitalChangeViewController *)GHHospitalChangeViewController;
+(AppointmentViewController *)AppointmentViewController;
+(GHAcceptDetailViewController *)GHAcceptDetailViewController;
+(GHSettingPayPasswordViewController *)GHSettingPayPasswordViewController;
+(GHUploadCertificateViewController *)GHUploadCertificateViewController;
+(AccompanyOrderViewController *)AccompanyOrderViewController;
+(HealthTestListViewController *)HealthTestListViewController;
+(GHShareViewController *)GHShareViewController;
+(CreateOrderExpertViewController *)CreateOrderExpertViewController;
+(HomePageVC *)homePageVC;
+(UploadImageViewController *)UploadImageViewController;
+(ChildBannerController *)ChildBannerController;
+(AccOrderListViewController *)AccOrderListViewController;
+(AccOrderDetailViewController *)AccOrderDetailViewController;
+(PatientRemarkViewController *)PatientRemarkViewController;
+(ExpertInfomationViewController *)ExpertInfomationViewController;
+(SpecialDepViewController *)SpecialDepViewController;
+(SpecialListViewController *)SpecialListViewController;
+(SpecialDoctorInfoViewController *)SpecialDoctorInfoViewController;
+(SpecialDoctorSelectViewController *)SpecialDoctorSelectViewController;
+(SpecialSearchDoctorViewController *)SpecialSearchDoctorViewController;
+(CreateOrderNormalViewController *)CreateOrderNormalViewController;
+(ChooseDepartmentsVC *)ChooseDepartmentsVC;
+(GHFixPersonInfoViewController *)GHFixPersonInfoViewController;
+(SeriousFlowViewController *)SeriousFlowViewController;
+(PackageViewController *)PackageViewController;
+(CreateSeriousOrderController *)CreateSeriousOrderController;
+(SeriousExpertSelectVC *)SeriousExpertSelectVC;
+(SeriousOrderListViewController *)SeriousOrderListViewController;
+(SeriousOrderDetailViewController *)SeriousOrderDetailViewController;
+(SeriousExpertInfoViewController *)SeriousExpertInfoViewController;
+(AccompanyMenuViewController *)AccompanyMenuViewController;
+(NewAccompanyFlowerViewController *)NewAccompanyFlowerViewController;
+(AccompanyReportViewController *)AccompanyReportViewController;
+(AccompanyMedicineViewController *)AccompanyMedicineViewController;
+(AccNewOrderDetailViewController *)AccNewOrderDetailViewController;
+(EvaluateViewController *)EvaluateViewController;
+(EvaluateOKViewController *)EvaluateOKViewController;
+(CityViewController *)CityViewController;
+(GHAcceptTypeViewController *)GHAcceptTypeViewController;
+(GHAcceptWJDetailViewController *)GHAcceptWJDetailViewController;
+(HealthManagerViewController *)HealthManagerViewController;
+(HealthBasicFlowViewController *)HealthBasicFlowViewController;
+(HealthCustomFlowViewController *)HealthCustomFlowViewController;
+(HealthBasicOrderViewController *)HealthBasicOrderViewController;
+(HealthCustomOrderViewController *)HealthCustomOrderViewController;
+(HealthManagerOrderViewController *)HealthManagerOrderViewController;
+(HealthManagerOrderDetailViewController *)HealthManagerOrderDetailViewController;
+(HealthManagerReportDetailViewController *)HealthManagerReportDetailViewController;
+(PayViewController *)PayViewController;
+(GHDisdcountListViewController *)GHDisdcountListViewController;
+(PacketInfoViewController *)PacketInfoViewController;
+(GHNormalOrderDetialViewController *)GHNormalOrderDetialViewController;
+(GHExpertOrderDetialViewController *)GHExpertOrderDetialViewController;
+(MessageViewController *)MessageViewController;
+(NormalUploadViewController *)NormalUploadViewController;
+(MemberCenterViewController *)MemberCenterViewController;
+(SpecialPayViewController *)SpecialPayViewController;
+(SpecialDiscountListViewController *)SpecialDiscountListViewController;
+(ExpertSelectViewController *)ExpertSelectViewController;
+(ChooseHospitalVC *)ChooseHospitalVC;
+(MessageTakeOrderController *)MessageTakeOrderController;
+(TestViewController *)TestViewController;
+(GHAcceptCompanyDetailViewController *)GHAcceptCompanyDetailViewController;
+(LoginViewController *)LoginViewController;
+(NormalOrderPayViewController *)NormalOrderPayViewController;
+(NormalDiscountListViewController *)NormalDiscountListViewController;
+(NewNormalAcceptViewController *)NewNormalAcceptViewController;
+(NewNormalCardAcceptViewController *)NewNormalCardAcceptViewController;


+(UIStoryboard *)mainStoryBoard;
+(UIStoryboard *)HomePageStoryBoard;

+(UIStoryboard *)MySelfStoryBoard;              ///我的
+(UIStoryboard *)OrderCenterStoryBoard;         ///订单
@end
