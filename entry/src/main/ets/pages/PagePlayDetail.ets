import { PageParam } from '../router/PageRouter';

@Entry
@Component
export struct PagePlayDetail {

  pageInfo: NavPathStack = AppStorage.get("pageInfo") as NavPathStack;


  build() {
    NavDestination() {
      Column() {
        Text("测试页面")
      }.width('100%').height('100%')
    }
    .hideTitleBar(true)
    .onAppear(() => {

    })
    .onReady(async (ctx: NavDestinationContext) => {
      const param = ctx?.pathInfo?.param as PageParam;
      const playId = param.map.get('play_id') as string;
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