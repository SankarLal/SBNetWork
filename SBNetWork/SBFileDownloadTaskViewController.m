
#import "SBFileDownloadTaskViewController.h"
#import "SBImageDownloadTaskViewController.h"
#import "SBVideoDownloadTaskViewController.h"
#import "SBAudioDownloadTaskViewController.h"
#import "SBPDFDownloadTaskViewController.h"


#define HEADER_COLOR                [UIColor colorWithRed:56.0/255 green:185.0/255 blue:158.0/255 alpha:1]

@interface SBFileDownloadTaskViewController ()

@end

@implementation SBFileDownloadTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"SBFILE DOWNLOAD";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self setUpUserInterface];
    
}

#pragma mark SetUp User Interface
-(void)setUpUserInterface {
    
    CGSize size = CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    
    CGFloat yValue = size.height - 150;
    yValue = yValue / 5;
    
    CGFloat xValue = size.width - 200;
    xValue = xValue / 2;
    
    UIButton *imageDownloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    imageDownloadButton.frame = CGRectMake(xValue, yValue, 200, 50);
    imageDownloadButton.backgroundColor = HEADER_COLOR;
    [imageDownloadButton setTitle:@"DOWNLOAD IMAGES" forState:UIControlStateNormal];
    [imageDownloadButton addTarget:self action:@selector(performImageButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageDownloadButton];
    
    UIButton *videoDownloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    videoDownloadButton.frame = CGRectMake(xValue, imageDownloadButton.frame.origin.y + imageDownloadButton.frame.size.height + yValue, 200, 50);
    videoDownloadButton.backgroundColor = HEADER_COLOR;
    [videoDownloadButton setTitle:@"DOWNLOAD VIDEO" forState:UIControlStateNormal];
    [videoDownloadButton addTarget:self action:@selector(performVideoButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:videoDownloadButton];
    
    UIButton *audioDownloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    audioDownloadButton.frame = CGRectMake(xValue, videoDownloadButton.frame.origin.y + videoDownloadButton.frame.size.height + yValue, 200, 50);
    audioDownloadButton.backgroundColor = HEADER_COLOR;
    [audioDownloadButton setTitle:@"DOWNLOAD AUDIO" forState:UIControlStateNormal];
    [audioDownloadButton addTarget:self action:@selector(performAudioButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:audioDownloadButton];
    
    
    UIButton *pdfDownloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pdfDownloadButton.frame = CGRectMake(xValue, audioDownloadButton.frame.origin.y + audioDownloadButton.frame.size.height + yValue, 200, 50);
    pdfDownloadButton.backgroundColor = HEADER_COLOR;
    [pdfDownloadButton setTitle:@"DOWNLOAD PDF" forState:UIControlStateNormal];
    [pdfDownloadButton addTarget:self action:@selector(performPDFButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pdfDownloadButton];
    
    
    
}


-(void)performImageButton {
    [self.navigationController pushViewController:[[SBImageDownloadTaskViewController alloc] init] animated:YES];
    
}

-(void)performVideoButton {
    [self.navigationController pushViewController:[[SBVideoDownloadTaskViewController alloc] init] animated:YES];
    
}

-(void)performAudioButton {
    [self.navigationController pushViewController:[[SBAudioDownloadTaskViewController alloc] init] animated:YES];
    
}

-(void)performPDFButton {
    [self.navigationController pushViewController:[[SBPDFDownloadTaskViewController alloc] init] animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
