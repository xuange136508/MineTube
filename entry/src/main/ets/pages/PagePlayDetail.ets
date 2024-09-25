import { decode, Decoder, encode, Encoder } from '@ohos/msgpack';
import { JSONUtil } from '@pura/harmony-utils';
import { SpinKitHelper } from '@pura/spinkit';
import { CameraBuilder, CameraSelector, MediaBuilder, MediaMimeType, TaoYao, UseCase } from '@shijing/taoyao';
import { SmartAllDialogType, SmartDialog } from 'ohos_smart_dialog';
import { ImageComponent } from '../common/imageknife/ImageComponent';
import { SystemCommonVideo } from '../common/player/system/SystemCommonVideo';
import { VideoParams, VideosBean } from '../common/player/system/VideoParams';
import { PageParam } from '../router/PageRouter';
import ToastCustomUtil from '../utils/ToastCustomUtil';
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { GeneralChecker } from '@shijing/taoyao/src/main/ets/shijing/taoyao/checker/GeneralChecker';
import { BusinessError } from '@kit.BasicServicesKit';
import { PermissionDialog } from '../common/permission/PermissionDialog';


//routerMap路由表修饰的需要加
@Builder
export function PageBuilder() {
  PagePlayDetail();
}

@Entry
@Component
export struct PagePlayDetail {

  private context = getContext(this) as common.UIAbilityContext

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


    // MessagePack 是一个提供高效对象序列化的库。它与 JSON 类似，但提供更高的效率和更小的数据量。
    // MessagePack 3.0 可用于实现复杂的 int64 编码。
    // https://ohpm.openharmony.cn/#/cn/detail/@ohos%2Fmsgpack
    // Json编码
    let encoder = new Encoder()
    let encoded: Uint8Array = encoder.encode(this.videoParams);
    // Json解码
    let decoder = new Decoder()
    let decodedObject = decoder.decode(encoded) as VideoParams;

    let reportBean = JSONUtil.beanToJsonStr(decodedObject);
    console.info(reportBean);
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
        //SystemCommonVideo({videoParams: this.videoParams})

        //图片加载
        //https://ohpm.openharmony.cn/#/cn/detail/@ohos%2Fimageknife
        ImageComponent({ loadSrc: img, objectFIt: ImageFit.Cover }).width(46).height(46).margin({top:100})
          .onClick(()=>{
            // 【加载loading】
            //SpinKit 是一个适用于OpenHarmony/HarmonyOS的加载动画库。
            //SpinKitHelper.showLoading()
            //隐藏加载框
            //SpinKitHelper.hide();

            //【自定义弹窗】
            // (1) https://ohpm.openharmony.cn/#/cn/detail/ohos_smart_dialog
            // (2) https://ohpm.openharmony.cn/#/cn/detail/@abner%2Fdialog
            // (3) https://ohpm.openharmony.cn/#/cn/detail/@pura%2Fharmony-dialog
            // 检查当前是否有AttachDialog处于打开状态
            //let isExist = SmartDialog.checkExist({ dialogTypes: [SmartAllDialogType.attach] })
            //SmartDialog.showLoading()
            //customLocation()
            //普通通用自定义弹窗
            // SmartDialog.show({
            //   builder: attachDialog
            // })

            //【权限申请】
            //https://ohpm.openharmony.cn/#/cn/detail/@shijing%2Ftaoyao
            //图片、视频选择器，拉起系统图库不需要申请存储权限，只能获取选中的图片、视频
            // TaoYao.with(this.context)
            //   .media()
            //   .onSuccess((uris) => {
            //     uris.forEach((uri) => {
            //       console.log("permission", uri)
            //     })
            //   })
            //   .onError((err) => {
            //     console.log(err.stack)
            //   })
            //   .select(new MediaBuilder()
            //     // 选择媒体文件的最大数目
            //     .setMaxSelectNumber(10)
            //       // 可选择的媒体文件类型，图片类型、视频类型、图片和视频类型、动态照片类型
            //     .setMediaMineType(MediaMimeType.IMAGE_VIDEO_TYPE)
            //   )
            const name = "ohos.permission.CAMERA" as Permissions
            const permissions: Array<Permissions> = [name]
            TaoYao.with(this.context)
              .runtime()
              .permission(permissions)
              .onGranted(permissions => {
                // 权限申请成功
                ToastCustomUtil.showToast("无权限")
              })
              .onDenied(permissions => {
                /*
                 * 1、由于安全隐私要求，应用不能通过系统弹窗的形式被授予后台位置权限，应用如果需要使用后台位置权限，会先申请模糊位置权限和精确位置权限，
                 * 然后弹窗提示用户到系统设置中打开相应的权限，用户在设置界面中的选择“始终允许”应用访问位置信息权限，应用就获取了后台位置权限。
                 * 2、权限申请失败，当用户拒绝授权时，将无法再次拉起系统的权限弹窗，此时只能弹窗提示用户到系统设置中打开相应的权限
                 */
                this.showPermissionDialog(permissions)
              })
                // 开始申请权限
              .request()
            // 官方申请权限
            // let atManager = abilityAccessCtrl.createAtManager();
            // try {
            //   let context: Context = getContext(this) as common.UIAbilityContext;
            //   atManager.requestPermissionsFromUser(context, ["ohos.permission.CAMERA"]).then((data) => {
            //     console.info("data:" + JSON.stringify(data));
            //     console.info("data permissions:" + data.permissions);
            //     console.info("data authResults:" + data.authResults);
            //     console.info("data dialogShownResults:" + data.dialogShownResults);
            //   }).catch((err: BusinessError) => {
            //     console.error("data:" + JSON.stringify(err));
            //   })
            // } catch(err) {
            //   console.error(`catch err->${JSON.stringify(err)}`);
            // }
            // 是否有权限
            // ToastCustomUtil.showToast(PagePlayDetail.hasPermission(["ohos.permission.CAMERA"]) ? "有权限" : "无权限")


          })
        //默认
        // Image(img).width(46).height(46)
        //   .objectFit(ImageFit.Cover)
        //   .borderRadius({topLeft:10,topRight:10,bottomLeft:0,bottomRight:0 })

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


