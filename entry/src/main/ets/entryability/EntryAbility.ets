
import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { ImageKnife } from '@ohos/imageknife';
import { MMKV } from '@tencent/mmkv';
import { SpinKitHelper } from '@pura/spinkit';
import { SpinType } from '@pura/spinkit';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    ImageKnife.getInstance().initFileCache(this.context, 256, 256 * 1024 * 1024)

    MMKV.initialize(this.context.getApplicationContext())

    //设置全局统一样式，在UIAbility的onCreate方法里初始化
    SpinKitHelper.setGlobalConfig((config) => {
      config.uiContext = this.context  //必须初始化上下文
      config.spinType = SpinType.spinC
      config.spinSize = 60
      config.spinColor = '#FFFFFF'
      config.backgroundColor = '#CC000000'
      config.borderRadius = 10
      config.maskColor = '#22000000'
      config.autoCancel = false
    })
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
