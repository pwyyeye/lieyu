//
//  GiftContent.m
//  lieyu
//
//  Created by 狼族 on 16/9/1.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "GiftContent.h"

@implementation GiftContent


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.giftId forKey:@"giftId"];
    [aCoder encodeObject:self.giftUrl forKey:@"giftUrl"];
    [aCoder encodeObject:self.giftLocalUrl forKey:@"giftLocalUrl"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.giftId = [aDecoder decodeObjectForKey:@"giftId"];
        self.giftUrl = [aDecoder decodeObjectForKey:@"giftUrl"];
        self.giftLocalUrl = [aDecoder decodeObjectForKey:@"giftLocalUrl"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    GiftContent *item = [[[self class] allocWithZone:zone] init];
    item.giftId   = [self.giftId copyWithZone:zone];
    item.giftUrl= [self.giftUrl copyWithZone:zone] ;
    item.giftLocalUrl    = [self.giftLocalUrl copyWithZone:zone] ;
//    item.strPrice   = [[self.strPrice copyWithZone:zone] autorelease];
    return item;
}

@end
