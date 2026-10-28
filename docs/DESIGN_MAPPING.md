# Pixso 设计与实现映射

已遍历当前可连接的 Pixso 文件页面分类。该文件仅有 `Page 1`（`0:1`），其下共有 16 个顶层界面，均已读取预览和导出参考图。没有根据单个选中节点推断整个文件范围。

| Pixso 界面 | 图层 ID | App 路由 | 截图 |
| --- | --- | --- | --- |
| Home | 4:42 | `/home` | `01_home.png` |
| Category | 4:123 | `/categories` | `02_categories.png` |
| Category Detail | 6:40 | `/category` | `03_category_detail.png` |
| Book Detail | 4:206 | `/book` | `04_book_detail.png` |
| List Author | 6:520 | `/authors` | `05_authors.png` |
| Search | 6:788 | `/search` | `06_search.png` |
| Filter | 6:896 | `/filter` | `07_filter.png` |
| Wishlist | 34:12 | `/wishlist` | `08_wishlist.png` |
| Bookmark | 36:37 | `/bookmarks` | `09_bookmarks.png` |
| Cart | 6:177 | `/cart` | `10_cart.png` |
| User Profile | 8:71 | `/profile` | `11_profile.png` |
| Login | 10:2 | `/login` | `12_login.png` |
| Sign Up | 11:16 | `/signup` | `13_signup.png` |
| Shipping Address | 6:270 | `/shipping-address` | `14_shipping_address.png` |
| Shipping Option | 6:348 | `/shipping-options` | `15_shipping_options.png` |
| Billing & Payment | 6:409 | `/payment` | `16_payment.png` |

`/author` 复用书籍列表显示指定作者的书籍；`/orders`、`/order-success` 是为演示闭环补充的页面。个人中心的优惠券、帮助、关于和账户资料采用弹窗展示。

## 素材

六张书封和十张作者头像均从 Pixso 的实际图层导出，并存放在 `assets/images/`。部分自动生成代码引用的临时图片返回 404，已通过图层重新导出修复业务所需素材；矢量导航和功能图标使用本地 Flutter/Cupertino 图标。

`reference/` 中的 PNG 为原始设计参考，可能包含透明背景，部分图片查看器会将透明区域显示为黑色。App 使用白色页面背景，与设计的白色卡片、绿色按钮及灰色正文匹配。

`pixso-generated.zip` 是未参与运行的原始导出代码审计归档，可能保留已失效的临时资源地址，不应直接作为可运行源码使用。运行源码均在 `lib/` 中，不引用 Pixso 临时服务器。

## 实现时的内容调整

- 保留绿色渐变按钮、灰色正文、蓝色辅助操作、双色分类卡、书封与列表结构；使用可滚动布局适配手机，系统栏与键盘由设备绘制。
- `Bookmark` 设计标题写作 `Steven Curran`；App 中书签入口标题为 `Bookmarks`，作者书目单独使用作者名作标题。
- 设计中的购物车示例合计与书籍单价不一致；App 按真实示例单价和数量计算，初始两本为 **$37.37**，运费在结算页单独加入。
- 筛选初值改为全部作者/全部分类，数量由本地 6 本书实际计算；语言和年份仅提供示例数据支持的 `English`、`2018`。
- 分类详情参考画面包含全部六本书，因此 `Art & Photography` 入口保留该示例网格；其他分类按示例分类展示，有些分类暂为空。
- 书名和书封沿用设计稿的示例配对；其中首本标题为 `The Mars Room`，封面本身包含其他语言的标题，不代表真实出版数据。
- 详情简介、ISBN 和评论为设计演示文本，统一复用于书目详情，不应视为真实书目信息。
- 修正了设计中的 `Countinue` 拼写，补充表单校验、空状态与本地下单成功反馈。
- Circular Std 未提供字体授权文件，当前使用系统字体；系统字号、图标轮廓和 Android 安全区会与参考图有差异。

当前只能读取已连接的这个 Pixso 文件，未访问其他未打开或未提供的文件。
