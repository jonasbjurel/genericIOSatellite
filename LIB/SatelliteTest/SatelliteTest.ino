 /*==============================================================================================================================================*/
/* License                                                                                                                                      */
/*==============================================================================================================================================*/
// Copyright (c)2021 Jonas Bjurel (jonas.bjurel@hotmail.com)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law and agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
/*==============================================================================================================================================*/
/* END License                                                                                                                                  */
/*==============================================================================================================================================*/

/*==============================================================================================================================================*/
/* Description                                                                                                                                  */
/*==============================================================================================================================================*/
//
//
/*==============================================================================================================================================*/
/* END Description                                                                                                                              */
/*==============================================================================================================================================*/

/*==============================================================================================================================================*/
/* Include files                                                                                                                                */
/*==============================================================================================================================================*/
#include "SatelliteTest.h"

/*==============================================================================================================================================*/
/* END Include files*/
/*==============================================================================================================================================*/

satelliteLink* satLink;
satellite* satellites[MAX_NO_OF_SAT_PER_CH];
bool drain[MAX_NO_OF_SAT_PER_CH];
SemaphoreHandle_t methodAccessCnt[MAX_NO_OF_SAT_PER_CH];

uint8_t noOfSat = 0;
uint8_t actVal;
uint16_t timeCnt = 0;
char* reportBuff;


void newSensorVal(satellite* satellite_p, uint8_t linkAddr_p, uint8_t satAddr_p, uint8_t senseAddr_p, bool state_p, void* metadata_P) {
  assert(state_p == satellite_p->getSenseVal(senseAddr_p));
  Serial.printf("Sensor %d:%d:%d changed value to %s\n", linkAddr_p, satAddr_p, senseAddr_p, state_p ? "Active" : "Inactive");
}

void newSatState(satellite* satellite_p, uint8_t linkAddr_p, uint8_t satAddr_p, satOpState_t opState_p, void* DUMMY) {
  char opStateStr[30];

  assert(opState_p == satellite_p->getOpState());
  opStateToStr(opState_p, opStateStr, 30);
  opStateStr[29] = '\0';
  Serial.printf("Satellite %d:%d changed opState to %s\n", linkAddr_p, satAddr_p, opStateStr);
}

void newSatLinkState(satelliteLink* satelliteLink_p, uint8_t linkAddr_p, satOpState_t opState_p, void* DUMMY) {
  char opStateStr[30];

  assert(opState_p == satLink->getOpState());
  opStateToStr(opState_p, opStateStr, 30);
  opStateStr[29] = '\0';
  Serial.printf("SatelliteLink %d: changed opState to %s\n", linkAddr_p, opStateStr);
}


void satdiscovered(satellite* satellite_p, uint8_t linkAddr_p, uint8_t satAddr_p, bool exists_p, void* DUMMY){
satErr_t rc;

  Serial.printf("GOT A DISCOVER CALLBACK\n");
  if (exists_p){
    satellites[satAddr_p] = satellite_p;
    noOfSat++;
    drain[satAddr_p] = false;
    Serial.printf("Satellite with address %d discovered, %d discovered satellites\n", satAddr_p, noOfSat);
    if(satellite_p == NULL){
      Serial.printf("Unexpected error - No reference to Satellite %d, breaking\n", satAddr_p);
      assert(false);
    }
    //assert(noOfSat == satLink->getSatLinkNoOfSats());
    assert(linkAddr_p == satLink->getAddress());
    assert(satellite_p == satLink->getsatHandle(satAddr_p));
    satellites[satAddr_p]->satRegSenseCb(&newSensorVal, NULL);
    satellites[satAddr_p]->satRegStateCb(&newSatState, NULL);
    Serial.printf("Registered sensor callback for Satellite %d\n", satAddr_p);
    satellites[satAddr_p]->setSatActMode(SATMODE_PWM1_25K, 0);
    satellites[satAddr_p]->setSatActMode(SATMODE_PWM100, 1);
    satellites[satAddr_p]->setSatActMode(SATMODE_PULSE, 2);
    satellites[satAddr_p]->setSatActMode(SATMODE_PULSE_INV, 3);
    Serial.printf("Set actuator modes for Satellite %d\n", satAddr_p);
    for(uint8_t i = 0; i < NO_OF_ACT; i++)
      satellites[satAddr_p]->setSatActVal(0, i);
    satellites[satAddr_p]->setSenseFilter(5000, 7); // Set filter value 5 seconds for Sensor 7 - default for the rest
    satellites[satAddr_p]->setErrTresh(10, 1);
    Serial.printf("Set initial actuator values for Satellite %d\n", satAddr_p);
    /*rc = satellites[satAddr_p]->enableSat();
    if(rc){
      Serial.printf("Failed to enable satellite %d, return code %x\n", satAddr_p, rc);
      assert(rc == 0);
    }
    satellites[satAddr_p]->clearSatStats();
    Serial.printf("Enabled Satellite %d\n", satAddr_p);
    */
    return;
  }
  else {
    satellites[satAddr_p] = NULL;
    if (noOfSat)
        noOfSat--;
    drain[satAddr_p] = true;
    while (uxSemaphoreGetCount(methodAccessCnt[satAddr_p]))
      vTaskDelay(1 / portTICK_PERIOD_MS);
    Serial.printf("Satellite with address %d deleted, %d discovered satellites\n", satAddr_p, noOfSat);
    return;
  }  
}

