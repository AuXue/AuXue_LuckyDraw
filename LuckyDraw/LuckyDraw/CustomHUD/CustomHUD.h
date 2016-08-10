//
//  CustomHUD.h
//
//  Created by yangqijia on 16/5/10.
//  Copyright © 2016年 yangqijia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HiddenHud)();


@interface CustomHUD : UIView

@property(nonatomic ,strong)UIActivityIndicatorView *activityView;
@property(nonatomic ,strong)UIView  *bgView;
@property(nonatomic ,strong)UILabel *contentlabel;
@property(nonatomic ,copy)  HiddenHud hiddenHud;

+(CustomHUD *)shareCustomHud;

/**
 *  停止并隐藏
 */
+(void)stopHidden;

/**
 *  设置显示内容以及等待时间
 *
 *  @param time    等待时间
 *  @param content 显示内容
 */
+(void)createHudCustomTime:(CGFloat)time showContent:(NSString *)content;

/**
 *  设置显示内容
 *
 *  @param content 显示内容
 */
+(void)createHudCustomShowContent:(NSString *)content;

/**
 *  仅显示提示语
 *
 *  @param content 提示语
 */
+(void)createShowContent:(NSString *)content;

@end
