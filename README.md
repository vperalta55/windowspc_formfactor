# windowspc_formfactor
Script to determine Windows PC form factor/ Cloud . This can later be used to created automation based on the device form factor or create device tags. w
# System Audit: Virtual Machine and Form Factor Detection

This PowerShell script performs an extended audit to determine whether a system is running in a virtualized environment or on physical hardware. It also identifies the system's form factor (e.g., Desktop, Laptop, All-in-One, etc.) by querying the chassis type using WMI (Windows Management Instrumentation).

## Features

- **Virtual Machine Detection**:
  - Identifies if the system is virtual by checking against a set of keywords.
  - Detects specific VM types, including:
    - VMware
    - Microsoft Hyper-V
    - Azure VM
    - Oracle VirtualBox
- **Form Factor Identification**:
  - Retrieves the chassis type using the `Win32_SystemEnclosure` WMI class.
  - Maps the chassis type code to a descriptive form factor (e.g., Desktop, Laptop, Tower).
- **Extended Audit Summary**:
  - Provides a consolidated output describing the system type and form factor.

## Requirements

- **PowerShell**: The script runs on both Windows PowerShell and PowerShell Core.
- **Administrative Privileges**: Ensure the script is executed with sufficient permissions to access WMI queries.