void selfTestRes(satellite* satHandle_p, uint8_t satLinkAddr_p, uint8_t satAddr_p, satErr_t err_p){
  Serial.printf("Selftest of satellite %d:%d ended with result code %x\n", satLinkAddr_p, satAddr_p, err_p);
  assert (err_p == 0);
}
/*==============================================================================================================================================*/
/* ARDUINO: setup                                                                                                                               */
/* Purpose:                                                                                                                                     */
/* Methods:                                                                                                                                     */
/* Data structures:                                                                                                                             */
/*==============================================================================================================================================*/
void setup() {
  satErr_t rc;
  
  // put your setup code here, to run once:
  Serial.begin(115200);
  for (uint8_t i = 0; i < MAX_NO_OF_SAT_PER_CH; i++){
    satellites[i] = NULL;
    drain[i] = true;
    methodAccessCnt[i] = xSemaphoreCreateCounting(255,0);
    if (methodAccessCnt[i] == NULL){
      Serial.printf("Failed to create semaphore\n");
      assert(false);
    }
  }
  
  satLink = new satelliteLink(LINK_ADDRESS, (gpio_num_t)LINK_TX_PIN, (gpio_num_t)LINK_RX_PIN, (rmt_channel_t) RMT_TX_CHAN, (rmt_channel_t)RMT_RX_CHAN, RMT_TX_MEMBANK, RMT_RX_MEMBANK, SCAN_PRIO, SCAN_CORE, SCAN_INTERVAL);
  satLink->satLinkRegSatDiscoverCb(&satdiscovered, NULL); 
  rc = satLink->enableSatLink();
  if(rc){
    Serial.printf("Failed to enable link, return code %x\n", rc);
    assert(rc == 0);
  }
  int t = 0;
  while (satLink->getOpState() & SAT_OP_INIT) {
      vTaskDelay(50 / portTICK_PERIOD_MS);
      assert(t < 400 && "Link wasnt enable in due time");
      t++;
  }
  if (!satLink->getOpState() == SAT_OP_WORKING){
      Serial.printf("SatLink not Working as expected, OpState: %i\n", satLink->getOpState());
      assert(false);
  }
  for (uint8_t i = 0; i < noOfSat; i++) {
      rc = satellites[i]->enableSat();
      if (rc) {
          Serial.printf("Failed to enable sat-%i, return code %x\n", i, rc);
          assert(rc == 0);
      }
  }
  satLink->satLinkRegStateCb(&newSatLinkState, NULL);
  satLink->setErrTresh(20, 2);
  Serial.printf("Satellite Link enabled\n");
  actVal = 0;
  reportBuff = (char*)malloc(2000);
}


/*==============================================================================================================================================*/
/* END setup                                                                                                                                    */
/*==============================================================================================================================================*/



