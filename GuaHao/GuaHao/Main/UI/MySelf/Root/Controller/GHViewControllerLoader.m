//
//  GHViewControllerLoader.m
//  Guahao
//
//  Created by 123456 on 16/7/25.
//  Copyright © 2016年 lihu. All rights reserved.
//

#import "GHViewControllerLoader.h"
#import "GHTabBarController.h"

@implementation GHViewControllerLoader
//+(GHTabBarController *)tabbarViewController{
//    
//}

+(GHTabBarController *)baseTabBarController;{
   return  (GHTabBarController *)[[self mainStoryBoard]instantiateViewControllerWithIdentifier:@"GHTabBarController"];
}
+(GHMySelfViewController *)GHMySelfViewController{
    return  (GHMySelfViewController *)[[self MySelfStoryBoard]instantiateViewControllerWithIdentifier:@"GHMySelfViewController"];
}
+(GHSettingViewController *)GHSettingViewController{
    return  (GHSettingViewController *)[[self MySelfStoryBoard]instantiateViewControllerWithIdentifier:@"GHSettingViewController"];
}
+(GHFamilyMemberViewController *)GHFamilyMemberViewController{
    return  (GHFamilyMemberViewController *)[[self MySelfStoryBoard]instantiateViewControllerWithIdentifier:@"GHFamilyMemberViewController"];
}
+(GHPersonInfoViewController *)GHPersonInfoViewController{
    return  (GHPersonInfoViewController *)[[self MySelfStoryBoard]instantiateViewControllerWithIdentifier:@"GHPersonInfoViewController"];
}
+(GHRechargeViewController *)GHRechargeViewController{
    return  (GHRechargeViewController *)[[self MySelfStoryBoard]instantiateViewControllerWithIdentifier:@"GHRechargeViewController"];
}
+(GHBankStatementController *)GHBankStatementController{
    return  (GHBankStatementController *)[[self MySelfStoryBoard]instantiateViewControllerWithIdentifier:@"GHBankStatementController"];
}



+(GHOrderTypeChooseController *)GHOrderTypeChooseController{
    return  (GHOrderTypeChooseController *)[[self OrderCenterStoryBoard]instantiateViewControllerWithIdentifier:@"GHOrderTypeChooseController"];
}

+(GHSearchViewController *)GHSearchViewController{
    return  (GHSearchViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"GHSearchViewController"];
}
+(GHHospitalChangeViewController *)GHHospitalChangeViewController{
    return  (GHHospitalChangeViewController *)[[self OrderCenterStoryBoard]instantiateViewControllerWithIdentifier:@"GHHospitalChangeViewController"];
}

+(AppointmentViewController *)AppointmentViewController{
    return  (AppointmentViewController *)[[self OrderCenterStoryBoard]instantiateViewControllerWithIdentifier:@"AppointmentViewController"];
}
+(GHAcceptDetailViewController *)GHAcceptDetailViewController{
    return  (GHAcceptDetailViewController *)[[self OrderCenterStoryBoard]instantiateViewControllerWithIdentifier:@"GHAcceptDetailViewController"];
}
+(GHAcceptOrderViewController *)GHAcceptOrderViewController{
    return  (GHAcceptOrderViewController *)[[self OrderCenterStoryBoard]instantiateViewControllerWithIdentifier:@"GHAcceptOrderViewController"];
}
+(GHOrderController *)GHOrderController{
    return  (GHOrderController *)[[self OrderCenterStoryBoard]instantiateViewControllerWithIdentifier:@"GHOrderController"];
}
+(GHOrderTypeViewController *)GHOrderTypeViewController{
    return  (GHOrderTypeViewController *)[[self OrderCenterStoryBoard]instantiateViewControllerWithIdentifier:@"GHOrderTypeViewController"];
}

