//
//  ZKDataProcess.h
//  
//
//  Created by apple on 15/3/18.
//
//

#import <Foundation/Foundation.h>

@class LYErrorMessage;

@interface HttpResponseParse : NSObject

+(void)praseData:(NSDictionary *)json erMsg:(LYErrorMessage **)erMsg data:(NSDictionary **)data;

@end
