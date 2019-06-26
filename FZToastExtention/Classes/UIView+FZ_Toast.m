
//
//  UIView+FZ_Toast.m
//  FZOCProject
//
//  Created by 吴福增 on 2019/1/24.
//  Copyright © 2019 wufuzeng. All rights reserved.
//

#import "UIView+FZ_Toast.h"
#import <objc/runtime.h>

@interface UIView ()

@property (nonatomic,strong,nullable) UIView *fz_backgroundView;

@property (nonatomic,copy,nullable) void(^fz_reloadAction)(void);

@property (nonatomic,copy,nullable) void(^fz_cancelAction)(void);

@end
 
@implementation UIView (FZ_Toast)

#pragma mark -- Message Info -------

- (void)fz_showIcon:(UIImage *)Icon{
    [self fz_showWithIcon:Icon msg:nil];
}
- (void)fz_showMsg:(NSString * _Nullable )msg{
    [self fz_showWithIcon:nil msg:msg];
}
- (void)fz_showWithIcon:(UIImage * _Nullable )icon msg:(NSString * _Nullable )msg{
    [self fz_showWithIcon:icon title:nil msg:msg reload:nil cancel:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self fz_dismiss];
    });
}
- (void)fz_showWithIcon:(UIImage * _Nullable )icon msg:(NSString * _Nullable )msg reload:(void(^)(void))reload cancel:(void(^ _Nullable)(void))cancel {
    [self fz_showWithIcon:icon title:nil msg:msg reload:reload cancel:cancel];
}
- (void)fz_showWithIcon:(UIImage * _Nullable )icon title:(NSString * _Nullable )title msg:(NSString * _Nullable )msg reload:(void(^ _Nullable)(void))reload cancel:(void(^ _Nullable)(void))cancel {
    [self fz_showWithType:FZViewToastTypeIcon | FZViewToastTypeTitle | FZViewToastTypeMessage | FZViewToastTypeReload | FZViewToastTypeCancel icon:icon title:title msg:msg reload:reload cancel:cancel];
}

#pragma mark -- Loading Info -------

-(void)fz_showLoading{
    [self fz_showLoadingWithMsg:nil];
}
-(void)fz_showLoadingWithMsg:(NSString * _Nullable)msg{
    [self fz_showLoadingWithMsg:msg cancel:nil];
}
-(void)fz_showLoadingWithMsg:(NSString * _Nullable)msg cancel:(void(^ _Nullable)(void))cancelAction {
    [self fz_showLoadingWithMsg:msg reload:nil cancel:cancelAction];
}
-(void)fz_showLoadingWithMsg:(NSString * _Nullable)msg reload:(void(^ _Nullable)(void))reloadAction cancel:(void(^ _Nullable)(void))cancelAction {
    [self fz_showWithType:FZViewToastTypeAll icon:nil title:nil msg:msg reload:reloadAction cancel:cancelAction];
    
}

#pragma mark -- Custom Info -------

-(void)fz_showCustomView:(UIView *)customView{
    if (self.fz_toastView.superview) {
        [self.fz_toastView removeFromSuperview];
    }
    self.fz_toastView = customView;
    [self addSubview:self.fz_toastView];
    self.fz_toastView.center = self.center;
    [self fz_showAnimate:YES];
        
        
}


#pragma mark -- Common Func ----


