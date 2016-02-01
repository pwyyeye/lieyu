//
//  f.m
//  gatako
//
//  Created by 光速达 on 15-2-3.
//  Copyright (c) 2015年 光速达. All rights reserved.
//

#import "MyUtil.h"
#import "sys/utsname.h"
#import <Reachability.h>
#import "GTM_Base64.h"
#import <CommonCrypto/CommonCryptor.h>

#define desKey @"lieyu"

@implementation MyUtil

+(MyUtil *)shareUtil{
    static dispatch_once_t onceToken;
    static MyUtil *singleton;
    dispatch_once(&onceToken, ^{
        singleton=[[MyUtil alloc] init];
    });
    NSLog(@"-------singletonAlipay---------%@",singleton);
    return singleton;
}
#pragma --mark 判断字符串是否为空
+ (BOOL) isEmptyString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
#pragma --mark  转化UTF8 的json
+ (NSString *) toJsonUTF8String:(id)obj{
    NSError *error=nil;
    NSData *data=[NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        NSLog(@"%@",error);
    }
    NSString *json=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return json;
}
#pragma --mark  保存图片到沙盒
+ (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName andCompressionQuality:(CGFloat) quality {
    NSData *imageDate=UIImageJPEGRepresentation(currentImage, quality);
    NSString *fullPath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]  stringByAppendingPathComponent:imageName];
    
    NSLog(@"%@",fullPath);
    [imageDate writeToFile:fullPath atomically:NO];
    
    

}


#pragma --mark  颜色值转化 ＃ffffff 转化成10进制
+(int)colorStringToInt:(NSString *)colorStrig colorNo:(int)colorNo
{
    const char *cstr;
    int iPosition = 0;
    int nColor = 0;
    cstr = [colorStrig UTF8String];
    
    //判断是否有#号
    if (cstr[0] == '#') iPosition = 1;//有#号，则从第1位开始是颜色值，否则认为第一位就是颜色值
    else iPosition = 0;
    
    //第1位颜色值
    iPosition = iPosition + colorNo*2;
    if (cstr[iPosition] >= '0' && cstr[iPosition] < '9') nColor = (cstr[iPosition] - '0') * 16;
    else  nColor = (cstr[iPosition] - 'A' + 10) * 16;
    
    //第2位颜色值
    iPosition++;
    if (cstr[iPosition] >= '0' && cstr[iPosition] < '9') nColor = nColor + (cstr[iPosition] - '0');
    else nColor = nColor + (cstr[iPosition] - 'A' + 10);
    
    return nColor;
}

#pragma --mark  验证手机号码格式
+ (BOOL)isValidateTelephone:(NSString *)str

{
    
    if ([str length] == 0) {
        
        return NO;
        
    }
    
    NSString *regex = @"^((17[0-9])|(13[0-9])|(147)|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        
        return NO;
        
    }
    
    return YES;
    
}

#pragma --mark  利用正则表达式验证邮箱
+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma --mark 获取格式化日期字符串 yyyy-MM-dd HH:mm:ss
+(NSString *)getFormatDate:(NSDate *)date
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    
    return currentDateStr;
    
}
#pragma --mark 获取格式化日期字符串 yyyyMMddHHmmss
+(NSString *)getNumberFormatDate:(NSDate *)date
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    
    return currentDateStr;
    
}

#pragma --mark 字符串转日期 yyyy－MM－dd
+(NSDate *)getDateFromString:(NSString *)dateString
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    return date;
    
}
#pragma --mark 字符串转日期 yyyyMMddHHmmss
+(NSDate *)getFullDateFromString:(NSString *)dateString
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    return date;
    
}

#pragma --mark 字符串去除空串
+(NSString *)trim:(NSString *)string{
    NSString *result = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return result;

}

#pragma --mark md5 加密
+ (NSString *)md5HexDigest:(NSString*)input
{
    const char *cStr = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

/*字符串加密
 *参数
 *plainText : 加密明文
 *key        : 密钥 64位
 */
#pragma --mark des 加密
+ (NSString *) encryptUseDES:(NSString *)plainText
{
    NSString *ciphertext = nil;
    const char *textBytes = [plainText UTF8String];
    NSUInteger dataLength = [plainText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    Byte iv[] = {1,2,3,4,5,6,7,8};
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [desKey UTF8String], kCCKeySizeDES,
                                          iv,
                                          textBytes, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        
        ciphertext = [[NSString alloc] initWithData:[GTM_Base64 encodeData:data] encoding:NSUTF8StringEncoding];
    }
    return ciphertext;
}

#pragma --mark des 解密
+ (NSString *) decryptUseDES:(NSString*)cipherText
{
    NSData* cipherData = [GTM_Base64 decodeString:cipherText];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    Byte iv[] = {1,2,3,4,5,6,7,8};
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [desKey UTF8String],
                                          kCCKeySizeDES,
                                          iv,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          1024,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return plainText;
}

#pragma --mark 验证身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

#pragma --mark 弹出消息框来显示消息
+ (void)showMessage:(NSString* )message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}