/*==============================================================================================================================================*/
/* ARDUINO: loop                                                                                                                                */
/* Purpose:                                                                                                                                     */
/* Methods:                                                                                                                                     */
/* Data structures:                                                                                                                             */
/*==============================================================================================================================================*/
int loopcnt = 0;
void loop() {
  uint16_t buffPointer;
  satPerformanceCounters_t satLinkStats, satStats;
  satErr_t rc;
  Serial.printf("Test Loop Count: %i\n", loopcnt);
  
  if(loopcnt == 45){
    for (uint8_t i = 0; i < MAX_NO_OF_SAT_PER_CH; i++) {
      if (!drain[i] && satellites[i] != NULL){
        xSemaphoreGive(methodAccessCnt[i]);
        uint8_t rc;
        Serial.printf("Starting self-test for satellite %d\n", i);
        while(satellites[i]->satSelfTest(&selfTestRes) == SAT_ERR_BUSY_ERR){
          Serial.printf("Selftest was busy for satellite %d - waiting\n", i);
          vTaskDelay(50 / portTICK_PERIOD_MS);
          for (uint8_t j = 0; j < MAX_NO_OF_SAT_PER_CH; j++){
            if (!drain[j] && satellites[j] != NULL){
              xSemaphoreGive(methodAccessCnt[j]);
              satellites[j]->setSatActVal(10, 2);
              satellites[j]->setSatActVal(10, 3);
              xSemaphoreTake(methodAccessCnt[j], portMAX_DELAY);
            }
          }
        }
        assert(rc == SAT_OK);
        xSemaphoreTake(methodAccessCnt[i], portMAX_DELAY);
      }
    }
  }

  if(loopcnt == 90){
    Serial.printf("Disabling all satellites\n");
    for(uint8_t i = 0; i < MAX_NO_OF_SAT_PER_CH; i++) {
      if (!drain[i] && satellites[i] != NULL){
        xSemaphoreGive(methodAccessCnt[i]);
        rc = satellites[i]->disableSat();
        xSemaphoreTake(methodAccessCnt[i], portMAX_DELAY);
        if(rc){
          Serial.printf("Failed to disable satellite %d, return code %x\n", i, rc);
          assert(rc == 0);
        }
      } 
    }
  }

  if(loopcnt == 180){
    Serial.printf("Re-enabling all satellites\n");
    for(uint8_t i = 0; i < MAX_NO_OF_SAT_PER_CH; i++) {
      if (!drain[i] && satellites[i] != NULL){
        xSemaphoreGive(methodAccessCnt[i]);
        rc = satellites[i]->enableSat();
        xSemaphoreTake(methodAccessCnt[i], portMAX_DELAY);
        if(rc){
          Serial.printf("Failed to disable satellite %d, return code %x\n", i, rc);
          assert(rc == 0);
        }
      } 
    }
  }
 
  if(loopcnt == 270){
    Serial.printf("disabling satellite Link\n");
    for(uint8_t i = 0; i < MAX_NO_OF_SAT_PER_CH; i++) {
      if (!drain[i] && satellites[i] != NULL){
        rc = satellites[i]->disableSat();
        if(rc){
          Serial.printf("Failed to disable satellite %d, return code %x\n", i, rc);
          assert(rc == 0);
        }
      } 
    }
    rc = satLink->disableSatLink();
    if(rc){
      Serial.printf("Failed to disable link, return code %x\n", rc);
      assert(rc == 0);
    }
  }
  if(loopcnt == 360){
    Serial.printf("Re-enabling satellite Link\n");
    rc = satLink->enableSatLink();
    if(rc){
      Serial.printf("Failed to enable link, return code %x\n", rc);
      assert(rc == 0);
    }
    int t = 0;
    while (satLink->getOpState() & SAT_OP_INIT) {
        vTaskDelay(50 / portTICK_PERIOD_MS);
        assert(t < 400 && "Link wasnt enable in due time");
        t++;
    }
    if (!satLink->getOpState() == SAT_OP_WORKING){
        Serial.printf("SatLink not Working as expected, OpState: %i\n", satLink->getOpState());
        assert(false);
    }
    for (uint8_t i = 0; i < MAX_NO_OF_SAT_PER_CH; i++) {
        if (!drain[i] && satellites[i] != NULL) {
            rc = satellites[i]->enableSat();
            if (rc) {
                Serial.printf("Failed to enable satellite %i, return code %x\n", i, rc);
                assert(rc == 0);
            }
        }
    }
  }
  for(uint8_t i = 0; i < MAX_NO_OF_SAT_PER_CH; i++) {
    if (!drain[i] && satellites[i] != NULL){
      //Serial.printf("Updating values - inverse values for even and odd satellites");
      xSemaphoreGive(methodAccessCnt[i]);
      satellites[i]->setSatActVal(i % 2 ? actVal:(255 - actVal), 0);
      satellites[i]->setSatActVal(i % 2 ? actVal:(255 - actVal), 1);
      satellites[i]->setSatActVal(i % 2 ? actVal:(255 - actVal), 2);
      satellites[i]->setSatActVal(i % 2 ? actVal:(255 - actVal), 3);
      xSemaphoreTake(methodAccessCnt[i], portMAX_DELAY);
    }
  }
  actVal ++;
  if(timeCnt >= 30){
    timeCnt = 0;
    buffPointer = 0;
    Serial.printf("Actuator value for even Actuators:%d - and for odd Actuators:%d\n", 255-actVal, actVal);
    satLink->getSatStats(&satLinkStats, false); 
    formatSatStat(reportBuff, 2000, &buffPointer, buffPointer, satLink->getAddress(), 0, satLink->getAdmState(), 
                  satLink->getOpState(), &satLinkStats,
                  LINK_ADDR|SAT_ADDR|RX_SIZE_ERR|RX_SYMB_ERR|TIMING_VIOLATION_ERR|RX_CRC_ERR|REMOTE_CRC_ERR|WATCHDG_ERR|ADM_STATE|OP_STATE,
                  LINK_ADDR|RX_SIZE_ERR|RX_SYMB_ERR|TIMING_VIOLATION_ERR|RX_CRC_ERR|REMOTE_CRC_ERR|WATCHDG_ERR|ADM_STATE|OP_STATE,
                  true);
 
    for(uint8_t i = 0; i < noOfSat; i++){
      if (!drain[i] & satellites[i] != NULL){
          Serial.printf(">>>>>>>>> i: %i\n", i);
        xSemaphoreGive(methodAccessCnt[i]);
        satellites[i]->getSatStats(&satStats, false);
        formatSatStat(reportBuff, 2000, &buffPointer, buffPointer, satLink->getAddress(), satellites[i]->getAddress(), 
                      satellites[i]->getAdmState(), satellites[i]->getOpState(), &satStats, 
                      LINK_ADDR|SAT_ADDR|RX_SIZE_ERR|RX_SYMB_ERR|TIMING_VIOLATION_ERR|RX_CRC_ERR|REMOTE_CRC_ERR|WATCHDG_ERR|ADM_STATE|OP_STATE,
                      LINK_ADDR|SAT_ADDR|RX_CRC_ERR|REMOTE_CRC_ERR|WATCHDG_ERR|ADM_STATE|OP_STATE,
                      false);
        xSemaphoreTake(methodAccessCnt[i], portMAX_DELAY);
      } 
    }
    Serial.printf("%s",reportBuff);
    if(!((loopcnt > 90 && loopcnt < 180) || (loopcnt > 270 && loopcnt < 360))){
        Serial.printf("Disable all satellites\n");
        for (uint8_t i = 0; i < noOfSat; i++) {
            assert(!satellites[i]->disableSat());
        }
        Serial.printf("All satellites disabled\n");
        Serial.printf("Disable satLink\n");
        assert(!satLink->disableSatLink());
        Serial.printf("satLink Disabled\n");
        Serial.printf("Enable satLink\n");
        assert(!satLink->enableSatLink());
        int t = 0;
        while (satLink->getOpState() & SAT_OP_INIT) {
            vTaskDelay(50 / portTICK_PERIOD_MS);
            assert(t < 400 && "Link wasnt enable in due time");
            t++;
        }
        if (!satLink->getOpState() == SAT_OP_WORKING) {
            Serial.printf("SatLink not Working as expected, OpState: %i\n", satLink->getOpState());
            assert(false);
        }
        Serial.printf("satLink Enabled\n");
        Serial.printf("Enable all satellites\n");
        for (uint8_t i = 0; i < noOfSat; i++) {
            assert(!satellites[i]->enableSat());
        }
        Serial.printf("All satellites Adm-deblocked\n");
    }
  }
  else {
    timeCnt++;
  }
  loopcnt++;
  vTaskDelay(300 / portTICK_PERIOD_MS);
}
/*==============================================================================================================================================*/
/* END loop                                                                                                                                     */
/*==============================================================================================================================================*/
