# PeopleCount
**Project Title:**
**Development of an Energy Optimization Device and People Counter with Temperature and Light Control**


![Bachelorarbeit](https://github.com/mrJamali/PeopleCount/assets/96734284/ef39cb6e-a5d7-4ddd-8801-9cec3f3d1759)


The use of four IR sensors (two pairs) helps accurately determine the direction of movement. The sensors are connected to the microcontroller, which processes the signals to update the people count. The sequence of beam interruption allows the system to differentiate between entry and exit, ensuring accurate tracking of the number of people in the room.
By implementing this setup, the microcontroller can reliably detect and count people entering and exiting, thus enabling efficient control of lighting and temperature based on the room's occupancy.

### Objective:
The aim of this project is to design and implement a system that optimizes energy consumption by controlling lighting and heating/cooling based on the number of people present in a room and the ambient temperature.
![Schematics](https://github.com/mrJamali/PeopleCount/assets/96734284/3b4a4c40-1b2c-4f30-87ac-04481090d7f6)
[Uploading Jamlai1.PrjPcb…]()   
### System Components:

1. **Microcontroller:**
   - **Type:** AVR ATmega32
   - **Role:** Central processing unit for the system, handling inputs from sensors and controlling outputs to relays and displays.

2. **Infrared (IR) Sensors:**
   - **Transmitters:** 2 IR LEDs (infrared light emitters)
   - **Receivers:** 2 IR photodiodes (infrared light detectors)
   - **Function:** Detect the presence of people by sensing the interruption of the IR beam.

3. **Temperature Sensor:**
   - **Type:** Analog or digital temperature sensor (e.g., LM35 for analog)
   - **Function:** Measure the ambient temperature and provide data to the microcontroller for temperature control.

4. **Relays:**
   - **Number:** 4 Relays
     - **Lighting Control:** 2 relays for controlling two sets of lights.
     - **HVAC Control:** 2 relays for controlling heating and cooling devices.
   - **Role:** Act as switches to turn on/off the connected electrical devices based on the microcontroller's signals.

5. **Display:**
   - **Type:** LCD (Liquid Crystal Display)
   - **Function:** Display the current number of people in the room and the ambient temperature.

6. **Power Supply:**
   - Provides the necessary voltage and current for the microcontroller, sensors, relays, and display.

### Circuit Design:

1. **Microcontroller Connections:**
   - **IR Receivers:** Connected to input pins (e.g., `PINC0`, `PINC1` for entrance; `PINC2`, `PINC3` for exit).
   - **Temperature Sensor:** Connected to an ADC pin for analog temperature sensors or a digital input pin for digital sensors.
   - **Relays:** Connected to output pins (e.g., `PORTB0`, `PORTB1` for lighting relays; `PORTB2`, `PORTB3` for HVAC relays).
   - **Display:** Connected to appropriate pins for data transfer and control (e.g., `PORTD` for data lines and control signals).

2. **Relay Configuration:**
   - **Lighting Relays:**
     - Relay 1 (LIGHT1): Controls the first set of lights.
     - Relay 2 (LIGHT2): Controls the second set of lights.
   - **HVAC Relays:**
     - Relay 3 (HEATER): Controls the heating device.
     - Relay 4 (COOLER): Controls the cooling device.
![personal count](https://github.com/user-attachments/assets/14fa99ed-4c78-48db-aeb8-f6f762174d9b)

### System Functionality:

1. **People Counting:**
   - **Detection:** IR sensors detect the interruption of the IR beam when a person passes through.
   - **Direction Determination:** The sequence of interruption of the two sensor pairs (entrance and exit) determines if a person is entering or exiting.
   - **Count Update:** The microcontroller updates the count of people in the room based on the detected direction.

2. **Lighting Control:**
   - **Based on People Count:** The system turns on the first set of lights when at least one person is in the room. Additional lights are activated if the count exceeds a predefined threshold.

3. **Temperature Control:**
   - **Temperature Monitoring:** The temperature sensor continuously measures the room's temperature.
   - **HVAC Activation:** The microcontroller activates the cooling device if the temperature exceeds an upper limit and the heating device if it falls below a lower limit.

4. **Display Update:**
   - **Information Displayed:** The LCD shows the current number of people in the room and the ambient temperature.
   - **Real-Time Update:** The display is updated in real-time as the people count or temperature changes.

### Code Overview:

**Setup Function:**
```c
void setup() {
    // Initialize ports for sensors and relays
    DDRB = 0xFF;  // Set Port B as output for relays
    DDRC = 0x00;  // Set Port C as input for sensors
    // Initialize the display
    initDisplay();
    // Setup timers and interrupts
    setupTimers();
}
```

**Main Loop:**
```c
void loop() {
    // Check for people entering or exiting
    updatePeopleCount();
    // Read current temperature
    int temperature = readTemperature();
    // Update display with current data
    updateDisplay(peopleCount, temperature);
    // Control lights based on people count
    controlLights(peopleCount);
    // Control temperature based on current temperature
    controlTemperature(temperature);
}
```

**Interrupt Service Routine:**
```c
ISR(INT0_vect) {
    // Handle sensor input for people counting
    if (sensorTriggered()) {
        peopleCount++;
    } else {
        peopleCount--;
    }
    // Update display immediately
    updateDisplay(peopleCount, readTemperature());
}
```

**Control Functions:**
```c
void controlLights(int count) {
    if (count > 0) {
        PORTB |= (1 << LIGHT1);  // Turn on first set of lights
    }
    if (count > threshold) {
        PORTB |= (1 << LIGHT2);  // Turn on second set of lights
    }
}

void controlTemperature(int temp) {
    if (temp > upperLimit) {
        PORTB |= (1 << COOLER);  // Turn on cooling system
    } else if (temp < lowerLimit) {
        PORTB |= (1 << HEATER);  // Turn on heating system
    }
}
```

### How to Use the System:

1. **Hardware Setup:**
   - Connect the IR sensors at the entrance of the room.
   - Wire the temperature sensor and relays to the microcontroller.
   - Connect the display to the appropriate pins.

2. **Programming:**
   - Upload the provided code to the ATmega32 microcontroller.

3. **Operation:**
   - Power on the system. The microcontroller will start monitoring the IR sensors and temperature sensor.
   - The display will show the current count of people and the room temperature.
   - The system will automatically control the lighting and HVAC devices based on the detected people count and temperature.


### Function of Infrared Sensors

**Infrared (IR) Sensors:**
- **Purpose:** The IR sensors are used to detect the presence of people entering or leaving the room.
- **Components:** Each sensor pair consists of an IR transmitter (emits infrared light) and an IR receiver (detects infrared light).
- **Working Principle:** When a person passes through the sensors, they interrupt the infrared beam between the transmitter and receiver, causing a change in the signal received by the microcontroller.

### Configuration with Four Sensors

**Why Four Sensors:**
- **Two Pairs of Sensors:** You have two pairs of IR sensors—each pair consists of one transmitter and one receiver.
  - **Pair 1:** Placed at the entrance.
  - **Pair 2:** Placed slightly behind the first pair.
- **Direction Detection:** This configuration allows the system to determine the direction of movement (entering or exiting).

### Connection to the Circuit

**Wiring:**
- **IR Transmitters:** Connected to the power supply (usually through current-limiting resistors).
- **IR Receivers:** Connected to the input pins of the microcontroller. When the IR beam is uninterrupted, the receiver outputs a certain voltage level (typically high). When the beam is interrupted, the output changes (typically low).

### Microcontroller Signal Processing

**Circuit Connections:**
- **IR Transmitter (SENDER_IN, SENDER_OUT):** Connected to the power supply.
- **IR Receiver (RECEIVER_IN, RECEIVER_OUT):** Connected to specific input pins on the microcontroller, for example, `PINC0` and `PINC1` for the entrance, and `PINC2` and `PINC3` for the exit.

**Example Pin Configuration:**
```c
#define SENDER_IN   PINC0
#define RECEIVER_IN PINC1
#define SENDER_OUT  PINC2
#define RECEIVER_OUT PINC3
```

**Initialization:**
```c
void initIRsensors() {
    DDRC &= ~(1 << RECEIVER_IN);  // Set RECEIVER_IN pin as input
    DDRC &= ~(1 << RECEIVER_OUT); // Set RECEIVER_OUT pin as input
    PORTC |= (1 << RECEIVER_IN);  // Enable pull-up resistor for RECEIVER_IN
    PORTC |= (1 << RECEIVER_OUT); // Enable pull-up resistor for RECEIVER_OUT
}
```

### Signal Processing

**People Counting Logic:**
1. **Entering the Room:**
   - **Step 1:** Person breaks the beam of `SENDER_IN` and `RECEIVER_IN` first.
   - **Step 2:** Shortly after, the person breaks the beam of `SENDER_OUT` and `RECEIVER_OUT`.
   - **Result:** Both beams broken in sequence indicate entry.

2. **Exiting the Room:**
   - **Step 1:** Person breaks the beam of `SENDER_OUT` and `RECEIVER_OUT` first.
   - **Step 2:** Shortly after, the person breaks the beam of `SENDER_IN` and `RECEIVER_IN`.
   - **Result:** Both beams broken in reverse sequence indicate exit.

**Code to Handle Signals:**
```c
void updatePeopleCount() {
    static uint8_t previousStateIn = 0;
    static uint8_t previousStateOut = 0;

    uint8_t currentStateIn = PINC & (1 << RECEIVER_IN);
    uint8_t currentStateOut = PINC & (1 << RECEIVER_OUT);

    // Detect entering
    if (!currentStateIn && previousStateIn) {  // Falling edge detected
        if (!currentStateOut) {  // If out receiver is also blocked
            peopleCount++;
        }
    }

    // Detect exiting
    if (!currentStateOut && previousStateOut) {  // Falling edge detected
        if (!currentStateIn) {  // If in receiver is also blocked
            peopleCount--;
        }
    }

    // Update previous states
    previousStateIn = currentStateIn;
    previousStateOut = currentStateOut;

    // Ensure count does not go below zero
    if (peopleCount < 0) {
        peopleCount = 0;
    }

    // Update display
    updateDisplay(peopleCount, readTemperature());
}
```
   










