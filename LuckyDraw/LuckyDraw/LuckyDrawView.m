//
//  LuckyDrawView.m
//  LuckyDraw
//
//  Created by yangqijia on 16/8/5.
//  Copyright © 2016年 yangqijia. All rights reserved.
//

#import "LuckyDrawView.h"

#define kDegreesToRadians(degrees)  ((M_PI * degrees)/ 180)
#define AKAngle(radian) (radian / M_PI * 180.f)
#define AKCos(a) cos(a / 180.f * M_PI)
#define AKSin(a) sin(a / 180.f * M_PI)

static NSString *string = @"0";

@interface PrizePlateView : UIView

@property(nonatomic ,assign)float   degrees;

@end

@implementation PrizePlateView

//自定初始化奖盘
-(id)initWithFrame:(CGRect)frame degrees:(float)degrees
{
    self = [super initWithFrame:frame];
    if (self) {
        _degrees = degrees;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//绘制选择扇形
-(void)drawRect:(CGRect)rect
{
    float width = rect.size.width;
    float height = rect.size.height;
    float moveAngle =  self.degrees  + 270 > 360 ? self.degrees  - 90 : self.degrees  + 270 ;
    CGContextRef cont = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(cont, [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3].CGColor);
    CGContextSetLineWidth(cont, width / 3.f);
    CGContextAddArc(cont, width / 2.f, height / 2.f, width / 3.f, kDegreesToRadians(270), kDegreesToRadians(moveAngle), 0);
    CGContextDrawPath(cont, kCGPathStroke);
    
    CGContextRef cont1 = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(cont1, [UIColor redColor].CGColor);
    CGContextSetLineWidth(cont1, width / 20.f);
    CGContextAddArc(cont1, width / 2.f, height / 2.f, 11 * width / 40.f, kDegreesToRadians(270), kDegreesToRadians(moveAngle), 0);
    CGContextDrawPath(cont, kCGPathStroke);
}

@end

@interface LuckyDrawView()

@property (nonatomic, strong) NSArray *prizeArray;
@property (nonatomic, strong) PrizePlateView *prizeView;
@property (nonatomic, assign) NSInteger prizeIndex;
@property (nonatomic, assign) NSInteger rotatCount;
@property (nonatomic, assign) NSInteger progressCount;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *timerTwo;
@property (nonatomic, copy)   Completion competion;
@property (nonatomic, assign) BOOL canBegin;
@property (nonatomic, assign) BOOL first;
@property (nonatomic, strong) NSString *selectPrize;
@property (nonatomic, assign) int number;
@property (nonatomic, assign) float time;



@end

@implementation LuckyDrawView

-(id)initWithFrame:(CGRect)frame prizeArray:(NSArray<NSString *> *)prizeArray completion:(Completion)completion selectPrize:(NSString *)selectPrize first:(BOOL)first
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置转动圈数的初始值
        self.number = 0;
        //设置转一圈的时间
        self.time = 0.4;
        //奖品数组
        self.prizeArray = prizeArray;
        //block设置
        self.competion = completion;
        //设置加速加速圈数
        self.progressCount = self.prizeArray.count * 2;
        //是否在抽奖
        self.canBegin = YES;
        //转动总圈数
        self.rotatCount = prizeArray.count * 10;
        //设置默认奖品
        self.selectPrize = selectPrize;
        //设置背景色
        self.backgroundColor = [UIColor clearColor];
        //设置首次
        self.first = first;
    }
    return self;
}


