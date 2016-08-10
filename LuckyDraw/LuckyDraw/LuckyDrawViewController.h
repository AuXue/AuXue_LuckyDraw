//
//  LuckyDrawViewController.h
//  LuckyDraw
//
//  Created by yangqijia on 16/8/5.
//  Copyright © 2016年 yangqijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LuckyDrawViewController : UIViewController

/**
 *  自定义初始化方法
 *
 *  @param prizes 奖品数组
 *  @param name   想要的奖品
 *
 *  @return 
 */
-(id)initWithPrizes:(NSArray *)prizes myPrize:(NSString *)name;

@end