+(GHSettingPayPasswordViewController *)GHSettingPayPasswordViewController{
    return  (GHSettingPayPasswordViewController *)[[self MySelfStoryBoard]instantiateViewControllerWithIdentifier:@"GHSettingPayPasswordViewController"];
}
+(GHUploadCertificateViewController *)GHUploadCertificateViewController{
    return  (GHUploadCertificateViewController *)[[self OrderCenterStoryBoard]instantiateViewControllerWithIdentifier:@"GHUploadCertificateViewController"];
}
+(HomePageVC *)homePageVC{
    return  (HomePageVC *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"HomePageVC"];
}
+(AccompanyOrderViewController *)AccompanyOrderViewController{
    return  (AccompanyOrderViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"AccompanyOrderViewController"];
}
+(HealthTestListViewController *)HealthTestListViewController{
    return  (HealthTestListViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"HealthTestListViewController"];
}
+(GHShareViewController *)GHShareViewController{
    return  (GHShareViewController *)[[self MySelfStoryBoard]instantiateViewControllerWithIdentifier:@"GHShareViewController"];
}
+(CreateOrderExpertViewController *)CreateOrderExpertViewController{
    return  (CreateOrderExpertViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"CreateOrderExpertViewController"];
}
+(UploadImageViewController *)UploadImageViewController{
     return  (UploadImageViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"UploadImageViewController"];
}
+(ChildBannerController *)ChildBannerController{
         return  (ChildBannerController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"ChildBannerController"];
}
+(AccOrderListViewController *)AccOrderListViewController{
    return  (AccOrderListViewController *)[[self OrderCenterStoryBoard]instantiateViewControllerWithIdentifier:@"AccOrderListViewController"];
}
+(AccOrderDetailViewController *)AccOrderDetailViewController{
    return  (AccOrderDetailViewController *)[[self OrderCenterStoryBoard]instantiateViewControllerWithIdentifier:@"AccOrderDetailViewController"];
}
+(PatientRemarkViewController *)PatientRemarkViewController{
    return  (PatientRemarkViewController *)[[self OrderCenterStoryBoard]instantiateViewControllerWithIdentifier:@"PatientRemarkViewController"];
}
+(ExpertInfomationViewController *)ExpertInfomationViewController{
    return  (ExpertInfomationViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"ExpertInfomationViewController"];
}

+(GHFixPersonInfoViewController *)GHFixPersonInfoViewController{
    return  (GHFixPersonInfoViewController *)[[self MySelfStoryBoard]instantiateViewControllerWithIdentifier:@"GHFixPersonInfoViewController"];

}
+(SpecialListViewController *)SpecialListViewController{
    return  (SpecialListViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"SpecialListViewController"];
}
+(SpecialDepViewController *)SpecialDepViewController{
    return  (SpecialDepViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"SpecialDepViewController"];
}
+(SpecialDoctorInfoViewController *)SpecialDoctorInfoViewController{
    return  (SpecialDoctorInfoViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"SpecialDoctorInfoViewController"];
}

