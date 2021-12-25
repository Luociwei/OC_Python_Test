
local HWIO = {}


	print("product is J171a")

	HWIO.critical = "42, 43, 170"

	HWIO.MeasureTable = {
	    ---VT_LIST_FLAT:START---

							PP1V8_S2_MESA_CONN           = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 }, { 41, 0 }, { 40, 0 }, { 39, 0 } }, CH = "AI1", GND = "DUT" ,GAIN = 1},  --PP1V825_S2_MESA_CONN
							PP2V9_CAM				     = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 }, { 41, 0 }, { 40, 0 }, { 39, 1 } }, CH = "AI1", GND = "DUT" ,GAIN = 1},
							PP3V1_S2_MESA_CONN           = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 }, { 41, 0 }, { 40, 1 }, { 39, 0 } }, CH = "AI1", GND = "DUT" ,GAIN = 1},
							PP2V9_AVDD_CAM_REAR_FILT     = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 }, { 41, 0 }, { 40, 1 }, { 39, 1 } }, CH = "AI1", GND = "DUT" ,GAIN = 1},
							PP1V8_S2                     = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 }, { 41, 1 }, { 40, 0 }, { 39, 0 } }, CH = "AI1", GND = "DUT" ,GAIN = 1},
							CONN_DP2_NV                  = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 }, { 41, 1 }, { 40, 0 }, { 39, 1 } }, CH = "AI1", GND = "DUT" ,GAIN = 1},
							CONN_DP2_PV                  = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 }, { 41, 1 }, { 40, 1 }, { 39, 0 } }, CH = "AI1", GND = "DUT" ,GAIN = 1},
							PP1V8_S2_SW3                 = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 }, { 41, 1 }, { 40, 1 }, { 39, 1 } }, CH = "AI1", GND = "DUT" ,GAIN = 1},
							
							SOCHOT0_PMU_TO_SOC_L         = {  IO = { { 152, 0 }, { 43, 1 },{ 42, 0 },{ 41, 0 }, { 40, 0 }, { 39, 0 } }, CH = "AI1", GND = "DUT"   ,GAIN = 1},  --AI1 FOR EVT
							PP1V8_S2_HALL_BUTTON_CONN	 = {  IO = { { 152, 0 }, { 43, 1 },{ 42, 0 },{ 41, 0 }, { 40, 0 }, { 39, 1 } }, CH = "AI1", GND = "DUT"   ,GAIN = 1},
							BATT_SNS	                 = {  IO = { { 152, 0 }, { 43, 1 },{ 42, 0 },{ 41, 0 }, { 40, 1 }, { 39, 0 } }, CH = "AI1", GND = "DUT"   ,GAIN = 1},
							PP1V8_SW1                    = {  IO = { { 152, 0 }, { 43, 1 },{ 42, 0 },{ 41, 0 }, { 40, 1 }, { 39, 1 } }, CH = "AI1", GND = "DUT"   ,GAIN = 1},
							--PP3V0_S2_MISC                = {  IO = { { 43, 1 },{ 42, 0 },{ 41, 1 }, { 40, 0 }, { 39, 0 } }, CH = "AI1", GND = "DUT"   ,GAIN = 1},
							PP1V8_CAM_REAR_FILT          = {  IO = { { 152, 0 }, { 43, 1 },{ 42, 0 },{ 41, 1 }, { 40, 0 }, { 39, 1 } }, CH = "AI1", GND = "DUT"   ,GAIN = 1},
							PP1V25_CAM_REAR_FILT         = {  IO = { { 152, 0 }, { 43, 1 },{ 42, 0 },{ 41, 1 }, { 40, 1 }, { 39, 0 } }, CH = "AI1", GND = "DUT"   ,GAIN = 1},						
							PP2V6_CAM_REAR_AF_FILT       = {  IO = { { 152, 0 }, { 43, 1 },{ 42, 0 },{ 41, 1 }, { 40, 1 }, { 39, 1 } }, CH = "AI1", GND = "DUT"   ,GAIN = 1},  --FOR EVT


							PP1V8_CAM_FRONT_FILT          = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 }, { 41, 0 }, { 40, 0 }, { 39, 0 } }, CH = "AI2", GND = "DUT" ,GAIN = 1},
							PP3V0_S2_TRISTAR              = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 }, { 41, 0 }, { 40, 0 }, { 39, 1 } }, CH = "AI2", GND = "DUT" ,GAIN = 1},
							PPVDD_ACC_FET                 = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 }, { 41, 0 }, { 40, 1 }, { 39, 0 } }, CH = "AI2", GND = "DUT" ,GAIN = 1},
							PP1V8_TOUCH_EXT_SW            = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 }, { 41, 0 }, { 40, 1 }, { 39, 1 } }, CH = "AI2", GND = "DUT" ,GAIN = 1},						
							PP2V8_KONA_M_VDDANA           = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 }, { 41, 1 }, { 40, 0 }, { 39, 0 } }, CH = "AI2", GND = "DUT" ,GAIN = 1},
							PP2V9_AVDD_CAM_FRONT_FILT     = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 }, { 41, 1 }, { 40, 0 }, { 39, 1 } }, CH = "AI2", GND = "DUT" ,GAIN = 1},
							PP3V3_TOUCH_EXT_SW            = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 }, { 41, 1 }, { 40, 1 }, { 39, 0 } }, CH = "AI2", GND = "DUT" ,GAIN = 1},
							PP0V8_S2_SOC_AOP              = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 }, { 41, 1 }, { 40, 1 }, { 39, 1 } }, CH = "AI2", GND = "DUT" ,GAIN = 1},

							DUT_CHECK_GND                 = {  IO = { { 152, 1 }, { 43, 1 },{ 42, 0 },{ 41, 0 }, { 40, 0 }, { 39, 0 } }, CH = "AI2", GND = "DUT"   ,GAIN = 1},  --AI1 FOR EVT
							FREQ_SPKRAMP	              = {  IO = { { 152, 0 }, { 43, 1 },{ 42, 0 },{ 41, 0 }, { 40, 0 }, { 39, 1 } }, CH = "AI2", GND = "DUT"   ,GAIN = 1},
							SPKRAMP_T_AI_OUT              = {  IO = { { 152, 0 }, { 43, 1 },{ 42, 0 },{ 41, 0 }, { 40, 1 }, { 39, 0 } }, CH = "AI2", GND = "DUT"   ,GAIN = 1},
							PP3V3_EXT_SW                  = {  IO = { { 152, 0 }, { 43, 1 },{ 42, 0 },{ 41, 0 }, { 40, 1 }, { 39, 1 } }, CH = "AI2", GND = "DUT"   ,GAIN = 1},
							--XXX                           = {  IO = { { 43, 1 },{ 42, 0 },{ 41, 1 }, { 40, 0 }, { 39, 0 } }, CH = "AI2", GND = "DUT"   ,GAIN = 1},
							GPIO_TO_BOOST_ENABLE_CONN     = {  IO = { { 152, 0 }, { 43, 1 },{ 42, 0 },{ 41, 1 }, { 40, 0 }, { 39, 1 } }, CH = "AI2", GND = "DUT"   ,GAIN = 1},
							PPOUT_E75_ACC_ID1_SENSE       = {  IO = { { 152, 0 }, { 43, 1 },{ 42, 0 },{ 41, 1 }, { 40, 1 }, { 39, 0 } }, CH = "AI2", GND = "DUT"   ,GAIN = 1},						
							PPOUT_E75_ACC_ID2_SENSE       = {  IO = { { 152, 0 }, { 43, 1 },{ 42, 0 },{ 41, 1 }, { 40, 1 }, { 39, 1 } }, CH = "AI2", GND = "DUT"   ,GAIN = 1},  --FOR EVT
                            
							PP1V7_S2_VA_VCP               = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 0 }, { 40, 0 }, { 39, 0 } }, CH = "AI3", GND = "DUT"   ,GAIN = 1},  --AI1 FOR EVT   PP1V8_S2_VA_VCP
							PP3V3_ACC	                  = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 0 }, { 40, 0 }, { 39, 1 } }, CH = "AI3", GND = "DUT"   ,GAIN = 1},
							PP3V3_S2                      = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 0 }, { 40, 1 }, { 39, 0 } }, CH = "AI3", GND = "DUT"   ,GAIN = 1},
							PPBATT_SENSE                  = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 0 }, { 40, 1 }, { 39, 1 } }, CH = "AI3", GND = "DUT"   ,GAIN = 1},
							PP3V0_ALS                     = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 1 }, { 40, 0 }, { 39, 0 } }, CH = "AI3", GND = "DUT"   ,GAIN = 1},
							USB_NV                        = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 1 }, { 40, 0 }, { 39, 1 } }, CH = "AI3", GND = "DUT"   ,GAIN = 1},
							USB_PV                        = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 1 }, { 40, 1 }, { 39, 0 } }, CH = "AI3", GND = "DUT"   ,GAIN = 1},						
							PP1V8_ALWAYS                  = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 1 }, { 40, 1 }, { 39, 1 } }, CH = "AI3", GND = "DUT"   ,GAIN = 1},  --FOR EVT

							CODEC_HP_HS3_REF               = {  IO = { { 152, 0 }, { 43, 1 },{ 42, 0 },{ 41, 0 }, { 40, 0 }, { 39, 1 } }, CH = "AI3", GND = "DUT"   ,GAIN = 1},  --AI1 FOR EVT
							CODEC_HP_HS4_REF	           = {  IO = { { 152, 0 }, { 43, 1 },{ 42, 0 },{ 41, 0 }, { 40, 1 }, { 39, 1 } }, CH = "AI3", GND = "DUT"   ,GAIN = 1},


	                        PPVDD_CPU_SRAM                = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 0 }, { 40, 0 }, { 39, 0 } }, CH = "AI4", GND = "DUT"   ,GAIN = 1},  --AI1 FOR EVT
							PP1V1_S2	                  = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 0 }, { 40, 0 }, { 39, 1 } }, CH = "AI4", GND = "DUT"   ,GAIN = 1},
							PPVDD_CPU                     = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 0 }, { 40, 1 }, { 39, 0 } }, CH = "AI4", GND = "DUT"   ,GAIN = 1},
							GPIO_FORCE_DFU                = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 0 }, { 40, 1 }, { 39, 1 } }, CH = "AI4", GND = "DUT"   ,GAIN = 1},
							PPVCC_MAIN_LCD_SW_CONN        = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 1 }, { 40, 0 }, { 39, 0 } }, CH = "AI4", GND = "DUT"   ,GAIN = 1},
							PPVCC_MAIN                    = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 1 }, { 40, 0 }, { 39, 1 } }, CH = "AI4", GND = "DUT"   ,GAIN = 1},
							TP_GPIO_DFU_STATUS            = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 1 }, { 40, 1 }, { 39, 0 } }, CH = "AI4", GND = "DUT"   ,GAIN = 1},	--TP_SOC_DFU_STATUS					
							PP3V3_USB                     = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 1 }, { 40, 1 }, { 39, 1 } }, CH = "AI4", GND = "DUT"   ,GAIN = 1},  --FOR EVT
	                        
	                        PP1V2_SOC                     = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 0 }, { 40, 0 }, { 39, 0 } }, CH = "AI5", GND = "DUT"   ,GAIN = 1},  --AI1 FOR EVT
							PPVDD_S1_SOC	              = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 0 }, { 40, 0 }, { 39, 1 } }, CH = "AI5", GND = "DUT"   ,GAIN = 1},
							PPVDD_GPU_SRAM                = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 0 }, { 40, 1 }, { 39, 0 } }, CH = "AI5", GND = "DUT"   ,GAIN = 1},
							PP1V2_BUFF                	  = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 0 }, { 40, 1 }, { 39, 1 } }, CH = "AI5", GND = "DUT"   ,GAIN = 1},
							PP1V1_XTAL_1                  = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 1 }, { 40, 0 }, { 39, 0 } }, CH = "AI5", GND = "DUT"   ,GAIN = 1},
							PP1V1_S1_EXT_SW               = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 1 }, { 40, 0 }, { 39, 1 } }, CH = "AI5", GND = "DUT"   ,GAIN = 1},
							PP1V2_PLL_SOC                 = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 1 }, { 40, 1 }, { 39, 0 } }, CH = "AI5", GND = "DUT"   ,GAIN = 1},						
							PPVDD_S1_FIXED                = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 1 }, { 40, 1 }, { 39, 1 } }, CH = "AI5", GND = "DUT"   ,GAIN = 1},  --FOR EVT

	                        PP1V2_PLL_CPU                 = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 0 }, { 40, 0 }, { 39, 0 } }, CH = "AI6", GND = "DUT"   ,GAIN = 1},  --AI1 FOR EVT
							MIKEY_TS_N	                  = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 0 }, { 40, 0 }, { 39, 1 } }, CH = "AI6", GND = "DUT"   ,GAIN = 1},
							MIKEY_TS_P                	  = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 0 }, { 40, 1 }, { 39, 0 } }, CH = "AI6", GND = "DUT"   ,GAIN = 1},
							PPVDD_GPU                	  = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 0 }, { 40, 1 }, { 39, 1 } }, CH = "AI6", GND = "DUT"   ,GAIN = 1},
							PP0V9_NAND                    = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 1 }, { 40, 0 }, { 39, 0 } }, CH = "AI6", GND = "DUT"   ,GAIN = 1},
							BATT_SWI_CONN                 = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 1 }, { 40, 0 }, { 39, 1 } }, CH = "AI6", GND = "DUT"   ,GAIN = 1},
							PP1V8_PHOS_F                  = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 1 }, { 40, 1 }, { 39, 0 } }, CH = "AI6", GND = "DUT"   ,GAIN = 1},						
							PP1V8_EXT_SW1                 = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 1 }, { 40, 1 }, { 39, 1 } }, CH = "AI6", GND = "DUT"   ,GAIN = 1},  --FOR EVT

	                        PP16V0_MESA_CONN              = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 0 }, { 40, 0 }, { 39, 0 } }, CH = "AI7", GND = "DUT"   ,GAIN = 3},  --AI1 FOR EVT
							PPVBUS_SENSE_DUT	          = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 0 }, { 40, 0 }, { 39, 1 } }, CH = "AI7", GND = "DUT"   ,GAIN = 3},
							PPVBUS_USB_RVP                = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 0 }, { 40, 1 }, { 39, 0 } }, CH = "AI7", GND = "DUT"   ,GAIN = 3},
							PPVBUS_USB_FILT               = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 0 }, { 40, 1 }, { 39, 1 } }, CH = "AI7", GND = "DUT"   ,GAIN = 3},
							PPVBUS_ORION_RVP              = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 1 }, { 40, 0 }, { 39, 0 } }, CH = "AI7", GND = "DUT"   ,GAIN = 3},
							PP15V0_TOUCH_FILT             = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 1 }, { 40, 0 }, { 39, 1 } }, CH = "AI7", GND = "DUT"   ,GAIN = 3},
							PPLED_OUT_A                   = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 1 }, { 40, 1 }, { 39, 0 } }, CH = "AI7", GND = "DUT"   ,GAIN = 3},						
							PPLED_OUT_B                   = {  IO = { { 152, 0 }, { 43, 0 },{ 42, 1 },{ 41, 1 }, { 40, 1 }, { 39, 1 } }, CH = "AI7", GND = "DUT"   ,GAIN = 3},  --FOR EVT

	                        PPLED_BACK_REG_A              = {  IO = { { 152, 0 }, { 63, 0 },{ 43, 0 },{ 42, 1 },{ 41, 0 }, { 40, 0 }, { 39, 0 } }, CH = "AI8", GND = "DUT"   ,GAIN = 3},  --AI1 FOR EVT
							PPLED_BACK_REG_B	          = {  IO = { { 152, 0 }, { 63, 0 },{ 43, 0 },{ 42, 1 },{ 41, 0 }, { 40, 0 }, { 39, 1 } }, CH = "AI8", GND = "DUT"   ,GAIN = 3},
							PP_YANGTZE_PMID               = {  IO = { { 152, 0 }, { 63, 0 },{ 43, 0 },{ 42, 1 },{ 41, 0 }, { 40, 1 }, { 39, 0 } }, CH = "AI8", GND = "DUT"   ,GAIN = 3},
							PP_VAR_USB_RVP                = {  IO = { { 152, 0 }, { 63, 0 },{ 43, 0 },{ 42, 1 },{ 41, 0 }, { 40, 1 }, { 39, 1 } }, CH = "AI8", GND = "DUT"   ,GAIN = 3},
							PPVBUS_ORION_SENSE            = {  IO = { { 152, 0 }, { 63, 0 },{ 43, 0 },{ 42, 1 },{ 41, 1 }, { 40, 0 }, { 39, 0 } }, CH = "AI8", GND = "DUT"   ,GAIN = 3},
							PPVBUS_SYS               	  = {  IO = { { 152, 0 }, { 63, 0 },{ 43, 0 },{ 42, 1 },{ 41, 1 }, { 40, 0 }, { 39, 1 } }, CH = "AI8", GND = "DUT"   ,GAIN = 3},
							--XX                   		  = {  IO = { { 63, 0 },{ 43, 0 },{ 42, 1 },{ 41, 1 }, { 40, 1 }, { 39, 0 } }, CH = "AI8", GND = "DUT"   ,GAIN = 3},						
							--XX                          = {  IO = { { 63, 0 },{ 43, 0 },{ 42, 1 },{ 41, 1 }, { 40, 1 }, { 39, 1 } }, CH = "AI8", GND = "DUT"   ,GAIN = 3},  --FOR EVT



      						USB_TARGET_URRENT            = {  IO = { { 152, 1 }, { 63, 1 },{ 43, 0 }, { 42, 1 },  { 41, 0 }, { 40, 0 }, { 39, 0 } }, CH = "AI8", GND = "DUT" ,GAIN = 2},----GAIN=2 FOR EVT

							LED1_CURRENT                 = {  IO = { { 152, 1 }, { 63, 1 },{ 43, 0 }, { 42, 1 },  { 41, 0 }, { 40, 0 }, { 39, 1 } }, CH = "AI8", GND = "DUT" ,GAIN = 0.003853564547 },
							LED2_CURRENT                 = {  IO = { { 152, 1 }, { 63, 1 },{ 43, 0 }, { 42, 1 },  { 41, 0 }, { 40, 1 }, { 39, 0 } }, CH = "AI8", GND = "DUT" ,GAIN = 0.003853564547},
							CODEC_HP_HS3			     = {  IO = { { 152, 0 }, { 63, 1 },{ 43, 0 }, { 42, 1 },  { 41, 0 }, { 40, 1 }, { 39, 1 } }, CH = "AI8", GND = "DUT" ,GAIN = 1},
							CODEC_HP_HS4			     = {  IO = { { 152, 0 }, { 63, 1 },{ 43, 0 }, { 42, 1 },  { 41, 1 }, { 40, 1 }, { 39, 0 } }, CH = "AI8", GND = "DUT" ,GAIN = 1},

							OAB_ELOAD_CURRENT            = {  IO = { { 152, 1 }, { 63, 1 },{ 43, 0 }, { 42, 1 },  { 41, 1 }, { 40, 1 }, { 39, 1 } }, CH = "AI8", GND = "DUT" ,GAIN = 1},
							
       
							LED1_IO1_CURRENT             = {  IO = { { 152, 1 }, { 63, 1 },{ 43, 0 }, { 42, 1 },  { 41, 0 }, { 40, 0 }, { 39, 1 }, { 67, 0 }, { 66, 0 }, { 65, 1 } }, CH = "AI8", GND = "DUT" ,GAIN = 0.2631578947368421}, -- 1/3.8
						    LED1_IO2_CURRENT             = {  IO = { { 152, 1 }, { 63, 1 },{ 43, 0 }, { 42, 1 },  { 41, 0 }, { 40, 0 }, { 39, 1 }, { 67, 0 }, { 66, 1 }, { 65, 0 } }, CH = "AI8", GND = "DUT" ,GAIN = 0.2631578947368421},
							LED1_IO3_CURRENT             = {  IO = { { 152, 1 }, { 63, 1 },{ 43, 0 }, { 42, 1 },  { 41, 0 }, { 40, 0 }, { 39, 1 }, { 67, 0 }, { 66, 1 }, { 65, 1 } }, CH = "AI8", GND = "DUT" ,GAIN = 0.2631578947368421},
							LED1_IO4_CURRENT             = {  IO = { { 152, 1 }, { 63, 1 },{ 43, 0 }, { 42, 1 },  { 41, 0 }, { 40, 0 }, { 39, 1 }, { 67, 1 }, { 66, 0 }, { 65, 0 } }, CH = "AI8", GND = "DUT" ,GAIN = 0.2631578947368421},
							LED1_IO5_CURRENT             = {  IO = { { 152, 1 }, { 63, 1 },{ 43, 0 }, { 42, 1 },  { 41, 0 }, { 40, 0 }, { 39, 1 }, { 67, 1 }, { 66, 0 }, { 65, 1 } }, CH = "AI8", GND = "DUT" ,GAIN = 0.2631578947368421},
							LED1_IO6_CURRENT             = {  IO = { { 152, 1 }, { 63, 1 },{ 43, 0 }, { 42, 1 },  { 41, 0 }, { 40, 0 }, { 39, 1 }, { 67, 1 }, { 66, 1 }, { 65, 0 } }, CH = "AI8", GND = "DUT" ,GAIN = 0.2631578947368421},

							LED2_IO1_CURRENT             = {  IO = { { 152, 1 }, { 63, 1 },{ 43, 0 }, { 42, 1 },  { 41, 0 }, { 40, 1 }, { 39, 0 }, { 70, 0 }, { 69, 0 }, { 68, 1 } }, CH = "AI8", GND = "DUT" ,GAIN = 0.2631578947368421},
							LED2_IO2_CURRENT             = {  IO = { { 152, 1 }, { 63, 1 },{ 43, 0 }, { 42, 1 },  { 41, 0 }, { 40, 1 }, { 39, 0 }, { 70, 0 }, { 69, 1 }, { 68, 0 } }, CH = "AI8", GND = "DUT" ,GAIN = 0.2631578947368421},
							LED2_IO3_CURRENT             = {  IO = { { 152, 1 }, { 63, 1 },{ 43, 0 }, { 42, 1 },  { 41, 0 }, { 40, 1 }, { 39, 0 }, { 70, 0 }, { 69, 1 }, { 68, 1 } }, CH = "AI8", GND = "DUT" ,GAIN = 0.2631578947368421},
							LED2_IO4_CURRENT             = {  IO = { { 152, 1 }, { 63, 1 },{ 43, 0 }, { 42, 1 },  { 41, 0 }, { 40, 1 }, { 39, 0 }, { 70, 1 }, { 69, 0 }, { 68, 0 } }, CH = "AI8", GND = "DUT" ,GAIN = 0.2631578947368421},
							LED2_IO5_CURRENT             = {  IO = { { 152, 1 }, { 63, 1 },{ 43, 0 }, { 42, 1 },  { 41, 0 }, { 40, 1 }, { 39, 0 }, { 70, 1 }, { 69, 0 }, { 68, 1 } }, CH = "AI8", GND = "DUT" ,GAIN = 0.2631578947368421},
							LED2_IO6_CURRENT             = {  IO = { { 152, 1 }, { 63, 1 },{ 43, 0 }, { 42, 1 },  { 41, 0 }, { 40, 1 }, { 39, 0 }, { 70, 1 }, { 69, 1 }, { 68, 0 } }, CH = "AI8", GND = "DUT" ,GAIN = 0.2631578947368421},

							
						    CLK_KONA_M_24MHZ			 = {  IO = { { 152, 0 }, { 155, 0 }, { 154, 0 }, { 153, 1 } }, CH = "Freq_IN", GND = "DUT" ,GAIN = 1},
							PMU_GPIO_CLK_32K_WLAN        = {  IO = { { 152, 0 }, { 155, 0 }, { 154, 1 }, { 153, 0 } }, CH = "Freq_IN", GND = "DUT" ,GAIN = 1},
							CLK_PMU_TO_AOP_32K	         = {  IO = { { 152, 0 }, { 155, 0 }, { 154, 1 }, { 153, 1 } }, CH = "Freq_IN", GND = "DUT" ,GAIN = 1},
							ISP0_CAM_REAR_CLK	         = {  IO = { { 152, 0 }, { 155, 1 }, { 154, 0 }, { 153, 0 } }, CH = "Freq_IN", GND = "DUT" ,GAIN = 1},
							DMIC1_FF_SCLK_FILT	         = {  IO = { { 152, 0 }, { 155, 1 }, { 154, 0 }, { 153, 1 } }, CH = "Freq_IN", GND = "DUT" ,GAIN = 1},
		
							SPKRAMP_L1_OUT_P		 = {  IO = { { 152, 0 }, { 155, 1 }, { 154, 1 }, { 153, 0 },{ 170, 1 }, { 169, 0 }, { 168, 0 }, { 167, 0 } }, CH = "Freq_IN", GND = "DUT" ,GAIN = 1},			
							SPKRAMP_L1_OUT_N		 = {  IO = { { 152, 0 }, { 155, 1 }, { 154, 1 }, { 153, 0 },{ 170, 1 }, { 169, 0 }, { 168, 0 }, { 167, 1 } }, CH = "Freq_IN", GND = "DUT" ,GAIN = 1},			
							SPKRAMP_R1_OUT_P		 = {  IO = { { 152, 0 }, { 155, 1 }, { 154, 1 }, { 153, 0 },{ 170, 1 }, { 169, 0 }, { 168, 1 }, { 167, 0 } }, CH = "Freq_IN", GND = "DUT" ,GAIN = 1},			
							SPKRAMP_R1_OUT_N		 = {  IO = { { 152, 0 }, { 155, 1 }, { 154, 1 }, { 153, 0 },{ 170, 1 }, { 169, 0 }, { 168, 1 }, { 167, 1 } }, CH = "Freq_IN", GND = "DUT" ,GAIN = 1},			
							SPKRAMP_L2_OUT_P		 = {  IO = { { 152, 0 }, { 155, 1 }, { 154, 1 }, { 153, 0 },{ 170, 1 }, { 169, 1 }, { 168, 0 }, { 167, 0 } }, CH = "Freq_IN", GND = "DUT" ,GAIN = 1},			
							SPKRAMP_L2_OUT_N		 = {  IO = { { 152, 0 }, { 155, 1 }, { 154, 1 }, { 153, 0 },{ 170, 1 }, { 169, 1 }, { 168, 0 }, { 167, 1 } }, CH = "Freq_IN", GND = "DUT" ,GAIN = 1},			
							SPKRAMP_R2_OUT_P		 = {  IO = { { 152, 0 }, { 155, 1 }, { 154, 1 }, { 153, 0 },{ 170, 1 }, { 169, 1 }, { 168, 1 }, { 167, 0 } }, CH = "Freq_IN", GND = "DUT" ,GAIN = 1},			
							SPKRAMP_R2_OUT_N		 = {  IO = { { 152, 0 }, { 155, 1 }, { 154, 1 }, { 153, 0 },{ 170, 1 }, { 169, 1 }, { 168, 1 }, { 167, 1 } }, CH = "Freq_IN", GND = "DUT" ,GAIN = 1},			


							DISCONNECT               = {  IO = { { 42, 0 }, { 43, 0 }, { 170,0 } }, CH = "N/A", GND = "DUT" ,GAIN = 1} }
	     ---VT_LIST_FLAT:END---


	HWIO.RelayTable = {
		---IO_LIST_FLAG:START---
		SPKRAMP_CN_ADD_LOAD	 = {        
										CONNECT_LEFT                 = {  IO = { { 158, 0 }, { 159, 1 } } },
										CONNECT_RIGHT                = {  IO = { { 158, 1 }, { 159, 1 } } },
										DISCONNECT                   = {  IO = { { 158, 0 }, { 159, 0 } } } },

		GPIO_HALL_BUTTON_TO_PMU_IRQ = {
										TO_1V8                       = {  IO = { { 172, 1 }, { 176, 0 } } },
										TO_GND                       = {  IO = { { 172, 0 }, { 176, 1 } } },
										DISCONNECT                   = {  IO = { { 172, 0 }, { 176, 0 } } } },
		GPIO_HALL_AJ_TO_IRQ = {
										TO_1V8                       = {  IO = { { 163, 1 }, { 173, 0 } } },  --GPIO_HALL_AJ_TO_PMU_IRQ
										TO_GND						 = {  IO = { { 163, 0 }, { 173, 1 } } },
										DISCONNECT                   = {  IO = { { 163, 0 }, { 173, 0 } } } },
		GPIO_TO_BOOST_ENABLE_CONN = {
										CONNECT                      = {  IO = { { 164, 1 } } },
										DISCONNECT                   = {  IO = { { 164, 0 } } } },

		GND_SENSE = {
										CONNECT                      = {  IO = { { 152, 1 } } },
										DISCONNECT                   = {  IO = { { 152, 0 } } } },	

		SPKAMP_T_COMM_SWITCH = {
										SPKAMP_R_T_OUT               = {  IO = { { 150, 1 } } },
										SPKAMP_L_T_OUT               = {  IO = { { 150, 0 } } } },
		SPKAMP_T_COMM = {
										CONNECT                      = {  IO = { { 151, 1 } } },
										DISCONNECT                   = {  IO = { { 151, 0 } } } },
		SPKAMP_W_COMM_SWITCH = {
										SPKAMP_R_W_OUT               = {  IO = { { 158, 1 } } },
										SPKAMP_L_W_OUT               = {  IO = { { 158, 0 } } } },
		SPKAMP_W_COMM = {
										CONNECT                      = {  IO = { { 159, 1 } } },
										DISCONNECT                   = {  IO = { { 159, 0 } } } },
		E75_DPAIR1 = {					
										TO_USB_HUB					 = {  IO = { { 171, 1 },{ 165, 1 },{ 175, 1 },{ 157, 1 },{ 156, 0 } } },
										TO_E75_CONNECT_Mikey		 = {  IO = { { 171, 1 },{ 165, 1 },{ 175, 0 },{ 130, 0 },{ 129, 1 } } },
										TO_E75_CONNECT_Mikey_SG		 = {  IO = { { 171, 1 },{ 165, 0 },{ 175, 0 },{ 130, 0 },{ 129, 1 } } },
										TO_UUT_PNV_265V				 = {  IO = { { 171, 1 },{ 165, 1 },{ 175, 0 },{ 130, 1 },{ 129, 1 },{ 137, 1 },{ 141, 0 },{ 139, 1 } } },
										TO_UUT_PNV_1V2				 = {  IO = { { 171, 1 },{ 165, 1 },{ 175, 0 },{ 130, 1 },{ 129, 1 },{ 137, 1 },{ 141, 0 },{ 139, 1 } } },
										TO_ADC_PNV				     = {  IO = { { 171, 1 },{ 165, 1 },{ 175, 0 },{ 129, 1 },{ 130, 1 },{ 137, 1 },{ 141, 0 },{ 139, 0 } } },
										DISCONNECT                   = {  IO = { { 171, 0 },{ 165, 0 },{ 175, 1 },{ 129, 0 },{ 130, 0 } } } },
		E75_DPAIR2 = {
										TO_USB_HUB					 = {  IO = { { 171, 1 },{ 166, 0 },{ 157, 0 },{ 156, 1 } } },
										TO_UART						 = {  IO = { { 171, 1 },{ 166, 1 },{ 131, 1 },{ 132, 0 },{ 133, 1 },{ 134, 0 } } },	
										TO_UUT_PNV_265V				 = {  IO = { { 171, 1 },{ 166, 1 },{ 132, 1 },{ 131, 1 },{ 137, 1 },{ 141, 0 },{ 139, 1 } } },
										TO_ADC_PNV				     = {  IO = { { 171, 1 },{ 166, 1 },{ 132, 1 },{ 131, 1 },{ 137, 1 },{ 141, 0 },{ 139, 0 } } },
										DISCONNECT                   = {  IO = { { 171, 0 },{ 132, 0 },{ 131, 0 } } } },

		




		ACCX_PNV_SELECT = {

										TO_UUT_PNV					 = {  IO = { { 141, 1 },{ 139, 0 } } },	
										TO_NV_PV					 = {  IO = { { 141, 1 },{ 139, 1 } } },	
										DISCONNECT                   = {  IO = { { 141, 0 } } } },


        
		BACKLIGHT_POWER = {
										CONNECT                      = {  IO = { { 51, 1 } } },  --PPLED_BACK_REG_B
										DISCONNECT                   = {  IO = { { 51, 0 } } } },




		DP2_P_TO_E75_CC_CON = {
										CONNECT                      = {  IO = { { 169, 1 } } },
										DISCONNECT                   = {  IO = { { 169, 0 } } } },

		UART_SOC_TO_DEBUG = {
										TO_UART                      = {  IO = { { 133, 1 }, { 134, 1 },{ 136, 1 } } },
										DISCONNECT                   = {  IO = { { 133, 1 }, { 134, 0 } } } },

		USB_UUT = {
										CONNECT                      = {  IO = { { 137, 1 } } },
										DISCONNECT                   = {  IO = { { 137, 0 } } } },
		VOL_ID_SEL = {
										CONNECT                      = {  IO = { { 139, 1 } } },
										DISCONNECT                   = {  IO = { { 139, 0 } } } },
		ID1_2_SEL = {
										CONNECT                      = {  IO = { { 138, 1 } } },
										DISCONNECT                   = {  IO = { { 138, 0 } } } },
		UUT_ACC_SEL = {
										CONNECT                      = {  IO = { { 141, 1 } } },
										DISCONNECT                   = {  IO = { { 141, 0 } } } },
		ACC1_ACC2_SEL = {
										CONNECT                      = {  IO = { { 135, 1 } } },
										DISCONNECT                   = {  IO = { { 135, 0 } } } },
		UART_DP2_SEL = {
										CONNECT                      = {  IO = { { 134, 1 } } },
										DISCONNECT                   = {  IO = { { 134, 0 } } } },
		UART_PN_SEL = {
										CONNECT                      = {  IO = { { 133, 1 } } },
										DISCONNECT                   = {  IO = { { 133, 0 } } } },
		UUT_RXD_SEL = {
										CONNECT                      = {  IO = { { 136, 1 } } },
										DISCONNECT                   = {  IO = { { 136, 0 } } } },
		USB_HUB_KIS = {
										CONNECT                      = {  IO = { { 160, 1 } } },
										DISCONNECT                   = {  IO = { { 160, 0 } } } },
		USB_SOC_N_P = {
										CONNECT                      = {  IO = { { 160, 1 } } },
										DISCONNECT                   = {  IO = { { 160, 0 } } } },

		CAL_A = {
										CONNECT                      = {  IO = { { 143, 1 } } },
										DISCONNECT                   = {  IO = { { 143, 0 } } } },
		CAL_HV = {
										CONNECT                      = {  IO = { { 144, 1 } } },
										DISCONNECT                   = {  IO = { { 144, 0 } } } },
		CAL_LV = {
										CONNECT                      = {  IO = { { 140, 1 } } },
										DISCONNECT                   = {  IO = { { 140, 0 } } } },
		BATT_NTC_P = {
										TO_3K3                       = {  IO = { { 47, 0 }, { 46, 1 } } },
										TO_10K                       = {  IO = { { 47, 1 }, { 46, 1 } } },
										TO_33K                       = {  IO = { { 47, 1 }, { 46, 0 } } },
										DISCONNECT                   = {  IO = { { 47, 0 }, { 46, 0 } } } },
		


		GPIO_BTN = {
										ONOFF_L_CONN                 = {  IO = { { 48, 1 }, { 49, 0 }, { 50, 0 }, { 11, 0 }, { 12, 0 } } },--HoldKey GPIO_BTN_ONOFF_L_FILT
										HOME_L_CONN                  = {  IO = { { 48, 0 }, { 49, 1 }, { 50, 0 }, { 11, 0 }, { 12, 0 } } },--home  GPIO_BTN_HOME_CONN_L
										VOL_UP_L_CONN                = {  IO = { { 48, 0 }, { 49, 0 }, { 50, 1 }, { 11, 0 }, { 12, 0 } } },--VolUp=1  GPIO_BTN_VOL_UP_L_FILT
										VOL_DOWN_L_CONN              = {  IO = { { 48, 0 }, { 49, 0 }, { 50, 0 }, { 11, 1 }, { 12, 0 } } },--VolDown  GPIO_BTN_VOL_DOWN_L_FILT
										CODEC_HP_HEADSET_DET_CONN    = {  IO = { { 48, 0 }, { 49, 0 }, { 50, 0 }, { 11, 0 }, { 12, 1 } } },--  CONN_HP_HEADSET_DET_FILT
										DISCONNECT                   = {  IO = { { 48, 0 }, { 49, 0 }, { 50, 0 }, { 11, 0 }, { 12, 0 } } } },	

        
	    ONOFF_L_CONN = {
										CONNECT                      = {  IO = { { 48, 1 } } },
										DISCONNECT                   = {  IO = { { 48, 0 } } } },

		HOME_L_CONN = {
											CONNECT                      = {  IO = { { 49, 1 } } },
											DISCONNECT                   = {  IO = { { 49, 0 } } } },

		VOL_UP_L_CONN = {
											CONNECT                      = {  IO = { { 50, 1 } } },
											DISCONNECT                   = {  IO = { { 50, 0 } } } },


		VOL_DOWN_L_CONN = {
											CONNECT                      = {  IO = { { 11, 1 } } },
											DISCONNECT                   = {  IO = { { 11, 0 } } } },

		CODEC_HP_HEADSET_DET_CONN = {
											CONNECT                      = {  IO = { { 12, 1 } } },
											DISCONNECT                   = {  IO = { { 12, 0 } } } },					
								
		ZYNQ_3V3_TO_3V0 = {
										ENABLE                       = {  IO = { { 60, 1 } } },
										DISABLE                      = {  IO = { { 60, 0 } } } },

		GPIO_FORCE_DFU_1V8 = {
										CONNECT                      = {  IO = { { 44, 1 } } },
										DISCONNECT                   = {  IO = { { 44, 0 } } } },
		E75_ACC_DET_CONN_L = {
										CONNECT                      = {  IO = { { 45, 1 } } },  --CONN_DET_L
										DISCONNECT                   = {  IO = { { 45, 0 } } } },
		GPIO_SOC_TO_MINION_CRESET_L = {
										CONNECT                      = {  IO = { { 64, 1 } } },
										DISCONNECT                   = {  IO = { { 64, 0 } } } },
		

		--PPVBUS_E75_USB_CONN
		PP_VBUS_TO_PWR_IN = {   
										CONNECT                      = {  IO = { { 23, 0 }, { 29, 1 }, { 25, 0 } } },
										DISCONNECT                   = {  IO = { { 23, 0 }, { 29, 0 }, { 25, 0 } } } },
		E75_DPAIR2_P_CHARGE_CC_TO_USB_CC = {
										CONNECT                      = {  IO = { { 26, 1 } } },
										DISCONNECT                   = {  IO = { { 26, 0 } } } },
		PPOUT_E75_ACC_ID1_TO_ACC_ID = {
										CONNECT                      = {  IO = { { 27, 1 } } },
										DISCONNECT                   = {  IO = { { 27, 0 } } } },
		PPOUT_E75_ACC_ID2_TO_ACC_PWR = {
										CONNECT                      = {  IO = { { 28, 1 } } },
										DISCONNECT                   = {  IO = { { 28, 0 } } } },
		PPVBUS_TARGET_TO_GND = {
										CONNECT                      = {  IO = { { 52, 1 } } },
										DISCONNECT                   = {  IO = { { 52, 0 } } } },
		HI5_VCC_TO_5V = {
										CONNECT                      = {  IO = { { 32, 1 } } },
										DISCONNECT                   = {  IO = { { 32, 0 } } } },
		CONN_ACCX = {
										ACC_ID1                      = {  IO = { { 30, 1 } } },
										ACC_ID2                      = {  IO = { { 30, 0 } } } },
		HI5_CONN_ACCX = {
										ZYNQ_HI5        			 = {  IO = { { 31, 1 } } },
										CONN_HI5                     = {  IO = { { 31, 0 } } } },
		HI5_RST = {
										CONNECT                      = {  IO = { { 54, 1 } } },
										DISCONNECT                   = {  IO = { { 54, 0 } } } },
		BANK_SEL = {
										CONNECT                      = {  IO = { { 57, 1 } } },
										DISCONNECT                   = {  IO = { { 57, 0 } } } },


		PPVBUS_USB_CONN_TO = {
										PPVBUS_USB_EMI               = {  IO = { { 23, 1 },{ 25, 0 },{ 29, 0 } } },
										--PP_EXT                       = {  IO = { { 24, 1 },{ 23, 0 },{ 25, 0 },{ 29, 0 },} },
										PP_VBUS                      = {  IO = { { 25, 1 },{ 23, 0 },{ 29, 0 }} },
										--PP_ORION                     = {  IO = { { 17, 1 },{ 19, 1 } } },
										--USB_CHARGE                   = {  IO = { { 23, 0 },{ 24, 0 },{ 25, 1 },{ 29, 0 } } },
										--DISCONN_USB_POWER            = {  IO = { { 23, 0 },{ 24, 0 },{ 25, 0 } } },
										DISCONNECT                   = {  IO = { { 23, 0 },{ 25, 0 },{ 29, 0 } } } },
																		
		-- PPVBUS_USB_CONN_TO_BK = {
		-- 								PPVBUS_USB_EMI               = {  IO = { { 23, 1 },{ 29, 0 },{ 25, 0 },{ 52, 1 } } },
		-- 								PP_EXT                       = {  IO = { { 24, 1 } } },
		-- 								PP_VBUS                      = {  IO = { { 23, 0 },{ 29, 0},{ 25, 1 } } },
		-- 								USB_CHARGE                   = {  IO = { { 23, 0 },{ 29, 1 },{ 25, 0 },{ 24, 0 },{ 52, 0 } } },
		-- 								DISCONNECT                   = {  IO = { { 23, 0 },{ 24, 0 },{ 25, 0 },{ 29, 0 },{ 52, 0 } } } },
		-- VBUS_CUR_MODE_CTL = {   --- control by power board 
		-- 								BIG                          = {  IO = { { 19, 1 } } },
		-- 								SMALL                        = {  IO = { { 19, 0 } } } },
		
		-- PPVBUS_SENSE_DUT_TO_PPVBUS_SENSE = {
		-- 								CONNECT                      = {  IO = { { 51, 1 } } },
		-- 								DISCONNECT                   = {  IO = { { 51, 0 } } } },
		-- PP_5V0_FB = {
		-- 								PPVBUS_SENSE_DUT             = {  IO = { { 53, 1 } } },
		-- 								PP_5V0_TPS_FB                = {  IO = { { 53, 0 } } } },
		VBUS_ORION_USB       = {
										CONNECT                      = {  IO = { { 1, 1 } } },
										DISCONNECT                   = {  IO = { { 1, 0 } } } },
											

		PPVBUS_ORION_CONN    = {
	    								DUT_OAB3                     = {  IO = { { 9, 1 } } },
	    								--VDM                          = {  IO = { { 2, 0 }, { 1, 1 }, { 24, 1 } } },
	    								OAB3                         = {  IO = { { 2, 1 }, { 1, 0 } } },
	    								--CC_LOAD_ENABLE               = {  IO = { { 21, 1} } },
	    								--CC_LOAD_DISABLE              = {  IO = { { 21, 0} } },
	    								CC_LOAD_CONNECT              = {  IO = { { 2, 1} } },
	    								CC_LOAD_DISCONNECT           = {  IO = { { 2, 0 } } },
	    								DISCONNECT                   = {  IO = { { 2, 0 }, { 1, 0 },{ 9, 0} } } },
			
	    ORION_COMM_CONN      = {
	    								CONNECT                      = {  IO = { { 10, 0 } } },
										DISCONNECT                   = {  IO = { { 10, 1 } } } },
		Orion_ADC_Voltage_PWR_GND_150K = {
										CONNECT                      = {  IO = { { 03, 0 }, { 04, 0 }, { 05, 1 } } },
										DISCONNECT                   = {  IO = { { 03, 0 }, { 04, 0 }, { 05, 0 } } } },

		Orion_ADC_Voltage_DATA_GND_150K = {
										CONNECT                      = {  IO = { { 03, 0 }, { 04, 1 }, { 05, 0 } } },
										DISCONNECT                   = {  IO = { { 03, 0 }, { 04, 0 }, { 05, 0 } } } },
		Orion_ADC_Voltage_DATA_PWR_150K = {
										CONNECT                      = {  IO = { { 03, 1 }, { 04, 0 }, { 05, 0 } } },
										DISCONNECT                   = {  IO = { { 03, 0 }, { 04, 0 }, { 05, 0 } } } },




		ELOAD_SWTICH = {
										PPVCC_MAIN                   = {  IO = { { 62, 1 }, { 55, 0 }, { 56, 0 } } },
										PPOUT_E75_ACC_ID1            = {  IO = { { 62, 0 }, { 55, 1 }, { 56, 0 } } },
										PPOUT_E75_ACC_ID2            = {  IO = { { 62, 0 }, { 55, 0 }, { 56, 1 } } },
										DISCONNECT                   = {  IO = { { 62, 0 }, { 55, 0 }, { 56, 0 } } } },

		--CV_Eload on OAB3 enable
		CV_ELOAD_SWITCH = {         
										CONNECT                      = {  IO = { { 6, 1 } } },
										DISCONNECT                   = {  IO = { { 6, 0 } } } },


		ELOAD_CAL = {
										CONNECT                      = {  IO = { { 33, 1 } } },
										DISCONNECT                   = {  IO = { { 33, 0 } } } },
		E75_CC_CON = {
										E75_DPAIR2_P_VDM_CC          = {  IO = { { 61, 1 } } },
										E75_DPAIR2_P_CHARGE_CC       = {  IO = { { 61, 0 } } } },
		MIC_MODE_SW_CTL = {
										 GLOBAL                      = {  IO = { { 36, 1 } } },
										 CHINA                       = {  IO = { { 36, 0 } } } },
		LOOP_EN_CTL = {
										CONNECT                      = {  IO = { { 37, 1 } } },
										DISCONNECT                   = {  IO = { { 37, 0 } } } },
		HPRL_SW_CTL = {
										RIGHT                        = {  IO = { { 38, 1 } } },
										LEFT                         = {  IO = { { 38, 0 } } } },
		HP_LOAD_EN = {
										CONNECT                      = {  IO = { { 34, 1 } } },
										DISCONNECT                   = {  IO = { { 34, 0 } } } },
		MIC_LOAD_EN = {
										CONNECT                      = {  IO = { { 35, 1 } } },
										DISCONNECT                   = {  IO = { { 35, 0 } } } },
															
		HP_GND_CTL = {
										CONNECT                      = {  IO = { { 58, 1 } } },
										DISCONNECT                   = {  IO = { { 58, 0 } } } },

	    MINION_FW_SPI_CTL = {
										CONNECT                      = {  IO = { { 13, 1 } } },
										DISCONNECT                   = {  IO = { { 13, 0 } } } },
        LED_GAIN_SET = {
										Reset                        = {  IO = { { 71, 0 } } },
										X1                           = {  IO = { { 71, 1 },{ 73, 0 },{ 72, 0 } } },
										X10                          = {  IO = { { 71, 1 },{ 73, 0 },{ 72, 1 } } },
										X100                         = {  IO = { { 71, 1 },{ 73, 1 },{ 72, 0 } } },
										X1000                        = {  IO = { { 71, 1 },{ 73, 1 },{ 72, 1 } } } },

		VDM_OUTPUT_TO_DUT_VBUS = {
									    CONNECT                      = {  IO = { { 19, 0 }, { 25, 1 }, { 23, 0 },{ 29, 0 } } },
										DISCONNECT                   = {  IO = { { 19, 0 }, { 25, 0 }, { 23, 0 },{ 29, 0 } } } },

        PPVCC_MAIN_DISCHARGE   = {
										CONNECT                      = {  IO = { { 174, 1 } } },
										DISCONNECT                   = {  IO = { { 174, 0 } } } },

        PPVBATT_DISCHARGE     = {
										CONNECT                      = {  IO = { { 162, 1 } } },
										DISCONNECT                   = {  IO = { { 162, 0 } } } },



	    PPVBUS_DISCHARGE     = {
										CONNECT                      = {  IO = { { 161, 1 } } },
										DISCONNECT                   = {  IO = { { 161, 0 } } } },
	    DISCHARGE_ALL     = {
										CONNECT                      = {  IO = { { 161, 1 }, { 162, 1 }, { 174, 1 } } },
										DISCONNECT                   = {  IO = { { 161, 0 }, { 162, 0 }, { 174, 0 } } } },								
		

 		PDM_CONN   = {
										CONNECT                      = {  IO = { { 59, 1 } } },  --DMIC1_FF_SD_FILT_1_UUT
										DISCONNECT                   = {  IO = { { 59, 0 } } } } }										

   


---IO_LIST_FLAG:END---
return HWIO
