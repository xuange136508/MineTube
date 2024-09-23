
import { VideoStatus } from '../VideoStatus'
import { VideosBean } from './VideoParams'
import { VideoParams } from './VideoParams'

//官方播放器
//https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/ts-media-components-video-V5#%E7%A4%BA%E4%BE%8B1
@Component
export struct SystemCommonVideo {
  @Prop videoParams: VideoParams
  video?: VideosBean
  controller: VideoController = new VideoController();
  curRate: PlaybackSpeed = PlaybackSpeed.Speed_Forward_1_00_X
  @State currentTime: number = 0;
  @State durationTime: number = 0;
  lpHeight: number = 0
  /**
   * 是否在播放
   */
  @State isPlay: number = VideoStatus.PREPARED;
  ratio: number = 0

  aboutToAppear(): void {
    this.video = this.videoParams?.videos[0]
    let videoHeight = this.video.height ?? 0
    let videoWidth = this.video.width ?? 0

    console.log('video:' + this.video.width);
    console.log('video:' + this.video.height);
    console.log('video:' + this.video.url);
    console.log('video:' + this.video.duration);
    console.log('video:' + this.video.cover);

    if (videoHeight != 0 && videoWidth != 0) {
      this.ratio = videoWidth / videoHeight
    } else {
      this.ratio = 4 / 3
    }
  }

  build() {
    Column() {
      this.VideoView()
    }
    .alignItems(HorizontalAlign.Start)
    .padding({
      left: 12,
      right: 12
    })
    .backgroundColor(Color.White)

  }

  @Builder
  VideoView() {
    Column() {
      Video({
        src: this.video?.url,
        previewUri: this.video?.cover,
        currentProgressRate: this.curRate,
        controller: this.controller
      })
        .muted(false)
        .width('100%')
        .aspectRatio(this.ratio)// .height(this.lpHeight)
        .borderRadius(3)
        .controls(false)
        .autoPlay(true)
        .objectFit(ImageFit.Contain)
        .loop(true)
        .zIndex(1)

        .onStart(() => {
          console.info('onStart')
        })
        .onStart(() => {
          if (this.isPlay != VideoStatus.PLAY) {
            this.isPlay = VideoStatus.PLAY
          }
        })
        .onPause(() => {
          if (this.isPlay === VideoStatus.PLAY) {
            this.isPlay = VideoStatus.PAUSE;
          }
        })
        .onFinish(() => {
          console.info('onFinish')
        })
        .onError(() => {
        })
        .onPrepared((event) => {
          if (event) {
            this.durationTime = event.duration
          }
        })
        .onUpdate((event) => {
          if (event) {
            this.currentTime = event.time
          }
        })

      Slider({
        value: this.currentTime,
        min: 0,
        max: (this.durationTime),
        style: SliderStyle.NONE
      })
        .height(1)
        .sliderInteractionMode(SliderInteraction.SLIDE_ONLY)
        .selectedColor($r('app.color.black'))
        .blockColor($r('app.color.white'))

    }.padding({ top: 12 }).onVisibleAreaChange([0.0, 0.5], (isVisible: boolean, currentRatio: number) => {
      if (isVisible && currentRatio >= 0.5) {
        this.startOrStop();
      }

      if (!isVisible && currentRatio <= 0.0) {
        this.startOrStop();
      }
    })

  }

  private startOrStop() {
    if (this.isPlay != VideoStatus.PLAY) {
      this.controller.start();
    } else {
      this.controller.pause();
    }
  }
}