//
//  FZViewController.m
//  FZToastExtention
//
//  Created by wufuzeng on 06/26/2019.
//  Copyright (c) 2019 wufuzeng. All rights reserved.
//

#import "FZViewController.h"

#import <FZToastExtention/FZToastExtention.h>

@interface FZViewController ()

@end

@implementation FZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    
    //[self.view fz_showLoading];
    
    //[self.view fz_showMsg:@"holle world !"];
    
    [self.view fz_showWithIcon:[UIImage imageNamed:@"submitSucceed"] title:@"title" msg:@"message" reload:^{
        
    } cancel:^{
         
    }];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
