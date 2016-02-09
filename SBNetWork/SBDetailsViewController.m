
#import "SBDetailsViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVAsset.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface SBDetailsViewController () {
    UIWebView *webView;
    AVAudioPlayer *audioPlayer;
    
}

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@end



@implementation SBDetailsViewController
@synthesize  moviePlayer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"SB DOWNLOAD TASK";
    self.view.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark - Show Video, Audio and PDF - Downloaded Content
-(void)showSBDetailFileType:(SBDownloadFileType)fileType filePath:(NSString *)filePath {
    
    switch (fileType) {
        case SBDownloadFileTypeVideo:
            
            [self playVideoFromPath:[NSURL fileURLWithPath:filePath]];
            
            break;
            
        case SBDownloadFileTypeAudio:
            
            [self playAudioFromPath:[NSURL fileURLWithPath:filePath]];
            
            break;
            
        case SBDownloadFileTypePDF:
            
            [self showPDFInWebView:[NSURL fileURLWithPath:filePath]];
            
            break;
            
            
        default:
            break;
    }
}

#pragma mark - Play Video
-(void)playVideoFromPath:(NSURL *)videoUrl {
    
    moviePlayer =  [[MPMoviePlayerController alloc]
                    initWithContentURL:videoUrl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerWillExitFullscreenNotification
                                               object:moviePlayer];
    
    
    [moviePlayer.view setFrame:self.view.bounds];
    moviePlayer.controlStyle = MPMovieControlStyleDefault;
    moviePlayer.shouldAutoplay = YES;
    [self.view addSubview:moviePlayer.view];
    [moviePlayer setFullscreen:YES animated:YES];
    [moviePlayer play];
    
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    
    
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerWillExitFullscreenNotification
     object:player];
    
    [moviePlayer stop];
    [moviePlayer.view removeFromSuperview];
    
    int reason = [[[notification userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    if (reason == MPMovieFinishReasonPlaybackError) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Live feed is not available at this moment." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        //error
    }
    
}

#pragma mark - Play Audio
-(void)playAudioFromPath:(NSURL *)url {
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [audioPlayer prepareToPlay];
    if (audioPlayer.isPlaying) [audioPlayer setCurrentTime:0.0];
    [audioPlayer play];
    
    
}

#pragma mark - Load PDF File
-(void)showPDFInWebView:(NSURL *)url {
    
    webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView setOpaque:NO];
    [webView setBackgroundColor:[UIColor clearColor]];
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView setUserInteractionEnabled:YES];
    [webView loadRequest:requestObj];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (moviePlayer) {
        
        [moviePlayer stop];
        [moviePlayer.view removeFromSuperview];
        moviePlayer= nil;
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
