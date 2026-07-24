# 从 Yahboom 派生自定义板子的最小改动清单

基于当前工程 [k230_sdk](file:///home/ceoifung/work/k230_sdk) 整理。

这份文档的目标是：从 `k230_canmv_yahboom` 出发，派生出你自己的板型，例如 `k230_canmv_myboard`，并尽量减少第一次改板时的试错成本。

## 先说结论

- 如果你的板子和 `Yahboom` 很像，最省事的方式就是从 `Yahboom` 派生。
- 第一次派生时，不要一上来大改所有内容。
- 最稳的顺序是：
  - 先复制 `defconfig`
  - 再复制板级目录
  - 再改 `DTS` 引脚
  - 再改 `sdcard` 资源
  - 最后再决定要不要保留 `Yahboom` 专属 C 模块和 UI 资源

## 派生时要改的层次

从 `Yahboom` 派生一个新板型，通常涉及 5 层：

| 层次 | 位置 | 作用 | 是否必改 |
| --- | --- | --- | --- |
| `defconfig` | `configs/` | 定义编译目标和硬件开关 | `必改` |
| 板级 Kconfig/board 目录 | `boards/` | 板级 Kconfig、打包配置、镜像配置 | `通常必改` |
| CanMV board 目录 | `src/canmv/port/boards/` | 板名、冻结 Python 包 | `必改` |
| U-Boot DTS | `src/uboot/uboot/arch/riscv/dts/` | IO 复用、电压 bank、控制脚 | `必改` |
| SD 卡资源 | `src/canmv/resources/ybsdcard` 或通用资源 | UI、应用、模型、脚本 | `按需求改` |

## 推荐的最小派生步骤

### 1. 复制一份新的 defconfig

参考文件：

- [k230_canmv_yahboom_defconfig](file:///home/ceoifung/work/k230_sdk/configs/k230_canmv_yahboom_defconfig)

建议新建：

- `configs/k230_canmv_myboard_defconfig`

起步时至少要改：

- `CONFIG_BOARD_CONFIG_NAME`
- `CONFIG_BOARD_K230_CANMV_YAHBOOM=y` 对应的板型宏

示意：

```config
CONFIG_BOARD_CONFIG_NAME="k230_canmv_myboard_defconfig"
CONFIG_BOARD_K230_CANMV_MYBOARD=y
```

第一次派生时，其他和硬件强相关的配置可以先沿用 `Yahboom`，例如：

- 摄像头类型
- `CSI` 设备号
- `MCLK`
- LCD 类型
- `LCD_RESET_PIN`

等第一次点亮/启动后，再逐步改。

### 2. 复制一份新的板级目录

参考目录：

- [boards/k230_canmv_yahboom](file:///home/ceoifung/work/k230_sdk/boards/k230_canmv_yahboom)

建议复制成：

- `boards/k230_canmv_myboard`

这里通常至少要检查：

- `Kconfig`
- 默认环境文件
- 镜像配置文件
- 是否引用了 `yahboom` 专用命名

当前 `Yahboom` 的板级 `Kconfig` 很简单，见 [Kconfig](file:///home/ceoifung/work/k230_sdk/boards/k230_canmv_yahboom/Kconfig)：

```config
if BOARD_K230_CANMV_YAHBOOM
    config BOARD_NOT_SUPPORT_HW_RTC
        def_bool y
endif
```

你派生时至少要把宏名改成自己的，例如：

```config
if BOARD_K230_CANMV_MYBOARD
    config BOARD_NOT_SUPPORT_HW_RTC
        def_bool y
endif
```

### 3. 复制 CanMV 板级目录

参考目录：

- [k230_canmv_yahboom](file:///home/ceoifung/work/k230_sdk/src/canmv/port/boards/k230_canmv_yahboom)

建议复制成：

- `src/canmv/port/boards/k230_canmv_myboard`

这里至少要改两个文件。

#### `mpconfigboard.h`

参考文件：

- [mpconfigboard.h](file:///home/ceoifung/work/k230_sdk/src/canmv/port/boards/k230_canmv_yahboom/mpconfigboard.h)

当前内容：

```c
#define MICROPY_HW_BOARD_NAME               CONFIG_BOARD
#define MICROPY_HW_MCU_NAME                 "K230"
#define OMV_ARCH_STR                        ""
#define OMV_BOARD_TYPE                      "CanMV K230 YAHBOOM - %d%c"
```

你至少应改 `OMV_BOARD_TYPE`，例如：

```c
#define OMV_BOARD_TYPE                      "CanMV K230 MYBOARD - %d%c"
```

#### `manifest.py`

参考文件：

- [manifest.py](file:///home/ceoifung/work/k230_sdk/src/canmv/port/boards/k230_canmv_yahboom/manifest.py)

当前内容：

```python
include("../manifest.py")

package("yahboom", base_path="../../builtin_py", opt=3)
```

这行：

```python
package("yahboom", base_path="../../builtin_py", opt=3)
```

表示会把 `yahboom` 的 Python 包冻结进固件。

你的选择有两种：

| 方案 | 怎么做 | 适用场景 |
| --- | --- | --- |
| 先保留 | 先不删 `package("yahboom", ...)` | 想最快从 Yahboom 跑起来 |
| 改成自己的 | 删除 `yahboom` 包，或换成自己的包 | 你不想继承 Yahboom 的应用框架 |

如果只是先验证硬件，建议第一阶段先保留。

### 4. 复制并修改 U-Boot DTS

参考文件：

- [k230_canmv_yahboom.dts](file:///home/ceoifung/work/k230_sdk/src/uboot/uboot/arch/riscv/dts/k230_canmv_yahboom.dts)

建议复制成：

- `src/uboot/uboot/arch/riscv/dts/k230_canmv_myboard.dts`

这里是硬件适配最关键的一层，至少要改：

- `model`
- `compatible`
- IO 复用
- Bank 电压
- 摄像头复位/时钟/I2C 脚
- LCD/TP 复位和中断脚
- 功放使能、蜂鸣器、按键等控制脚

参考：

- [k230_canmv_yahboom.dts](file:///home/ceoifung/work/k230_sdk/src/uboot/uboot/arch/riscv/dts/k230_canmv_yahboom.dts#L37-L174)

尤其要注意：

- `IO62~IO63` 是 `1.8V bank`
- `Yahboom` 里已定义：
  - `IO22 = LCD_RST`
  - `IO23 = TP_INT`
  - `IO24 = TP_RST`
  - `IO25 = LCD_EN`
  - `IO48 = SPEAKER_EN`
  - `IO53 = BUZZER-PWM5`
  - `IO62 = CAM2_RST`
  - `IO63 = CAM2_MCLK3`

如果你的硬件不同，这里必须改。

### 5. 决定是否继续使用 Yahboom 专用打包模式

当前 `Yahboom` 在 CanMV 构建里走专门分支，见 [src/canmv/Makefile](file:///home/ceoifung/work/k230_sdk/src/canmv/Makefile#L26-L45)。

它会直接把：

- [ybsdcard](file:///home/ceoifung/work/k230_sdk/src/canmv/resources/ybsdcard)

整体拷到：

- `output/<defconfig>/images/sdcard`

你的选择有两种：

| 方案 | 怎么做 | 适合谁 |
| --- | --- | --- |
| 继续沿用 `Yahboom` 专用模式 | 先继续使用 `ybsdcard` 这套资源 | 你要快速做出一整套产品型界面 |
| 切回通用 `sdcard` 模式 | 参考通用 `resources/libs/font/examples` 组织方式 | 你想做更轻量、标准的 CanMV 板型 |

第一次派生时，更建议：

- **先沿用 `Yahboom` 资源模式**
- 等板子跑通后，再决定要不要精简

### 6. 决定是否保留 Yahboom 专属 C 源和 LVGL 配置

在 [port/Makefile](file:///home/ceoifung/work/k230_sdk/src/canmv/port/Makefile#L173-L178) 中，`Yahboom` 会额外编译：

- `builtin_py/yahboom/ybMain/*.c`
- `builtin_py/yahboom/ybUtils/*.c`

在 [port/Makefile](file:///home/ceoifung/work/k230_sdk/src/canmv/port/Makefile#L281-L289) 中，还会额外启用：

- `yb_config/lv_conf_yb.h`
- `lv_font_yb_cn_16.c`
- `lv_font_yb_cn_22.c`

这部分的建议是：

| 阶段 | 建议 |
| --- | --- |
| 第一阶段 | 先保留，优先把板子编过、点亮、跑起来 |
| 第二阶段 | 再决定是否替换成你自己的 UI、字体、模块 |

如果你一开始就全部删掉，第一次很容易把“硬件问题”和“资源/框架问题”混在一起。

## 最小可行改动集

如果你想要“最小变更先编通”，建议第一版只做这些：

| 改动项 | 是否第一版必做 | 备注 |
| --- | --- | --- |
| 新增 `defconfig` | `是` | 必须有自己的编译入口。 |
| 新增 `boards/<myboard>` | `是` | 至少把宏名改掉。 |
| 新增 `src/canmv/port/boards/<myboard>` | `是` | 至少改板名字符串。 |
| 新增 `U-Boot DTS` | `是` | 硬件脚位必须对应你自己的板子。 |
| 改 `ybsdcard` 应用资源 | `否` | 可以先完全沿用。 |
| 删除 `yahboom` 冻结包 | `否` | 可以第二阶段再做。 |
| 删除 `ybMain/ybUtils` C 源 | `否` | 可以第二阶段再做。 |
| 替换 `LVGL` 配置和字体 | `否` | 可以第二阶段再做。 |

## 推荐开发顺序

建议你按这个顺序推进：

1. 复制 `yahboom defconfig` 成 `myboard defconfig`
2. 复制 `boards/k230_canmv_yahboom` 成 `boards/k230_canmv_myboard`
3. 复制 `src/canmv/port/boards/k230_canmv_yahboom` 成 `.../k230_canmv_myboard`
4. 复制并修改 `k230_canmv_yahboom.dts`
5. 先保留 `ybsdcard`、`yahboom` Python 包、`ybMain/ybUtils`
6. 编译并点亮验证
7. 再逐步删减 `Yahboom` 定制内容

## 编译时的建议

等你做好自己的 `defconfig` 后，建议用通用脚本编：

- [build_k230.sh](file:///home/ceoifung/work/k230_sdk/build_k230.sh)

例如：

```bash
cd /home/ceoifung/work/k230_sdk
./build_k230.sh k230_canmv_myboard_defconfig
```

## 一句话建议

- 如果你现在最想要的是“先出第一版可启动固件”，那就：
  - **复制 `Yahboom`**
  - **只改板名、defconfig、DTS**
  - **先不要急着删 `Yahboom` 资源和模块**

- 如果你现在最想要的是“做一套完全自己的轻量固件”，那就：
  - 仍然可以从 `Yahboom` 起步
  - 但第二阶段尽快切回通用 `sdcard` 模式

## 相关文件

- `defconfig`： [k230_canmv_yahboom_defconfig](file:///home/ceoifung/work/k230_sdk/configs/k230_canmv_yahboom_defconfig)
- 板级 Kconfig： [Kconfig](file:///home/ceoifung/work/k230_sdk/boards/k230_canmv_yahboom/Kconfig)
- CanMV 板级目录： [k230_canmv_yahboom](file:///home/ceoifung/work/k230_sdk/src/canmv/port/boards/k230_canmv_yahboom)
- U-Boot DTS： [k230_canmv_yahboom.dts](file:///home/ceoifung/work/k230_sdk/src/uboot/uboot/arch/riscv/dts/k230_canmv_yahboom.dts)
- Yahboom 资源目录： [ybsdcard](file:///home/ceoifung/work/k230_sdk/src/canmv/resources/ybsdcard)
- CanMV 构建逻辑： [src/canmv/Makefile](file:///home/ceoifung/work/k230_sdk/src/canmv/Makefile)
- CanMV port 构建逻辑： [port/Makefile](file:///home/ceoifung/work/k230_sdk/src/canmv/port/Makefile)
