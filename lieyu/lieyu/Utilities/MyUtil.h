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

+(NSString *)trim:(NSString *)string;

+ (NSString *)md5HexDigest:(NSString*)input;

+ (BOOL) validateIdentityCard: (NSString *)identityCard;

//弹出消息框来显示消息
+ (void)showMessage:(NSString* )message;
@end
