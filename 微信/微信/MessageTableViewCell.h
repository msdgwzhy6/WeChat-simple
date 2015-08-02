//
//  MessageTableViewCell.h
//  微信
//
//  Created by 弄潮者 on 15/7/15.
//  Copyright (c) 2015年 弄潮者. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModal.h"

@interface MessageTableViewCell : UITableViewCell
{
    UIImageView *_iconImageView;
    UIImageView *_backGroundImageView;
    UILabel *_label;
    MessageModal *_message;
}
@property (nonatomic,strong) MessageModal *message;
@end
