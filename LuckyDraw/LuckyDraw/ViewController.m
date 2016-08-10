//
//  ViewController.m
//  LuckyDraw
//
//  Created by yangqijia on 16/8/5.
//  Copyright © 2016年 yangqijia. All rights reserved.
//

#import "ViewController.h"
#import "LuckyDrawViewController.h"
#import "CustomHUD.h"

#define HEIGHT  [UIScreen mainScreen].bounds.size.height
#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define TEXT_STRING(string) [NSString stringWithFormat:@"%@",string]

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    //奖品列表
    UITableView     *_tableView;
    //全部奖品
    NSMutableArray  *_allPrizes;
    //我想要的奖品
    NSMutableArray  *_myPrize;
    //判断添加奖品类型
    NSInteger       _addInteger;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //初始化奖品数组
    _allPrizes = [[NSMutableArray alloc]init];
    
    [_allPrizes addObjectsFromArray:[NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E", nil]];
    
    //初始化我想要的奖品
    _myPrize = [[NSMutableArray alloc]init];
    
    [_myPrize addObjectsFromArray:[NSArray arrayWithObjects:@"D", nil]];
    
    //创建奖品列表
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, WIDTH, HEIGHT-61) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //创建button
    UIButton *goButton = [UIButton buttonWithType:UIButtonTypeCustom];
    goButton.frame = CGRectMake(0, _tableView.frame.size.height + _tableView.frame.origin.y + 1, WIDTH, 40);
    goButton.backgroundColor = [UIColor purpleColor];
    [goButton setTitle:@"前往抽奖" forState:UIControlStateNormal];
    [goButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [goButton addTarget:self action:@selector(goPrize:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goButton];
}

-(void)goPrize:(UIButton *)sender
{
    NSString *prize = nil;
    if (_myPrize.count > 0) {
        prize = [_myPrize objectAtIndex:0];
    }
    if (_allPrizes.count == 0) {
        [CustomHUD createShowContent:@"请添加奖品"];
        return;
    }
    LuckyDrawViewController *luckVC = [[LuckyDrawViewController alloc]initWithPrizes:_allPrizes myPrize:prize];
    UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:luckVC];
    [self presentViewController:naVC animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_allPrizes.count == 0) {
            return 1;
        }else{
            return _allPrizes.count;
        }
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellPrize";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (indexPath.section == 0) {
        if (_allPrizes.count > 0) {
            cell.textLabel.text = TEXT_STRING([_allPrizes objectAtIndex:indexPath.row]);
        }else{
            cell.textLabel.text = @"";
        }
    }else{
        if (_myPrize.count > 0) {
            cell.textLabel.text = TEXT_STRING([_myPrize objectAtIndex:indexPath.row]);
        }else{
            cell.textLabel.text = @"";
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 设置Header、Footer
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, WIDTH, 20)];
    label.backgroundColor = [UIColor whiteColor];
    if (section == 0) {
        label.text = @"全部奖品";
    }else{
        label.text = @"我想要的奖品";
    }
    return label;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, WIDTH, 30);
    if (section == 0) {
        [button setTitle:@"添加奖品" forState:UIControlStateNormal];
    }else{
        [button setTitle:@"添加我想要的奖品" forState:UIControlStateNormal];
    }
    button.tag = 1000 + section;
    button.backgroundColor = [UIColor purpleColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(addPrize:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

#pragma mark - 编辑删除cell（删除奖项）
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_allPrizes.count > 0) {
            return YES;
        }else{
            return NO;
        }
    }else{
        if (_myPrize.count > 0) {
            return YES;
        }else{
            return NO;
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [_allPrizes removeObjectAtIndex:indexPath.row];
    }else{
        [_myPrize removeAllObjects];
    }
    [_tableView reloadData];
}

/**
 *  添加奖品
 *
 *  @param sender
 */
-(void)addPrize:(UIButton *)sender
{
    _addInteger = sender.tag;
    [self createAlert];
}

/**
 *  创建添加奖品视图
 */
-(void)createAlert
{
    NSString *title = nil;
    NSString *message = nil;
    if (_addInteger == 1000) {
        title = @"添加奖品";
        message = @"所添加的奖品将会显示在列表中！";
    }else{
        title = @"添加我想要的奖品";
        message = @"想要的奖品只能添加一个，反复添加将会覆盖上次输入的奖品";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"添加", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }else{
        UITextField *textField = [alertView textFieldAtIndex:0];
        if (_addInteger == 1000) {
            [_allPrizes addObject:textField.text];
        }else{
            [_myPrize removeAllObjects];
            [_myPrize addObject:textField.text];
        }
        [_tableView reloadData];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
