import { GridAttr, GridView,
  LoadMoreLayoutStatusModel,
  RefreshController, RefreshDataSource, RefreshLayoutStatusModel } from '@abner/refresh'
import { it } from '@ohos/hypium'
import { SIZE } from '@ohos/hypium/src/main/Constant'
import { SpecList, SpecListController } from '../base/SpecList'
import { VideoGridItem } from '../component/VideoGridItem'
import { ToastUtil } from '@pura/harmony-utils'
import { PageRouterUtils } from '../router/PageRouterUtils'
import ToastCustomUtil from '../utils/ToastCustomUtil'
import { PageResult } from '../router/PageRouter'

@Component
export struct HomePage {

  @State text: string =''
  @State isShowClearIcon: boolean = false

  @State
  typeList: string[] = ['直播','推荐','热门']

  scroller = new Scroller()

  @StorageProp('topHeight')
  topHeight: number = 0
  @State
  opacityValue: number = 0
  @State
  areaHeight: number = 0

  controller = new SpecListController()
  @State
  list: Array<string> = []

  //刷新控制器
  refreshController: RefreshController = new RefreshController()
  array: Array<number> = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  array2: Array<number> = [12, 13, 14, 15, 16, 17, 18, 19, 20, 21]
  lazyDataSource: RefreshDataSource = new RefreshDataSource()

  /**
   * Author:AbnerMing
   * Describe:自定义刷新头
   */
  @Builder
  headerRefreshLayout(model: RefreshLayoutStatusModel) {
    Text("当前状态：" + model.status)
      .width("100%")
      .textAlign(TextAlign.Center)
      .height(80)
      .backgroundColor(Color.Pink)
  }

  /**
   * Author:AbnerMing
   * Describe:自定义加载尾部
   */
  @Builder
  footerLoadLayout(model: LoadMoreLayoutStatusModel) {
    Text("当前状态：" + model.status)
      .width("100%")
      .textAlign(TextAlign.Center)
      .height(80)
      .backgroundColor(Color.Pink)
  }

  aboutToAppear(): void {
    for(let index = 0; index<10; index++){
      this.list.push(index.toString())
    }
    this.lazyDataSource.pushDataArray(this.array)
  }

  scrollStatusBar(y: number) {
    if (y < this.areaHeight) {
      this.opacityValue = y / this.areaHeight
    } else {
      this.opacityValue = 1
    }
  }

  onLoad() {
  }

  onRefresh() {
  }

  reLoad() {
  }