+(SpecialDoctorSelectViewController *)SpecialDoctorSelectViewController{
    return  (SpecialDoctorSelectViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"SpecialDoctorSelectViewController"];
}
+(SpecialSearchDoctorViewController *)SpecialSearchDoctorViewController{
    return  (SpecialSearchDoctorViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"SpecialSearchDoctorViewController"];
}
+(CreateOrderNormalViewController *)CreateOrderNormalViewController{
    return  (CreateOrderNormalViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"CreateOrderNormalViewController"];
}
+(ChooseDepartmentsVC *)ChooseDepartmentsVC{
    return  (ChooseDepartmentsVC *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"ChooseDepartmentsVC"];
}
+(SeriousFlowViewController *)SeriousFlowViewController{
    return  (SeriousFlowViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"SeriousFlowViewController"];
}
+(PackageViewController *)PackageViewController{
    return  (PackageViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"PackageViewController"];
}
+(CreateSeriousOrderController *)CreateSeriousOrderController{
    return  (CreateSeriousOrderController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"CreateSeriousOrderController"];
}
+(SeriousExpertSelectVC *)SeriousExpertSelectVC{
    return  (SeriousExpertSelectVC *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"SeriousExpertSelectVC"];
}
+(SeriousOrderListViewController *)SeriousOrderListViewController{
    return  (SeriousOrderListViewController *)[[self OrderCenterStoryBoard]instantiateViewControllerWithIdentifier:@"SeriousOrderListViewController"];
}
+(SeriousOrderDetailViewController *)SeriousOrderDetailViewController{
    return  (SeriousOrderDetailViewController *)[[self OrderCenterStoryBoard]instantiateViewControllerWithIdentifier:@"SeriousOrderDetailViewController"];
}
+(SeriousExpertInfoViewController *)SeriousExpertInfoViewController{
    return  (SeriousExpertInfoViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"SeriousExpertInfoViewController"];

}
+(AccompanyMenuViewController *)AccompanyMenuViewController{
    return  (AccompanyMenuViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"AccompanyMenuViewController"];
    
}
+(NewAccompanyFlowerViewController *)NewAccompanyFlowerViewController{
    return  (NewAccompanyFlowerViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"NewAccompanyFlowerViewController"];
    
}
+(AccompanyReportViewController *)AccompanyReportViewController{
    return  (AccompanyReportViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"AccompanyReportViewController"];
    
}
+(AccompanyMedicineViewController *)AccompanyMedicineViewController{
    return  (AccompanyMedicineViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"AccompanyMedicineViewController"];
    
}
+(AccNewOrderDetailViewController *)AccNewOrderDetailViewController{
    return  (AccNewOrderDetailViewController *)[[self OrderCenterStoryBoard]instantiateViewControllerWithIdentifier:@"AccNewOrderDetailViewController"];

}
+(EvaluateViewController *)EvaluateViewController{
    return  (EvaluateViewController *)[[self OrderCenterStoryBoard]instantiateViewControllerWithIdentifier:@"EvaluateViewController"];
}
+(EvaluateOKViewController *)EvaluateOKViewController{
    return  (EvaluateOKViewController *)[[self OrderCenterStoryBoard]instantiateViewControllerWithIdentifier:@"EvaluateOKViewController"];
}

+(CityViewController *)CityViewController
{
    return  (CityViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"CityViewController"];
}

+(GHAcceptTypeViewController *)GHAcceptTypeViewController{
    return  (GHAcceptTypeViewController *)[[self OrderCenterStoryBoard]instantiateViewControllerWithIdentifier:@"GHAcceptTypeViewController"];
}
+(GHAcceptWJDetailViewController *)GHAcceptWJDetailViewController{
    return  (GHAcceptWJDetailViewController *)[[self OrderCenterStoryBoard]instantiateViewControllerWithIdentifier:@"GHAcceptWJDetailViewController"];
}
+(HealthManagerViewController *)HealthManagerViewController{
    return  (HealthManagerViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"HealthManagerViewController"];
}
+(HealthBasicFlowViewController *)HealthBasicFlowViewController{
    return  (HealthBasicFlowViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"HealthBasicFlowViewController"];
}
+(HealthCustomFlowViewController *)HealthCustomFlowViewController{
    return  (HealthCustomFlowViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"HealthCustomFlowViewController"];
}
+(HealthBasicOrderViewController *)HealthBasicOrderViewController{
    return  (HealthBasicOrderViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"HealthBasicOrderViewController"];
}
+(HealthCustomOrderViewController *)HealthCustomOrderViewController{
    return  (HealthCustomOrderViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"HealthCustomOrderViewController"];
}

