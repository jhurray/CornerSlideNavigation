//
//  CornerSlideNavigationView.h
//  CornerSlideNavigationSampleProject
//
//  Created by Gregoire on 1/6/14.
//  Copyright (c) 2014 jhurrayApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TriangleView.h"

@class CornerSlideNavigationView;
@protocol CornerSlideNavigationDelegate <NSObject>

@optional
-(void)triangleButtonTouched:(TriangleView *)triangleView;
-(void)cornersHidden:(CornerSlideNavigationView *)cornerSlideNavView;

@end

@interface CornerSlideNavigationView : UIView <TriangleViewDelegate>

@property (nonatomic, weak) id<CornerSlideNavigationDelegate> delegate;
@property (nonatomic, strong) NSArray *triangles;
@property (nonatomic, readwrite) BOOL visible;
@property (nonatomic, strong) UIView *backgroundSheet;

- (id)initWithFrame:(CGRect)frame withStatusBar:(BOOL)statusBar withNavBar:(BOOL)navBar;

-(void) moveTriangles;

@end
