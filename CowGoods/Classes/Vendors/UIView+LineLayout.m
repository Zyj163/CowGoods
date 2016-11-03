//
//  UIView+LineLayout.m
//  PageViewController
//
//  Created by zhangyongjun on 16/4/27.
//  Copyright © 2016年 张永俊. All rights reserved.
//

#import "UIView+LineLayout.h"
#import "UIView+Extension.h"

@implementation UIView (LineLayout)

- (void)lineLayout:(NSArray *)views withSetting:(void (^)(NSInteger, UIView *))setting withInset:(UIEdgeInsets)insets andSpace:(CGFloat)space
{
    for (NSInteger i = 0; i < views.count; i ++) {
        UIView *view = views[i];
        view.width = (self.width - space * (views.count - 1) - insets.left - insets.right) / views.count;
        view.height = self.height - insets.top - insets.bottom;
        if (setting) {
            setting(i, view);
        }
        view.x = (view.width + space) * i + insets.left;
        view.y = insets.top;
    }
}

- (void)lineButNoEqualWithLayout:(NSArray *)views withSetting:(void(^)(NSInteger idx, UIView *view))setting withInset:(UIEdgeInsets)insets andSpace:(CGFloat)space {
    UIView *preView;
    for (NSInteger i = 0; i < views.count; i ++) {
        UIView *view = views[i];
        
        view.y = insets.top;
        if (setting) {
            setting(i, view);
        }
        if (i == 0) {
            view.x = insets.left;
        }else if (i == views.count - 1) {
            view.x = CGRectGetMaxX(preView.frame) + space;
        }else {
            view.x = CGRectGetMaxX(preView.frame) + space;
        }
        
        preView = view;
    }
}

- (void)VlineLayout:(NSArray *)views withSetting:(void(^)(NSInteger idx, UIView *view))setting withInset:(UIEdgeInsets)insets andSpace:(CGFloat)space {
    
    for (NSInteger i = 0; i < views.count; i ++) {
        UIView *view = views[i];
        view.width = self.width - insets.left - insets.right;
        view.height = (self.height - space * (views.count - 1) - insets.bottom - insets.top) / views.count;
        if (setting) {
            setting(i, view);
        }
        
        view.x = insets.left;
        view.y = (view.height + space) * i + insets.top;
    }
    
}

- (void)VlineButNoEqualWithLayout:(NSArray *)views withSetting:(void(^)(NSInteger idx, UIView *view))setting withInset:(UIEdgeInsets)insets andSpace:(CGFloat)space {
    
}


@end
