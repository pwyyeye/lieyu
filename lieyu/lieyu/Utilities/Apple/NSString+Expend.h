//
//  NSString+Expend.h
//  expend
//
//  Created by ZAK on 14-3-26.
//  Copyright (c) 2014年 JKZL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface NSString (Expend)

/**
 *  获取版本号
 */
+(NSString *)getAppVersion;

/**
 *  获取IP地址
 *
 *  @return
 */
+(NSString *)getLocalIPAddress;

/**
 *  获取文本的高度
 *
 *  @param fontSize 多大字体
 *  @param str 内容
 *  @param range  在多大的范围内
 *
 *  @return
 */
-(CGSize)autoResize:(float)fontSize withSize:(CGSize)range;

/**
 *  获取到文本的宽度
 *
 *  @param text
 *  @param font
 *  @param height
 *
 *  @return
 */
-(float)getTextWidthfont:(UIFont *)font labelHeight:(float)height;
/**
 *  获取文本的高度
 *
 *  @param text
 *  @param font
 *  @param width
 *
 *  @return 
 */
-(float)getTextHeightfont:(UIFont *)font labelWidth:(float)width;
/**
 *  去掉HTML标签
 *
 *  @param html 字符串
 *
 *  @return 返回字符串
 */
-(NSString *)flattenHTML;
/**
 *  去掉内容前面的空格和回车 或者去掉空格
 *
 *  @param str
 *
 *  @return
 */
-(NSString *)removeWhitespaceAndNewlinewithboolNewLine:(BOOL)isSure;

/**
 *  md5加密
 *
 *  @param str 密码串
 *
 *  @return NSString
 */
-(NSString *)md5Hash;
-(NSData *)sha1Hash;
-(NSData *)sha256;

/**
 *  判断是否是电话号码
 *
 *  @param mobile 字符串
 *
 *  @return Bool
 */
-(BOOL)validateMobile;
/**
 *  判断是否是数字
 *
 *  @param num 数字
 *
 *  @return bool
 */
- (BOOL)validateNum;

/**
 *  判断是否是数字密码
 *
 *  @param pwd
 *  @param min 个数范围
 *  @param max
 *
 *  @return 
 */

-(BOOL)validatePwdRangeMin:(int)min rangeMax:(int)max;

/**
 *  判断是否是邮箱
 *
 *  @param email
 *
 *  @return
 */
- (NSNumber *)getNumber;
- (BOOL) validateEmail;
-(BOOL)validateTime;

/**
 *  判断身份证
 *
 *  @param identityCard
 *
 *  @return 
 */
- (BOOL)validateIdentityCard;
- (BOOL)validatePlateNumber; //验证车牌
- (BOOL)validatePassword;
- (BOOL)vaildateNumber;
- (NSString *)toSHA256String;
-(NSMutableString *)reverseString;
-(BOOL)isEmpty;
-(NSString *)getTimeHm;
-(NSString *)removeAllBlankAndReturnCharacter;
-(NSString *)GetDatezH;

//<---json
-(NSArray *)toJsonArray;
-(NSDictionary *)toDictionary;

-(NSData *)hexToByteToNSData;

@end





