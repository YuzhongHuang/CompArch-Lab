/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/
 
/*
* spi_tester.c: Will test send/receive functions of SPI module
*
* This application configures UART 16550 to baud rate 9600.
* PS7 UART (Zynq) is not initialized by this application, since
* bootrom/bsp configures it to baud rate 115200
*
* ------------------------------------------------
* | UART TYPE   BAUD RATE                        |
* ------------------------------------------------
*   uartns550   9600
*   uartlite    Configurable only in HW design
*   ps7_uart    115200 (configured by bootrom/bsp)
*/
#define SPI_DEVICE_ID                                XPAR_SPI_0_DEVICE_ID
#define GPIO_DEVICE_ID                            XPAR_AXI_GPIO_0_DEVICE_ID
#define LED_CHANNEL                                 0x1
 
#include <stdio.h>
#include "platform.h"
#include "xparameters.h"
#include "xspi.h"
#include "xgpio.h"
#include "xil_printf.h"
 
static XSpi SpiInstance;
static XGpio GpioInstance;
 
int init_spi(XSpi *SpiInstancePtr);
void spi_write(XSpi *SpiInstancePtr, u8 addr, u8 value);
u8 spi_read(XSpi *SpiInstancePtr, u8 addr);
int init_gpio(XGpio *GpioInstancePtr);
void delay(int n);
 
int main()
{
                xil_printf("Program Started\n\r");
    init_platform();
    init_spi(&SpiInstance);
    init_gpio(&GpioInstance);
 
    u8 LED_data = 0x1;
    XGpio_DiscreteWrite(&GpioInstance, LED_CHANNEL, LED_data);
    xil_printf("Tess started.\n\r");
    LED_data |= 0x1<<1;
    XGpio_DiscreteWrite(&GpioInstance, LED_CHANNEL, LED_data);
 
    
    u8 res;
    int i, j;
    int pass = 1;

    // test 1, exhaustive test
    for (i = 0; i < 128; i++) { // write to all the addresses
        for (j = 0; j < 256; j++) { // write all the possible values
            spi_write(&SpiInstance, i, j); // write to certain address
            res = spi_read(&SpiInstance, i); // read to see if the value is correct or not
            if (res != j) { // test shall not pass when read value is unexpected
                pass = 0; 
            }
        }
    }    

    // test 2, write all and read all exhaustive test
    for (i = 0; i < 128; i++) { 
    // loop through all the addresses and assign value equal to its address
    // and therefore make the value unique
        spi_write(&SpiInstance, i, i);
    }  

    for (i = 0; i < 128; i++) {
        res = spi_read(&SpiInstance, i); // read to see if the value is correct or not
            if (res != i) { // test shall not pass when read value is unexpected
                pass = 0; 
            }
    }         

    LED_data |= 0x1<<2;
    xil_printf("Tests complete. Please review results.\n\r");
 
    XGpio_DiscreteWrite(&GpioInstance, LED_CHANNEL, LED_data);
    LED_data |= 0x1<<3;
   XGpio_DiscreteWrite(&GpioInstance, LED_CHANNEL, LED_data);
    cleanup_platform();
    return 0;
}
 
void spi_write(XSpi *SpiInstancePtr, u8 addr, u8 value){
                u8 sendBuffer[2];
                sendBuffer[0] = addr << 1; // left shift buffer by 1 and append with 0
                sendBuffer[1] = value;
 
                XSpi_Transfer(SpiInstancePtr, sendBuffer, NULL, 2);
}
 
u8 spi_read(XSpi *SpiInstancePtr, u8 addr){
                u8 recvBuffer[2];
                u8 sendBuffer[2];
                sendBuffer[0] = (addr << 1) | 1; // left shift buffer by 1 and append with 0
 
                XSpi_Transfer(SpiInstancePtr, sendBuffer, recvBuffer, 2);
 
                return recvBuffer[1];
}
 
int init_gpio(XGpio *GpioInstancePtr){
                int Status;
                Status = XGpio_Initialize(GpioInstancePtr, GPIO_DEVICE_ID);
                if (Status != XST_SUCCESS) {
                                return XST_FAILURE;
                }
                XGpio_SetDataDirection(GpioInstancePtr, LED_CHANNEL, 0x0);
                return XST_SUCCESS;
}
 
int init_spi(XSpi *SpiInstancePtr){
                int Status;
                XSpi_Config *ConfigPtr;                /* Pointer to Configuration data */
 
                ConfigPtr = XSpi_LookupConfig(SPI_DEVICE_ID);
                if (ConfigPtr == NULL) {
                                return XST_DEVICE_NOT_FOUND;
                }
                Status = XSpi_CfgInitialize(SpiInstancePtr, ConfigPtr,
                                                                  ConfigPtr->BaseAddress);
                if (Status != XST_SUCCESS) {
                                return XST_FAILURE;
                }
                Status = XSpi_SelfTest(SpiInstancePtr);
                if (Status != XST_SUCCESS) {
                                return XST_FAILURE;
                }
                if (SpiInstancePtr->SpiMode != XSP_STANDARD_MODE) {
                                return XST_SUCCESS;
                }
                Status = XSpi_SetOptions(SpiInstancePtr, XSP_MASTER_OPTION);
                if (Status != XST_SUCCESS) {
                                return XST_FAILURE;
                }
                XSpi_Start(SpiInstancePtr);
                XSpi_IntrGlobalDisable(SpiInstancePtr);
                return XST_SUCCESS;
}
 
void delay(int n){
                int i;
                volatile int k;
                for(i = 0; i < n; i++){
                                k++;
                }
}