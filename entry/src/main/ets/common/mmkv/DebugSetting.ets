// 导入相关模块
import { BaseMMKVUtils } from './BaseMMKVUtils'

class DebugSetting {
  static readonly MMAP_ID = 'debug_setting_sp_utils_mmkv'
  private static IS_DEBUG = "is_debug";
  private static IP = "ip";
  private static HOST = "host";
  private static instance: DebugSetting | null = null;
  private isDebug: boolean = false;
  private ip: string = '';
  private host: string = '';
  debugSettingSpMmkv = new BaseMMKVUtils(DebugSetting.MMAP_ID)

  private constructor() {
  }

  static getInstance(): DebugSetting {
    if (!DebugSetting.instance) {
      DebugSetting.instance = new DebugSetting();
    }
    return DebugSetting.instance;
  }

  setIp(ip: string) {
    if (this.ip === ip) {
      return;
    }
    this.ip = ip;
    this.debugSettingSpMmkv.setStringValue(DebugSetting.IP, ip);
  }

  getIp(): string {
    this.ip = this.debugSettingSpMmkv.getStringValue(DebugSetting.IP) ?? '';
    return this.ip;
  }

  setHost(host: string) {
    if (this.host === host) {
      return;
    }
    this.host = host;
    this.debugSettingSpMmkv.setStringValue(DebugSetting.HOST, host);
  }

  getHost(): string {
    this.host = this.debugSettingSpMmkv.getStringValue(DebugSetting.HOST) ?? '';
    return this.host;
  }
}

export default DebugSetting