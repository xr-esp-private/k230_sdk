# K230 CanMV Yahboom IO Map

基于文件 [k230_canmv_yahboom.dts](file:///home/ceoifung/work/k230_sdk/src/uboot/uboot/arch/riscv/dts/k230_canmv_yahboom.dts) 整理。

这份文档面向硬件设计人员，用来快速查看 `Yahboom` 板级在 U-Boot 设备树中的 `IO0 ~ IO63` 默认复用状态和注释信息。

## 说明

- 本文档来源于 `U-Boot DTS`，反映的是当前固件默认 pinmux 配置，不等价于完整原理图。
- 表中的 `SEL` 为 DTS 中的复用选择值，具体复用定义仍应结合 `K230 pinctrl` 手册确认。
- `SEL=0` 在本文件中通常表现为普通 GPIO/未注明功能，但最终用途仍需结合上层软件和原理图确认。
- `MIPI CSI/DSI` 这类高速专用接口的数据 Lane 不会在这里以普通 `IOxx` 全部展开，本表主要覆盖 DTS 中显式列出的复位、I2C、UART、PWM、GPIO 等控制脚。

## Bank 电压配置

| IO 范围 | Bank 电压 |
| --- | --- |
| `IO0 ~ IO1` | `1.8V` |
| `IO2 ~ IO13` | `3.3V` |
| `IO14 ~ IO25` | `3.3V` |
| `IO26 ~ IO37` | `3.3V` |
| `IO38 ~ IO49` | `3.3V` |
| `IO50 ~ IO61` | `3.3V` |
| `IO62 ~ IO63` | `1.8V` |

## IO 详细表

| IO | SEL | 电压 Bank | DTS 注释/当前功能 | 中文备注 |
| --- | --- | --- | --- | --- |
| `IO0` | `1` | `IO0~IO1 / 1.8V` | `boot` | 启动相关引脚，固定用途，硬件设计时不要随意复用。 |
| `IO1` | `1` | `IO0~IO1 / 1.8V` | `boot1` | 启动相关引脚，固定用途，硬件设计时不要随意复用。 |
| `IO2` | `1` | `IO2~IO13 / 3.3V` | `JTAG` | JTAG 调试引脚。 |
| `IO3` | `1` | `IO2~IO13 / 3.3V` | `JTAG` | JTAG 调试引脚。 |
| `IO4` | `1` | `IO2~IO13 / 3.3V` | `JTAG` | JTAG 调试引脚。 |
| `IO5` | `1` | `IO2~IO13 / 3.3V` | `JTAG` | JTAG 调试引脚。 |
| `IO6` | `1` | `IO2~IO13 / 3.3V` | `JTAG` | JTAG 调试引脚。 |
| `IO7` | `2` | `IO2~IO13 / 3.3V` | `CAMERA2 IIC4-SCL` | 摄像头 2 的 `I2C4_SCL`。 |
| `IO8` | `2` | `IO2~IO13 / 3.3V` | `CAMERA2 IIC4-SDA` | 摄像头 2 的 `I2C4_SDA`。 |
| `IO9` | `2` | `IO2~IO13 / 3.3V` | `EXPORT UART1_TXD` | 对外导出的 `UART1_TXD`。 |
| `IO10` | `2` | `IO2~IO13 / 3.3V` | `EXPORT UART1_RXD` | 对外导出的 `UART1_RXD`。 |
| `IO11` | `0` | `IO2~IO13 / 3.3V` | `未注明` | 当前 DTS 未标注专用功能，可视作普通 GPIO/保留脚。 |
| `IO12` | `0` | `IO2~IO13 / 3.3V` | `未注明` | 当前 DTS 未标注专用功能，可视作普通 GPIO/保留脚。 |
| `IO13` | `0` | `IO2~IO13 / 3.3V` | `未注明` | 当前 DTS 未标注专用功能，可视作普通 GPIO/保留脚。 |
| `IO14` | `0` | `IO14~IO25 / 3.3V` | `未注明` | 当前 DTS 未标注专用功能，可视作普通 GPIO/保留脚。 |
| `IO15` | `0` | `IO14~IO25 / 3.3V` | `未注明` | 当前 DTS 未标注专用功能，可视作普通 GPIO/保留脚。 |
| `IO16` | `3` | `IO14~IO25 / 3.3V` | `RGB` | 设备树中注释为 `RGB`，为显示相关复用脚。 |
| `IO17` | `0` | `IO14~IO25 / 3.3V` | `未注明` | 当前 DTS 未标注专用功能，可视作普通 GPIO/保留脚。 |
| `IO18` | `0` | `IO14~IO25 / 3.3V` | `未注明` | 当前 DTS 未标注专用功能，可视作普通 GPIO/保留脚。 |
| `IO19` | `0` | `IO14~IO25 / 3.3V` | `未注明` | 当前 DTS 未标注专用功能，可视作普通 GPIO/保留脚。 |
| `IO20` | `0` | `IO14~IO25 / 3.3V` | `未注明` | 当前 DTS 未标注专用功能，可视作普通 GPIO/保留脚。 |
| `IO21` | `0` | `IO14~IO25 / 3.3V` | `未注明` | 当前 DTS 未标注专用功能，可视作普通 GPIO/保留脚。 |
| `IO22` | `0` | `IO14~IO25 / 3.3V` | `LCD_RST` | LCD 复位脚。 |
| `IO23` | `0` | `IO14~IO25 / 3.3V` | `TP_INT` | 触摸面板中断脚。 |
| `IO24` | `0` | `IO14~IO25 / 3.3V` | `TP_RST` | 触摸面板复位脚。 |
| `IO25` | `0` | `IO14~IO25 / 3.3V` | `LCD_EN` | LCD 使能脚。 |
| `IO26` | `0` | `IO26~IO37 / 3.3V` | `未注明` | 当前 DTS 未标注专用功能，可视作普通 GPIO/保留脚。 |
| `IO27` | `0` | `IO26~IO37 / 3.3V` | `未注明` | 当前 DTS 未标注专用功能，可视作普通 GPIO/保留脚。 |
| `IO28` | `0` | `IO26~IO37 / 3.3V` | `未注明` | 当前 DTS 未标注专用功能，可视作普通 GPIO/保留脚。 |
| `IO29` | `0` | `IO26~IO37 / 3.3V` | `未注明` | 当前 DTS 未标注专用功能，可视作普通 GPIO/保留脚。 |
| `IO30` | `0` | `IO26~IO37 / 3.3V` | `未注明` | 当前 DTS 未标注专用功能，可视作普通 GPIO/保留脚。 |
| `IO31` | `0` | `IO26~IO37 / 3.3V` | `未注明` | 当前 DTS 未标注专用功能，可视作普通 GPIO/保留脚。 |
| `IO32` | `0` | `IO26~IO37 / 3.3V` | `GPIO - PIN` | 普通 GPIO。 |
| `IO33` | `0` | `IO26~IO37 / 3.3V` | `GPIO - PIN` | 普通 GPIO。 |
| `IO34` | `0` | `IO26~IO37 / 3.3V` | `GPIO - PIN` | 普通 GPIO。 |
| `IO35` | `0` | `IO26~IO37 / 3.3V` | `GPIO - PIN` | 普通 GPIO。 |
| `IO36` | `0` | `IO26~IO37 / 3.3V` | `未注明` | 当前 DTS 未标注专用功能，可视作普通 GPIO/保留脚。 |
| `IO37` | `0` | `IO26~IO37 / 3.3V` | `未注明` | 当前 DTS 未标注专用功能，可视作普通 GPIO/保留脚。 |
| `IO38` | `1` | `IO38~IO49 / 3.3V` | `UART0_TXD` | `UART0` 发送脚。 |
| `IO39` | `1` | `IO38~IO49 / 3.3V` | `UART0_RXD` | `UART0` 接收脚。 |
| `IO40` | `0` | `IO38~IO49 / 3.3V` | `unused reserve` | 预留未使用。 |
| `IO41` | `0` | `IO38~IO49 / 3.3V` | `unused reserve` | 预留未使用。 |
| `IO42` | `0` | `IO38~IO49 / 3.3V` | `GPIO - PIN` | 普通 GPIO。 |
| `IO43` | `0` | `IO38~IO49 / 3.3V` | `GPIO - PIN` | 普通 GPIO。 |
| `IO44` | `2` | `IO38~IO49 / 3.3V` | `I2C3 TP_SCL` | 触摸面板 `I2C3_SCL`。 |
| `IO45` | `2` | `IO38~IO49 / 3.3V` | `I2C3 TP_SDA` | 触摸面板 `I2C3_SDA`。 |
| `IO46` | `0` | `IO38~IO49 / 3.3V` | `未注明` | 当前 DTS 未标注专用功能，可视作普通 GPIO/保留脚。 |
| `IO47` | `0` | `IO38~IO49 / 3.3V` | `未注明` | 当前 DTS 未标注专用功能，可视作普通 GPIO/保留脚。 |
| `IO48` | `0` | `IO38~IO49 / 3.3V` | `SPEAKER_EN` | 喇叭/功放使能脚，高概率用于功放 `EN/SHDN` 控制。 |
| `IO49` | `0` | `IO38~IO49 / 3.3V` | `未注明` | 当前 DTS 未标注专用功能，可视作普通 GPIO/保留脚。 |
| `IO50` | `0` | `IO50~IO61 / 3.3V` | `未注明` | 当前 DTS 未标注专用功能，可视作普通 GPIO/保留脚。 |
| `IO51` | `0` | `IO50~IO61 / 3.3V` | `未注明` | 当前 DTS 未标注专用功能，可视作普通 GPIO/保留脚。 |
| `IO52` | `0` | `IO50~IO61 / 3.3V` | `未注明` | 当前 DTS 未标注专用功能，可视作普通 GPIO/保留脚。 |
| `IO53` | `2` | `IO50~IO61 / 3.3V` | `BUZZER-PWM5` | 蜂鸣器 PWM 输出脚。 |
| `IO54` | `2` | `IO50~IO61 / 3.3V` | `MMC1 -> TFCARD` | TF 卡接口相关引脚。 |
| `IO55` | `2` | `IO50~IO61 / 3.3V` | `MMC1 -> TFCARD` | TF 卡接口相关引脚。 |
| `IO56` | `2` | `IO50~IO61 / 3.3V` | `MMC1 -> TFCARD` | TF 卡接口相关引脚。 |
| `IO57` | `2` | `IO50~IO61 / 3.3V` | `MMC1 -> TFCARD` | TF 卡接口相关引脚。 |
| `IO58` | `2` | `IO50~IO61 / 3.3V` | `MMC1 -> TFCARD` | TF 卡接口相关引脚。 |
| `IO59` | `2` | `IO50~IO61 / 3.3V` | `MMC1 -> TFCARD` | TF 卡接口相关引脚。 |
| `IO60` | `0` | `IO50~IO61 / 3.3V` | `未注明` | 当前 DTS 未标注专用功能，可视作普通 GPIO/保留脚。 |
| `IO61` | `0` | `IO50~IO61 / 3.3V` | `KEY1` | 按键 `KEY1` 输入脚。 |
| `IO62` | `0` | `IO62~IO63 / 1.8V` | `CAM2_RST` | 摄像头 2 复位脚。注意该 Bank 为 `1.8V`。 |
| `IO63` | `1` | `IO62~IO63 / 1.8V` | `CAM2_MCLK3` | 摄像头 2 时钟 `MCLK3` 输出。注意该 Bank 为 `1.8V`。 |

## 给硬件设计人员的重点提示

- `IO62 ~ IO63` 是 `1.8V Bank`，不要按 `3.3V` 设计。
- `IO48` 在 DTS 中明确标为 `SPEAKER_EN`，建议优先作为功放使能脚参考。
- `IO53` 明确标为 `BUZZER-PWM5`，这是蜂鸣器控制脚，不建议和功放使能混淆。
- 摄像头相关控制脚：
  - `IO7` = `CAMERA2 IIC4-SCL`
  - `IO8` = `CAMERA2 IIC4-SDA`
  - `IO62` = `CAM2_RST`
  - `IO63` = `CAM2_MCLK3`
- 显示和触摸相关控制脚：
  - `IO22` = `LCD_RST`
  - `IO23` = `TP_INT`
  - `IO24` = `TP_RST`
  - `IO25` = `LCD_EN`
- 真正的 `MIPI CSI/DSI` 高速数据信号不在这里以普通 `IOxx` 形式完整展开，仍需结合原理图和 SoC 文档确认。

## 原始文件

- 源文件： [k230_canmv_yahboom.dts](file:///home/ceoifung/work/k230_sdk/src/uboot/uboot/arch/riscv/dts/k230_canmv_yahboom.dts)
