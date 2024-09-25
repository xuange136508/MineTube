import { HomePage } from './HomePage';
import { router } from '@kit.ArkUI';
import { OhosSmartDialog, SmartAttachAlignmentType, SmartDialog } from 'ohos_smart_dialog';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  @State currentIndex: number = 0
  private controller: TabsController = new TabsController()

  @Builder tabBuilder(title: string, targetIndex: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 25, height: 25 })
        .margin(5)
      Text(title)
        .fontSize(13)
        .fontColor(this.currentIndex === targetIndex ? '#1698CE' : '#6B6B6B')
        .margin(3)
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Stack() {
      Navigation(OhosSmartDialog.registerRouter(this.pageInfo)) {
        Column() {
          Tabs({ barPosition: BarPosition.End }) {
            TabContent() {
              Column() {
                HomePage()
              }
              .width('100%')
              .height('100%')
              .backgroundColor('#FFFFFF')
            }
            .tabBar(this.tabBuilder('首页', 0, $r('app.media.app_icon'), $r('app.media.app_icon')))

            TabContent() {
              Column() {
                Text('2')
              }
              .width('100%')
              .height('100%')
              .backgroundColor('#FFFFFF')
            }
            .tabBar(this.tabBuilder('动态', 1, $r('app.media.app_icon'), $r('app.media.app_icon')))

            TabContent() {
              Column() {
                Text('3')
              }
              .width('100%')
              .height('100%')
              .backgroundColor('#000000')
            }
            .tabBar(this.tabBuilder('我的', 2, $r('app.media.app_icon'), $r('app.media.app_icon')))
          }
          .scrollable(false)
          .animationDuration(0)
          .backgroundColor('#F1F3F5')
          .onChange((index: number) => {
            this.currentIndex = index
          })
        }.width('100%')
      }
      .hideTitleBar(true)

      // 添加侵入式全局自定义弹窗
      OhosSmartDialog({
        loadingBuilder: customLoading
      })
    }.height('100%').width('100%')
  }


  aboutToDisappear(): void {
  }
  pageInfo: NavPathStack = new NavPathStack()

  // 组件生命周期
  aboutToAppear() {
    router.clear();
    AppStorage.setOrCreate("pageInfo", this.pageInfo)

    this.pageInfo.setInterception({
      // 页面路由拦截器
      willShow: (from: NavDestinationContext | "navBar", to: NavDestinationContext | "navBar",
        operation: NavigationOperation, animated: boolean) => {
        // 离开首页
        if (typeof from === "string") {
          return;
        }
        // 进入首页
        if (typeof to === "string") {
          return;
        }
      }
    })

    // 自定义全局弹窗样式
    SmartDialog.config.custom.maskColor = "#75000000"
    SmartDialog.config.custom.alignment = Alignment.Center
    // showAttach
    SmartDialog.config.attach.attachAlignmentType = SmartAttachAlignmentType.center
  }
}

@Builder
export function customLoading(args: ESObject) {
  Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }){
    LoadingProgress().width(80).height(80).color(Color.White)
  }
  .height(100)
  .width(100)
  .backgroundColor($r('app.color.black'))
}