- (void)fz_showWithType:(FZViewToastType)type icon:(UIImage  * _Nullable )icon title:(NSString  * _Nullable )title msg:(NSString  * _Nullable )msg reload:(void(^)(void))reload cancel:(void(^)(void))cancel {
    
    if (type == FZViewToastTypeCustom) {
        //...
        @throw [NSException exceptionWithName:@"发生错误" reason:@"自定义类型 请使用用\"-(void)fz_showCustomView:(UIView *)customView\"" userInfo:nil];
        return;
    }
    
    self.fz_reloadAction = reload;
    self.fz_cancelAction = cancel;
    
    UIView * backgroundView = [[UIView alloc]initWithFrame:self.frame];
    backgroundView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [self addSubview:backgroundView];
    self.fz_backgroundView = backgroundView;
    
    UIView * toastView = [[UIView alloc] init];
    
    toastView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.6];
    toastView.layer.cornerRadius = 5;
    toastView.layer.borderColor = [UIColor colorWithWhite:0.4 alpha:0.6].CGColor;
    toastView.layer.borderWidth = 0.5;
    toastView.layer.masksToBounds = YES;
    
    if (self.fz_toastView.superview) {
        [self.fz_toastView removeFromSuperview];
    }
    self.fz_toastView = toastView;
    [self addSubview:self.fz_toastView];
    
    UIActivityIndicatorView * activityView;
    UIImageView * imageView;
    UILabel  * titleLabel,  * messageLabel;
    UIButton * reloadButton,* cancelButton;
    
    CGFloat margin    = 20.0;
    CGFloat maxWidth  = self.frame.size.width - margin *2;
    CGFloat maxHeight = self.frame.size.height - margin *2;
    CGFloat minHeight = 30 + margin * 2.0;
    
    UIView * firstView = nil;
    UIView * lastView  = nil;
    
    if ((type & FZViewToastTypeLoading) == FZViewToastTypeLoading) {
        
        activityView = [[UIActivityIndicatorView alloc]init];
        [activityView startAnimating];
        
        [toastView addSubview:activityView];
        activityView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:activityView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:toastView attribute:NSLayoutAttributeTop multiplier:1.0 constant:margin];
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:activityView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:toastView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:activityView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:30.0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:activityView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:30.0];
        [toastView addConstraints:@[top,centerX,width,height]];

        firstView = activityView;
        lastView = activityView;
    }

    if ((type & FZViewToastTypeIcon) == FZViewToastTypeIcon) {

        if (icon) {
            imageView = [[UIImageView alloc]init];
            imageView.image = icon;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            [toastView addSubview:imageView];
            imageView.translatesAutoresizingMaskIntoConstraints = NO;
            if (lastView) {
                NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:margin];
                [toastView addConstraint:top];
            }else{
                firstView = imageView;
                NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:toastView attribute:NSLayoutAttributeTop multiplier:1.0 constant:margin];
                [toastView addConstraint:top];
            }
            NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:toastView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:60.0];
            NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:width.constant];
            [toastView addConstraints:@[centerX,width,height]];
            lastView = imageView;

        }else{
            
        }
    }

    if ((type & FZViewToastTypeTitle) == FZViewToastTypeTitle){
        
        if (title.length) {
            
            titleLabel = [[UILabel alloc]init];
            [toastView addSubview:titleLabel];
            titleLabel.text = title;
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.numberOfLines = 0;
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
            if (lastView) {
                NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:title.length?margin:0];
                [toastView addConstraint:top];
            }else{
                firstView = titleLabel;
                NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:toastView attribute:NSLayoutAttributeTop multiplier:1.0 constant:title.length?margin:0];
                [toastView addConstraint:top];
            }
            NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:toastView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
            
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:toastView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-margin * 2.0];
            
            NSLayoutConstraint *width_max = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:maxWidth - margin * 2];
            //[self addConstraint:width_max];
            
            [toastView addConstraints:@[centerX,width,width_max]];
            
            lastView = titleLabel;
        }
        
        
    }
    
    if ((type & FZViewToastTypeMessage) == FZViewToastTypeMessage){
        
        if (msg.length) {
            messageLabel = [[UILabel alloc]init];
            [toastView addSubview:messageLabel];
            messageLabel.text = msg;
            messageLabel.textColor = [UIColor whiteColor];
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.numberOfLines = 0;
            
            messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
            if (lastView) {
                NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:msg.length?margin:0];
                [toastView addConstraint:top];
            }else{
                firstView = messageLabel;
                NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:toastView attribute:NSLayoutAttributeTop multiplier:1.0 constant:msg.length?margin:0];
                [toastView addConstraint:top];
            }
            NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:toastView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
            
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:toastView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-margin * 2.0];
            NSLayoutConstraint *width_max = [NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:maxWidth - margin *2];
            [toastView addConstraints:@[centerX,width,width_max]];
            
            lastView = messageLabel;
        }
    }

    if (((type & FZViewToastTypeReload) == FZViewToastTypeReload) && reload){
        
        reloadButton = [[UIButton alloc]init];
        [reloadButton setTitle:@"重载" forState:UIControlStateNormal];
        [reloadButton addTarget:self action:@selector(fz_reloadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        reloadButton.layer.borderColor = [UIColor whiteColor].CGColor;
        reloadButton.layer.borderWidth = 0.5;
        reloadButton.layer.cornerRadius = 3;
        reloadButton.layer.masksToBounds = YES;
        
        [toastView addSubview:reloadButton];
        reloadButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        if (lastView) {
            NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:reloadButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:margin];
            [toastView addConstraint:top];
        }else{
            firstView = reloadButton;
            NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:reloadButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:toastView attribute:NSLayoutAttributeTop multiplier:1.0 constant:margin];
            [toastView addConstraint:top];
        }
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:reloadButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:toastView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
        
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:reloadButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:60.0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:reloadButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:30.0];

        [toastView addConstraints:@[centerX,width,height]];

        if (reload) {
            reloadButton.hidden = NO;
           lastView = reloadButton;
        }else{
            reloadButton.hidden = YES;
        }
    }
    
    
    if (((type & FZViewToastTypeCancel) == FZViewToastTypeCancel) && cancel){
        cancelButton = [[UIButton alloc]init];
   
//        NSBundle *mainBundle = [NSBundle mainBundle];
//        NSString *myBundlePath = [mainBundle pathForResource:@"FZToastExtention" ofType:@"bundle"];
//        NSBundle *myBundle = [NSBundle bundleWithPath:myBundlePath];
//        //放在自定义bundle中的图片
//        NSString *imagePath = [myBundle pathForResource:@"delete_icon@2x" ofType:@"png"];
//        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        UIImage *image = [UIImage imageNamed:@"FZToastExtention.bundle/delete_icon"];
        [cancelButton setImage:image forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(fz_cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [toastView addSubview:cancelButton];
        cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:toastView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:toastView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:30.0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:margin];

        [toastView addConstraints:@[top,right,width,height]];

        //lastView = messageLabel;
        if (cancel) {
            cancelButton.hidden = NO;
        }else{
            cancelButton.hidden = YES;
        }

    }
    
    
    self.fz_toastView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.fz_toastView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.fz_toastView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint *height_min = [NSLayoutConstraint constraintWithItem:self.fz_toastView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:0 multiplier:1.0 constant:minHeight];
    
    NSLayoutConstraint *height_max = [NSLayoutConstraint constraintWithItem:self.fz_toastView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:0 multiplier:1.0 constant:maxHeight];
    
    NSLayoutConstraint *width_min = [NSLayoutConstraint constraintWithItem:self.fz_toastView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.fz_toastView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    [self addConstraint:width_min];
    
    [self addConstraints:@[centerX,centerY,height_min,height_max]];
    
    if (lastView) {
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.fz_toastView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:margin];
        [self addConstraint:bottom];
        
//        if ([lastView isKindOfClass:[UILabel class]]) {
//            NSLayoutConstraint *width_max = [NSLayoutConstraint constraintWithItem:self.fz_toastView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-margin *2];
//            [self addConstraint:width_max];
//        }else{
//            
//        }
        
    }
    [self fz_showAnimate:YES];
}

