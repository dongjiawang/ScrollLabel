//
//  ViewController.m
//  JWScrollLabel
//
//  Created by djw on 2017/5/16.
//  Copyright © 2017年 ubiquitous. All rights reserved.
//

#import "ViewController.h"
#import "JWScrollLabel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    JWScrollLabel *scrollLabel = [[JWScrollLabel alloc] initWithFrame:CGRectMake(20, 100, 300, 30)];
    scrollLabel.textColor = [UIColor redColor];
    scrollLabel.labelText = @"这是一很长的可以滚动文字，长文字，长标题，滚起来是什么样子的呢";
    [self.view addSubview:scrollLabel];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
