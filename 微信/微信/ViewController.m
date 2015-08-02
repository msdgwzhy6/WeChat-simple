//
//  ViewController.m
//  微信
//
//  Created by 弄潮者 on 15/7/15.
//  Copyright (c) 2015年 弄潮者. All rights reserved.
//

#import "ViewController.h"
#import "MessageModal.h"
#import "MessageTableViewCell.h"
#import <Foundation/Foundation.h>
#import "ViewControllerFriendsList.h"

#define kwidth [UIScreen mainScreen].bounds.size.width
#define kheight [UIScreen mainScreen].bounds.size.height
#define kbottom 49
#define knavgationbar 44

@interface ViewController ()
{
    CGFloat *yuanlaiweizhi;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _loadData];
    [self _setNavigation];
    [self _createTableView];
    [self _createBottomView];
    
    //监听键盘事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideKeyboard:) name:UIKeyboardDidHideNotification object:nil];
    
    //监听状态栏的改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(statusBarChange:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];

    
    // Do any additional setup after loading the view.
}

#pragma mark - 键盘和call-in状态栏的监听
- (void)hideKeyboard:(NSNotification *)notification {
    NSLog(@"keyboard消失");
    NSValue *rectValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [rectValue CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:keyboardRect fromView:[[UIApplication sharedApplication] keyWindow]];
    CGFloat keyboardHeight = keyboardFrame.size.height;

    CGRect lastBound = _bottomView.frame;
    CGFloat lasty = lastBound.origin.y;
//    NSLog(@"%f",lasty);
//    NSLog(@"%f",keyboardHeight);
    
    NSString *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    double doubleDuration = [duration doubleValue];
    [UIView animateWithDuration:doubleDuration animations:^{
        _bottomView.frame = CGRectMake(0, lasty+keyboardHeight, kwidth, kbottom);
        _tableView.frame = CGRectMake(0, 0, kwidth, kheight-kbottom);
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messageArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
    
}

- (void)showKeyboard:(NSNotification *)notification {
    NSLog(@"keyboard响应");
    NSLog(@"%@",notification.userInfo);

    NSValue *rectValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [rectValue CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:keyboardRect fromView:[[UIApplication sharedApplication] keyWindow]];
    CGFloat keyboardHeight = keyboardFrame.size.height;

    CGRect lastBound = _bottomView.frame;
    CGFloat lasty = lastBound.origin.y;
    
    _bottomView.frame = CGRectMake(0, lasty-keyboardHeight, kwidth, kbottom);
    _tableView.frame = CGRectMake(0, 0, kwidth, kheight-keyboardHeight-kbottom);
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messageArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];

//    NSLog(@"%f",keyboardHeight);
//    NSLog(@"%@",rectValue);
}


- (void)statusBarChange:(NSNotification *)notification {
//    NSLog(@"statusBar响应");
//    NSLog(@"%@",notification.userInfo);
    
    NSValue *rectValue = [notification.userInfo objectForKey:UIApplicationStatusBarFrameUserInfoKey];
    CGRect statusRect = [rectValue CGRectValue];
    
    CGRect statusFrame = [self.view convertRect:statusRect fromView:[[UIApplication sharedApplication]keyWindow]];
    CGFloat statusHeight = statusFrame.size.height-20;

    CGRect lastbound = _bottomView.frame;
    CGFloat lasty = lastbound.origin.y;
    
    CGRect lastTableBound = _tableView.frame;
    CGFloat lastTabley = lastTableBound.origin.y;
//    NSLog(@"%f",lasty);
//    NSLog(@"%f",statusHeight);
    
    if (statusHeight == 0) {
        _bottomView.frame = CGRectMake(0, lasty+20, kwidth, kbottom);
        _tableView.frame = CGRectMake(0, lastTabley+20, kwidth, kheight-kbottom);

    }else {
        _bottomView.frame = CGRectMake(0, lasty-statusHeight, kwidth, kbottom);
        _tableView.frame = CGRectMake(0, lastTabley-statusHeight, kwidth, kheight-kbottom);

    }
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messageArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    NSLog(@"%f",_bottomView.frame.origin.y);
    
}

- (void)viewWillAppear:(BOOL)animated {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_messageArray.count-1 inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    NSLog(@"解除通知");
}

#pragma mark - 加载数据
- (void)_loadData {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"messages" ofType:@"plist"];
//    NSLog(@"path = %@",path);
    
    _messageArray = [NSMutableArray array];
    NSArray *countArray = [NSArray arrayWithContentsOfFile:path];
    for (int i = 0; i < countArray.count; i++ ) {
        NSDictionary *dic = countArray[i];
        MessageModal *messageModal = [[MessageModal alloc] init];
        messageModal.icon = dic[@"icon"];
        messageModal.content = dic[@"content"];
        messageModal.time = dic[@"time"];
        //！！！！bool不是OC类型，而字典存储的是id类型，所以要转换
        messageModal.isSelf = [dic[@"self"] boolValue];
        [_messageArray addObject:messageModal];

//        NSLog(@"%@,%@,%@,%@",messageModal.icon,messageModal.content,messageModal.time,messageModal.isSelf?@"YES":@"NO");
    }
//    NSLog(@"dic = %@",_messageArray);

}

