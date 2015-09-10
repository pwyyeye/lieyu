//
//  NSString+Expend.m
//  expend
//
//  Created by ZAK on 14-3-26.
//  Copyright (c) 2014年 JKZL. All rights reserved.
//

#import "NSString+Expend.h"
#import <CommonCrypto/CommonDigest.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
@implementation NSString (Expend)

+(NSString *)getAppVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
}

//获取本地ip
+(NSString *)getLocalIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while (temp_addr != NULL)
        {
            if( temp_addr->ifa_addr->sa_family == AF_INET)
            {
                //[[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]
                if (strcmp(temp_addr->ifa_name, "en0")==0)
                {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    break;
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    
    return address;
}

-(CGSize)autoResize:(float)fontSize withSize:(CGSize)range
{
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rc = [self boundingRectWithSize:range options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    return rc.size;
}

-(float)getTextWidthfont:(UIFont *)font labelHeight:(float)height
{
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rc = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:options attributes:@{NSFontAttributeName:font} context:nil];
    return rc.size.width;
}

-(float)getTextHeightfont:(UIFont *)font labelWidth:(float)width
{
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rc = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:options attributes:@{NSFontAttributeName:font} context:nil];
    return rc.size.height;
}

- (NSString *)md5Hash
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
- (NSData *)sha1Hash
{
	//NSData *dataFromString = [self dataUsingEncoding:NSUTF8StringEncoding];
	const char *cStr = [self UTF8String];
    unsigned char hashed[CC_SHA1_DIGEST_LENGTH];
	
    if ( CC_SHA1(cStr, (CC_LONG)strlen(cStr), hashed) )
	{
        __autoreleasing NSData *data = [[NSData alloc] initWithBytes:hashed
                                                              length:CC_SHA1_DIGEST_LENGTH];
        return data;
        
    } else {
		
        return nil;
    }
}
-(NSData *)sha256
{
    const char *cStr = [self UTF8String];
    unsigned char hashed[CC_SHA256_DIGEST_LENGTH];
	
    if ( CC_SHA256(cStr, (CC_LONG)strlen(cStr), hashed) )
	{
        __autoreleasing NSData *data = [[NSData alloc] initWithBytes:hashed
                                                              length:CC_SHA256_DIGEST_LENGTH];
        return data;
        
    } else {
		
        return nil;
    }
}
- (NSString *)flattenHTML
{
    NSString *mySelf = self;
    mySelf = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:self];
    while ([theScanner isAtEnd] == NO)
    {
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        mySelf = [mySelf stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    return mySelf;
    
}
-(NSString *)removeWhitespaceAndNewlinewithboolNewLine:(BOOL)isSure
{
    if (isSure) {
        return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }else
    {
        return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
}


-(BOOL)validateNum
{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(\\d)$"] evaluateWithObject:self];
}


- (BOOL)validateMobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSRange range = [self rangeOfString:@"-"];
    NSString *mySelf = self;
    if (range.location != NSNotFound)
    {
        mySelf = [self stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    NSString *phoneRegex = @"(^((13[0-9])|(14[^7,\\D])|(17[^0,\\D])||(15[0-9])|(18[0-9]))\\d{8}$)";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

-(BOOL)validatePwdRangeMin:(int)min rangeMax:(int)max
{
    NSString *pwdRegex = [NSString stringWithFormat:@"(^[0-9]{%d,%d}$)",min,max] ;
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pwdRegex];
    
    return [pwdTest evaluateWithObject:self];
}



-(BOOL)validateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

-(BOOL)validateIdentityCard
{
    BOOL flag;
    if (self.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:self];
}
- (BOOL)validatePlateNumber //验证车牌
{
    BOOL ret = NO;
    if (self == nil || [self isEqualToString:@""]) {
        return NO;
    }
    NSString *regex2 = @"^[\u4e00-\u9fa5]{1}[A-Z0-9]{6}$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    NSLog(@"carTest is %@",identityCardPredicate);

    ret = [identityCardPredicate evaluateWithObject:self];
    return ret;
}
- (BOOL)validatePassword
{
    BOOL ret = NO;
    if(self == nil || [self isEqualToString:@""])
    {
        return ret;
    }
    NSString *regex2 = @"^[a-zA-Z0-9_]+$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    ret = [identityCardPredicate evaluateWithObject:self];
    return ret;
}
-(NSString *)toSHA256String
{
    const char *str = [self UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG) strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for ( int i=0; i<CC_SHA256_DIGEST_LENGTH; i++ )
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    
	return ret;
}
-(NSMutableString *)reverseString
{
    NSMutableString *reversedString = [NSMutableString string];
    NSInteger charIndex = [self length];
    while (charIndex > 0)
    {
        charIndex--;
        NSRange subStrRange = NSMakeRange(charIndex, 1);
        [reversedString appendString:[self substringWithRange:subStrRange]];
    }
    return reversedString;
}
- (NSNumber *)getNumber
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    NSInteger number = 0;
    [scanner scanInteger:&number];
    return [NSNumber numberWithInteger:number];
}
-(BOOL)validateTime
{
    BOOL res = NO;
    NSString *regx = @"^(([0-1]\\d)|(2[0-4])):[0-5]\\d$";
    NSPredicate *timeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regx];
    res = [timeTest evaluateWithObject:self];
    return res;
}
-(BOOL)isEmpty
{
    NSString *mySelf = self;
    mySelf = [self removeWhitespaceAndNewlinewithboolNewLine:NO];
    if (self == nil || self.length == 0) {
        return YES;
    }
    return NO;
}
-(NSString *)getTimeHm
{
    NSString *time = [self removeWhitespaceAndNewlinewithboolNewLine:NO];
    NSRange index = [self rangeOfString:@" " options:NSBackwardsSearch];
    if (index.location == NSNotFound ) {
        return @"";
    }
    time = [time substringFromIndex:index.location+1];
    index = [time rangeOfString:@":" options:NSBackwardsSearch];
    if (index.location == NSNotFound) {
        return @"";
    }
    time = [time substringToIndex:index.location];
    return time;
}
- (BOOL)vaildateNumber
{
    NSString *numRegex = @"^[0-9]*$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numRegex];
    return [numberTest evaluateWithObject:self];
}

-(NSString *)removeAllBlankAndReturnCharacter
{
    NSString *mySelf = self;
    mySelf = [self stringByReplacingOccurrencesOfString: @"\r" withString:@""];
    mySelf = [self stringByReplacingOccurrencesOfString: @"\n" withString:@""];
    mySelf = [self stringByReplacingOccurrencesOfString: @" " withString:@""];
    return mySelf;
};
-(NSString *)GetDatezH
{
    NSString *str ;
    NSRange index = [self rangeOfString:@" " options:NSBackwardsSearch];
    str = [self substringToIndex:index.location];
    NSArray *ary = [str componentsSeparatedByString:@"-"];
    NSArray *desAry = @[@"年",@"月",@"日"];
    str = @"";
    for (int i = 0;i <ary.count; i++)
    {
        str = [str stringByAppendingString:ary[i]];
        str = [str stringByAppendingString:desAry[i]];
    }
    return str;
}

-(NSArray *)toJsonArray
{
    NSError *er = nil;
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *ary = [NSJSONSerialization JSONObjectWithData:data
                                                   options:NSJSONReadingMutableContainers
                                                     error:&er];
    if (er != nil)
    {
        ary = nil;
    }
    return ary;
}

-(NSDictionary *)toDictionary
{
    NSError *error = nil;
    NSDictionary *JSON =
    [NSJSONSerialization JSONObjectWithData: [self dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: &error];
    return error == nil?JSON:nil;
}

-(NSData *)hexToByteToNSData
{
    int j=0;
    int len = (int)[self length];

    Byte bytes[len/2];
    for(int i=0;i<len;i++)
    {
        int int_ch;  ///两位16进制数转化后的10进制数
        unichar hex_char1 = [self characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        unichar hex_char2 = [self characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    //    for (int i = 0; i<str.length/2; i++) {
    //        NSLog(@"%d",bytes[i]);
    //    }
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:len/2 ];
    return newData;
}


@end






