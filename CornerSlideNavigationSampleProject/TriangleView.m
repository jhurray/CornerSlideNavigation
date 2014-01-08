//
//  TriangleView.m
//  CornerSlideNavigationSampleProject
//
//  Created by Gregoire on 1/6/14.
//  Copyright (c) 2014 jhurrayApps. All rights reserved.
//

#import "TriangleView.h"

#define ARCCURVE 25

@implementation TriangleView

@synthesize btn, delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGFloat size = frame.size.width;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0.0, 0.0);
        //CGPathAddLineToPoint(path, NULL, - size, size);
        CGPathAddQuadCurveToPoint(path, NULL, -size/2-ARCCURVE, size/2-ARCCURVE, -size, size);
        CGPathAddLineToPoint(path, NULL, 0.0, size);
        
        CGPathAddLineToPoint(path, NULL, 0.0f, 0.0f);
        
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [shapeLayer setPath:path];
        [shapeLayer setFillColor:TRIANGLE_COLOR.CGColor];
        [shapeLayer setStrokeColor:TRIANGLE_COLOR.CGColor];
        [shapeLayer setPosition:CGPointMake(self.bounds.size.width, 0.0f)];
        [[self layer] addSublayer:shapeLayer];
        
        CGPathRelease(path);
        
        //for buttons
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:BTN_COLOR];
        [btn.layer setCornerRadius:size/4];
        [btn setFrame:CGRectMake(size/2.4, size/2.4, size/2, size/2)];
        [btn addTarget:self action:@selector(btnTouched) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(highlightBtn) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(unhighlightBtn) forControlEvents:UIControlEventTouchUpOutside];
        
        [self addSubview:btn];
        
        self.tag = 0;
        
    }
    return self;
}

-(void) highlightBtn{
    
    [btn setBackgroundColor:[UIColor whiteColor]];
}

-(void) unhighlightBtn{
    
    [btn setBackgroundColor:BTN_COLOR];
}

-(void) btnTouched{
    
    NSLog(@"Btn %li touched", (long)self.tag);
    [delegate triangleButtonTouched:self];
    [self unhighlightBtn];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

}
*/

@end
