#ifndef GENJMRI_H
#define GENJMRI_H
#define PROJECT_ROOT C:\Users\jonas\OneDrive\Projects\ModelRailway\genericIOSatellite\LIB
//#define PROJECT_ROOT %SATELLITE_LIB_PATH%

#define TO_STRING(s) #s
#define ABSOLUTE_PATH(root, relative_path) TO_STRING(root\relative_path)
#define RELATIVE_PATH(library) ABSOLUTE_PATH(PROJECT_ROOT, library)
#include RELATIVE_PATH(src\Satelite.h)
#include RELATIVE_PATH(src\Satelite.cpp)

#define LINK_ADDRESS    0
#define LINK_TX_PIN     25
#define LINK_RX_PIN     14
#define RMT_TX_CHAN     2
#define RMT_RX_CHAN     1
#define RMT_TX_MEMBANK  2
#define RMT_RX_MEMBANK  1
#define SCAN_PRIO       20
#define SCAN_CORE       1
#define SCAN_INTERVAL   5

#endif /*GENJMRI_H*/
