//
//  ViewControllerFriendsList.m
//  微信
//
//  Created by 弄潮者 on 15/7/16.
//  Copyright (c) 2015年 弄潮者. All rights reserved.
//

#import "ViewControllerFriendsList.h"
#import "ViewController.h"

#define kwidth [UIScreen mainScreen].bounds.size.width
#define kheight [UIScreen mainScreen].bounds.size.height

@interface ViewControllerFriendsList ()
{
    UITableView *_tableViewFriends;
    NSMutableArray *_dataArray;
    BOOL flag[100];         //默认为NO
}
@end

@implementation ViewControllerFriendsList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"好友列表";
    
    _tableViewFriends = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kwidth, kheight) style:UITableViewStylePlain];
    _tableViewFriends.dataSource = self;
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"friends" ofType:@"plist"];
    
    _dataArray = [NSMutableArray arrayWithContentsOfFile:path];
    
    [self.view addSubview:_tableViewFriends];
    
    _tableViewFriends.delegate = self;
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *dic = _dataArray[section];
    NSString *groupName = dic[@"group"];
    UIButton *button = [[UIButton alloc] init]; //不用指定frame,因为滑动时frame一直在变
    [button setBackgroundImage:[UIImage imageNamed:@"tableCell_common"] forState:UIControlStateNormal];
//    [button setBackgroundColor:[UIColor blackColor]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:groupName forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(buttonAction:)
     forControlEvents:UIControlEventTouchUpInside];
    button.tag = section;
    
    return button;
}

- (void)buttonAction:(UIButton *)btn {
    NSInteger index = btn.tag;
    flag[index] = !flag[index];
    
    //指定刷新某一组，效率高
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
    [_tableViewFriends reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    
}

//选中的设置
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    //取得选中的cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    //设置cell的辅助视图
    cell.accessoryType = UITableViewCellAccessoryNone;
    if ([cell.textLabel.text isEqualToString:@"Friend0"]) {
        ViewController *vc = [[ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dic = _dataArray[section];
    NSArray *friends = dic[@"friends"];
    if (flag[section] == NO) {
        return 0;
    }
    return friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = _dataArray[indexPath.section];
    NSArray *friends = dic[@"friends"];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = friends[indexPath.row];
    cell.textLabel.numberOfLines = 0;   //多行显示，行数设为0
    return cell;
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
