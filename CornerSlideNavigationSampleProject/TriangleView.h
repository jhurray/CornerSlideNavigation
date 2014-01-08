//
//  TriangleView.h
//  CornerSlideNavigationSampleProject
//
//  Created by Gregoire on 1/6/14.
//  Copyright (c) 2014 jhurrayApps. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BTN_COLOR [UIColor lightGrayColor]
#define TRIANGLE_COLOR [UIColor blackColor]

@class TriangleView;
@protocol TriangleViewDelegate <NSObject>

@optional
-(void)triangleButtonTouched:(TriangleView *)triangleView;

@end

@interface TriangleView : UIView

@property (nonatomic, weak) id<TriangleViewDelegate> delegate;
@property (nonatomic, strong) UIButton *btn;

@end
