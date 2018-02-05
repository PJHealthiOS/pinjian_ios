//
//  ServerManger.h
//  GuaHao
//
//  Created by qiye on 16/1/21.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define PUBLISH_SERVER 1
#if PUBLISH_SERVER
#define HOST "https://www.pjhealth.com.cn/"//生产环境
#else
#define HOST "https://139.196.14.136:6080/"      //测试环境
#endif
@interface ServerManger : NSObject
+(ServerManger *) getInstance;
@property(strong,nonatomic) NSString* serverURL;
@property(strong,nonatomic) NSString* appDownloadURL;
@property(strong,nonatomic) NSString* regTime;
@property(strong,nonatomic) NSString* acceptTime;
@property(strong,nonatomic) NSString* descTime;
@property(strong,nonatomic) NSString* payTime;
@property(strong,nonatomic) NSNumber* isExpert;

-(void) getSMSCode:(NSString *) phone andCallback: (void (^)(id data))callback;

-(void) userRegister:(NSDictionary *) dic andCallback: (void (^)(id  data))callback;

-(void) fixedPhoneNumber:(NSDictionary *) dic andCallback: (void (^)(id  data))callback;

-(void) bindWX:(NSDictionary *) dic andCallback: (void (^)(id  data))callback;

-(void) getPwd:(NSDictionary *) dic andCallback: (void (^)(id  data))callback;

-(void) userLogin:(NSString *) name password:(NSString*)pwd andCallback: (void (^)(id  data))callback;

-(void) getPersonalCenterInfo: (void (^)(id  data))callback;

-(void) createOrder:(NSDictionary *) dic andCallback: (void (^)(id  data))callback;

-(void) createExpertOrder:(NSDictionary *) dic andCallback: (void (^)(id  data))callback;

-(void) createExpertNewOrder:(NSDictionary *) dic imgs:(NSMutableArray*) imgs andCallback: (void (^)(id  data))callback;

// 取消订单----------------------------
-(void) cancelOrder:(NSNumber*) orderID andNormalType:(BOOL)orderType andCallback: (void (^)(id  data))callback;

-(void) cancelExpertOrder:(NSNumber*) orderID andCallback: (void (^)(id  data))callback;

-(void) feedback:(int) type msg:(NSString*) msg andCallback: (void (^)(id  data))callback;

// 删除订单-----------------------------
-(void) deleteOrder:(NSNumber*) orderID andNormalType:(BOOL)orderType andCallback: (void (^)(id  data))callback;

-(void) deleteExpertOrder:(NSNumber*) orderID andCallback: (void (^)(id  data))callback;

-(void) getOrders:(int) type size:(int) size page:(int) page longitude:(NSString*)longitude latitude:(NSString*)latitude andCallback: (void (^)(id  data))callback;

-(void) getExpertOrders:(int) size page:(int) page longitude:(NSString*)longitude latitude:(NSString*)latitude andCallback: (void (^)(id  data))callback;

// 我的优惠券1.2.0
-(void) getCouponslistPageNo:(int)pageNo  andCallback: (void (^)(id  data))callback;

-(void) cancelRealnameAuth:(NSNumber*) patientID andCallback: (void (^)(id  data))callback;

-(void) getPatients:(int) size page:(int) page andCallback: (void (^)(id  data))callback;

-(void) createPatient:(NSDictionary *) dic andCallback: (void (^)(id  data))callback;

-(void) getHospitals:(NSString*) msg isAccompany:(NSString *)serviceType size:(int) size page:(int) page longitude:(NSString*) longitude latitude:(NSString*) latitude andCallback: (void (^)(id  data))callback;

-(void) getNearByHospitals:(int) size page:(int) page longitude:(NSString*) longitude latitude:(NSString*) latitude andCallback: (void (^)(id  data))callback;

-(void) getFirstDepartment:(NSNumber*) hosID oppointment:(int)oppointment  isChildEmergency:(BOOL)isChildEmergency andCallback:(void (^)(id  data))callback;

