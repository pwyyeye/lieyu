//
//  MyUtil.h
//  gatako
//
//  Created by 光速达 on 15-2-3.
//  Copyright (c) 2015年 光速达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

typedef NS_ENUM(NSInteger, QiNiuUploadTpye)
{
    //以下是枚举成员
    QiNiuUploadTpyeDefault = 0,//默认图片
    QiNiuUploadTpyeMedia = 1,//媒体资源
    QiNiuUploadTpyeSmallMedia = 2,//小媒体资源
};
@interface MyUtil : NSObject

+(MyUtil *)shareUtil;

//判断字符串是否为空
+ (BOOL) isEmptyString:(NSString *)string;
//对象转换成utf8json
+ (NSString *) toJsonUTF8String:(id)obj;

//将图片压缩 保存至本地沙盒
+ (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName andCompressionQuality:(CGFloat) quality ;

//颜色值转化 ＃ffffff 转化成10进制
+(int)colorStringToInt:(NSString *)colorStrig colorNo:(int)colorNo;

//验证手机号码格式
+ (BOOL)isValidateTelephone:(NSString *)str;

//利用正则表达式验证邮箱
+(BOOL)isValidateEmail:(NSString *)email;

+(NSString *)getFormatDate:(NSDate *)date;

+(NSString *)getNumberFormatDate:(NSDate *)date;

+(NSDate *)getDateFromString:(NSString *)dateString;

+(NSDate *)getFullDateFromString:(NSString *)dateString;

+(NSString *)trim:(NSString *)string;

+ (NSString *)md5HexDigest:(NSString*)input;
//des加密
+ (NSString *) encryptUseDES:(NSString *)plainText;

//des解密
+ (NSString *) decryptUseDES:(NSString*)cipherText;

+ (BOOL) validateIdentityCard: (NSString *)identityCard;
//判断是否数字
+ (BOOL)isPureInt:(NSString*)string;
//弹出消息框来显示消息
+ (void)showMessage:(NSString* )message;
//显示不需要确认的提示消息
+(void)showCleanMessage:(NSString *)message;

//获取键值参数
+ (NSDictionary *) getKeyValue:(NSString *)string;
//获取月份中文
+ (NSString *) getMoonValue:(NSString *)string;
//获取纯色块图片
+(UIImage *)getImageFromColor:(UIColor *)color;
//获取随机数
+ (NSString *)randomStringWithLength:(int)len;
//获取7牛全链接
+ (NSString *)getQiniuUrl:(NSString *)key width:(NSInteger)width andHeight:(NSInteger)height;
//获取7牛全链接
+ (NSString *)getQiniuUrl:(NSString *)key mediaType:(QiNiuUploadTpye)qiNiuUploadTpye width:(NSInteger)width andHeight:(NSInteger)height;
+ (NSString*)deviceString;

//根据日期字符串 获取星座
+(NSString *)getAstroWithBirthday:(NSString *)dateString;

//根据生日获取年龄
+ (NSString*)getAgefromDate:(NSString *)birthday;

+ (void)showPlaceMessage:(NSString* )message;

//判断当前网络状况
+ (int)configureNetworkConnect;

//pragma mark - 时间转换为昨天，前天，今天等。。。。
+ (NSString *)calculateDateFromNowWith:(NSString *)dateString;

+ (void)showLikePlaceMessage:(NSString* )message;
//获取字符长度 中文＝2 英文＝1
+ (int)countTheStrLength:(NSString*)strtemp;
//根据日期获取星期
+ (NSString*)weekdayStringFromDate:(NSString *)dateString;
//剩余时间计算
+ (NSString *)residueTimeFromDate:(NSString *)dateString;
@end