  build() {

    Stack({ alignContent: Alignment.Top }) {
      Row()
        .height(this.topHeight)
        .width('100%')
        .backgroundColor(Color.White)
        .opacity(this.opacityValue)
        .zIndex(1)

      Scroll(this.scroller) {
        Column() {
          Column() {
            Row() {
              Image($r('app.media.startIcon'))
                .size({ width: 25, height: 25 })
                .margin({left:10})
              Row() {
                Image($r('app.media.icon_search_small'))
                  .width(20)
                  .height(20)
                  .margin({left:10})
                  .onClick(() => {
                    console.log('icon_search_small.url:')
                  })

                TextInput({
                  placeholder: '地下城与与勇士手游',
                })
                  .borderRadius(0)
                  .layoutWeight(1)
                  .backgroundColor(Color.Transparent)
                  .margin({ right: 5 })
                  .fontWeight(FontWeight.Normal)
                  .fontSize(12)
                  .placeholderColor(Color.Black)
                  .placeholderFont({ size: 12, weight: FontWeight.Normal })
                  .type(InputType.Normal)
                  .onChange((value: string) => {
                    this.text = value
                    this.isShowClearIcon = value.length > 0
                  })
                  .onSubmit((EnterKeyType) => {
                    console.info(EnterKeyType + '输入法回车键的类型值')
                  })
              }
              .border({ width: 1 })
              .borderRadius(30)
              .backgroundColor('#99FFFFFF')
              .margin({top:2, bottom:2, left:20, right:20})
              .layoutWeight(1)
              .height(30)

              Image($r('app.media.startIcon'))
                .width(25)
                .height('auto')
                .margin({right:10})
                .visibility(Visibility.Visible)
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.SpaceBetween)
          }.onAreaChange((_o, n) => {
            this.areaHeight = n.height as number
          })

          // 加了Stack才有吸顶效果
          Stack(){
            // 指示器
            Tabs({ barPosition: BarPosition.Start }) {
              ForEach(this.typeList,
                (item: string, index: number) => {
                  TabContent() {
                    Column() {
                      // 懒加载样式
                      GridView({
                        lazyDataSource: this.lazyDataSource,
                        itemLayout: this.itemLayout,
                        controller: this.refreshController,
                        lazyCachedCount: 10,
                        gridAttribute: (g) => {
                          g.rowsGap = 10 //设置行间距
                          g.columnsGap = 10
                        },
                        headerRefreshLayout: this.headerRefreshLayout,
                        footerLoadLayout: this.footerLoadLayout,
                        onRefresh: () => {
                          setTimeout(() => {
                            this.lazyDataSource.deleteAll(() => {
                              this.lazyDataSource.pushDataArray([500, 501, 502, 503, 504, 505])
                            })
                            this.refreshController.finishRefresh()
                          }, 1000)
                        },
                        onLoadMore: () => {
                          setTimeout(() => {
                            this.lazyDataSource.pushDataArray(this.array2)
                            this.refreshController.finishLoadMore()
                          }, 1000)
                        }
                      }).margin({top:10, left: 5, right: 5})

                      //  普通样式
                      // GridView({
                      //   items: this.list,
                      //   enableRefresh: true,
                      //   enableLoadMore: true,
                      //   gridAttribute: (attr) => {
                      //     attr.rowsGap = 5;
                      //     attr.columnsGap = 5;},
                      //   itemLayout: (item, index) => this.itemLayout(item, index),
                      //   controller: this.refreshController, //控制器，负责关闭下拉和上拉
                      //   isLazyData: false,//禁止懒加载，使用ForEach进行数据加载
                      //   onRefresh: () => {
                      //     //下拉刷新
                      //     this.refreshController.finishRefresh();
                      //     ToastUtil.showToast("下拉刷新")
                      //   },
                      //   onLoadMore: () => {
                      //     //上拉加载
                      //     this.refreshController.finishLoadMore();
                      //     ToastUtil.showToast("上拉加载")
                      //   }
                      // }).margin({left: 5, right: 5})

                      // 下拉刷新列表
                      // SpecList({
                      //   controller: this.controller,
                      //   onLoad: () => {
                      //     this.onLoad()
                      //   },
                      //   onRefresh: () => {
                      //     this.onRefresh()
                      //   }
                      // }) {
                      //   ForEach(this.list, (item: string) => {
                      //     ListItem() {
                      //       Column(){
                      //         VideoGridItem({videoBean:item})
                      //       }
                      //     }
                      //   })
                      // }
                    }
                    .backgroundColor($r('app.color.common_bg'))
                  }.tabBar(this.TabItemBuilder(item, index))
                })
            }
            //.divider({ strokeWidth: 1, color: $r('app.color.common_gray_border') })
            .barMode(BarMode.Scrollable)
            .barHeight(44)
            .barBackgroundColor(Color.White)
            .onTabBarClick(i => {
              this.homeTabIndex = i
            })
            .onChange((index: number) => {
              this.homeTabIndex = index
            })
            .layoutWeight(1)
            .scrollable(true)
          }

        }.padding({ top: this.topHeight })

      }.width('100%')
      .scrollBar(BarState.Off)
      .onScroll(() => {
        this.scrollStatusBar(this.scroller.currentOffset().yOffset)
      })
    }

  }


  @Builder
  itemLayout(item: Object, index: number): void {
      VideoGridItem({videoBean:item as string}).onClick(()=>{
        PageRouterUtils.getInstance().goToPlayDetail("123", (popInfo) => {
          const result = popInfo.result as PageResult
          ToastCustomUtil.showToast("回调数据:"+result.map.get("result_message"))
        })
      })
  }

  @State homeTabIndex: number = 0

  @Builder
  TabItemBuilder(name: string, index: number) {
    Row() {
      Stack({ alignContent: Alignment.Bottom }) {
        Text(name)
          .fontSize(15)
          .height(43)
          .fontColor(this.homeTabIndex === index ? Color.Black :Color.Gray)
        Text()
          .width(this.homeTabIndex === index ? 20 : 0)
          .height(2)
          .backgroundColor(Color.Black)
          .animation({ duration: this.homeTabIndex === index ? 300 : 0 })
      }
      .padding({ left: 2 })
      // Image($r("app.media.icon_search_small"))
      //   .width(32)
      //   .height(14)
      //   .objectFit(ImageFit.Contain)
      //   .margin({ left: 4 })
    }
    .padding({ right:  2})
  }
}

