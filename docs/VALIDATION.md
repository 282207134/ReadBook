# 验证记录

验证日期：2026-10-28（Asia/Tokyo）。

## 环境

- Flutter 3.41.6 stable / Dart 3.11.4。
- Android 15 / API 35、arm64 模拟器 `emulator-5554`。
- 模拟器画面 1125 × 2436，逻辑宽度 375。
- Widget 测试额外覆盖 320 × 740 逻辑像素的窄屏。

## 已执行验证

| 检查 | 结果 |
| --- | --- |
| `flutter analyze` | 无问题 |
| `flutter test --reporter expanded` | 10 项通过 |
| Android 全页面渲染 | Pixso 16 个界面均无 Flutter 布局异常 |
| Android 端到端流程 | 搜索 Blue → 详情加入购物车 → 修改数量 → 完整填写地址 → 标准配送 → PayPal 本地模拟 → 订单成功 → 订单历史 |
| 截图核对 | 逐页检查页面总览；主要业务界面额外单独查看 |
| Android arm64 release 构建 | 成功，安装包约 18.4 MB |
| release 安装与启动 | Android 模拟器安装成功，正常显示首页 |
| `flutter build web` | 编译成功，包含 Wasm dry run 检查；未宣称已完成浏览器交互测试 |

状态测试覆盖整数金额计算、数量上下限、移除、搜索组合筛选、收藏/书签/账户/订单的本地重载、订单前置条件以及损坏 JSON 降级。界面测试覆盖 16 页窄屏渲染、搜索结果与空状态、收藏与加入购物车、登录校验、滚出屏幕的地址字段仍需完整校验。

端到端测试断言购物车数量与总额、完整姓名和街道/邮编被保留、标准运费为零、下单后购物车清空及订单总额正确。该测试使用 `AppState()` 的独立内存数据，不替换用户正常运行时的持久化数据。

## 复现命令

```bash
flutter pub get
flutter analyze
flutter test --reporter expanded
flutter drive -d emulator-5554 \
  --driver=test_driver/screenshot_driver.dart \
  --target=integration_test/app_test.dart
```

截图重建：

```bash
python3 -m pip install Pillow
python3 tool/make_contact_sheets.py
```

此机器使用 Codex 自带 Python 环境中的 Pillow 生成文档图集。项目不依赖该环境路径，普通安装 Pillow 的 Python 也可运行脚本。

## 验证范围

Android 为实际运行验证平台。iOS 工程已生成，但本机没有可用的 iOS Simulator runtime，未宣称已通过 iOS 编译或真机测试。支付流程为本地演示；未对真实银行、PayPal、Facebook 或 Google 身份服务进行联网验证。

字体采用系统默认 sans-serif，未包含设计稿的 Circular Std。截图的状态栏安全区、字体字形和原生图标与 Pixso 预览存在已说明的差异。
