//
//  LuckyDrawView.h
//  LuckyDraw
//
//  Created by yangqijia on 16/8/5.
//  Copyright © 2016年 yangqijia. All rights reserved.
//

#import <UIKit/UIKit.h>

//抽奖结果（奖品下标）
typedef void(^Completion)(NSInteger index);

@interface LuckyDrawView : UIView

/**
 *  自定义初始化方法
 *
 *  @param frame       frame坐标
 *  @param prizeArr    奖品数组
 *  @param completion  抽奖结果奖品
 *  @param selectPrize 设置抽选固定奖品
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame prizeArray:(NSArray<NSString *> *)prizeArray completion:(Completion)completion selectPrize:(NSString *)selectPrize first:(BOOL)first;

@end