#pragma mark - nav的设置
- (void)_setNavigation {
    self.title = @"WeChat";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"好友列表" style:UIBarButtonItemStylePlain target:self action:@selector(returnFriendsListAction:)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)returnFriendsListAction:(UIBarButtonItem *)btn {
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"返回");
}

#pragma mark - bottom view的设置
- (void)_createBottomView {
    //自定制
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kheight-kbottom, kwidth, kbottom)];
    
    //背景图片
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kwidth, kbottom)];
    background.image = [UIImage imageNamed:@"toolbar_bottom_bar"];
    [_bottomView addSubview:background];
    
    //按钮
    //语音按钮
    UIButton *voiceButton = [[UIButton alloc] initWithFrame:CGRectMake(7, 7, 35, 35)];
    [voiceButton setImage:[UIImage imageNamed:@"chat_bottom_voice_press"] forState:UIControlStateNormal];
    [_bottomView addSubview:voiceButton];
    
    //加号按钮
    UIButton *upButton = [[UIButton alloc] initWithFrame:CGRectMake(kwidth-45, 5, 40, 40)];
    [upButton setImage:[UIImage imageNamed:@"chat_bottom_up_nor"] forState:UIControlStateNormal];
    [_bottomView addSubview:upButton];
    
    //表情按钮
    UIButton *smileButton = [[UIButton alloc] initWithFrame:CGRectMake(kwidth-45-40, 5, 40, 40)];
    [smileButton setImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:UIControlStateNormal];
    [_bottomView addSubview:smileButton];
    
    //输入
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(45, 5, kwidth-45-45-40, 40)];
    textField.background = [UIImage imageNamed:@"chat_bottom_textfield"];
    textField.returnKeyType = UIReturnKeySend;
    textField.delegate = self;
    [_bottomView addSubview:textField];
    
    [self.view addSubview:_bottomView];
    
}

#pragma mark - tableview
- (void)_createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kwidth, kheight-kbottom)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (cell == nil) {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    }
    cell.message = _messageArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageModal *messageModal = _messageArray[indexPath.row];
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:18]};
    
    CGSize size = [messageModal.content boundingRectWithSize:CGSizeMake(kwidth-140, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return size.height+40;
    
}

#pragma mark - keyboard设置
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    static BOOL isSelf = YES;
    if (textField.text.length != 0) {
        MessageModal *modal = [[MessageModal alloc] init];
        modal.content = textField.text;
        modal.isSelf = YES;
//        modal.isSelf = isSelf;
//        isSelf = !isSelf;
        modal.icon = @"icon01.jpg";
        
        [_messageArray addObject:modal];
   
        
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"messages" ofType:@"plist"];
        NSMutableArray *plist = [[NSMutableArray arrayWithContentsOfFile:path]mutableCopy];
        
        NSDictionary *dic = @{@"content" : modal.content,
                              @"icon" : @"icon.jpg",
                              @"time" : @"昨天",
                              @"self" : @"YES"
                              };
        [plist addObject:dic];
        [plist writeToFile:path atomically:YES];
        [_tableView reloadData];
        NSLog(@"$$$$$$");
    }
    NSLog(@"xxxx");
    [textField resignFirstResponder];
    textField.text = nil;
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messageArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    NSLog(@"xxxxxxxxxx");
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
