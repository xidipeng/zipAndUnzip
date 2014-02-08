//
//  ViewController.h
//  ZipTest
//
//  Created by wangyinan on 14-1-24.
//  Copyright (c) 2014年 wangyinan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextView *contextStringView;
@property (retain, nonatomic) IBOutlet UITextView *compressStringView;


- (IBAction)compress:(id)sender;
- (IBAction)uncompress:(id)sender;

@end
