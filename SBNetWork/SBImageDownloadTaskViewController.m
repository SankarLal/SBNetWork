

#import "SBImageDownloadTaskViewController.h"
#import "SBTableView.h"

@interface SBImageDownloadTaskViewController ()

@end

@implementation SBImageDownloadTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"SBIMAGE DOWNLOAD TASK";
    self.view.backgroundColor = [UIColor whiteColor];
    
    SBTableView *sbTblView = [[SBTableView alloc] initWithFrame:self.view.bounds];
    [sbTblView setFileArrayValue:@[
                                   @"https://www.gstatic.com/webp/gallery3/5.png",
                                   @"http://oi44.tinypic.com/16hvtok.jpg"
                                   ]
              sbDownloadFileType:SBDownloadFileTypeImage];
    
    [self.view addSubview:sbTblView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
