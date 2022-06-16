import-module ActiveDirectory
import-module .\deprovision_funtions.psm1

Write-host `
' _____     ______     ______   ______     ______     __   __   __     ______     __     ______     __   __     __     __   __     ______        ______   ______     ______     __        
/\  __-.  /\  ___\   /\  == \ /\  == \   /\  __ \   /\ \ / /  /\ \   /\  ___\   /\ \   /\  __ \   /\ "-.\ \   /\ \   /\ "-.\ \   /\  ___\      /\__  _\ /\  __ \   /\  __ \   /\ \       
\ \ \/\ \ \ \  __\   \ \  _-/ \ \  __<   \ \ \/\ \  \ \ \ /   \ \ \  \ \___  \  \ \ \  \ \ \/\ \  \ \ \-.  \  \ \ \  \ \ \-.  \  \ \ \__ \     \/_/\ \/ \ \ \/\ \  \ \ \/\ \  \ \ \____  
 \ \____-  \ \_____\  \ \_\    \ \_\ \_\  \ \_____\  \ \__|    \ \_\  \/\_____\  \ \_\  \ \_____\  \ \_\\"\_\  \ \_\  \ \_\\"\_\  \ \_____\       \ \_\  \ \_____\  \ \_____\  \ \_____\ 
  \/____/   \/_____/   \/_/     \/_/ /_/   \/_____/   \/_/      \/_/   \/_____/   \/_/   \/_____/   \/_/ \/_/   \/_/   \/_/ \/_/   \/_____/        \/_/   \/_____/   \/_____/   \/_____/  
                                                                                                                                                                                        ' -ForegroundColor Red -BackgroundColor DarkRed

$username = Read-host -Prompt "Enter the user's username"

try {
    deprovision-user -username $username
}
catch {
    Write-Host "The user could not be deprovisioned. Please verify that the username for the user is correct" -ForegroundColor Red
}
