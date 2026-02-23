#ifndef QUEUE_H
#define QUEUE_H

#include <stdint.h>

#define QUEUE_MAX_ELEMENTS 4U
/* An estimated max length for a SREC_line */
#define SREC_LINE_MAX_LEN  100U

/* Info required from a queue*/
typedef struct {
    uint8_t data[QUEUE_MAX_ELEMENTS][SREC_LINE_MAX_LEN];
    uint8_t head;
    uint8_t tail;
    uint8_t count;
} SREC_Queue_t;

/* Possible return status after executing function that operates queue*/
typedef enum
{
    QUEUE_OK = 0U,          /* If operation with queue is successful*/
    QUEUE_ERROR = 1U,       /* If operation with queue encounter error */
    QUEUE_STATE_FULL = 2U,  /* If queue is full */
    QUEUE_STATE_NOT_FULL = 3U /* If queue is not full*/
} Queue_Status_t;

void Queue_Init(SREC_Queue_t *q);
Queue_Status_t Queue_Push(SREC_Queue_t *q, const uint8_t *line);
Queue_Status_t Queue_Pop(SREC_Queue_t *q, uint8_t *dest);
Queue_Status_t Queue_IsFull(const SREC_Queue_t *q);

#endif
