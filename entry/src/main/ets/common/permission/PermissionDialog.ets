import { TaoYao } from '@shijing/taoyao/Index'
import { common, Permissions } from '@kit.AbilityKit'
import { hilog } from '@kit.PerformanceAnalysisKit'

/**
 * 跳转系统设置之前，需要先弹窗
 */
@CustomDialog
export struct PermissionDialog {

  private title: string = '权限设置'
  private subtitle?: Resource | string
  private left: string = '取消'
  private right: string = '去设置'
  private permissions = new Array<Permissions>()
  private message = ''
  private context = getContext(this) as common.UIAbilityContext
  controller: CustomDialogController

  aboutToAppear(): void {
    if (this.permissions.indexOf(('ohos.permission.ACCESS_BLUETOOTH' as Permissions)) >= 0) {
      this.subtitle = $r('app.string.access_bluetooth')
    } else if (this.permissions.indexOf(('ohos.permission.MEDIA_LOCATION' as Permissions)) >= 0) {
      this.subtitle = $r('app.string.media_location')
    } else if (this.permissions.indexOf(('ohos.permission.APP_TRACKING_CONSENT' as Permissions)) >= 0) {
      this.subtitle = $r('app.string.app_tracking_consent')
    } else if (this.permissions.indexOf(('ohos.permission.ACTIVITY_MOTION' as Permissions)) >= 0) {
      this.subtitle = $r('app.string.activity_motion')
    } else if (this.permissions.indexOf(('ohos.permission.CAMERA' as Permissions)) >= 0) {
      this.subtitle = $r('app.string.camera')
    } else if (this.permissions.indexOf(('ohos.permission.DISTRIBUTED_DATASYNC' as Permissions)) >= 0) {
      this.subtitle = $r('app.string.distributed_datasync')
    } else if (this.permissions.indexOf(('ohos.permission.LOCATION_IN_BACKGROUND' as Permissions)) >= 0) {
      this.subtitle = $r('app.string.location_in_background')
    } else if (this.permissions.indexOf(('ohos.permission.LOCATION' as Permissions)) >= 0) {
      this.subtitle = $r('app.string.location')
    } else if (this.permissions.indexOf(('ohos.permission.APPROXIMATELY_LOCATION' as Permissions)) >= 0) {
      this.subtitle = $r('app.string.approximately_location')
    } else if (this.permissions.indexOf(('ohos.permission.MICROPHONE' as Permissions)) >= 0) {
      this.subtitle = $r('app.string.microphone')
    } else if (this.permissions.indexOf(('ohos.permission.READ_CALENDAR' as Permissions)) >= 0) {
      this.subtitle = $r('app.string.read_calendar')
    } else if (this.permissions.indexOf(('ohos.permission.WRITE_CALENDAR' as Permissions)) >= 0) {
      this.subtitle = $r('app.string.write_calendar')
    } else if (this.permissions.indexOf(('ohos.permission.READ_HEALTH_DATA' as Permissions)) >= 0) {
      this.subtitle = $r('app.string.read_health_data')
    } else if (this.permissions.indexOf(('ohos.permission.READ_MEDIA' as Permissions)) >= 0) {
      this.subtitle = $r('app.string.read_media')
    } else if (this.permissions.indexOf(('ohos.permission.WRITE_MEDIA' as Permissions)) >= 0) {
      this.subtitle = $r('app.string.write_media')
    } else {
      this.subtitle = this.message
    }
  }

  build() {
    Column() {
      Text(this.title)
        .fontSize(20)
        .fontColor('#151724')
      Text(this.subtitle)
        .fontColor('#151724')
        .fontSize(15)
        .margin({top: 30})
      Row() {
        Button(this.left)
          .fontColor('#585a5c')
          .borderRadius(24)
          .backgroundColor('#eeeeee')
          .width('40%')
          .height(48)
          .margin({right: 20})
          .onClick(() => {
            this.controller.close()
          })
        Button(this.right)
          .fontColor('#ffffff')
          .borderRadius(24)
          .backgroundColor('#4b54fa')
          .width('40%')
          .height(48)
          .onClick(() => {
            this.controller.close()
            TaoYao.goToSettingPage(this.context)
          })
      }
      .margin({top: 30})
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .borderRadius(20)
    .backgroundColor('#ffffff')
    .padding({left: 24, right: 24, top: 30, bottom: 28})
  }
}