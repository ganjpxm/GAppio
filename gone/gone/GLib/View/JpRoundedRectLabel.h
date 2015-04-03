//
//  JpFXBlurView.h
//
//  Version 1.4.1
//

#import <UIKit/UIKit.h>

@interface CountLabel : UILabel {
    int cornerRadius;
    UIColor *rectColor;
}

@property (nonatomic) int cornerRadius;
@property (nonatomic, retain) UIColor *rectColor;

- (void) setBackgroundColor:(UIColor *)color;
- (void) drawRoundedRect:(CGContextRef)c rect:(CGRect)rect radius:(int)corner_radius color:(UIColor *)color;

@end