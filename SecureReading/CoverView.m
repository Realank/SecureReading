//
//  CoverView.m
//  SecureReading
//
//  Created by Realank on 16/8/26.
//  Copyright © 2016年 Realank. All rights reserved.
//

#import "CoverView.h"

@interface CoverView ()

@property (nonatomic, strong) CAShapeLayer* contentHoleLayer;
@property (nonatomic, assign) CGRect contentMaskFrame;
@property (nonatomic, strong) UIView *resizeButton;
@property (nonatomic, strong) UIView *moveButton;

@end

@implementation CoverView

+ (instancetype)coverView{
    CoverView *view = [[[NSBundle mainBundle] loadNibNamed:@"CoverView" owner:self options:nil] lastObject];
    view.contentMaskFrame = CGRectMake(50, 50, 200, 100);
    return view;
}


+ (instancetype)coverViewWithFrame:(CGRect)frame{
    CoverView *view = [self coverView];
    view.frame = frame;
    return view;
}

- (void)setContentMaskFrame:(CGRect)contentMaskFrame{
    
    _contentMaskFrame = contentMaskFrame;
    
    if (!_contentHoleLayer) {
        _contentHoleLayer = [CAShapeLayer layer];
        _contentHoleLayer.fillColor = [UIColor blueColor].CGColor;
        _contentHoleLayer.fillRule = kCAFillRuleEvenOdd;
        self.layer.mask = _contentHoleLayer;
    }
    
    UIBezierPath *bPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 1000, 1000)];
    UIBezierPath *bsPath = [UIBezierPath bezierPathWithRect:contentMaskFrame];
    [bPath appendPath:bsPath];//追加
    bPath.usesEvenOddFillRule = YES;

    self.contentHoleLayer.path = bPath.CGPath;
    
    CGFloat buttonSize = 30;
    
    if (!_resizeButton) {
        _resizeButton = [[UIView alloc]init];
        _resizeButton.bounds = CGRectMake(0, 0, buttonSize, buttonSize);
        _resizeButton.backgroundColor = [UIColor orangeColor];
        _resizeButton.layer.cornerRadius = buttonSize/2;
        [self addSubview:_resizeButton];
        UIPanGestureRecognizer* panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(resizeHole:)];
        [_resizeButton addGestureRecognizer:panGes];
    }
    _resizeButton.center = CGPointMake(CGRectGetMaxX(contentMaskFrame), CGRectGetMaxY(contentMaskFrame));
    
    if (!_moveButton) {
        _moveButton = [[UIView alloc]init];
        _moveButton.bounds = CGRectMake(0, 0, buttonSize, buttonSize);
        _moveButton.backgroundColor = [UIColor orangeColor];
        _moveButton.layer.cornerRadius = buttonSize/2;
        [self addSubview:_moveButton];
        UIPanGestureRecognizer* panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveHole:)];
        [_moveButton addGestureRecognizer:panGes];
    }
    _moveButton.center = CGPointMake(CGRectGetMaxX(contentMaskFrame), CGRectGetMinY(contentMaskFrame));

}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    return CGRectContainsPoint(_resizeButton.frame, point) |CGRectContainsPoint(_moveButton.frame, point);
}

- (void)resizeHole:(UIPanGestureRecognizer*)panGes{
    static CGRect originHole;
    if (panGes.state == UIGestureRecognizerStateBegan) {
        originHole = _contentMaskFrame;
        
    }else if (panGes.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [panGes translationInView:self];
        CGRect holeFrame = _contentMaskFrame;
        holeFrame.size.width = originHole.size.width + point.x;
        holeFrame.size.height = originHole.size.height + point.y;
        NSLog(@"%f,%f",holeFrame.size.width,holeFrame.size.height);
        if (holeFrame.size.width > 20 && holeFrame.size.height > 20) {
            self.contentMaskFrame = holeFrame;
        }
        
    }
}

- (void)moveHole:(UIPanGestureRecognizer*)panGes{
    
    static CGRect originHole;
    if (panGes.state == UIGestureRecognizerStateBegan) {
        originHole = _contentMaskFrame;
        
    }else if (panGes.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [panGes translationInView:self];
        CGRect holeFrame = _contentMaskFrame;
        holeFrame.origin.x = originHole.origin.x + point.x;
        holeFrame.origin.y = originHole.origin.y + point.y;
//        holeFrame.size.width = originHole.size.width - point.x;
//        holeFrame.size.height = originHole.size.height - point.y;
        NSLog(@"%f,%f",holeFrame.size.width,holeFrame.size.height);
        if (holeFrame.size.width > 20 && holeFrame.size.height > 20) {
            self.contentMaskFrame = holeFrame;
        }
        
    }
}


@end
