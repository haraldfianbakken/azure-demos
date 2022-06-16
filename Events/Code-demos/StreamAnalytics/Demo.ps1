# https://github.com/markscholman/AzureIoT
find-module AzureRM.IotHub|install-module
Install-Module -name AzureIoT

$hub = Get-AzureRmIotHub -ResourceGroupName 'ariot-prehack';
$connectionStrings = Get-AzureRmIotHubConnectionString -ResourceGroupName $hub.Resourcegroup -Name $hub.Name;


$k = $connectionStrings[0].PrimaryConnectionString.Replace('ShareAccessKeyName','SharedAccessKeyName');
$device = Register-IoTDevice -iotConnString $k -deviceId 'hfpoewrshell'

$device 
#endregion

#region Create a DeviceClient
$deviceClientParams = @{
    deviceId = $device.DeviceId
    deviceKey = $device.DevicePrimaryKey
    iotHubUri = "myIoTHub.azure-devices.net"
}
$deviceClient = Get-IoTDeviceClient @deviceClientParams 
$deviceClient
#endregion

#region send message from device
$deviceMessageParams = @{
    deviceClient = $deviceClient
    messageString = "Hello World to Cloud"
}
Send-IoTDeviceMessage @deviceMessageParams
#endregion

#region Receive message from cloud
$message = Receive-IoTCloudMessage -deviceClient $deviceClient
$message 
$message[1] 
#endregion

#To operate the Cloud site of the IoT hub:
#region Create a CloudClient
$CloudClientParams = @{
    iotConnString = "HostName=myIoTHub.azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey=HwbsdfsfsdfsdgsdgdfmbHh7w1QM2KvRE="
}
$cloudClient = Get-IoTCloudClient @CloudClientParams 
$cloudClient   
#endregion

#region send message from Cloud
$cloudMessageParams = @{
    deviceId = "MyTestDevice100"
    messageString = "Hello World to Device"
    cloudClient = $cloudClient
}
Send-IoTCloudMessage @cloudMessageParams
#endregion

#region Receive message from Device
$message = Receive-IoTDeviceMessage -iotConnString "HostName=myIoTHub.azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey=HwbsdfsfsdfsdgsdgdfmbHh7w1QM2KvRE="
#endregion