+ (void)showPlaceMessage:(NSString* )message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
    [alertView show];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1 *NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
            [alertView dismissWithClickedButtonIndex:0 animated:NO];
    });
}

+ (void)showLikePlaceMessage:(NSString* )message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
    [alertView show];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.5 *NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [alertView dismissWithClickedButtonIndex:0 animated:NO];
    });
}

#pragma --mark 判断是否数字
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
+ (NSDictionary *) getKeyValue:(NSString *)string{
//    name=ligang&phone=13888888888
    NSMutableDictionary *dic=[NSMutableDictionary new];
    if(string){
        NSArray *arr=[string componentsSeparatedByString:@"&"];
        for (NSString *str in arr) {
            NSArray *arr1=[str componentsSeparatedByString:@"="];
            if(arr1.count>=2){
                [dic setObject:arr1[1] forKey:arr1[0]];
            }
        }
    }
    
    
    return dic;
}
+ (NSString *) getMoonValue:(NSString *)string{
    NSDictionary *dic=@{@"1":@"一月",@"2":@"二月",@"3":@"三月",@"4":@"四月",@"5":@"五月",@"6":@"六月",@"7":@"七月",@"8":@"八月",@"9":@"九月",@"10":@"十月",@"11":@"十一月",@"12":@"十二月"};
    return [dic objectForKey:string];
}
#pragma --mark 通过颜色生产纯色图片
+(UIImage *)getImageFromColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, 10, 10);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return img;
}

#pragma --mark 生产指定长度随机串
+ (NSString *)randomStringWithLength:(int)len
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    
    return randomString;
}

#pragma --mark 获取7牛访问链接

+ (NSString *)getQiniuUrl:(NSString *)key width:(NSInteger)width andHeight:(NSInteger)height{
    NSString *encodeKey=[key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if(width>0&&height>0){
        return [NSString stringWithFormat:@"http://source.lie98.com/%@?imageView2/0/w/%d/h/%d",encodeKey,width,height];
    }else{
        return [NSString stringWithFormat:@"http://source.lie98.com/%@",encodeKey];

    }
}

#pragma --mark 获取7牛media访问链接

+ (NSString *)getQiniuUrl:(NSString *)key mediaType:(QiNiuUploadTpye)qiNiuUploadTpye width:(NSInteger)width andHeight:(NSInteger)height{
    NSString *encodeKey=[key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    switch (qiNiuUploadTpye) {
        case QiNiuUploadTpyeDefault:
            if(width>0&&height>0){
                return [NSString stringWithFormat:@"http://media.lie98.com/%@.jpg?imageView2/0/w/%ld/h/%ld",encodeKey,width,height];
            }else{
                return [NSString stringWithFormat:@"http://media.lie98.com/%@.jpg",encodeKey];
                
            }
            break;
        case QiNiuUploadTpyeMedia:
            return [NSString stringWithFormat:@"http://media.lie98.com/%@.mp4",encodeKey];
            break;
        case QiNiuUploadTpyeSmallMedia:
            return [NSString stringWithFormat:@"http://media.lie98.com/%@_s.mp4",encodeKey];
            break;
        default:
            return @"";
            break;
    }
    
}

#pragma --mark 获取设备型号
+ (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"]||[deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString hasPrefix:@"iPhone6"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}


/**
 *  根据生日计算星座
 *
 *  @param month 月份
 *  @param day   日期
 *
 *  @return 星座名称
 */
#pragma --mark 根据生日计算星座
+(NSString *)getAstroWithBirthday:(NSString *)dateString
{
    if ([MyUtil isEmptyString:dateString]) {
        return @"";
    }
    if ([dateString isEqualToString:@"1990-04-15"]||[dateString isEqualToString:@"1990-04-15"]) {
        return @"白羊座";
    }
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd"];
    NSString *myDayString = [NSString stringWithFormat:@"%@",
                   [df stringFromDate:date]];
    [df setDateFormat:@"MM"];
    NSString *myMonthString = [NSString stringWithFormat:@"%@",
                     [df stringFromDate:date]];
    
    NSInteger month=myMonthString.integerValue;
    NSInteger day=myDayString.integerValue;
    
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    
    if (month<1 || month>12 || day<1 || day>31){
        return @"";
    }
    
    if(month==2 && day>29)
    {
        return @"";
    }else if(month==4 || month==6 || month==9 || month==11) {
        if (day>30) {
            return @"";
        }
    }
    
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(month*2-(day < [[astroFormat substringWithRange:NSMakeRange((month-1), 1)] intValue] - (-19))*2,2)]];
    
    return [NSString stringWithFormat:@"%@座",result];
}


#pragma --mark 根据日期来计算年龄
+ (NSString*)getAgefromDate:(NSString *)birthday{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSDate *date;
    if ([birthday isEqualToString:@"1990-04-15"] || [birthday isEqualToString:@"1990-4-15"]) {
        birthday=@"1990-04-15 1:00:00";
        date=[MyUtil getFullDateFromString:birthday];
    }else{
         date= [dateFormatter dateFromString:birthday];
    }

    
    NSDate *myDate = date;
    
    
    NSDate *nowDate = [NSDate date];
    
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    
    unsigned int unitFlags = NSYearCalendarUnit;
    
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:myDate toDate:nowDate options:0];
    
    
    int year = (int)[comps year];
    
    
    return [NSString stringWithFormat:@"%d",year];
    
    
}

