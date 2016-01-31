
#import "SBHomeViewController.h"
#import "SBJsonViewController.h"
#import "SBImageDownloadViewController.h"

@interface SBHomeViewController ()

@end

@implementation SBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"SB NETWORKING";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpUserInterface];
}

-(void)setUpUserInterface {
    
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    CGFloat yValue = size.height - 100;
    yValue = yValue / 3;
    
    CGFloat xValue = size.width - 200;
    xValue = xValue / 2;
    
    UIButton *jsonButton = [UIButton buttonWithType:UIButtonTypeCustom];
    jsonButton.frame = CGRectMake(xValue, yValue, 200, 50);
    jsonButton.backgroundColor = [UIColor purpleColor];
    [jsonButton setTitle:@"JSON RESPONSE" forState:UIControlStateNormal];
    [jsonButton addTarget:self action:@selector(performJsonButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jsonButton];
    
    UIButton *imageDownloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    imageDownloadButton.frame = CGRectMake(xValue, jsonButton.frame.origin.y + jsonButton.frame.size.height + yValue, 200, 50);
    imageDownloadButton.backgroundColor = [UIColor purpleColor];
    [imageDownloadButton setTitle:@"DOWNLOAD IMAGE" forState:UIControlStateNormal];
    [imageDownloadButton addTarget:self action:@selector(performImageDownloadButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageDownloadButton];
    

}

-(void)performJsonButton {
    
    [self.navigationController pushViewController:[[SBJsonViewController alloc] init] animated:YES];
}

-(void)performImageDownloadButton {
    [self.navigationController pushViewController:[[SBImageDownloadViewController alloc] init] animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
