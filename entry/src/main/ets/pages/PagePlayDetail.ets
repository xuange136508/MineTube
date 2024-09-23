import { SystemCommonVideo } from '../common/player/system/SystemCommonVideo';
import { VideoParams, VideosBean } from '../common/player/system/VideoParams';
import { PageParam } from '../router/PageRouter';
import ToastCustomUtil from '../utils/ToastCustomUtil';


//routerMap路由表修饰的需要加
@Builder
export function PageBuilder() {
  PagePlayDetail();
}

@Entry
@Component
export struct PagePlayDetail {

  pageInfo: NavPathStack = AppStorage.get("pageInfo") as NavPathStack;

  private videoParams?: VideoParams

  aboutToAppear(): void {
    this.videoParams = new VideoParams([new VideosBean(
      'https://pt-images.cdnmama.com/pregnancy/persistent_5/admin/subjectcontent/158763785375.mp4',
      // 'https://vimg.cdnmama.com/lp/2024/09/20/21073bc19de04eed8d2dc52749f66276.mp4',
      1280,
      720,
      11,
      'https://vimg.cdnmama.com/lp/2024/09/20/46eeb57e6fb54eef963a03419351de08.jpg?imageView2/3/w/750'
    )])
  }

  build() {
    NavDestination() {
      Column() {
        // Text("测试页面").onClick(()=>{
        //   let map: Map<string, Object> = new Map()
        //   map.set('result_message', "result_message")
        //   let pageResult = new PageResult(map)
        //   this.pageInfo.pop(pageResult);
        // })

        //IJK视频播放器(demo代码)
        //IjkVideoPlayerPage()

        //IJK视频播放器(组件版)
        //VideoNewsView()

        //系统播放器
        SystemCommonVideo({videoParams: this.videoParams})

      }.width('100%').height('100%')
    }
    .hideTitleBar(true)
    .onAppear(() => {

    })
    .onReady(async (ctx: NavDestinationContext) => {
      const param = ctx?.pathInfo?.param as PageParam;
      const playId = param.map.get('play_id') as string;
      ToastCustomUtil.showToast("播放ID:"+playId)
    })
    .onShown(() => {
    })
    .onHidden(() => {
    })
    .onDisAppear(() => {
    })
    .onBackPressed(() => {
      this.pageInfo.pop()
      return true
    })
  }

}