# K230 SDK 板型资源组织说明

基于当前工程 [k230_sdk](file:///home/ceoifung/work/k230_sdk) 整理。

这份文档说明：

- `repo sync` 是否只同步了 `Yahboom`
- 为什么资源目录里只看到一个 `ybsdcard`
- 各板型是走“通用 `sdcard` 模式”还是“专用资源目录模式”
- 你后续做自定义板子时应该参考哪种方式

## 结论

- `repo sync` 同步的是整个 SDK，不是只同步 `Yahboom`。
- 当前 SDK 里有很多板型目录和很多 `defconfig`，并不是只有 `Yahboom`。
- 之所以只看到一个 `ybsdcard`，是因为它是 `Yahboom` 板型专门维护的一套 `sdcard` 资源目录。
- 其他板型大多走通用 `sdcard` 打包逻辑，不会各自再维护一个 `xxsdcard` 目录。

## 关键依据

### 1. Yahboom 走专用打包逻辑

在 [src/canmv/Makefile](file:///home/ceoifung/work/k230_sdk/src/canmv/Makefile#L26-L45) 中，`Yahboom` 单独走一个分支：

```make
ifeq ($(CONFIG_BOARD_K230_CANMV_YAHBOOM),y)
gen_image: build copy_sdcard copy_micropython
copy_sdcard:
	rsync -aq --delete --exclude='.git' --exclude='micropython' \
	$(SDK_SRC_ROOT_DIR)/src/canmv/resources/ybsdcard/ \
	${SDK_BUILD_IMAGES_DIR}/sdcard/
```

这说明：

- `Yahboom` 的 `sdcard` 内容直接来自 `src/canmv/resources/ybsdcard`
- 它不是走通用示例/库/字体拼装流程

### 2. 其他板型走通用打包逻辑

同一个文件的通用分支见 [src/canmv/Makefile](file:///home/ceoifung/work/k230_sdk/src/canmv/Makefile#L46-L173)。

通用模式会把这些目录/文件打包进 `sdcard`：

- `resources/boot.py`
- `resources/main.py`
- `resources/fallback.py`
- `resources/libs/`
- `resources/font/`
- `resources/examples/`
- 可选的 `resources/sdcard/`

也就是说，大多数板型复用的是“公共资源 + 可选自定义覆盖”模式，而不是单独一个 `xxsdcard` 目录。

## 当前资源目录结构

当前 [resources](file:///home/ceoifung/work/k230_sdk/src/canmv/resources) 下可见目录有：

- `examples`
- `font`
- `libs`
- `test_todo`
- `ybsdcard`

这进一步说明：

- `examples/font/libs` 是公共资源
- `ybsdcard` 是 `Yahboom` 专用资源

## 板型资源模式对照表

| 资源模式 | 适用板型 | 资源来源 | 打包方式 | 说明 |
| --- | --- | --- | --- | --- |
| `Yahboom 专用模式` | `k230_canmv_yahboom` | `src/canmv/resources/ybsdcard` | 专门分支直接整体复制到 `images/sdcard` | 适合 UI、应用、模型、资源都强定制的整机板型。 |
| `通用 sdcard 模式` | 除 `k230_canmv_yahboom` 外的大多数 `CanMV` 板型 | `resources/boot.py`、`resources/libs`、`resources/font`、`resources/examples`、可选 `resources/sdcard` | 通用分支按类别拼装到 `images/sdcard` | 适合复用 CanMV 公共生态，只在局部做差异化。 |

## 当前工程里的板型情况

下面这些板型目录都已经在 SDK 里同步到了，不是只同步了 `Yahboom`：

| 板级目录 | 说明 |
| --- | --- |
| `k230_canmv` | 通用 CanMV 基础板型。 |
| `k230_canmv_01studio` | 01Studio 板型。 |
| `k230_canmv_dongshanpi` | 东山派板型。 |
| `k230_canmv_gt6700` | GT6700 板型。 |
| `k230_canmv_hiwonder` | Hiwonder 板型。 |
| `k230_canmv_lckfb` | 立创开发板相关板型。 |
| `k230_canmv_mrt` | MRT 板型。 |
| `k230_canmv_rtt_evb` | RTT EVB 板型。 |
| `k230_canmv_v3p0` | CanMV V3P0 板型。 |
| `k230_canmv_wondermk` | WonderMK 板型。 |
| `k230_canmv_yahboom` | Yahboom 板型，带专用 `ybsdcard`。 |
| `k230_aihardware` | 其他 RTOS/应用方向板型。 |
| `k230_evb` | 官方 EVB 板型。 |
| `k230_labplus_1956` | Labplus 相关板型。 |
| `k230d_*` | 一批 `K230D` 系列板型。 |

对应的配置文件也都有，见 [configs](file:///home/ceoifung/work/k230_sdk/configs)。

## 为什么只有一个 `ybsdcard`

| 现象 | 原因 |
| --- | --- |
| 只看到 `resources/ybsdcard` | 因为当前只有 `Yahboom` 被实现成“整套专用 SD 卡资源包”模式。 |
| 没看到 `01studiosdcard`、`lckfbsdcard` 之类目录 | 因为这些板子多数复用公共资源，没必要单独维护完整资源包。 |
| 同步后 `boards/` 和 `configs/` 有很多板子，但 `resources/` 没那么多专用目录 | 因为“板级配置”和“资源目录”是两层概念，不是一一对应。 |

## 你做自己板子时怎么选

| 你的目标 | 推荐模式 | 原因 |
| --- | --- | --- |
| 只改板级配置、显示、触摸、摄像头、少量脚本 | `通用 sdcard 模式` | 改动更小，跟官方公共资源兼容性更好。 |
| 需要一整套自己的 UI、应用菜单、模型、资源包、系统启动体验 | `Yahboom 专用模式` | 直接维护一整套专属 `sdcard` 资源最清晰。 |
| 想从现有整机产品快速派生 | 从 `Yahboom` 模式派生 | 适合“整套产品化固件”思路。 |
| 想做更轻量的板卡适配 | 从通用模式派生 | 适合“板级适配 + 通用 CanMV 生态”的思路。 |

## 推荐实践

- 如果你的板子和 `Yahboom` 很像，并且你也要一整套应用桌面、模型和资源：
  - 直接参考 `Yahboom` 模式
  - 重点看 [ybsdcard](file:///home/ceoifung/work/k230_sdk/src/canmv/resources/ybsdcard)
- 如果你的板子更像普通 CanMV 开发板：
  - 优先走通用模式
  - 重点看 [resources](file:///home/ceoifung/work/k230_sdk/src/canmv/resources)
  - 需要额外资源时，可新增 `resources/sdcard/` 做覆盖

## 相关文件

- 构建逻辑： [src/canmv/Makefile](file:///home/ceoifung/work/k230_sdk/src/canmv/Makefile)
- 板级目录： [boards](file:///home/ceoifung/work/k230_sdk/boards)
- 配置目录： [configs](file:///home/ceoifung/work/k230_sdk/configs)
- Yahboom 资源： [ybsdcard](file:///home/ceoifung/work/k230_sdk/src/canmv/resources/ybsdcard)
- 公共资源： [resources](file:///home/ceoifung/work/k230_sdk/src/canmv/resources)
