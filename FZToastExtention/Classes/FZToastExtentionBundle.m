//
//  FZToastExtentionBundle.m
//  FZToastExtention
//
//  Created by 吴福增 on 2019/7/9.
//

#import "FZToastExtentionBundle.h"

@implementation FZToastExtentionBundle

+ (NSBundle *)fz_bundle{
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        //frameworkBundle
        NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
        bundle = [NSBundle bundleWithPath:[currentBundle pathForResource:@"FZToastExtention" ofType:@"bundle"]];
        if (bundle == nil) {
            //mainBundle
            NSBundle *mainBundle = [NSBundle mainBundle];
            bundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"FZToastExtention" ofType:@"bundle"]];
        }
    }
    return bundle;
}

+ (UIImage *)fz_imageNamed:(NSString *)name {
    return [self fz_imageNamed:name ofType:nil];
}

+ (UIImage *)fz_imageNamed:(NSString *)name ofType:(nullable NSString *)type {
    if (name == nil) return nil;
    if ([UIImage respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
        //iOS8.0+ 有缓存
        return [UIImage imageNamed:name inBundle:[self fz_bundle] compatibleWithTraitCollection:nil];
    } else {
        //没有缓存
        UIImage *image = [[UIImage imageWithContentsOfFile:[[self fz_bundle] pathForResource:[name stringByAppendingString:@"@2x"] ofType:type?:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        if (image) {
            return image;
        }else{
            image = [[UIImage imageWithContentsOfFile:[[self fz_bundle] pathForResource:name ofType:type?:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            return image;
        }
    }
}


@end