+(HealthManagerOrderViewController *)HealthManagerOrderViewController{
    return  (HealthManagerOrderViewController *)[[self OrderCenterStoryBoard]instantiateViewControllerWithIdentifier:@"HealthManagerOrderViewController"];
}
+(HealthManagerOrderDetailViewController *)HealthManagerOrderDetailViewController{
    return  (HealthManagerOrderDetailViewController *)[[self OrderCenterStoryBoard]instantiateViewControllerWithIdentifier:@"HealthManagerOrderDetailViewController"];
}
+(HealthManagerReportDetailViewController *)HealthManagerReportDetailViewController{
    return  (HealthManagerReportDetailViewController *)[[self OrderCenterStoryBoard]instantiateViewControllerWithIdentifier:@"HealthManagerReportDetailViewController"];
}
+(PayViewController *)PayViewController{
    return  (PayViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"PayViewController"];
}
+(GHDisdcountListViewController *)GHDisdcountListViewController{
    return  (GHDisdcountListViewController *)[[self MySelfStoryBoard]instantiateViewControllerWithIdentifier:@"GHDisdcountListViewController"];
}
+(PacketInfoViewController *)PacketInfoViewController{
    return  (PacketInfoViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"PacketInfoViewController"];
}

+(GHNormalOrderDetialViewController *)GHNormalOrderDetialViewController{
    return  (GHNormalOrderDetialViewController *)[[self OrderCenterStoryBoard]instantiateViewControllerWithIdentifier:@"GHNormalOrderDetialViewController"];

}
+(GHExpertOrderDetialViewController *)GHExpertOrderDetialViewController{
    return  (GHExpertOrderDetialViewController *)[[self OrderCenterStoryBoard]instantiateViewControllerWithIdentifier:@"GHExpertOrderDetialViewController"];
    
}
+(MessageViewController *)MessageViewController{
    return  (MessageViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"MessageViewController"];

}

+(NormalUploadViewController *)NormalUploadViewController{
    return  (NormalUploadViewController *)[[self OrderCenterStoryBoard]instantiateViewControllerWithIdentifier:@"NormalUploadViewController"];
}

+(MemberCenterViewController *)MemberCenterViewController{
    return  (MemberCenterViewController *)[[self MySelfStoryBoard]instantiateViewControllerWithIdentifier:@"MemberCenterViewController"];
}

+(SpecialPayViewController *)SpecialPayViewController{
    return  (SpecialPayViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"SpecialPayViewController"];

}

+(SpecialDiscountListViewController *)SpecialDiscountListViewController{
    return  (SpecialDiscountListViewController *)[[self MySelfStoryBoard]instantiateViewControllerWithIdentifier:@"SpecialDiscountListViewController"];

}

+(ExpertSelectViewController *)ExpertSelectViewController{
    return  (ExpertSelectViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"ExpertSelectViewController"];

}
+(ChooseHospitalVC *)ChooseHospitalVC{
    return  (ChooseHospitalVC *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"ChooseHospitalVC"];
    
}
+(MessageTakeOrderController *)MessageTakeOrderController{
    return  (MessageTakeOrderController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"MessageTakeOrderController"];
}

+(TestViewController *)TestViewController{
    return  (TestViewController *)[[self HomePageStoryBoard]instantiateViewControllerWithIdentifier:@"TestViewController"];

}
+(GHAcceptCompanyDetailViewController *)GHAcceptCompanyDetailViewController{
    return  (GHAcceptCompanyDetailViewController *)[[self OrderCenterStoryBoard]instantiateViewControllerWithIdentifier:@"GHAcceptCompanyDetailViewController"];

}
+(LoginViewController *)LoginViewController{
    return  (LoginViewController *)[[self MySelfStoryBoard]instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
}














+(UIStoryboard *)mainStoryBoard{
    static UIStoryboard *storyBoard = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }) ;
    return storyBoard;
}
+(UIStoryboard *)HomePageStoryBoard{
    static UIStoryboard *storyBoard = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storyBoard = [UIStoryboard storyboardWithName:@"HomePage" bundle:nil];
    }) ;
    return storyBoard;
}
+(UIStoryboard *)MySelfStoryBoard{
    static UIStoryboard *storyBoard = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storyBoard = [UIStoryboard storyboardWithName:@"MySelf" bundle:nil];
    }) ;
    return storyBoard;
}
 static UIStoryboard *storyBoard = nil;
+(UIStoryboard *)OrderCenterStoryBoard{
   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storyBoard = [UIStoryboard storyboardWithName:@"MyOrder" bundle:nil];
    }) ;
    return storyBoard;
}


@end
