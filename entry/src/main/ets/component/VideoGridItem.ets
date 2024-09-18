import { BorderRadiuses } from '@ohos.arkui.node'

@Component
export struct VideoGridItem {
  @State
  videoBean: string = ""

  build() {
    Column(){
      Image('https://p3.toutiaoimg.com/tos-cn-i-qvj2lq49k0/c4e6881ba59e4d61916faca062d8de6c~noop.image')
        .width('100%')
        .height(150)
        .objectFit(ImageFit.Cover)
        .borderRadius({topLeft:10,topRight:10,bottomLeft:0,bottomRight:0 })
      Text("年轻就是好到头就睡啦，给公安局长寄子弹, 这首歌先给你，你的炸弹")
        .textAlign(TextAlign.Center)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(2)
        .fontSize(16)
        .margin(5)
        .width('100%')
        //.constraintSize({ maxWidth: 200 }) //限制最大宽度
      // Row({space:10}){
      //   Text("热")
      //     .margin({ left: 6 })
      //     .textAlign(TextAlign.Center)
      //     .fontSize(10)
      //     .fontColor(Color.White)
      //     .fontWeight(600)
      //     .backgroundColor(0xCC5500)
      //     .borderRadius(5)
      //     .width(15)
      //     .height(14)
      //   Text("小番茄")
      //     .textAlign(TextAlign.Center)
      //     .textOverflow({ overflow: TextOverflow.Ellipsis })
      //     .maxLines(1)
      //     .fontSize(10)
      //   Image($r('app.media.app_icon'))
      //     .width(15)
      //     .height(15)
      // }
      // .margin({bottom:10})
      // .alignItems(VerticalAlign.Center)
      // .justifyContent(FlexAlign.Center)

      RelativeContainer() {
        Text("热")
          .margin({ left: 6 })
          .textAlign(TextAlign.Center)
          .fontSize(10)
          .fontColor(Color.White)
          .fontWeight(600)
          .backgroundColor(0xCC5500)
          .borderRadius(5)
          .width(15)
          .height(14)
          .alignRules({
            'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
            'left': { 'anchor': '__container__', 'align': HorizontalAlign.Start }
          }).id("row1")
        Text("小番茄1号，小番茄2号，小番茄3号，小番茄4号")
          .textAlign(TextAlign.Center)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .fontSize(10)
          .alignRules({
            'top': { 'anchor': 'row1', 'align': VerticalAlign.Top },
            'bottom': { 'anchor': 'row1', 'align': VerticalAlign.Bottom },
            'left': { 'anchor': 'row1', 'align': HorizontalAlign.End },
            'right': { 'anchor': 'row2', 'align': HorizontalAlign.Start }
          }).margin({left:5,right:5})
        Image($r('app.media.app_icon'))
          .width(15)
          .height(15)
          .alignRules({
            'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
            'right': { 'anchor': '__container__', 'align': HorizontalAlign.End }
          }).id("row2")
      }
      .margin({left:5,right:5,bottom:10})
      .height(20)
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(10)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}