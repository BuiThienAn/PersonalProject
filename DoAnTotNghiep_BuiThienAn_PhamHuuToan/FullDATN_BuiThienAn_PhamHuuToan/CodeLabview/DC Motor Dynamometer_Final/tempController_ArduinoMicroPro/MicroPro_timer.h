#define _Base_Freq          80000      // Hz
#define _Working_Freq       50       // Hz    
#define _dt                 (1.0/_Working_Freq)     // s    
//-------------------------------------------------------------------------------
#define _Sys_CLK            16000000  // Hz
#define _BaseTimer_CLK      16000000   // Hz
#define _BaseTimer_TOP      (((_BaseTimer_CLK / _Base_Freq)) - 1)
#define _WrkCycle_MAX       (_Base_Freq / _Working_Freq)
//-------------------------------------------------------------------------------
#define _tim1_Prescaler                         1   
#define _tim1_CLK                               (_Sys_CLK / _tim1_Prescaler)   // Hz
#define _tim1_Freq                              1000
#define _tim1_TOP                               65535
#define _tim3_Prescaler                         8   
#define _tim3_CLK                               (_Sys_CLK / _tim3_Prescaler)   // Hz
#define _tim3_Freq                              50
#define _tim3_TOP                               (((_tim3_CLK / _tim3_Freq)) - 1)
#define _SyrenDriverMid                         (0.0015*_tim3_Freq)
#define _SyrenDriverDif                         (0.0005*_tim3_Freq)
#define _ICP1_timeout                           5           // s 
#define _INT0_timeout                           5           // s
#define _ICP1_timeout_ovf_count                 1000  
#define _INT0_timeout_ovf_count                 1000   
//-------------------------------------------------------------------------------
volatile bool F_cap_newValue = false;
volatile uint16_t ICP1_tim1_ovf_count = 0, temp_ICP1_tim1_ovf_count = 0, INT0_tim1_ovf_count = 0, temp_INT0_tim1_ovf_count = 0;
uint32_t cap_value = 0, cap_value_old = 0;
volatile float f_cap, f_int0;

float tim3_cnA_dutycycle = _SyrenDriverMid;
//-------------------------------------------------------------------------------
uint16_t WrkCycle_Counter = _WrkCycle_MAX;
volatile bool F_Working_Cycle = false;
//-------------------------------------------------------------------------------

// base timer Init
//-------------------------------------------------------------------------------
void onBaseTimer()
{
  TCCR0A = 0; TCCR0B = 0; TIMSK0 = 0;   // reset timer0
  TCCR0A |= (1 << WGM01);               // CTC mode, TOP value = OCR0A
  TCCR0B |= (1 << CS00);                // no prescaling
  TIMSK0 |= (1 << OCIE0A);              // Output compare match A interrupt enable 
  OCR0A = _BaseTimer_TOP;               // _Base_Freq 80000 Hz
}
// End of base timer Init
//-------------------------------------------------------------------------------

// base timer ISR
//-------------------------------------------------------------------------------
ISR (TIMER0_COMPA_vect)     
{
  if (!(--WrkCycle_Counter)) 
  {
    WrkCycle_Counter = _WrkCycle_MAX;
    F_Working_Cycle = true;
  }
}
// End of base timer ISR
//-------------------------------------------------------------------------------

// timer 1 Init
//-------------------------------------------------------------------------------
void setup_tim1_Inputcapture()
{
  TCCR1A = 0; TCCR1B = 0; TCCR1C = 0; TIMSK1 = 0;   // reset timer1
  TCCR1B |= (1 << ICES1);                           // Input Capture Rising Edge
  TCCR1B |= (1 << CS10);                            // no prescaling
  TIMSK1 |= (1 << ICIE1)|(1 << TOIE1);              // Input capture interrupt enable + Compare match A interrupt enable
}
// End of timer 1 Init
//-------------------------------------------------------------------------------

// timer 1 overflow ISR
//-------------------------------------------------------------------------------
ISR (TIMER1_OVF_vect)     
{  
  ICP1_tim1_ovf_count++;  
  INT0_tim1_ovf_count++;  
  if (ICP1_tim1_ovf_count > _ICP1_timeout_ovf_count)
    f_cap = 0;
  if (INT0_tim1_ovf_count > _INT0_timeout_ovf_count)
    f_int0 = 0;
}
// End of timer 1 overflow ISR
//-------------------------------------------------------------------------------

// timer 1 input capture ISR
//-------------------------------------------------------------------------------
ISR (TIMER1_CAPT_vect)
{
  temp_ICP1_tim1_ovf_count = ICP1_tim1_ovf_count;
  ICP1_tim1_ovf_count = 0;
  cap_value = ICR1;
  F_cap_newValue = true;
}
// End of timer 1 input capture ISR
//-------------------------------------------------------------------------------

// timer 3 Init
//-------------------------------------------------------------------------------
void setup_tim3_PWM_50Hz_res_40000()
{
  TCCR3A = 0; TCCR3B = 0; TCCR3C = 0; TIMSK3 = 0;                       // reset timer3
  DDRC |= (1 << PC6);                                                   // OCR3A - PC6 OUTPUT PWM (pin 5) 
  TCCR3A |= (1 << WGM31);  TCCR3B |= (1 << WGM32)|(1 << WGM33);         // Fast PWM mode, TOP value = ICR3
  TCCR3A |= (1 << COM3A1);                                              // none-inverting
  TIMSK3 |= (1 << TOIE3);                                               // Overflow interrupt enable 
  TCCR3B |= (1 << CS31);                                                // prescaler = 8
  ICR3 = _tim3_TOP;                                                     // freq 50Hz
  OCR3A = tim3_cnA_dutycycle*(float)_tim3_TOP;
}
// End of timer 3 Init
//-------------------------------------------------------------------------------

// timer 3 overflow ISR
//-------------------------------------------------------------------------------
ISR (TIMER3_OVF_vect)     
{  
  OCR3A = tim3_cnA_dutycycle*(float)_tim3_TOP;
}
// End of timer 3 overflow ISR
//-------------------------------------------------------------------------------