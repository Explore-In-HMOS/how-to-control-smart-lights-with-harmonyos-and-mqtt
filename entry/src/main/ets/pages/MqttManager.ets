import {
  MqttClient,
  MqttConnectOptions,
  MqttMessage,
  MqttPublishOptions,
  MqttResponse,
  MqttSubscribeOptions
} from '@ohos/mqtt';

export class MqttManager {
  private mqttAsyncClient: MqttClient | null = null;

  constructor() {
    // port 1883
    this.mqttAsyncClient = new MqttClient({
      url: 'tcp://XXX.XXX.XXX:XXXX',
      clientId: `Harmony_User`,
      persistenceType: 1,
      MQTTVersion: 5
    });
    this.mqttAsyncClient.messageArrived((err: Error, data: MqttMessage) => {
      const topic = data.topic;
      const payload = data.payload;
      console.info(`[MQTT] Message received -> Topic: ${topic}, Veri: ${payload}`);

      if (payload === '1') {
        // Here you can run a logic command that will change the lamp state.
        console.info('The command to turn the lamp ON was received.!');
      } else if (payload === '0') {
        console.info('The command to turn the lamp OFF was received.!');
      }
    });
    this.connect();
    this.mqttAsyncClient?.isConnected();

  }

  public connect(): void {

    const options: MqttConnectOptions = {
      //set userName and password
      userName: '',
      password: '',
      connectTimeout: 30,
      MQTTVersion: 5
    };

    // Connection execution:
    this.mqttAsyncClient?.connect(options)
      .then(() => {
        console.info('');
        const subscribeOption: MqttSubscribeOptions = {
          topic: '',
          qos: 1
        };
        // README: subscribe(topic, qos)
        if (this.mqttAsyncClient !== null) {
          this.mqttAsyncClient.subscribe(subscribeOption, (err: Error, data: MqttResponse) => {

          });
        }
      })
      .catch((err: BusinessError) => {
        console.error('Connection failed: ', err.message);
      });

  }

  public async sendLightCommand(isActive: boolean): Promise<void> {

    if (this.mqttAsyncClient !== null) {
      this.mqttAsyncClient.isConnected().then((data: boolean) => {

      });

      const result: boolean = await this.mqttAsyncClient.isConnected(); //true  or false
      if (result) {
        const value = isActive ? '' : '0FF';
        const publishOption: MqttPublishOptions = {
          topic: 'home/livingroom/control',
          qos: 1,
          payload: value
        };

        // README: publish(topic: string, payload: string, qos: number, retained: boolean)
        this.mqttAsyncClient.publish(publishOption, (err: Error, data: MqttResponse) => {

          if (err) {
            // This works if an error occurs during submission.
            console.error(`[MQTT] Publish error: ${err.message}`);
          } else {
            // If sent successfully, this will work.
            console.info(`[MQTT] Publish success! Data sent: ${data.message}`);
          }
        });
      } else {
        this.mqttAsyncClient.reconnect();
        const value = isActive ? 'ON' : 'OFF';
        const publishOption: MqttPublishOptions = {
          topic: 'home/livingroom/control',
          qos: 1,
          payload: value,
          retained: true
        };

        // Publish(topic: string, payload: string, qos: number, retained: boolean)
        this.mqttAsyncClient.publish(publishOption, (err: Error, data: MqttResponse) => {

          if (err) {
            // This works if an error occurs during submission.
            console.error(`[MQTT] Publish error: ${err.message}`);
          } else {
            // If sent successfully, this will work.
            console.info(`[MQTT] Publish success! Data sent: ${data.message}`);

          }
        });
      }
    }

  }

  public turnOnDashboard(): void {
    this.sendLightCommand(true);
  }

  public turnOffDashboard(): void {
    this.sendLightCommand(false);
  }
}