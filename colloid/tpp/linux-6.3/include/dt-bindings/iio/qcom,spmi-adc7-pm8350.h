/* SPDX-License-Identifier: GPL-2.0-only */
/*
 * Copyright (c) 2020, The Linux Foundation. All rights reserved.
 */

#ifndef _DT_BINDINGS_QCOM_SPMI_VADC_PM8350_H
#define _DT_BINDINGS_QCOM_SPMI_VADC_PM8350_H

/* ADC channels for PM8350_ADC for PMIC7 */
#define PM8350_ADC7_REF_GND(sid)			((sid) << 8 | 0x0)
#define PM8350_ADC7_1P25VREF(sid)			((sid) << 8 | 0x01)
#define PM8350_ADC7_VREF_VADC(sid)			((sid) << 8 | 0x02)
#define PM8350_ADC7_DIE_TEMP(sid)			((sid) << 8 | 0x03)

#define PM8350_ADC7_AMUX_THM1(sid)			((sid) << 8 | 0x04)
#define PM8350_ADC7_AMUX_THM2(sid)			((sid) << 8 | 0x05)
#define PM8350_ADC7_AMUX_THM3(sid)			((sid) << 8 | 0x06)
#define PM8350_ADC7_AMUX_THM4(sid)			((sid) << 8 | 0x07)
#define PM8350_ADC7_AMUX_THM5(sid)			((sid) << 8 | 0x08)
#define PM8350_ADC7_GPIO1(sid)				((sid) << 8 | 0x0a)
#define PM8350_ADC7_GPIO2(sid)				((sid) << 8 | 0x0b)
#define PM8350_ADC7_GPIO3(sid)				((sid) << 8 | 0x0c)
#define PM8350_ADC7_GPIO4(sid)				((sid) << 8 | 0x0d)

/* 30k pull-up1 */
#define PM8350_ADC7_AMUX_THM1_30K_PU(sid)		((sid) << 8 | 0x24)
#define PM8350_ADC7_AMUX_THM2_30K_PU(sid)		((sid) << 8 | 0x25)
#define PM8350_ADC7_AMUX_THM3_30K_PU(sid)		((sid) << 8 | 0x26)
#define PM8350_ADC7_AMUX_THM4_30K_PU(sid)		((sid) << 8 | 0x27)
#define PM8350_ADC7_AMUX_THM5_30K_PU(sid)		((sid) << 8 | 0x28)
#define PM8350_ADC7_GPIO1_30K_PU(sid)			((sid) << 8 | 0x2a)
#define PM8350_ADC7_GPIO2_30K_PU(sid)			((sid) << 8 | 0x2b)
#define PM8350_ADC7_GPIO3_30K_PU(sid)			((sid) << 8 | 0x2c)
#define PM8350_ADC7_GPIO4_30K_PU(sid)			((sid) << 8 | 0x2d)

/* 100k pull-up2 */
#define PM8350_ADC7_AMUX_THM1_100K_PU(sid)		((sid) << 8 | 0x44)
#define PM8350_ADC7_AMUX_THM2_100K_PU(sid)		((sid) << 8 | 0x45)
#define PM8350_ADC7_AMUX_THM3_100K_PU(sid)		((sid) << 8 | 0x46)
#define PM8350_ADC7_AMUX_THM4_100K_PU(sid)		((sid) << 8 | 0x47)
#define PM8350_ADC7_AMUX_THM5_100K_PU(sid)		((sid) << 8 | 0x48)
#define PM8350_ADC7_GPIO1_100K_PU(sid)			((sid) << 8 | 0x4a)
#define PM8350_ADC7_GPIO2_100K_PU(sid)			((sid) << 8 | 0x4b)
#define PM8350_ADC7_GPIO3_100K_PU(sid)			((sid) << 8 | 0x4c)
#define PM8350_ADC7_GPIO4_100K_PU(sid)			((sid) << 8 | 0x4d)

/* 400k pull-up3 */
#define PM8350_ADC7_AMUX_THM1_400K_PU(sid)		((sid) << 8 | 0x64)
#define PM8350_ADC7_AMUX_THM2_400K_PU(sid)		((sid) << 8 | 0x65)
#define PM8350_ADC7_AMUX_THM3_400K_PU(sid)		((sid) << 8 | 0x66)
#define PM8350_ADC7_AMUX_THM4_400K_PU(sid)		((sid) << 8 | 0x67)
#define PM8350_ADC7_AMUX_THM5_400K_PU(sid)		((sid) << 8 | 0x68)
#define PM8350_ADC7_GPIO1_400K_PU(sid)			((sid) << 8 | 0x6a)
#define PM8350_ADC7_GPIO2_400K_PU(sid)			((sid) << 8 | 0x6b)
#define PM8350_ADC7_GPIO3_400K_PU(sid)			((sid) << 8 | 0x6c)
#define PM8350_ADC7_GPIO4_400K_PU(sid)			((sid) << 8 | 0x6d)

/* 1/3 Divider */
#define PM8350_ADC7_GPIO4_DIV3(sid)			((sid) << 8 | 0x8d)

#define PM8350_ADC7_VPH_PWR(sid)			((sid) << 8 | 0x8e)

#endif /* _DT_BINDINGS_QCOM_SPMI_VADC_PM8350_H */