#pragma --mark 弹出提示框 不需要确认 
+(void)showCleanMessage:(NSString *)message
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = RGBA(114, 5, 147, 0.8);
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 0.8f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.numberOfLines=0;
    [showview addSubview:label];
    showview.frame = CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds) - LabelSize.width - 20)/2, CGRectGetWidth([UIScreen mainScreen].bounds) - 100, LabelSize.width+20, LabelSize.height+10);
    [UIView animateWithDuration:2 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

+ (int)configureNetworkConnect{
    NetworkStatus netStatus = [[Reachability reachabilityWithHostName:@"www.lie98.com"] currentReachabilityStatus];
    switch (netStatus){
        case NotReachable:
            return 0;//没有网络连接
            break;
        case ReachableViaWWAN:
            return 1;//数据流量
            break;
        case ReachableViaWiFi:
            return 2;//Wi-Fi连接
            break;
        default:
            break;
    }
}

#pragma mark - 时间转换为昨天，前天，今天等。。。。
+ (NSString *)calculateDateFromNowWith:(NSString *)dateString{
    NSDateFormatter *dateFmter = [[NSDateFormatter alloc]init];
    [dateFmter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFmter dateFromString:dateString];
    //
    [dateFmter setDateFormat:@"HH:mm:ss"];
    //    NSLog(@"-------->%@",[dateFmter stringFromDate:date]);
    //    NSString *str = [dateFmter stringFromDate:date];
    //    NSLog(@"------>%@",str);
    NSString *dateStringPart = [dateFmter stringFromDate:date];
    
    NSInteger preTime = [date timeIntervalSince1970];
    NSDate* dat = [NSDate date];
    NSTimeInterval now= [dat timeIntervalSince1970]*1;
    NSInteger today = now / (24*3600);
    NSInteger yestoday = preTime / (24*3600);
    NSInteger iDiff = today - yestoday;
    NSString *strDiff = nil;
    
    if(iDiff == 0) {
        strDiff= [NSString stringWithFormat:@"今天"];
    }else if (iDiff == 1) {
        strDiff = [NSString stringWithFormat:@"昨天"];
    }else if (iDiff == 2) {
        strDiff = [NSString stringWithFormat:@"前天"];
    }else if (iDiff >= 3 ) {
        [dateFmter setDateFormat:@"yy-MM-dd"];
        strDiff = [dateFmter stringFromDate:date];
    }
    return [NSString stringWithFormat:@"%@ %@",strDiff,dateStringPart];
}


#pragma --mark  获取字符长度 中文＝2 英文＝1
+ (int)countTheStrLength:(NSString*)strtemp {
    
    int strlength = 0;
    
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        
        if (*p) {
            
            p++;
            
            strlength++;
            
        }
        
        else {
            
            p++;
            
        }
        
    }
    
    return (strlength+1)/2;
    
}

#pragma mark - 根据日期获取星期
+ (NSString*)weekdayStringFromDate:(NSString *)dateString{
    NSDateFormatter *dateFmter = [[NSDateFormatter alloc]init];
    [dateFmter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFmter dateFromString:dateString];
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"Sunday", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

#pragma mark -剩余时间计算
+ (NSString *)residueTimeFromDate:(NSString *)dateString{
    NSDateFormatter *dateFmter = [[NSDateFormatter alloc]init];
    [dateFmter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFmter dateFromString:dateString];
    NSTimeInterval orderTime = [date timeIntervalSinceNow];
//    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
//    NSTimeInterval differentTime = orderTime - nowTime;
    if (orderTime >= 60 * 60) {
        return [NSString stringWithFormat:@"%.0fhour",orderTime/60/60];
    }else if(orderTime >= 0 && orderTime <= 60 * 60){
        return [NSString stringWithFormat:@"%.0fmin",orderTime/60];
    }else{
        return @"已过期";
    }
}

@end
