enum ViewState { Idle, Busy }
enum Power { Off, On }
enum MqttClientConnectionState {
  Idle,
  Connecting,
  Connected,
  Disconnected,
  ErrorWhenConnecting,
}

enum MqttClientSubcriptionState { Idle, Subcripting }