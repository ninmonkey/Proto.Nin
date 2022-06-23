function _repeatAlarm.proto {
param($Text = 'Tick', $MinutesDelay = 15)
$Message = "Delay = {0} min, Text = {1}" -f @( $MinutesDelay, $Text)
New-BurntToastNotification -Text $Message
while($true) {
  New-BurntToastNotification -Text $Tick
 (get-date).ToShortTimeString()
  sleep -Seconds (60*$MinutesDelay)
}}
