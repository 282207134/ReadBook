# 交付文件

- `ReadBook-android-arm64.apk`：Android arm64 安装包，约 18.4 MB，已在 Android 15 模拟器安装并启动。
- `ReadBook-source.zip`：Flutter 源码、项目架构说明、22 张实际界面截图、2 张截图总览，以及 16 张 Pixso 设计参考；不包含构建缓存。

安装示例：

```bash
adb install -r ReadBook-android-arm64.apk
```

安装包采用 Flutter 模板的调试密钥签名，适用于本地演示。正式发布请配置发布密钥。该包为 arm64，不能安装在仅支持 x86 的旧模拟器或仅支持 32 位的设备上。

SHA-256：

```text
f11bc41fced7ba3b1483cdd295c6c483d4e832d1aada8b50c87751b3dec9b7f8
```

账户与支付均为本地演示。项目详细说明请打开根目录 `README.md`。
