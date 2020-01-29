# Arduiner
A Phoenix application which connects and sends data over serial ports.

<p align="center"><img src="https://cdn.freebiesupply.com/logos/thumbs/2x/arduino-logo.png" /></p>


## How does this work?
When the web application is started is creates a GenServer to hold state for the port. This GenServer is active regardless if the port is disconnected. When the user tries to connect to a port, the said GenServer start a child GenServer which is the port connection.

With this the user can send 2 serial commands: `start` and `stop`. These values for now are hard-coded but it can be easily expanded to send any serial data.

Now it is coded to work with a single port connection but it can be expanded to use an array of child GenServers for that. This project is more of a proof-of-concept rather than a complete app.

## In which case can this be applied?
This application is semi-IOT. It uses a webapp but the server which hosts the webapp has to be connected to the microcontrollers directly. 

This can be used if you have a Raspberry Pi which is connected to several arduinos/microcontrollers.

## To start your Phoenix sever:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## How does the code look like on the Arduino's side?
For this project I am using a copy of an Arduino Pro Micro which is connected as an Arduino Leonardo. The code in use is:

```arduino
void setup()
{
  Serial.begin(115200);
  Serial.setTimeout(100);
  while(!Serial.available());
  Serial.write("Started application!");
}

void loop()
{
  if (Serial.available() > 0)
  {
    String input = Serial.readString();

    if (input == "start")
      TXLED1;

    if (input == "stop")
      TXLED0;
  }
}
```


## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
