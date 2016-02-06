
#import "SBVideoDownloadTaskViewController.h"
#import "SBTableView.h"
#import "SBDetailsViewController.h"


@interface SBVideoDownloadTaskViewController () <SBDetailDelegate>
@end

@implementation SBVideoDownloadTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.title = @"SBVIDEO DOWNLOAD TASK";
    self.view.backgroundColor = [UIColor whiteColor];
    
    SBTableView *sbTblView = [[SBTableView alloc] initWithFrame:self.view.bounds];
    sbTblView.delegate = self;
    
    [sbTblView setFileArrayValue:@[
                                   @"http://techslides.com/demos/sample-videos/small.mp4",
                                   @"http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4"
                                   ]
              sbDownloadFileType:SBDownloadFileTypeVideo];
    
    [self.view addSubview:sbTblView];
    
    // @"http://techslides.com/demos/sample-videos/small.mp4"
    // @"http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4"
    // @"http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_10mb.mp4"
    // @"http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_5mb.mp4"
    // @"http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_2mb.mp4"
    
    
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