-(void) getSecondDepartment:(NSNumber*) hosId oppointment:(int)oppointment departmentId:(NSNumber*) depId isChildEmergency:(BOOL)isChildEmergency andCallback:(void (^)(id  data))callback;

-(void) verification:(NSDictionary *) dic me:(UIImage*) me front:(UIImage*) image opposite:(UIImage*) oppImage andCallback: (void (^)(id  data))callback;

-(void) verificationPatient:(NSNumber*) _id  front:(UIImage*) image opposite:(UIImage*) oppImage andCallback: (void (^)(id  data))callback;

-(void) passportPatient:(NSNumber*) _id  front:(UIImage*) image  andCallback: (void (^)(id  data))callback;

//编辑就诊人   参数见： 就诊人模块
-(void) editPatient:(NSNumber*) _id patient:(NSDictionary*) dic andCallback:(void (^)(id  data))callback;

-(void) editUserView:(NSDictionary*) dic  andCallback:(void (^)(id  data))callback;

-(void) editUser:(NSDictionary*) dic front:(UIImage*) image andCallback:(void (^)(id  data))callback;

-(void) editUserr:(NSDictionary*) dic  andCallback:(void (^)(id  data))callback;

-(void) realNameUser:(NSDictionary*) dic andCallback:(void (^)(id  data))callback;

-(void) waitingList:(int) size page:(int) page andCallback: (void (^)(id  data))callback;

-(void) acceptOrder:(NSNumber*) orderID andCallback: (void (^)(id  data))callback;
///接单专家号
-(void) acceptExpertOrder:(NSNumber*) orderID andCallback: (void (^)(id  data))callback;

-(void) myAcceptedOrders:(int) size page:(int) page type:(NSInteger) type longitude:(NSString*)longitude latitude:(NSString*)latitude hospitalId:(NSString*)hospitalId andCallback: (void (^)(id  data))callback;

-(void) bindHospital:(NSNumber*) hosID andCallback: (void (^)(id  data))callback;

-(void) getUpMoneyList:(void (^)(id  data))callback;

-(void) topdUpMoney:(float) money channel:(NSString*) channel andCallback: (void (^)(id  data))callback;

-(void) notifyAccount:(NSString*) chargeid andCallback:(void (^)(id  data))callback;

-(void) payOrder:(NSNumber*) orderID channel:(NSString*) channel isExpert:(BOOL)isExpert andCallback: (void (^)(id  data))callback;

-(void) getOrderStatus:(NSString*) serialNo longitude:(NSString*) longitude latitude:(NSString*) latitude andCallback:(void (^)(id  data))callback;

-(void) getExpertOrderStatus:(NSString*) serialNo longitude:(NSString*) longitude latitude:(NSString*) latitude andCallback:(void (^)(id  data))callback;

-(void) notifyOrder:(NSString*) chargeid isExpert:(BOOL)isExpert andCallback:(void (^)(id  data))callback;

-(void) getAccount:(int) size page:(int) page andCallback: (void (^)(id  data))callback;

-(void) withdrawCrash:(NSNumber*) bankID amount:(float) amo andCallback:(void (^)(id  data))callback;


-(void) withAddBankCard:(NSDictionary*) dic andCallback:(void (^)(id  data))callback;

-(void) getBankList: (void (^)(id  data))callback;

-(void) getBankListName:(void (^)(id  data))callback;

// 校正登录密码
-(void) vallidLoginPassword:(NSString*) passwordr andCallback:(void (^)(id  data))callback;

-(void) vallidPayPassword:(NSString*) passwordr andCallback:(void (^)(id  data))callback;

-(void) getNotices:(NSNumber*) userId size:(int) size page:(int) page andCallback: (void (^)(id  data))callback;

-(void) getOrderBid:(NSString*) serialNo andCallback:(void (^)(id  data))callback;

