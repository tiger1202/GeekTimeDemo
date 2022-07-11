//
//  GTVideoCoverView.m
//  Demo
//
//  Created by tiger on 2022/6/29.
//

#import "GTVideoCoverView.h"
#import <AVFoundation/AVFoundation.h>

@interface GTVideoCoverView ()

@property (nonatomic, strong, readwrite) UIImageView *coverImageView;
@property (nonatomic, strong, readwrite) UIImageView *playButtonImageView;
@property (nonatomic, copy, readwrite) NSString* videoURLString;

@property (nonatomic, strong, readwrite) AVPlayerItem *playerItem;
@property (nonatomic, strong, readwrite) AVPlayer *avPlayer;
@property (nonatomic, strong, readwrite) AVPlayerLayer *playerLayer;

@end

@implementation GTVideoCoverView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.coverImageView];
        [self.coverImageView addSubview:self.playButtonImageView];
        [self.coverImageView addSubview:self.playButtonImageView];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToPlay)];
        [self addGestureRecognizer:recognizer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePlayEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.coverImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.playButtonImageView.frame = CGRectMake((self.frame.size.width - 50) / 2, (self.frame.size.height - 50) / 2, 50, 50);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];  // defaultCenter是存在于整个app生命周期的，注意在当前类销毁时移除注册
    [self removeObserver:self forKeyPath:@"status"];  // KVO监听也需要在dealloc时移除
    [self removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

#pragma mark - 公有方法
- (void)layoutWithVideoCoverURL:(NSString *)coverURL videoURLString:(NSString *)videoURLString {
    self.playButtonImageView.image = [UIImage imageNamed:@"resource/playButton.png"];
    self.coverImageView.image = [UIImage imageNamed:coverURL];
    self.videoURLString = videoURLString;
}

#pragma mark - 私有方法
- (void)tapToPlay {
    AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:self.videoURLString]];
    
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    CMTime duration = self.playerItem.duration;
    CGFloat videoDuration = CMTimeGetSeconds(duration);  // 此时获取不到时间，因为资源还没有从网络中下载好
    
    self.avPlayer = [AVPlayer playerWithPlayerItem:self.playerItem];
    [self.avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        NSLog(@"当前播放时间: %f", CMTimeGetSeconds(time));
    }];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    self.playerLayer.frame = self.bounds;
    
    [self.layer addSublayer:self.playerLayer];
    
    [self.avPlayer play];
}

- (void)handlePlayEnd {
//    [self.playerLayer removeFromSuperlayer];
//    self.playerItem = nil;
//    self.avPlayer = nil;
    
    [self.avPlayer seekToTime:CMTimeMake(0, 1)]; // 播放完毕后seek回初识节点
    [self.avPlayer play];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        if (((NSNumber *)[change objectForKey:NSKeyValueChangeNewKey]).integerValue == AVPlayerItemStatusReadyToPlay) {
            [self.avPlayer play];
        } else {
            // 将播放错误的原因打日志
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSLog(@"缓冲: %@", [change objectForKey:NSKeyValueChangeNewKey]);
    }
}

#pragma mark - lazyInit
- (UIImageView *)coverImageView {
    if (_coverImageView == nil) {
        _coverImageView = [UIImageView new];
    }
    return _coverImageView;
}

- (UIImageView *)playButtonImageView {
    if (_playButtonImageView == nil) {
        _playButtonImageView = [UIImageView new];
    }
    return _playButtonImageView;
}

@end
