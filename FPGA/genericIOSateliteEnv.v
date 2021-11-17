
//Edit these Params to change master frequency or pulselengths, or other timing parameters:
`define	OSCH_FREQ				"66.50"
`define MASTER_CLK_CYC_PER_MS	66500			// `OSCH_FREQ*1000
`define K1_25_PWM_CYC			53200			// `OSCH_FREQ*100000/125
`define K1_25_PWM_STEP			208				// `OSCH_FREQ*100000/(125*256)
`define T1H_CYC					40				//	T1H_NS*`MASTER_CLK_FREQ_M/1000 (600 ns)
`define T0H_CYC					17				//	K0H_NS*`MASTER_CLK_FREQ_M/1000 (250 ns)
`define K800_CYC				83				//	TK800_NS*`MASTER_CLK_FREQ_M/1000 (1250 ns)
`define K800_HALF_CYC			41				// `K800_CYC/2
`define T1HTRES_CYC				28				// (T1H_NS+T0H_NS)/2*`MASTER_CLK_FREQ_M/1000 (425 ns)
`define RESET_CYC				6650			// `RESET_NS*`MASTER_CLK_FREQ_M/1000 (50000 ns)
`define WATCHDOG_TIMEOUT_CYC	33250000		// `WATCHDOG_TIMEOUT_NS*`MASTER_CLK_FREQ_M/1000 (500000000 ns/500ms)
`define K800_NS					1250
`define K800_HALF_NS			625
`define T1H_NS					600
`define T0H_NS					250
`define T1HTRES_NS				425
`define RESET_NS				100000
`define WATCHDOG_TIMEOUT_NS		500000000

// Timing constants for simulation - no need to ever change:
`define K1_25_NS				800000
`define HZ100_NS				10000000
`define MS_NS					1000000
`define US_NS					1000

/*
define WATCHDOG_TIMEOUT_MS		500
define WATCHDOG_TIMEOUT_NS		`WATCHDOG_TIMEOUT_MS*1000000
define WATCHDOG_TIMEOUT_CYC		(`WATCHDOG_TIMEOUT_MS*`MS_NS/1000)*`MASTER_CLK_FREQ_M
define WATCHDOG_WD				
*/
`define NO_ACTUATORS			4
`define CRC_WD					4
`define FEEDBACK_WD				4
`define RESERVED_WD				4
`define MODE_WD					3
`define ACTUATOR_WD				8
`define SENSOR_WD				8

`define FEEDBACK_REMOTECRCERR	0
`define FEEDBACK_WDERR			1

`define COMMAND_ADDR_ZERO		0
`define COMMAND_INVCRC			1
`define COMMAND_ENABLE			2
`define COMMAND_WD_ERR			3