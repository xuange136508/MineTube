import { BaseMMKVUtils } from '../common/mmkv/BaseMMKVUtils';

/**
 * 用于日常普通统计
 */
export class StatisticsSpUtil {
  static readonly MMAP_ID = 'statistics_sp_utils_mmkv'

  // 常量定义
  public static readonly DEVICEID = "deviceId";
  public static readonly KEY_DEVICE_ID = "key_device_id";
  public static readonly OAID = "oaid";
  public static readonly KEY_UUID = "uuid";
  public static readonly BIND_BLUETOOTH = "bind_bluetooth";
  public static readonly BLUETOOTH_MACADRESS = "bluetooth_macadress";
  public static readonly IS_FIRST_INSTALL = "is_first_install";

  private static instance: StatisticsSpUtil | null = null;
  statisticsSpUtilMmkv = new BaseMMKVUtils(StatisticsSpUtil.MMAP_ID)

  private constructor() {
  }


  /**
   * 获取单例实例
   * @returns
   */
  static getInstance(): StatisticsSpUtil {
    if (!StatisticsSpUtil.instance) {
      StatisticsSpUtil.instance = new StatisticsSpUtil();
    }
    return StatisticsSpUtil.instance;
  }

  getStringValue(key:string){
    return this.statisticsSpUtilMmkv.getStringValue(key, "");
  }

  setStringValue(key:string,value:string){
    this.statisticsSpUtilMmkv.setStringValue(key, value);
  }
}

export default StatisticsSpUtil