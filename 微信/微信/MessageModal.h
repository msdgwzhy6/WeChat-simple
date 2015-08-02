//
//  MessageModal.h
//  微信
//
//  Created by 弄潮者 on 15/7/15.
//  Copyright (c) 2015年 弄潮者. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModal : NSObject
{
    NSString *_icon;
    NSString *_content;
    NSString *_time;
//    BOOL *isSelf;
}
@property (nonatomic,strong) NSString *icon;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,assign) BOOL isSelf;
@end
