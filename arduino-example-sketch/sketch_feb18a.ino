//
// Example sketch to send command from arduino to PC
// This sketch is a sample to send character to the PC through
// Serial port.
///

const int buttonPin = 2;
const int ledPin = 13;
int buttonState = 0;
int change = 0;
int cnt = 0;
void setup(){
  pinMode(ledPin, OUTPUT);
  pinMode(buttonPin, INPUT);
  Serial.begin(9600);
}

void loop(){
    
   if( change == digitalRead(buttonPin)){
     return;
   } else {
     change = digitalRead(buttonPin);
   }
   
   
   if (change){
     buttonState = 1- buttonState;
     int a = 97;
     Serial.print(a);
   }
   if( buttonState == HIGH ){
     digitalWrite(ledPin, HIGH);
   } else {
     digitalWrite(ledPin, LOW);
   }
 
}
