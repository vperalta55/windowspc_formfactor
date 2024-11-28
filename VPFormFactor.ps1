# Get the computer system information using WMI
$ComputerSystem = Get-WmiObject -Class Win32_ComputerSystem

# Determine the virtual machine type based on the Manufacturer
$Manufacturer = $ComputerSystem.Manufacturer

# Define an array of keywords to check against the Model property
$VirtualKeywords = @("Virtual", "VMware", "Microsoft", "VirtualBox")

# Check if it's a virtual machine (VM)
$IsVirtual = $false
$VMType = "Unknown VM"

# Check each keyword in the array against the Model property
foreach ($Keyword in $VirtualKeywords) {
    if ($ComputerSystem.Model -match $Keyword) {
        $IsVirtual = $true

        # Determine the specific VM type based on the Manufacturer
        switch -Wildcard ($Manufacturer) {
            "VMware, Inc.*" {
                $VMType = "VMware VM"
            }
            "Microsoft Corporation*" {
                # Check if the "Windows Azure Guest Agent" service is running
                $azureGuestAgentService = Get-Service | Where-Object { $_.DisplayName -eq "Windows Azure Guest Agent" }
                if ($azureGuestAgentService -ne $null) {
                    $VMType = "Azure VM"
                } else {
                    $VMType = "Microsoft Hyper-V VM"
                }
            }
            "Oracle Corporation*" {
                $VMType = "Oracle VirtualBox VM"
            }
            # Add more conditions for other Manufacturers as needed. Make sure to add keywords under VirtualKeywords.
            default {
                $VMType = "Unknown VM"
            }
        }

        break  # Exit the loop once a match is found
    }
}

# Get computer form factor using WMI
$SystemEnclosure = Get-WmiObject -Class Win32_SystemEnclosure

# Determine the form factor
$OutputFormFactor = switch ($SystemEnclosure.ChassisTypes[0]) {
    1 { "Other" }
    2 { "Unknown" }
    3 { "Desktop" }
    4 { "Low Profile Desktop" }
    5 { "Pizza Box" }
    6 { "Mini Tower" }
    7 { "Tower" }
    8 { "Portable" }
    9 { "Laptop" }
    10 { "Notebook" }
    11 { "Handheld" }
    12 { "Docking Station" }
    13 { "All-in-One" }
    14 { "Sub-Notebook" }
    15 { "Space-saving" }
    16 { "Lunch Box" }
    17 { "Main Server Chassis" }
    18 { "Expansion Chassis" }
    19 { "Sub-Chassis" }
    20 { "Bus Expansion Chassis" }
    21 { "Peripheral Chassis" }
    22 { "Storage Chassis" }
    23 { "Rack Mount Chassis" }
    24 { "Sealed-Case PC" }
    default { "Unknown" }
}

if ($IsVirtual) {
    Write-Output "Extended Audit: System is a $VMType. Form Factor: $OutputFormFactor"
}
else {
    Write-Output "Extended Audit: System is not a VM. Form Factor: $OutputFormFactor"
}
