#include "HAL_USART.h"
#include "S32K144.h"
#include "QUEUE.h"

#define PIN_TXD 7U
#define PIN_RXD 6U
#define NVIC_ISER1 (*((volatile uint32_t *)0xE000E104u))

static SREC_Queue_t s_rx_queue;

/* Temporary buffer for HAL to store lines sent from SREC from Hercules */
static uint8_t s_isr_temp_buffer[BUFFER_SIZE];
static uint8_t s_isr_index = 0U;

/* Initialize clock for UART*/
void HAL_USART_ClockInit(void)
{
    IP_PCC->PCCn[PCC_LPUART1_INDEX] &= ~PCC_PCCn_PCS_MASK;
    IP_PCC->PCCn[PCC_LPUART1_INDEX] |= PCC_PCCn_PCS(0b001);
    IP_PCC->PCCn[PCC_LPUART1_INDEX] |= PCC_PCCn_CGC_MASK;
    IP_PCC->PCCn[PCC_PORTC_INDEX] |= PCC_PCCn_CGC_MASK;
}

/* Initialize pin for UART*/
void HAL_USART_PinInit(void)
{
    IP_PORTC->PCR[PIN_TXD] |= PORT_PCR_MUX(0b010U);
    IP_PORTC->PCR[PIN_RXD] |= PORT_PCR_MUX(0b010U);
}

/* Initialize UART to get the desired setting*/
void HAL_USART_LPUART_Init(void)
{
    IP_LPUART1->CTRL &= ~(LPUART_CTRL_TE_MASK | LPUART_CTRL_RE_MASK);
    IP_LPUART1->CTRL &= ~LPUART_CTRL_M_MASK;
    IP_LPUART1->CTRL &= ~LPUART_CTRL_M7_MASK;
    IP_LPUART1->CTRL &= ~LPUART_CTRL_PE_MASK;
    IP_LPUART1->STAT &= ~LPUART_STAT_MSBF_MASK;
    /* With this setting, Baudrate is ~115200 baud */
    /* OSR = 9 (Sampling 10x), SBR = 7 */
    IP_LPUART1->BAUD = LPUART_BAUD_OSR(9U) | LPUART_BAUD_SBR(7U);
    IP_LPUART1->CTRL |= LPUART_CTRL_RIE_MASK;
    NVIC_ISER1 = (uint32_t)(1u << 1u);
    IP_LPUART1->CTRL |= LPUART_CTRL_TE_MASK | LPUART_CTRL_RE_MASK;
    Queue_Init(&s_rx_queue);
}

/* Use UART to send a single character*/
void HAL_USART_sendChar(uint8_t c)
{
    while (!(IP_LPUART1->STAT & LPUART_STAT_TDRE_MASK));
    IP_LPUART1->DATA = (uint8_t)c;
}

/* Use UART to send a string*/
void HAL_USART_sendString(const uint8_t *string) { /* Giữ nguyên */
    while (*string != (uint8_t)'\0') {
        HAL_USART_sendChar(*string);
        string++;
    }
}

/* Allow a buffer from upper layer to get line from HAL*/
Queue_Status_t HAL_USART_GetLineFromQueue(uint8_t *buffer) {
    /* Allow upper layer to pop from the queue in HAL without directly
     * interact queue */
    return Queue_Pop(&s_rx_queue, buffer);
}

void LPUART1_RxTx_IRQHandler(void)
{
    uint8_t received_char;

    /* Check if Receive Buffer is Full?*/
    if (IP_LPUART1->STAT & LPUART_STAT_RDRF_MASK)
    {
        received_char = (uint8_t)IP_LPUART1->DATA;

        /* Ignore '\n' since we're only care about '\r\' */
        if (received_char != (uint8_t)'\n')
        {
            /* If encounter \r */
            if (received_char == (uint8_t)'\r')
            {
            	/* End the last element of the line with \0 */
            	s_isr_temp_buffer[s_isr_index] = (uint8_t)'\0';
            	/* Push that string into the temporary buffer*/
                Queue_Push(&s_rx_queue, s_isr_temp_buffer);

                /* Reset index to prepare for a new line */
                s_isr_index = 0U;
            }
            else
            {
                /* Store into the temporary buffer */
                if (s_isr_index < (uint8_t)BUFFER_SIZE - 1U)
                {
                    s_isr_temp_buffer[s_isr_index] = received_char;
                    s_isr_index++;
                }
            }
        }
    }
}
