//
//  JpFXBlurView.h
//
//  Version 1.4.1
//



#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>


@interface UIImage (FXBlur)

- (UIImage *)blurredImageWithRadius:(CGFloat)aRadius iterations:(NSUInteger)aIterations tintColor:(UIColor *)aTintColor;

@end


@interface JpFXBlurView : UIView

+ (void)setBlurEnabled:(BOOL)blurEnabled;
+ (void)setUpdatesEnabled;
+ (void)setUpdatesDisabled;

@property (nonatomic, getter = isBlurEnabled) BOOL blurEnabled;
@property (nonatomic, getter = isDynamic) BOOL dynamic;
@property (nonatomic, assign) NSUInteger iterations;
@property (nonatomic, assign) NSTimeInterval updateInterval;
@property (nonatomic, assign) CGFloat blurRadius;
@property (nonatomic, strong) UIColor *tintColor;

@end