-(void) putOrderPrice:(NSNumber*) orderID price:(NSString*) value andCallback:(void (^)(id  data))callback;

-(void) getSysParameter:(void (^)(id  data))callback;

-(void) getAppVersion:(void (^)(id  data))callback;

-(void) editPush:(NSString*) isPush andCallback:(void (^)(id  data))callback;

-(void) clearMessage:(void (^)(id  data))callback;

-(void) getOrderDesc:(NSNumber*) ids andCallback:(void (^)(id  data))callback;

-(void) getHistoryOrder:(NSNumber*) orderID andCallback: (void (^)(id  data))callback;

-(void) getDoctorList:(NSNumber*) departmentID size:(int) size page:(int) page andCallback:(void (^)(id  data))callback;

-(void) getFirstExpDepartment:(NSNumber*) hosID andCallback:(void (^)(id  data))callback;

-(void) getSecondExpDepartment:(NSNumber*) hosId departmentId:(NSNumber*) depId andCallback:(void (^)(id  data))callback;

-(void) getExpDoctorList:(NSNumber*) departmentID content:(NSString*) content size:(int) size page:(int) page andCallback:(void (^)(id  data))callback;

-(void) getExpDoctor:(NSNumber*) expID andCallback:(void (^)(id  data))callback;

-(void) getExpInfo:(void (^)(id  data))callback;

-(void) getExpNewInfo:(NSNumber *)doctorId scheduleId:(NSNumber *)scheduleId andCallback:(void (^)(id  data))callback;
-(void) getOrderTags:(NSNumber*) depID andCallback:(void (^)(id  data))callback;

-(void) getExpOrderTags:(NSNumber*) depID andCallback:(void (^)(id  data))callback;

-(void) getPayOrderPageData:(NSNumber*) orderID isExpert:(BOOL)isExpert andCallback:(void (^)(id  data))callback;

-(void) fillInvitationCode:(NSString*) ids andCallback:(void (^)(id  data))callback;

-(void) getSysParameterListByGroup:(NSString*) content andCallback:(void (^)(id  data))callback;

-(void) setCancelReason:(NSNumber*) ids reason:(NSString*) reason andCallback:(void (^)(id  data))callback;

-(void) getBannerList:(void (^)(id  data))callback;

-(void) getOrderInfo:(NSString*) longitude latitude:(NSString*) latitude isChildEmergency:(BOOL)isChildEmergency andCallback:(void (^)(id  data))callback;

-(void) getExpertDoctorList:(NSNumber*) hospitalID departmentID:(NSNumber*) departmentID filterDate:(NSString*) date apm:(NSNumber*)apm type:(NSNumber*)type keywords:(NSString*) keywords size:(int) size page:(int) page andCallback:(void (^)(id  data))callback;

-(void) getListFilterDates:(NSNumber*) hospitalID departmentID:(NSNumber*) departmentID andCallback:(void (^)(id  data))callback;

-(void) getExpSearchInHomage:(NSString*) content size:(int) size page:(int) page andCallback:(void (^)(id  data))callback;

-(void) getExpSearch:(NSString*) content size:(int) size page:(int) page andCallback:(void (^)(id  data))callback;

-(void) getExpSMSCode:(NSString *) phone andCallback: (void (^)(id  data))callback;

-(void) estimateExpSms:(NSString*) ids mobile:(NSString*) mobile smsCode:(NSString*) smsCode andCallback:(void (^)(id  data))callback;

-(void) getPointInfo: (void (^)(id  data))callback;

-(void) setSignWarn:(NSString*) isOpen andCallback:(void (^)(id  data))callback;

-(void) signBean:(void (^)(id  data))callback;

-(void) getExchangeDetails:(int) size page:(int) page andCallback: (void (^)(id  data))callback;

-(void) getMyExchangeCoupons:(int) size page:(int) page andCallback: (void (^)(id  data))callback;

-(void) exchangeCoupons:(NSNumber*) couponsId andCallback:(void (^)(id  data))callback;

