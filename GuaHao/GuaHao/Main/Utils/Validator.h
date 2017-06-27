#import <UIKit/UIKit.h>

@interface Validator : UIView

+ (BOOL)isValidPassword:(NSString *)password;
+ (BOOL)isValidMobile:(NSString *)mobile;
+ (BOOL)isValidSMSCode:(NSString *)code;
+ (BOOL)isValidEmail:(NSString *)email;
+ (NSString *)birthdayStrFromIdentityCard:(NSString *)numberStr;
+ (BOOL)isValidIdentityCard:(NSString *)ID;
+ (NSInteger)isValidIdentityCard:(NSString *)ID birthDate:(NSDate *)birthDate gender:(NSString *)gender;
+ (BOOL)isValidMedicareCard:(NSString *)medicare;
+ (BOOL)isValidDoctorCertificate:(NSString *)certificate;
+(BOOL)isValidCardNumber:(NSString *)identityCard;
+(BOOL)getSexWithIDCardNumber:(NSString *)cardNumber;
+ (BOOL)isValidName:(NSString *)name;
+ (BOOL)isValidSexWithCard:(NSString *)ID sex:(NSString*)sex;
+ (BOOL)isValidPassport:(NSString *)ID;
@end
