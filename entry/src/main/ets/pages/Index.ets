import { MqttManager } from './MqttManager';

@Entry
@Component
struct Index {
  mqttManager: MqttManager = new MqttManager();

  build() {
    Column() {
      Button(`OPEN LAMP ON`)
        .onClick(() => {
          this.mqttManager.turnOnDashboard();
        }).margin({ bottom: 16 })
      Button(`OPEN LAMP OFF`)
        .onClick(() => {
          this.mqttManager.turnOffDashboard();
        })
    }.width(`100%`).height(`100%`).alignItems(HorizontalAlign.Center).justifyContent(FlexAlign.Center)
  }
}