//绘制转盘
-(void)drawRect:(CGRect)rect
{
    float width = rect.size.width;
    float height = rect.size.height;
    float degrees = (1 / (float)self.prizeArray.count) * 360.f;
    float statAngle = kDegreesToRadians(270.f);
    self.prizeView = [[PrizePlateView alloc] initWithFrame:rect degrees:degrees];
    [self addSubview:self.prizeView];
    
    float radius = 2 * width / 5.f + width / 10.f;
    float radius1 = width / 5.f;
    for (int i = 0; i < self.prizeArray.count; i++) {
        //计算弧度
        float moveAngle =  degrees * (i + 1) + 270 > 360 ? degrees * (i + 1) - 90 : degrees * (i + 1) + 270 ;
        //绘制弧度
        CGContextRef cont = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(cont, [UIColor colorWithRed:255 / 255.f green:166 / 255.f blue:49 / 255.f alpha:1].CGColor);
        CGContextSetLineWidth(cont, width / 5.f);
        CGContextAddArc(cont, width / 2.f, height / 2.f, 2 * width / 5.f, statAngle, kDegreesToRadians(moveAngle), 0);
        CGContextDrawPath(cont, kCGPathStroke);
        statAngle = kDegreesToRadians(moveAngle);
        //绘制分割线
        CGContextRef cont1 = UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(cont1, radius + AKSin(i * degrees) * radius, radius - AKCos(i * degrees) * radius);
        CGContextAddLineToPoint(cont1, (radius + AKSin(i * degrees) * radius) - AKSin(i * degrees) * radius1, (radius - AKCos(i * degrees) * radius) + AKCos(i * degrees) * radius1);
        CGContextSetStrokeColorWithColor(cont1, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(cont1, 1);
        CGContextDrawPath(cont1, kCGPathStroke);
        //添加奖品名称
        UILabel *label = [[UILabel alloc] init];
        label.text = [self.prizeArray objectAtIndex:i];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        CGSize size = [label sizeThatFits:CGSizeMake(100, 99999)];
        label.frame = CGRectMake(0, 0, size.width, size.height);
        float labelDegees = i * degrees + degrees / 2.f;
        float centerX = AKSin(labelDegees) * 2 * width / 5.f + radius;
        float centerY = radius - AKCos(labelDegees) * 2 * width / 5.f;
        label.textAlignment = NSTextAlignmentCenter;
        label.center = CGPointMake(centerX, centerY);
        [self addSubview:label];
        label.transform = CGAffineTransformRotate(label.transform, kDegreesToRadians(labelDegees));
    }
    
    //中间按钮部分
    CGContextRef cont2 = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(cont2, [UIColor colorWithRed:255 / 255.f green:70 / 255.f blue:31 / 255.f alpha:1].CGColor);
    CGContextAddArc(cont2, width / 2.f, height / 2.f, 3 * width / 10.f, 0, 2 * M_PI, 0);
    CGContextDrawPath(cont2, kCGPathFill);

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 3 * width / 10.f, 3 * width / 10.f);
    button.center = CGPointMake(width / 2.f, height / 2.f);
    [self addSubview:button];
    [button setTitle:@"启动" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(beginPrize) forControlEvents:UIControlEventTouchUpInside];
}

//点击开始抽奖
- (void)beginPrize
{
    if (self.canBegin) {
        if (self.selectPrize) {
            for (int j = 0; j < self.prizeArray.count; j++) {
                NSString *prize = [self.prizeArray objectAtIndex:j];
                if ([prize isEqualToString:self.selectPrize]) {
                    self.prizeIndex = j;
                }
            }
            string = @"1";
        }else{
            string = @"0";
            self.prizeIndex = arc4random() % (self.prizeArray.count -1);
        }
        [self rollingPrize];
    }
}

//抽奖动画
- (void)rollingPrize
{
    self.canBegin = NO;
    self.prizeView.transform = CGAffineTransformRotate(self.prizeView.transform, kDegreesToRadians(self.prizeView.degrees));
    self.number++;
    if (self.number == self.prizeArray.count*2) {
        self.time = 0.08;
    }else if (self.number < self.prizeArray.count*2){
        self.time = self.time - (0.3/self.progressCount);
    }else if (self.number > self.prizeArray.count * 8){
        self.time = self.time + (0.3/self.progressCount);
    }    
    NSInteger allNumber = 0;
    if ([string isEqualToString:@"1"]) {
        if (self.first) {
            allNumber = self.rotatCount + self.prizeIndex;
        }else{
            allNumber = self.rotatCount + self.prizeIndex + (self.prizeArray.count - self.prizeIndex);
        }
    }else{
        allNumber = self.rotatCount + self.prizeIndex;
    }
    
    if (self.number == allNumber) {
        [self.timer invalidate];
        self.timer = nil;
        self.competion(((self.rotatCount + self.prizeIndex) % self.prizeArray.count));
        self.canBegin = YES;
        self.first = NO;
        self.number = 0;
        self.time = 0.4;
    }else{
        [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(rollingPrize) userInfo:nil repeats:NO];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
