// - IoT Devices -
export const listIoTDevices = /* GraphQL */ `
  query ListIoTDevices($limit: Int, $nextToken: String) {
    listIoTDevices(limit: $limit, nextToken: $nextToken) {
      devices {
        DeviceId
        DeviceName
        ShortName
        ComputerModule
        Manufacturer
        Model
        Device
        RegisteredOwner
        PrimaryLocation
      }
      nextToken
    }
  }
`;

export const getIoTDevice = /* GraphQL */ `
  query GetIoTDevice($DeviceId: String!) {
    getIoTDevice(DeviceId: $DeviceId) {
      DeviceId
      DeviceName
      ShortName
      ComputerModule
      Manufacturer
      Model
      Device
      RegisteredOwner
      PrimaryLocation
    }
  }
`;

// - IoT Messages -
export const listIoTMessages = /* GraphQL */ `
  query ListIoTMessages($limit: Int, $nextToken: String) {
    listIoTMessages(limit: $limit, nextToken: $nextToken) {
      messages {
        MessageId
        Timestamp
        DeviceId
        DeviceName
        ShortName
        ComputerModule
        Manufacturer
        Model
        Device
        RegisteredOwner
        PrimaryLocation
        Message
      }
      nextToken
    }
  }
`;
// - IoT Messages -
export const listIoTMessagesByDeviceId = /* GraphQL */ `
  query ListIoTMessagesByDeviceId($DeviceId: String!, $limit: Int, $nextToken: String) {
    listIoTMessagesByDeviceId(DeviceId: $DeviceId, limit: $limit, nextToken: $nextToken) {
      messages {
        MessageId
        Timestamp
        DeviceId
        DeviceName
        ShortName
        ComputerModule
        Manufacturer
        Model
        Device
        RegisteredOwner
        PrimaryLocation
        Message
      }
      nextToken
    }
  }
`;

export const getIoTMessage = /* GraphQL */ `
  query GetIoTMessage($MessageId: String!) {
    getIoTMessage(MessageId: $MessageId) {
        MessageId
        Timestamp
        DeviceId
        DeviceName
        ShortName
        ComputerModule
        Manufacturer
        Model
        Device
        RegisteredOwner
        PrimaryLocation
        Message
    }
  }
`;
