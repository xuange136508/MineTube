import axios, { AxiosError, AxiosInstance, AxiosResponse, CreateAxiosDefaults } from '@ohos/axios'
import PhoneInfoUtil from '../../utils/PhoneInfoUtil';
import ToastCustomUtil from '../../utils/ToastCustomUtil';
import DebugSetting from '../mmkv/DebugSetting';
import { ErrorMsg } from './ErrorMsg';
import { Response } from './Response';


/**
 * axios封装
 */
class AxiosHelper {
  timeout: number = 15000;
  toast: boolean = true
  //登录失效返回码
  LOGIN_CODE: number = 1022038;

  setToastEnable(toast: boolean): AxiosHelper {
    this.toast = toast
    return this

  }

  getAxios<T>(): AxiosInstance {
    const header: CreateAxiosDefaults = {
      timeout: this.timeout,
      headers: {
        'User-Agent': `pt/${PhoneInfoUtil.version}(harmony;${PhoneInfoUtil.osFullName};${PhoneInfoUtil.widthPixels}*${PhoneInfoUtil.heightPixels})`,
        'Cookie': 'UUID=8f22656c422449c1aa0d81577d3ce878'
      }
    };
    // 是否开启调试抓包模式
    if (AppStorage.get('isDebug')) {
      const debugSetting: DebugSetting = DebugSetting.getInstance();
      header.proxy = {
        host: debugSetting.getIp(),
        port: Number(debugSetting.getHost()),
        exclusionList: []
      }
    }
    const instance = axios.create(header);
    // 添加响应拦截器
    instance.interceptors.response.use((response: AxiosResponse<Response<T>>) => {
      // 对响应数据做点什么
      if (response.status === 200) {
        if (response.data.code === 0 || response.data.status === 1) {
          return response;
        } else {
          if (response.data.errmsg != null) {
            if (this.toast) {
              ToastCustomUtil.showToast(response.data.errmsg.msg)
            }
            this.setToastEnable(true)
            return Promise.reject(new ErrorMsg(response.data.errmsg.errno, response.data.errmsg.msg));
          } else {
            if (this.toast) {
              ToastCustomUtil.showToast(response.data.msg)
            }
            this.setToastEnable(true)
            return Promise.reject(new ErrorMsg(response.data.code, response.data.msg));
          }
        }
      } else {
        if (response.status === this.LOGIN_CODE) {
          /*
          PassportUtils.clearLoginSecretKey()
          CookieUtils.deleteLoginSessionCookies(UserInfo.getInstance().getUid())
          UserInfo.getInstance().clearLoginInfo()
          CheckUserStateUtil.login()*/
        }
        if (this.toast) {
          ToastCustomUtil.showToast(response.statusText)
        }
        this.setToastEnable(true)
        return Promise.reject(new ErrorMsg(response.status, response.statusText));
      }

    }, (error: AxiosError) => {
      // 对响应错误做点什么
      if (this.toast) {
        ToastCustomUtil.showToast("网络不给力，请检查网络设置")
      }
      this.setToastEnable(true)
      return Promise.reject(new ErrorMsg(error.status, error.message));
    });
    return instance
  }
}

export default new AxiosHelper() as AxiosHelper