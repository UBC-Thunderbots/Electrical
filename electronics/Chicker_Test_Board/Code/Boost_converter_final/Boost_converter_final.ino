const int INDUCTANCE = 22; //mH
const long MAXCURRENT = 10000; //mA
const long INDUCTANCEANDMAXCURRENT = INDUCTANCE * MAXCURRENT; //A*mH
//PIN LAYOUT
const int PMOSFET = 3; //assuming that active low makes it an open circuit
const int PKICK_BUTTON = 7;
const int PCHIP_BUTTON = 12;
//const int PBATTERY = A0;
const int PCAPACITOR = A1;
const int PBUTTON = 13;//charge button
const int PESTOP = 11;    
const int PKICK = 8; //assuming that active low discharges cap
const int PCHIP = 9;

//time variables for charge/discharge of inductor
float tCharge;
float tDischarge;



//Global variables where values are stored
//int VBAT;
long VCAP; //(millivolts)
long BUTTON;//assuming that active low is charge 
long STOP;//assuming that active low is stop
long KICK_BUTTON;
long CHIP_BUTTON;
long bat = 16*1000; //(mV)
//int charge = LOW;
//float inversebat = 1.0/16000000;

void setup(){
  Serial.begin(9600);
  // initialize pin as input/output
  pinMode(PMOSFET, OUTPUT);
  pinMode(PKICK_BUTTON, INPUT);
  pinMode(PCHIP_BUTTON, INPUT);
  //pinMode(PBATTERY, INPUT);
  pinMode(PCAPACITOR, INPUT); 
  pinMode(PBUTTON, INPUT);
  pinMode(PESTOP, INPUT);
  pinMode(PKICK, OUTPUT);
  pinMode(PCHIP, OUTPUT);

  //make the mosfet open circuit so that circuit becomes inductor, diode, cap 
  //capacitors initially. (Idle circuit)
  digitalWrite(PMOSFET, LOW);
  digitalWrite(PKICK, LOW); //close switch
  digitalWrite(PCHIP, LOW);


}


void loop()
{

  //read states 
  KICK_BUTTON = digitalRead(PKICK_BUTTON);
  CHIP_BUTTON = digitalRead(PCHIP_BUTTON);  
  STOP = digitalRead(PESTOP);
  BUTTON = digitalRead(PBUTTON); 
  //  VCAP = (analogRead(PCAPACITOR)*5000/1024)*91 ; //this gives VCAP in millivolts
  //VBAT = analogRead(PBATTERY)*100;  
  //Serial.print(VCAP);
  //Serial.print("\n");



  while(STOP == LOW)
  {
    STOP = digitalRead(PESTOP);
    //charge = LOW;

  }



  while(BUTTON == HIGH) //if(charge == HIGH)
  {

    BUTTON = digitalRead(PBUTTON); 
    //VCAP = (analogRead(PCAPACITOR)*5.0/1024.0)*91.2*1000 ; //this gives VCAP in millivolts
    VCAP = 129000;
    Serial.print(VCAP);
    Serial.print("\n");  
    if(VCAP <=230000 && VCAP >=10000)
    {

      //digitalWrite(PKICK,LOW); //open the load switch  -----REDUNDANT
      charge1Cycle();

    }



  } 



  if(KICK_BUTTON == LOW)//i.e, discharge caps into load
  {      
    dischargeUsingPulseWidth_Kicker();   
  }
  if(CHIP_BUTTON == LOW)//i.e, discharge caps into load
  {
    dischargeUsingPulseWidth_Chip(); 
  }

}


void charge1Cycle()
{

  //calculate time required to discharge the inductor
  tDischarge = ((INDUCTANCEANDMAXCURRENT) / (VCAP - bat + 700)); //in microseconds    mA*mH/(mV - mV +C)
  tCharge = (INDUCTANCEANDMAXCURRENT / bat);//IN milliSECONDS 
  int ontime = tCharge*1000;  //useconds
  int offtime = (tDischarge + tDischarge/10) +1; 

  Serial.print("Tdischarge: ");
  Serial.print(offtime);
  Serial.print("\n");
  Serial.print("Charge: ");
  Serial.print(tCharge);
  Serial.print("\n");


  PORTD |= 1 << 3;
  delayMicroseconds(ontime);
  PORTD &= ~(1 << 3);
  delayMicroseconds(offtime);


  return; 
}



void dischargeUsingPulseWidth_Chip()
{

  //send a pulse width four ms wide
  digitalWrite(PCHIP,HIGH);
  delay(4);
  digitalWrite(PCHIP,LOW);

  delay(1000);
  return;
}

void dischargeUsingPulseWidth_Kicker()
{

  //send a pulse width four ms wide
  digitalWrite(PKICK,HIGH);
  delay(4);
  digitalWrite(PKICK,LOW);

  delay(1000);
  return;
}