  /**
   * 仅仅检测是否有权限，如果没有权限，不会申请权限
   * @param permissions
   * @returns true 有权限
   */
  static hasPermission(permissions: Array<Permissions>): boolean {
    const generalChecker = new GeneralChecker()
    return generalChecker.hasPermission(permissions)
  }

  private dialogController = new CustomDialogController({
    builder: PermissionDialog(),
  })


  private showPermissionDialog(permission: Array<Permissions>) {
    this.dialogController = new CustomDialogController({
      builder: PermissionDialog({permissions: permission}),
    })
    this.dialogController.open()
  }

}
let img = 'https://p3.toutiaoimg.com/tos-cn-i-qvj2lq49k0/c4e6881ba59e4d61916faca062d8de6c~noop.image'

export async function customLocation() {
  const animationTime = 500
  // SmartDialog.show({
  //   builder: dialogLocationHorizontal,
  //   alignment: Alignment.Start,
  // })
  await delay(animationTime)
  SmartDialog.show({
    builder: dialogLocationVertical,
    alignment: Alignment.Bottom,
    tag: "A",
  })
  await delay(1000)
  SmartDialog.dismiss({ tag: "A" })
}


@Builder
function dialogLocationVertical() {
  Text("location")
    .width("100%")
    .height("20%")
    .fontSize(20)
    .fontColor(Color.White)
    .textAlign(TextAlign.Center)
    .padding(50)
    .backgroundColor(randomColor())
}

@Builder
function dialogLocationHorizontal() {
  Text("location")
    .width("30%")
    .height("100%")
    .fontSize(20)
    .fontColor(Color.White)
    .textAlign(TextAlign.Center)
    .padding(50)
    .backgroundColor(randomColor())
}


export function randomColor(): string {
  const letters: string = '0123456789ABCDEF';
  let color = '#';
  for (let i = 0; i < 6; i++) {
    color += letters[Math.floor(Math.random() * 16)];
  }
  return color;
}

export function delay(ms?: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}


@Builder
function attachDialog() {
  Stack() {
    Text("Attach")
      .backgroundColor(randomColor())
      .padding(20)
      .fontColor(Color.White)
      .borderRadius(5)
      .onClick(() => {
        SmartDialog.showAttach({
          targetId: "Attach",
          builder: targetLocationDialog,
        })
      })
      .id("Attach")
  }
  .borderRadius(12)
  .padding(50)
  .backgroundColor(Color.White)
}

@Builder
function targetLocationDialog() {
  Text("targetIdDialog")
    .fontSize(20)
    .fontColor(Color.White)
    .textAlign(TextAlign.Center)
    .padding(50)
    .borderRadius(12)
    .backgroundColor(randomColor())
}

