import { MMKV } from '@tencent/mmkv';
import { JSONUtil, NumberUtil, StrUtil } from '@pura/harmony-utils';


//MMKV工具类
export class BaseMMKVUtils {
  mmkv?: MMKV

  /**
   * 初始化你需要的MMKV
   * @param mmapID
   */
  constructor(mmapID: string) {
    try {
      this.mmkv = MMKV.mmkvWithID(mmapID);
    } catch (err) {
      console.debug(`mmkv加载失败, err: ` + JSON.stringify(err))
    }
  }

  /**
   * 写入数据
   * expiration: 自定义过期时间 秒级
   * */
  setStringValue(key: string, value: string, expiration?: number): boolean {
    if (StrUtil.isEmpty(value)) {
      return false
    }
    return this.mmkv?.encodeString(key, value, expiration) ?? false
  }

  /**
   * 读取数据
   * @param defaultValue 默认数据
   * */
  getStringValue(key: string, defaultValue?: string): string {
    return this.mmkv?.decodeString(key, defaultValue) ?? ''
  }


  /**
   * 写入数据
   *  expiration: 自定义过期时间 秒级
   * */
  setInt32Value(key: string, value: number, expiration?: number): boolean {
    if (!NumberUtil.isNumber(value) || value === undefined) {
      return false
    }
    return this.mmkv?.encodeInt32(key, value, expiration) ?? false
  }

  /**
   * 读取数据
   * @param defaultValue 默认数据
   * */
  getInt32Value(key: string, defaultValue?: number): number {
    return this.mmkv?.decodeInt32(key, defaultValue) ?? 0
  }

  /**
   * 写入数据
   *  expiration: 自定义过期时间 秒级
   * */
  setBooleanValue(key: string, value: boolean, expiration?: number): boolean {
    return this.mmkv?.encodeBool(key, value, expiration) ?? false
  }

  /**
   * 读取数据
   * @param defaultValue 默认数据
   * */
  getBooleanValue(key: string, defaultValue?: boolean): boolean {
    return this.mmkv?.decodeBool(key, defaultValue) ?? false
  }

  /**
   * 写入数据
   *  expiration: 自定义过期时间 秒级
   * */
  setBeanValue(key: string, value: Object, expiration?: number): boolean {
    if (value === undefined || value === null) {
      return false
    }
    let jsonStr = JSONUtil.beanToJsonStr(value)
    return this.setStringValue(key, jsonStr, expiration)
  }

  /**
   * 读取数据
   * @param defaultValue 默认数据
   * 在外面再进行json转bean操作
   * */
  getBeanValue(key: string): string {
    return this.getStringValue(key) ?? ''
  }

  /**
   * 清除key
   * */
  removeKey(key: string) {
    this.mmkv?.removeValueForKey(key)
  }

  /**
   * 包含某个key
   * */
  containsKey(key: string): boolean {
    return this.mmkv?.containsKey(key) ?? false
  }
}