-(void) getLoveOrderInfo:(NSString*) longitude latitude:(NSString*) latitude andCallback:(void (^)(id  data))callback;

-(void) createLoveOrder:(NSDictionary *) dic andCallback: (void (^)(id  data))callback;

-(void) getLoveOrderStatus:(NSString*) serialNo longitude:(NSString*) longitude latitude:(NSString*) latitude andCallback:(void (^)(id  data))callback;

-(void) getExpHospitals:(NSString*) msg size:(int) size page:(int) page longitude:(NSString*) longitude latitude:(NSString*) latitude andCallback: (void (^)(id  data))callback;

-(void) checkMedicalCardIsMatchHospital:(NSNumber*) patientId hospitalID:(NSNumber*) hospitalId andCallback: (void (^)(id  data))callback;

-(void) share:(int) size page:(int) page andCallback: (void (^)(id  data))callback;

-(void) shareLogs:(int) size page:(int) page andCallback: (void (^)(id  data))callback;

-(void) shareRanks:(int) size page:(int) page andCallback: (void (^)(id  data))callback;

-(void) bankList: (void (^)(id  data))callback;

-(void) withDrawal:(NSDictionary *) dic andCallback: (void (^)(id  data))callback;

-(void) cardLogList: (void (^)(id  data))callback;

-(void) completeTicket:(NSNumber *) _id andCallback: (void (^)(id  data))callback;

-(void) getPatient:(NSNumber*) patientID andCallback: (void (^)(id  data))callback;

////专家号结单详情页
-(void) getOrderDetailStatus:(NSString*) serialNo andNormalType:(BOOL)orderType longitude:(NSString*) longitude latitude:(NSString*) latitude andCallback:(void (^)(id  data))callback;
/////普通号接单详情页
-(void) getNormalOrderDetail:(NSString*) serialNo longitude:(NSString*) longitude latitude:(NSString*) latitude andCallback:(void (^)(id  data))callback;
-(void) getBankInfo:(NSNumber*) bankID andCallback: (void (^)(id  data))callback;

-(void) codeLogin:(NSString *) name code:(NSString *)pwd andCallback: (void (^)(id  data))callback;
///专家号详情
-(void) getOrderExpertStatus:(NSString*) serialNo longitude:(NSString*) longitude latitude:(NSString*) latitude andCallback:(void (^)(id  data))callback;
//改变订单用户是否同意
-(void) acceptChangeNormalOrder:(NSNumber*) orderID accept:(NSString *) accept andCallback: (void (^)(id  data))callback;
//改变订单专家用户是否同意
-(void) acceptChangeExpertOrder:(NSNumber*) orderID accept:(NSString *) accept andCallback: (void (^)(id  data))callback;
///普通接单人转号操作
-(void) launchChangeNormalOrder:(NSNumber*) orderID operation:(NSNumber*) operation  andCallback: (void (^)(id  data))callback;
///专家接单人转号操作
-(void) launchChangeExpertOrder:(NSNumber*) orderID operation:(NSNumber*) operation andCallback: (void (^)(id  data))callback;

-(void) wxLogin:(NSString *)code andCallback: (void (^)(id  data))callback;

-(void) waiterOrders:(NSString*) msg size:(int) size page:(int) page andCallback: (void (^)(id  data))callback;

-(void) getScaninfo:(NSString*) serialNo longitude:(NSString*) longitude latitude:(NSString*) latitude andCallback:(void (^)(id  data))callback;

-(void) completeGetTicket:(NSNumber *) _id andCallback: (void (^)(id  data))callback;

-(void) getPaySuccessPageData:(NSNumber*) orderID isExpert:(BOOL)isExpert andCallback:(void (^)(id  data))callback;

-(void) getMSGNewOrder:(NSNumber*) ids andCallback:(void (^)(id  data))callback;
////设置支付密码
-(void) setPayPassWord:(NSDictionary *) dic andCallback: (void (^)(id  data))callback;

