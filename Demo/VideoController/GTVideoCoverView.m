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
        [self addSubview:({
            self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            self.coverImageView;
        })];
        
        [self.coverImageView addSubview:({
            self.playButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 50) / 2, (self.frame.size.height - 50) / 2, 50, 50)];
            self.playButtonImageView;
        })];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapToPlay)];
        [self addGestureRecognizer:recognizer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handlePlayEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self]; // defaultCenter是存在于整个app生命周期的，注意在当前类销毁时移除注册
    [self removeObserver:self forKeyPath:@"status"]; // KVO监听也需要在dealloc时移除
    [self removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

#pragma mark - 公有方法
- (void)layoutWithVideoCoverURL:(NSString *)coverURL videoURLString:(NSString *)videoURLString {
    self.playButtonImageView.image = [UIImage imageNamed:@"resource/playButton.png"];
    self.coverImageView.image = [UIImage imageNamed:coverURL];
    self.videoURLString = videoURLString;
}

#pragma mark - 私有方法
- (void)_tapToPlay {
    AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:self.videoURLString]];
    
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    self.avPlayer = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    self.playerLayer.frame = self.bounds;
    
    [self.layer addSublayer:self.playerLayer];
    
    [self.avPlayer play];
}

- (void)_handlePlayEnd {
    [self.playerLayer removeFromSuperlayer];
    self.playerItem = nil;
    self.avPlayer = nil;
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
        
    }
}

@end
