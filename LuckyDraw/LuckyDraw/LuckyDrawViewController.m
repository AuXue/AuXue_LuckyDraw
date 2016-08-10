//
//  LuckyDrawViewController.m
//  LuckyDraw
//
//  Created by yangqijia on 16/8/5.
//  Copyright © 2016年 yangqijia. All rights reserved.
//

#import "LuckyDrawViewController.h"
#import "LuckyDrawView.h"

#define HEIGHT  [UIScreen mainScreen].bounds.size.height
#define WIDTH  [UIScreen mainScreen].bounds.size.width

@interface LuckyDrawViewController ()
{
    NSArray  *_prizes;
    NSString *_name;
}

@end

@implementation LuckyDrawViewController

-(id)initWithPrizes:(NSArray *)prizes myPrize:(NSString *)name
{
    self = [super init];
    if (self) {
        _prizes = prizes;
        _name = name;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //创建关闭按钮
    self.navigationItem.leftBarButtonItem = [self createCloseButton];
    self.view.backgroundColor = [UIColor whiteColor];
    //__weak __typeof(self)weakSelf = self;
    //初始化大转盘
    LuckyDrawView *luckView = [[LuckyDrawView alloc]initWithFrame:CGRectMake(10, 70, WIDTH - 20, WIDTH - 20) prizeArray:_prizes completion:^(NSInteger index) {
        NSLog(@"我想要的奖品：%@",[_prizes objectAtIndex:index]);
    } selectPrize:_name first:YES];
    [self.view addSubview:luckView];
}

-(UIBarButtonItem *)createCloseButton
{
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0, 0, 60, 30);
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [closeBtn addTarget:self action:@selector(closeVC) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:closeBtn];
}


-(void)closeVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