-(void) getCity:(void (^)(id  data))callback;

-(void) bindCity:(NSNumber *) _id andCallback: (void (^)(id  data))callback;
//获取新闻详情
-(void) getArticle:(NSNumber*) articleID size:(int) size page:(int) page andCallback:(void (^)(id  data))callback;

//获取消息分类
-(void) getGroupMsg:(void (^)(id  data))callback;
//系统消息列表
-(void) getTypeNotices:(NSNumber*) groupId size:(int) size page:(int) page andCallback: (void (^)(id  data))callbac;

///陪诊页数据
-(void)getAccompanyVCDataCallback: (void (^)(id  data))callback;
///陪诊介绍页数据
-(void)getAccompanyFlowVCData:(int)type andCallback: (void (^)(id  data))callback;
///创建陪诊订单
-(void)createAccompanyOrder:(NSDictionary *) dic andCallback: (void (^)(id  data))callback;
//AccompanyOrderViewController 数据请求
-(void)getAccompanyOrderVCData:(int)type andCallback: (void (^)(id  data))callback;
///支付界面数据
-(void) getAccompanyPayOrderPageData:(NSNumber*) orderID  andCallback:(void (^)(id  data))callback;
///陪诊支付
-(void) payAccompanyOrder:(NSNumber*) orderID channel:(NSString*) channel  andCallback: (void (^)(id  data))callback;
///陪诊支付回调
-(void) notifyAccompanyOrder:(NSString*) chargeid andCallback:(void (^)(id  data))callback;
///健康评测
-(void) gethealthTestPageDataSize:(int) size page:(int) page andCallback: (void (^)(id  data))callback;

//新闻首页
-(void) getHomeArticle:(int) size page:(int) page andCallback: (void (^)(id  data))callback;

-(void) getHomeList:(NSNumber*) categoryId size:(int) size page:(int) page andCallback: (void (^)(id  data))callback;

//获取评论列表
-(void) getCommendList:(NSNumber*) articleId size:(int) size page:(int) page andCallback: (void (^)(id  data))callback;

//点赞评论
-(void) praiseComment:(NSNumber*) _id andCallback: (void (^)(id  data))callback;

//点赞文章
-(void) praiseArticle:(NSNumber*) _id andCallback: (void (^)(id  data))callback;

//评论文章
-(void) commentArticle:(NSMutableDictionary*) dic ariticleID:(NSNumber*) _id andCallback: (void (^)(id  data))callback;

//关注
-(void) follow:(NSNumber*) _id andCallback: (void (^)(id  data))callback;

//取消关注
-(void) unfollow:(NSNumber*) _id andCallback: (void (^)(id  data))callback;
///陪诊列表
-(void) getAccompanyListOrderSize:(int) size page:(int) page longitude:(NSString*)longitude latitude:(NSString*)latitude andCallback: (void (^)(id  data))callback;
//关注列表
-(void) followList:(int) size page:(int) page andCallback: (void (^)(id  data))callback;
//陪诊挂号详情
-(void) getAccDetailOrderStatus:(NSString*) serialNo longitude:(NSString*) longitude latitude:(NSString*) latitude andCallback:(void (^)(id  data))callback;
// 取消陪诊订单
-(void) cancelAccompanyOrder:(NSNumber*) orderID andCallback: (void (^)(id  data))callback;
///陪诊余额支付成功页
-(void) getAccompanyPaySuccessPageData:(NSNumber*) orderID andCallback:(void (^)(id  data))callback;
///支付界面数据
-(void)getVisitTypePageDataCallback:(void (^)(id  data))callback;

