//
//  ViewController.h
//  微信
//
//  Created by 弄潮者 on 15/7/15.
//  Copyright (c) 2015年 弄潮者. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    UIView *_bottomView;
    NSMutableArray *_messageArray;
}
@end
