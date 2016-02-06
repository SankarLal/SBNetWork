
#import "SBAudioDownloadTaskViewController.h"
#import "SBTableView.h"
#import "SBDetailsViewController.h"

@interface SBAudioDownloadTaskViewController () <SBDetailDelegate>

@end

@implementation SBAudioDownloadTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"SBAUDIO DOWNLOAD TASK";
    self.view.backgroundColor = [UIColor whiteColor];
    
    SBTableView *sbTblView = [[SBTableView alloc] initWithFrame:self.view.bounds];
    sbTblView.delegate = self;
    [sbTblView setFileArrayValue:@[
                                   @"http://www.siop.org/conferences/09con/17Leadership.mp3"
                                   ]
              sbDownloadFileType:SBDownloadFileTypeAudio];
    
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