-(void)fz_showAnimate:(BOOL)animate{
    self.fz_toastView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.fz_toastView.alpha = 0.1;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.fz_toastView.transform = CGAffineTransformIdentity;
        self.fz_toastView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}


-(void)fz_dismissAnimate:(BOOL)animate{

    if (animate) {
        [UIView animateWithDuration:0.2 animations:^{
            self.fz_toastView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.fz_toastView.alpha = 0.1;
        } completion:^(BOOL finished) {
             [self fz_dismiss];
        }];
    }else{
        [self fz_dismiss];
    }
}

- (void)fz_dismiss{
    [self.fz_toastView removeFromSuperview];
    [self.fz_backgroundView removeFromSuperview];
    
    self.fz_toastView = nil;
    self.fz_backgroundView = nil;
    self.fz_reloadAction = nil;
    self.fz_cancelAction = nil;
}


#pragma mark -- Action Func ----

-(void)fz_reloadButtonAction:(UIButton *)sender{
    if (self.fz_reloadAction) {
        self.fz_reloadAction();
    }
}


-(void)fz_cancelButtonAction:(UIButton *)sender{
    if (self.fz_cancelAction) {
        self.fz_cancelAction();
    }
    [self fz_dismissAnimate:YES];
}



#pragma mark -- Set、Get Func ----

- (void)setFz_toastView:(UIView *)fz_toastView{
    objc_setAssociatedObject(self, @selector(fz_toastView),fz_toastView, OBJC_ASSOCIATION_RETAIN);
} 
- (UIView *)fz_toastView{
    return objc_getAssociatedObject(self, @selector(fz_toastView));
}

- (void)setFz_backgroundView:(UIView *)fz_backgroundView{
    objc_setAssociatedObject(self, @selector(fz_backgroundView),fz_backgroundView, OBJC_ASSOCIATION_RETAIN);
}
- (UIView *)fz_backgroundView{
    return objc_getAssociatedObject(self, @selector(fz_backgroundView));
}

-(void)setFz_reloadAction:(void (^)(void))fz_reloadAction{
    objc_setAssociatedObject(self, @selector(fz_reloadAction), fz_reloadAction, OBJC_ASSOCIATION_COPY);
}
-(void (^)(void))fz_reloadAction{
    return objc_getAssociatedObject(self, @selector(fz_reloadAction));
}
-(void)setFz_cancelAction:(void (^)(void))fz_cancelAction{
    objc_setAssociatedObject(self, @selector(fz_cancelAction), fz_cancelAction, OBJC_ASSOCIATION_COPY);
}
-(void (^)(void))fz_cancelAction{
    return objc_getAssociatedObject(self, @selector(fz_cancelAction));
}


@end
