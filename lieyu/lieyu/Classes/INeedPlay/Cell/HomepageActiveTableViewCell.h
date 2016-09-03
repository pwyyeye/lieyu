//
//  HomepageActiveTableViewCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/8/30.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendedTopic.h"

@interface HomepageActiveTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *topicName;
@property (weak, nonatomic) IBOutlet UIImageView *topicImage;

@property (nonatomic, strong) RecommendedTopic *topicModel;

@end
