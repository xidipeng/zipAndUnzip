//
//  ViewController.m
//  ZipTest
//
//  Created by wangyinan on 14-1-24.
//  Copyright (c) 2014年 wangyinan. All rights reserved.
//

#import "ViewController.h"
#import "zipAndUnzip.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//
//    NSString *str = [NSString stringWithFormat:@"%@", @"wangyinanwangyinanwangyinanwangyinanwangyinanwangyinanwangyinanwangyinanwangy"];
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"data is %@.", data);
//    
//    zipAndUnzip *zipTools = [[zipAndUnzip alloc] init];
//    NSData *dataZip = [zipTools gzipDeflate:data];
//    
//    NSLog(@"%@", dataZip);
//    
//    NSData *dataUnzip = [zipTools gzipInflate:dataZip];
//    
//    NSLog(@"%@", dataUnzip);
//    NSString *strUnzip = [[[NSString alloc] initWithData:dataUnzip encoding:NSUTF8StringEncoding] autorelease];
//    NSLog(@"str is %@.", strUnzip);    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_contextStringView release];
    [_compressStringView release];
    [super dealloc];
}

- (NSData *)changeHexStringToData:(NSString *)str
{    
    NSLog(@"changeStringToChar start!");
    NSString *context = [[NSString alloc] initWithFormat:@"%@", str];
    uint length = [context length]/2;
    if ( length > 0xffffffff )
    {
        NSLog(@"length is too long!");
        return NULL;
    }
    Byte *compressString = malloc(length);
    if ( nil == compressString )
    {
        NSLog(@"malloc is error!");
        return NULL;
    }
    memset(compressString, 0x00, length);
    
    Byte *p = compressString;
    uint flag = 1;  //用于偏移4位
    for (int i = 0; i < [str length]; i++) {
        unichar c = [context characterAtIndex:i];
        if ( c >= 0x30 && c <= 0x39 )
        {
            if ( flag )
            {
                *p = (c - 0x30) << 4;
                flag = 0;
            }
            else
            {
                *p |= (c - 0x30);
                NSLog(@"*p is %02x", *p);
                p++;
                flag = 1;
            }
        }
        else if ( c >= 0x41 && c <= 0x5a )
        {
            if ( flag )
            {
                *p = (c - 0x41 + 0x0a) << 4;
                flag = 0;
            }
            else
            {
                *p |= (c - 0x41 + 0x0a);
                NSLog(@"*p is %02x", *p);
                p++;
                flag = 1;
            }
        }
        else if ( c >= 0x61 && c <= 0x7a )
        {
            if ( flag )
            {
                *p = (c - 0x61 + 0x0a) << 4;
                flag = 0;
            }
            else
            {
                *p |= (c - 0x61 + 0x0a);
                NSLog(@"*p is %02x", *p);
                p++;
                flag = 1;
            }
        }
        else
        {
            continue;
        }
    }
    
    NSLog(@"changeStringToChar end!");
    
    int dataLength = p - compressString;
    NSData *data = [[[NSData alloc] initWithBytes:compressString length:dataLength] autorelease];
    NSLog(@"data"
           "is %@", data);
    
    return data;
}

- (IBAction)compress:(id)sender {
    
    [_contextStringView resignFirstResponder];
    [_compressStringView resignFirstResponder];
    
    if ( nil == _contextStringView.text || 0 == [_contextStringView.text length])
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"警告"
                                                        message:@"字符串不能为空"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil] autorelease];
        [alert show];
        
        return;
    }
    
    NSString *str = [[NSString alloc] initWithFormat:@"%@",  _contextStringView.text];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    zipAndUnzip *zipTools = [[[zipAndUnzip alloc] init] autorelease];
    NSData *datazip = [zipTools gzipDeflate:data];
    
    NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"%@\n", @"字符串的十六进制为："];
    [result appendFormat:@"%@\n", data];
    [result appendString:@"压缩后字符串十六进制为：\n"];
    [result appendFormat:@"%@\n", datazip];
    
    _compressStringView.text = result;
    [str release];
    [result release];
    
}

- (IBAction)uncompress:(id)sender {
    
    [_contextStringView resignFirstResponder];
    [_compressStringView resignFirstResponder];
    
    if ( nil == _contextStringView.text || 0 == [_contextStringView.text length])
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"警告"
                                                         message:@"字符串不能为空"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil] autorelease];
        [alert show];
        
        return;
    }
    
    NSString *str = [[NSString alloc] initWithFormat:@"%@",  _contextStringView.text];
    NSData *data = [self changeHexStringToData:str];
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    zipAndUnzip *zipTools = [[[zipAndUnzip alloc] init] autorelease];
    NSData *datazip = [zipTools gzipInflate:data];
    
    NSMutableString *result = [[NSMutableString alloc] initWithData:datazip encoding:NSUTF8StringEncoding];
    [result insertString:@"解压缩后字符串：" atIndex:0];
    
    _compressStringView.text = result;
    [str release];
    [result release];
}
@end
