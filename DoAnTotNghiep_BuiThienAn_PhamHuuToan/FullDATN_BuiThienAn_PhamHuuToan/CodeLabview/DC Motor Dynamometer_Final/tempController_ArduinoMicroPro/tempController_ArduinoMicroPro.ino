
#include "MicroPro_timer.h"

#define e_max         512.0


volatile bool F_int0_newValue = false;
uint32_t int0_value = 0, int0_value_old = 0;
uint8_t breakCircuit;

char read_buffer[6];
byte *p_num;
float num_float;

void send_num_float(float send_num_float)
{  
  p_num = (byte*)&send_num_float; 
  Serial.print((char)*(p_num + 3));
  Serial.print((char)*(p_num + 2));
  Serial.print((char)*(p_num + 1));
  Serial.print((char)*p_num);
  Serial.print(';');
}

float split_num_float()
{
  p_num = (byte*)&num_float;
  *(p_num + 3) = read_buffer[0];
  *(p_num + 2) = read_buffer[1];
  *(p_num + 1) = read_buffer[2];
  *p_num = read_buffer[3];
  return num_float;
}

void int0_()
{
  temp_INT0_tim1_ovf_count = INT0_tim1_ovf_count;
  INT0_tim1_ovf_count = 0;
  int0_value = TCNT1;
  F_int0_newValue = true;
}

void setup()
{
  cli();
  
  pinMode(4, INPUT);      
  pinMode(8, OUTPUT);           // Contactor of DC motor/generator

  attachInterrupt(digitalPinToInterrupt(3), int0_, FALLING);
  onBaseTimer();       
  setup_tim1_Inputcapture();    
  setup_tim3_PWM_50Hz_res_40000();
  Serial.begin(500000);
  sei();
}


void loop()
{ 
  if (F_Working_Cycle)
  {
    F_Working_Cycle = false; 
    send_data();
  } 

  if (Serial.available() >= 7)
  {
    switch (Serial.read())
    {
      case 'B': if (Serial.read() == 'C')
                {
                  Serial.readBytes(read_buffer, 5);
                  if (read_buffer[4] == ';')
                  {
                    breakCircuit = (uint8_t)split_num_float();                    
                    if (breakCircuit)
                      digitalWrite(8, HIGH);
                    else
                      digitalWrite(8, LOW);
                  }
                }
    }
  }

  if (F_cap_newValue)
  {
    F_cap_newValue = false;
    f_cap = (float)_Sys_CLK/((float)temp_ICP1_tim1_ovf_count*65536 + cap_value - cap_value_old);
    cap_value_old = cap_value; 
  }

  if (F_int0_newValue)
  {
    F_int0_newValue = false;
    f_int0 = (float)_Sys_CLK/((float)temp_INT0_tim1_ovf_count*65536 + int0_value - int0_value_old);
    int0_value_old = int0_value;  
  }
}

void send_data()
{
  Serial.print("Fm");
  send_num_float(f_cap);
  Serial.print("Fg");
  send_num_float(f_int0);
  Serial.println();
}