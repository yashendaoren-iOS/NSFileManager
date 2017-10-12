//
//  ViewController.m
//  文件读写
//
//  Created by Silver on 2017/9/30.
//  Copyright © 2017年 Silver. All rights reserved.
//

#import "ViewController.h"

#define AppStoreInfoLocalFilePath  [NSString stringWithFormat:@"%@/%@/", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],@"appleBuy"]

@interface ViewController (){
    
    UITextField *textField;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _initView];

}

- (void)_initView{
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 50, 200, 40)];
    textField.borderStyle= UITextBorderStyleRoundedRect;
    [self.view addSubview:textField];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 200, 40)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"购买" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(saveReceipt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 200, 200, 40)];
    btn1.backgroundColor = [UIColor redColor];
    [btn1 setTitle:@"查询" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(checkReceipt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(10, 300, 200, 40)];
    btn2.backgroundColor = [UIColor redColor];
    [btn2 setTitle:@"删除" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(deleteReceipt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

- (void)saveReceipt{
    NSLog(@"-----保存交易凭证--------");
    NSString *savedPath = [NSString stringWithFormat:@"%@%@.plist", AppStoreInfoLocalFilePath, textField.text];

    NSDictionary *dic = @{@"id":textField.text,@"receipt":textField.text};
    
    [dic writeToFile:savedPath atomically:YES];
    
}
//检验凭证
- (void)checkReceipt{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    //从服务器验证receipt失败之后，在程序再次启动的时候，使用保存的receipt再次到服务器验证
    if (![fileManager fileExistsAtPath:AppStoreInfoLocalFilePath]) {//如果在改路下不存在文件，说明就没有保存验证失败后的购买凭证，也就是说发送凭证成功。
        [fileManager createDirectoryAtPath:AppStoreInfoLocalFilePath//创建目录
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    else//存在购买凭证，说明发送凭证失败，再次发起验证
    {
        //搜索该目录下的所有文件和目录
        NSArray *cacheFileNameArray = [fileManager contentsOfDirectoryAtPath:AppStoreInfoLocalFilePath error:&error];
        if (error == nil)
        {
            for (NSString *name in cacheFileNameArray)
            {
                if ([name hasSuffix:@".plist"])//如果有plist后缀的文件，说明就是存储的购买凭证
                {
                    NSString *filePath = [NSString stringWithFormat:@"%@%@", AppStoreInfoLocalFilePath, name];
                    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
                    
                    NSLog(@"%@", dic);
                }
            }
        }
        else
        {
            NSLog(@"AppStoreInfoLocalFilePath error:%@", [error domain]);
        }
    }
    
}
- (void)deleteReceipt{
    NSLog(@"-----删除交易凭证--------");
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *savedPath = [NSString stringWithFormat:@"%@%@.plist", AppStoreInfoLocalFilePath, @"1"];
    
    if ([fileManager fileExistsAtPath:savedPath])
    {
        [fileManager removeItemAtPath:savedPath error:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