//特色科室
-(void)specialDepListDataCallback: (void (^)(id  data))callback;
//特色科室科室详情
-(void) specialDepInfo:(NSNumber*) _id andCallback: (void (^)(id  data))callback;
///特色科室医生筛选
-(void) specialDepDoctorSelect:(NSString *)kewWord size:(int)size page:(int)page _id:(NSNumber*) _id parameter:(NSMutableDictionary *)parameter andCallback:(void (^)(id  data))callback;
///修改个人信息
-(void) fixPersonInfoWithID:(NSNumber*) patientID parameter:(NSMutableDictionary *)parameter andCallback: (void (^)(id  data))callback;
///获得支付二维码信息
-(void)getQRPayInfoWithID:(NSNumber*) patientID isNormal:(BOOL)isNormal channel:(NSString *)channel andCallback: (void (^)(id  data))callback;
///轮询支付结果
-(void) getNormalOrderPayStatus:(NSNumber*) _id isNormal:(BOOL)isNormal andCallback: (void (^)(id  data))callback;
///重疾所有套餐/critical/illness/packageList
-(void) getPackageDataCallback: (void (^)(id  data))callback;
///重疾所有人/critical/illness/getCreatePageData
-(void) getPackagePersonListCallback: (void (^)(id  data))callback;
///提交重疾(new)订单/critical/illness
-(void) createSeriousOrder:(NSDictionary *) dic imgs:(NSMutableArray*) imgs andCallback: (void (^)(id  data))callback;
///重疾列表/critical/illness/criticalIllnessOrderList
-(void) getSeriousListOrderSize:(int) size page:(int) page longitude:(NSString*)longitude latitude:(NSString*)latitude andCallback: (void (^)(id  data))callback;
///重疾订单详情/critical/illness/{serialNo}
-(void) getSeriosOrderDetail:(NSString*) serialNo andCallback:(void (^)(id  data))callback;
/// 取消重疾订单----------/critical/illness/{id}/cancel
-(void) cancelSeriousOrder:(NSNumber*) orderID andCallback: (void (^)(id  data))callback;
///创建取药或报告订单
-(void)createMedicineOrReportOrder:(NSDictionary *) dic imgs:(NSMutableArray*) imgs andCallback: (void (^)(id  data))callback;
///创建评价
-(void)createEvaluate:(NSDictionary *) dic orderID:(NSNumber*) orderID  andCallback: (void (^)(id  data))callback;
///评价页详情/order/{id}/showEvaluation
-(void)getEvaluate:(NSDictionary *) dic orderID:(NSNumber*) orderID  andCallback: (void (^)(id  data))callback;
///获得城市区县
-(void) getContyInfoWithCityCode:(NSString *)cityCode andCallback: (void (^)(id  data))callback;
///搜索医院
-(void) getHospitals:(NSString*) msg serviceType:(NSString *)serviceType oppointment:(int)oppointment size:(int) size page:(int) page longitude:(NSString*) longitude latitude:(NSString*) latitude orderBy:(NSInteger)orderBy cityId:(NSString *)cityId andCallback: (void (^)(id  data))callback;
/////万家接单详情页
-(void) getWJOrderDetail:(NSString*) orderID  andCallback:(void (^)(id  data))callback;
///万家订单专员操作/api/pjOrder/{order_id}/operation
-(void)wjOrderOperation:(NSNumber*) orderID operationID:(NSNumber*) operationID  andCallback: (void (^)(id  data))callback;
///健康管理创建订单页/health/order/getCreatePageData 1 基础健康管理套餐 2 定制化增值服务
-(void) getHealthOrderPageData:(NSString *)serviceType  Callback: (void (^)(id  data))callback;
///创建取健康管理订单 /health/order
-(void)createHealthManagerOrder:(NSDictionary *) dic andCallback: (void (^)(id  data))callback;
///健康管理列表/health/order/list
-(void) getHealthListOrderSize:(int) size page:(int) page serviceType:(int)type andCallback: (void (^)(id  data))callback;
////健康预约详情health/order/{id}
-(void) getHealthOrderDetialOrderID:(NSNumber*)orderID andCallback:(void (^)(id  data))callback;
///1.普通用户主动发起 2.普通接单员主动发起 在线排队查询的推送订单-----------------------------
-(void) inquireCurrentProgress:(NSNumber*) orderID fromType:(int)orderType andCallback: (void (^)(id  data))callback;
-(void) expertInquireCurrentProgress:(NSNumber*) orderID fromType:(int)orderType andCallback: (void (^)(id  data))callback;
///专家接单人转号操作 /pjOrder/doPrivilege/{orderId}
-(void) openOnlineServiceAction:(NSNumber*) orderID  andCallback: (void (^)(id  data))callback;
///普通号上传凭证
-(void)normalOrderUploadTicket:(NSNumber *) _id visitSeq:(NSString *)visitSeq currentVisitSeq:(NSString *)currentVisitSeq currentVisitTime:(NSString *)currentVisitTime front:(UIImage*) image isNormalOrder:(BOOL)isNormal andCallback: (void (^)(id  data))callback;
///专家号上传凭证
-(void)ExpertUploadTicket:(NSNumber *) _id visitSeq:(NSString *)visitSeq front:(UIImage*) image andCallback: (void (^)(id  data))callback;
///专家号陪诊结束
-(void) expertOrderAccompanyFinish:(NSNumber*) orderID andCallback: (void (^)(id  data))callback;
///会员中心接口
-(void) getMemberCenterInfo: (void (^)(id  data))callback;
///专家号支付
-(void) payOrder:(NSNumber*) orderID channel:(NSString*) channel couponID:(NSString *)couponID useBalance:(BOOL)useBalance andCallback: (void (^)(id  data))callback;
///特需号优惠券
-(void) getSpecialCouponslistPageNo:(int)pageNo orderID:(NSString *)orderID andCallback: (void (^)(id  data))callback;
///企业订单专员操作/acceptedOrder/{order_id}/operation
-(void)companyOrderOperation:(NSNumber*) orderID operationID:(NSNumber*) operationID  andCallback: (void (^)(id  data))callback;
/////企业接单详情页/2b/pjorder/acceptedOrder/{order_id}
-(void) getCompanyOrderDetail:(NSString*) orderID  andCallback:(void (^)(id  data))callback;
////普通号新版本支付
-(void) getPayNormalOrderPageData:(NSNumber*) orderID andCallback:(void (^)(id  data))callback;
////专家号新版本支付
-(void) getPayExpertOrderPageData:(NSNumber*) orderID andCallback:(void (^)(id  data))callback;
///新普通号号支付
-(void) payNormalOrder:(NSNumber*) orderID channel:(NSString*) channel couponID:(NSString *)couponID useBalance:(BOOL)useBalance andCallback: (void (^)(id  data))callback;
///普通号优惠券
-(void) getNormalCouponslistPageNo:(int)pageNo  andCallback: (void (^)(id  data))callback;

///普通号挂号单号满
-(void) normalOrderFullAction:(NSNumber*) orderID andCallback: (void (^)(id  data))callback;
///普通号预约完成预约
-(void) normalOrderCompleteRegAction:(NSNumber*) orderID dateStr:(NSString *)dateStr andCallback: (void (^)(id  data))callback;
///普通号操作
-(void) normalOrderOperationAction:(NSNumber*)orderID Operation:(NSString *)operation andCallback: (void (^)(id  data))callback;
///充值支付结果
-(void) getAccountRechargePayStatus:(NSString*) orderID  andCallback: (void (^)(id  data))callback;
////普通号支付结果查询
-(void) getNormalOrderPayStatus:(NSString*) orderID  andCallback: (void (^)(id  data))callback;
////专家特需号支付结果查询/pjOrder/pay/query
-(void) getSpecialOrderPayStatus:(NSString*) orderID  andCallback: (void (^)(id  data))callback;
////陪诊号支付结果查询/pjOrder/pay/query
-(void) getAccompanyOrderPayStatus:(NSString*) orderID  andCallback: (void (^)(id  data))callback;






@end
