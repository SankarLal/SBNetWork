

#import "SBPDFDownloadTaskViewController.h"
#import "SBTableView.h"
#import "SBDetailsViewController.h"

@interface SBPDFDownloadTaskViewController () <SBDetailDelegate>

@end

@implementation SBPDFDownloadTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"SBPDF DOWNLOAD TASK";
    self.view.backgroundColor = [UIColor whiteColor];
    
    SBTableView *sbTblView = [[SBTableView alloc] initWithFrame:self.view.bounds];
    sbTblView.delegate = self;
    [sbTblView setFileArrayValue:@[
                                   @"http://swift-lang.org/guides/trunk/userguide/userguide.pdf"
                                   ]
              sbDownloadFileType:SBDownloadFileTypePDF];
    
    [self.view addSubview:sbTblView];
    
}

-(void)selectedFileType:(SBDownloadFileType)fileType filePath:(NSString *)filePath {
    
    SBDetailsViewController *sbDVCtrl = [[SBDetailsViewController alloc] init];
    [sbDVCtrl showSBDetailFileType:fileType filePath:filePath];
    [self.navigationController pushViewController:sbDVCtrl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
