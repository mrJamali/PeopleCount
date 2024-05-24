// MADE BY: MOHAMAD REZA JAMALI
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/eeprom.h>
#include <util/delay.h>
#include <stdio.h>
#include "lcd.h"

#define F_CPU 1000000UL

#define LIGHT1 PD6
#define LIGHT2 PD7
#define HEATER PD5
#define COOLER PB0

volatile uint16_t B;
volatile uint16_t N;
volatile uint8_t H;
volatile uint8_t L;
volatile uint16_t C;
uint16_t Sum;
uint8_t S;

void initADC() {
    ADMUX = (1 << REFS0);  // AVCC with external capacitor at AREF pin
    ADCSRA = (1 << ADEN) | (1 << ADPS2) | (1 << ADPS1);  // Enable ADC, Prescaler = 64
}

uint16_t readADC(uint8_t channel) {
    ADMUX = (ADMUX & 0xF8) | (channel & 0x07);  // Select ADC channel with safety mask
    ADCSRA |= (1 << ADSC);  // Start conversion
    while (ADCSRA & (1 << ADSC));  // Wait for conversion to complete
    return ADC;
}

void initPorts() {
    DDRC &= ~(1 << PC3) & ~(1 << PC4);  // Set PC3 and PC4 as inputs
    DDRB &= ~(1 << PB1) & ~(1 << PB2) & ~(1 << PB3);  // Set PB1, PB2, and PB3 as inputs
    DDRD |= (1 << PD7) | (1 << PD6) | (1 << PD5);  // Set PD7, PD6, and PD5 as outputs
    DDRB |= (1 << PB0);  // Set PB0 as output
}

void initEEPROM() {
    B = eeprom_read_word((uint16_t*)2);
    N = eeprom_read_word((uint16_t*)0);
    H = eeprom_read_byte((uint8_t*)4);
    L = eeprom_read_byte((uint8_t*)6);
}

void debounce(volatile uint8_t *port, uint8_t pin, void (*func)()) {
    if (!(*port & (1 << pin))) {
        _delay_ms(50);
        if (!(*port & (1 << pin))) {
            func();
        }
    }
}

void updateDisplay() {
    char buffer[16];
    lcd_clrscr();
    lcd_home();
    snprintf(buffer, 16, "number=%d", B);
    lcd_puts(buffer);
    _delay_ms(500);
    snprintf(buffer, 16, "Temp: %d%cC", C, 0xDF);
    lcd_puts(buffer);
    _delay_ms(500);
}

void checkSensors() {
    debounce(&PINC, PC3, incCount);
    debounce(&PINC, PC4, decCount);
    debounce(&PINB, PB3, numSetting);
}

void incCount() {
    B++;
    eeprom_write_word((uint16_t*)2, B);
}

void decCount() {
    B--;
    eeprom_write_word((uint16_t*)2, B);
}

void numSetting() {
    // Implement number setting logic
}

void controlDevices() {
    if (B > 0) {
        PORTD |= (1 << LIGHT1);
    } else {
        PORTD &= ~(1 << LIGHT1);
    }

    if (B >= N) {
        PORTD |= (1 << LIGHT2);
    } else {
        PORTD &= ~(1 << LIGHT2);
    }

    if (C >= H && B >= N) {
        PORTD |= (1 << HEATER);
    } else if (C < H) {
        PORTD &= ~(1 << HEATER);
    }

    if (C <= L && B >= N) {
        PORTB |= (1 << COOLER);
    } else if (C > L) {
        PORTB &= ~(1 << COOLER);
    }
}

void readTemperature() {
    for (int i = 0; i < 20; i++) {
        C = readADC(5);  // Assume ADC channel 5 is connected to temperature sensor
        Sum += C;
    }
    C = Sum / 20;
    Sum = 0;
}

ISR(INT0_vect) {
    S = 1;
    incCount();
}

ISR(INT1_vect) {
    S = 0;
    decCount();
}

int main(void) {
    initPorts();
    initADC();
    initEEPROM();
    lcd_init(LCD_DISP_ON);
    sei();  // Enable global interrupts

    lcd_clrscr();
    lcd_puts("Passing Counter");
    _delay_ms(2000);
    lcd_clrscr();
    lcd_puts("Made By:");
    _delay_ms(1500);
    lcd_clrscr();
    lcd_home();
    lcd_puts("MOHAMMAD REZA");
    _delay_ms(1500);
    lcd_gotoxy(0, 1);
    lcd_puts("JAMALI");
    _delay_ms(3000);
    lcd_clrscr();

    while (1) {
        readTemperature();
        updateDisplay();
        controlDevices();
        checkSensors();
    }
}
