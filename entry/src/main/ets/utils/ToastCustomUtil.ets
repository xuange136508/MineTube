import { ToastUtil } from '@pura/harmony-utils'
import { promptAction } from '@kit.ArkUI';

class ToastCustomUtil {
  showToast(message?: ResourceStr) {
    ToastUtil.showToast(message, { showMode: promptAction.ToastShowMode.DEFAULT })
  }
}

export default new ToastCustomUtil() as ToastCustomUtil