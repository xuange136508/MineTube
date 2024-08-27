import { SIZE } from '@ohos/hypium/src/main/Constant'
import { SpecList, SpecListController } from '../base/SpecList'

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

  aboutToAppear(): void {
    for(let index = 0; index<30; index++){
      this.list.push(index.toString())
    }
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
              Row() {
                Image($r('app.media.icon_search_small')).width(20).height(20).margin({ left: 10, right: 2 })
                  .onClick(() => {
                    console.log('icon_search_small.url:')
                  })

                TextInput({
                  placeholder: '地下城与与勇士手游',
                })
                  .backgroundColor(Color.Transparent)
                  .margin({ right: 5 })
                  .fontWeight(FontWeight.Normal)
                  .fontSize(10)
                  .placeholderColor(Color.Black)
                  .placeholderFont({ size: 10, weight: FontWeight.Normal })
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
              .margin({top:2, bottom:2})
              .width('70%')
              .height(30)

              Image($r('app.media.startIcon'))
                .size({ width: 25, height: 25 })
            }
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
                      // 下拉刷新列表
                      SpecList({
                        controller: this.controller,
                        onLoad: () => {
                          this.onLoad()
                        },
                        onRefresh: () => {
                          this.onRefresh()
                        }
                      }) {
                        ForEach(this.list, (item: string) => {
                          ListItem() {
                            Column(){
                              Text(item)
                            }.height(50)
                          }
                        })
                      }
                    }
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

