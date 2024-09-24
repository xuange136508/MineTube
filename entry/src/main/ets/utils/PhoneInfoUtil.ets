import bundleManager from '@ohos.bundle.bundleManager'
import deviceInfo from '@ohos.deviceInfo'
import { common, Want } from '@kit.AbilityKit';
import { DeviceUtil, DisplayUtil, StrUtil } from '@pura/harmony-utils'
import StatisticsSpUtil from './StatisticsSpUtil';
import CryptoJS from '@ohos/crypto-js';

const tag = "PhoneInfoUtil"

const EQUIPMENT_SYSTEM = "harmony";

/**
 * 手机信息工具类
 */
export class PhoneInfoUtil {
  version: string = ''
  serial: string = ''
  brand: string = ''
  manufacture: string = ''
  localDeviceID: string = ''
  productModel: string = ''
  osFullName: string = ''
  deviceID: string = ''
  widthPixels: number = 0;
  heightPixels: number = 0;
  longitude: string = ''
  latitude: string = ''
  map: Map<string, string> = new Map()

  /**
   * 获取UUID
   * @returns
   */
  getUUID(): string {
    let serial = '';
    let m_szDevIDShort = '35' + this.serial.length % 10 + this.brand.length % 10 + this.manufacture.length % 10
    //API>=9 使用serial号
    if (serial === "" || serial === null) {
      serial = "serial"; // 随便一个初始化
    }
    let encodedString = m_szDevIDShort + serial
    let md5Hash: string = CryptoJS.MD5(encodedString).toString();
    return md5Hash
  }


  getOpenMmid() {
    if (StrUtil.isNotEmpty(this.deviceID)) {
      return this.deviceID;
    }
    let deviceId = StatisticsSpUtil.getInstance().getStringValue(StatisticsSpUtil.DEVICEID);
    if (StrUtil.isNotEmpty(deviceId)) {
      this.deviceID = deviceId;
      return this.deviceID;
    }
    let sbDeviceMeta = this.getUUID() + this.localDeviceID
    deviceId = CryptoJS.MD5(sbDeviceMeta).toString();
    let bytes = StrUtil.strToUint8Array(deviceId)
    let sum1: number = 0, sum2: number = 0;

    for (let i = 0; i < bytes.byteLength; i++) {
      if (i % 2 === 0) {
        sum1 += bytes[i];
      } else {
        sum2 += bytes[i];
      }
    }

    const codes: string[] = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'];

    let checkSum1: number = sum1 % codes.length;
    let checkSum2: number = sum2 % codes.length;

    deviceId = deviceId + codes[checkSum1] + codes[checkSum2];
    if (StrUtil.isNotEmpty(deviceId)) {
      StatisticsSpUtil.getInstance().setStringValue(StatisticsSpUtil.DEVICEID, deviceId);
    }
    return deviceId;
    return this.deviceID
  }

  /**
   * 获取手机一些信息
   * @param context
   */
  async getPhoneInfo(context: common.UIAbilityContext) {
    // 获取当前应用的版本号
    let info = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT);
    this.version = info.versionName

    // this.serial = deviceInfo.serial
    // console.log(tag+':序列号：', this.serial)

    this.brand = deviceInfo.brand
    this.manufacture = deviceInfo.manufacture
    this.productModel = deviceInfo.productModel
    this.osFullName = deviceInfo.osFullName

    this.widthPixels = DisplayUtil.getWidth()
    this.heightPixels = DisplayUtil.getHeight()

    // console.log(tag+':udid:' + this.getUUID())

    try {
      let deviceId = StatisticsSpUtil.getInstance().getStringValue(StatisticsSpUtil.KEY_DEVICE_ID);
      if (!StrUtil.isNotEmpty(deviceId)) {
        this.localDeviceID = await DeviceUtil.getDeviceId()
        StatisticsSpUtil.getInstance().setStringValue(StatisticsSpUtil.KEY_DEVICE_ID, this.localDeviceID)
      } else {
        this.localDeviceID = deviceId
      }
      console.log(tag + ':deviceId:' + this.localDeviceID)
    } catch (e) {
      console.log(tag + ':获取设备ID失败：' + e)
    }
    this.initExtraParam()
  }

  initExtraParam() {
    this.map.set('system', EQUIPMENT_SYSTEM)
    this.map.set('appVersion', this.version)
    this.map.set('systemVersion', this.osFullName)
    this.map.set('deviceModel', this.brand)
    this.map.set('deviceId', this.getOpenMmid())
    this.map.set('interval', "10")
    this.map.set('ip', '0.0.0.0')
    this.map.set('brand', this.brand)
  }
}

export default new PhoneInfoUtil() as PhoneInfoUtil