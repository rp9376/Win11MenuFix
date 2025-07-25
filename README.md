# Windows 11 Context Menu Scripts

![Windows Version](https://img.shields.io/badge/Windows-11-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Script Type](https://img.shields.io/badge/Script-Batch-yellow)

Two complementary batch scripts to easily switch between classic and modern Windows 11 right-click context menus.

## 📋 Table of Contents

- [Overview](#-overview)
- [Scripts Included](#-scripts-included)
- [Features](#-features)
- [Requirements](#-requirements)
- [Installation & Usage](#-installation--usage)
- [What They Do](#-what-they-do)
- [Safety Features](#-safety-features)
- [Switching Between Menus](#-switching-between-menus)
- [Troubleshooting](#-troubleshooting)
- [Technical Details](#-technical-details)
- [Contributing](#-contributing)
- [License](#-license)

## 🎯 Overview

Windows 11 introduced a simplified right-click context menu that hides many useful options behind a "Show more options" submenu. These scripts allow you to easily switch between the classic full-featured context menu and the modern simplified version.

## 📦 Scripts Included

### 🔧 `Win11-Classic-ContextMenu-Restore.bat`
- **Purpose**: Restores the classic Windows context menu
- **Color**: Green theme
- **Effect**: Shows all context menu options directly (like Windows 10)

### 🔄 `Win11-Restore-Modern-ContextMenu.bat`
- **Purpose**: Restores the modern Windows 11 simplified context menu
- **Color**: Red theme  
- **Effect**: Returns to the simplified menu with "Show more options"

## ✨ Features

- 🔧 **Easy switching** - Toggle between classic and modern context menus
- 🛡️ **Safe operation** - Both scripts create automatic registry backups
- 👤 **Smart privileges** - Automatically request admin rights when needed
- 📱 **User-friendly** - Clear progress indicators and instructions
- ⚡ **Immediate effect** - Restart Explorer automatically to apply changes
- 🔄 **Fully reversible** - Use either script to switch back and forth
- 📝 **Well-documented** - Comprehensive error handling and feedback
- 🎨 **Visual distinction** - Different colors help identify each script's purpose

## 📋 Requirements

- **Operating System**: Windows 11
- **Privileges**: Administrator rights (script will request if needed)
- **Architecture**: Works on both x64 and x86 systems

## 🚀 Installation & Usage

### Quick Start

#### To Get Classic Context Menu:
1. **Download** the `Win11-Classic-ContextMenu-Restore.bat` file
2. **Double-click** to run (script will request admin rights automatically)
3. **Follow** the on-screen prompts
4. **Enjoy** your classic context menu with all options visible!

#### To Restore Modern Context Menu:
1. **Download** the `Win11-Restore-Modern-ContextMenu.bat` file  
2. **Double-click** to run (script will request admin rights automatically)
3. **Follow** the on-screen prompts
4. **Back to** the simplified Windows 11 context menu!

### Step-by-Step

1. **Save both scripts** to any location on your computer
2. **Run the script** for your desired menu style
3. **Read the information** displayed and press any key to continue
4. **Allow admin privileges** when prompted by Windows UAC
5. **Wait** for the script to complete (usually takes 5-10 seconds)
6. **Test** your right-click menu - it should show the selected style!

## 🔧 What They Do

### Classic Context Menu Script:
1. **Privilege Check**: Verifies and requests administrator privileges
2. **Registry Backup**: Creates a safety backup of relevant registry keys
3. **Registry Modification**: Adds a registry entry to disable Windows 11's simplified context menu
4. **Explorer Restart**: Gracefully restarts Windows Explorer to apply changes
5. **Confirmation**: Provides success feedback and switching instructions

### Modern Context Menu Script:
1. **Privilege Check**: Verifies and requests administrator privileges  
2. **Registry Detection**: Checks if classic menu modification exists
3. **Registry Backup**: Creates a safety backup before removal
4. **Registry Cleanup**: Removes the registry entry that disabled the modern menu
5. **Explorer Restart**: Gracefully restarts Windows Explorer to apply changes
6. **Confirmation**: Provides success feedback and switching instructions

### Registry Key Modified

```
HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32
```

This key effectively disables the Windows 11 context menu handler, allowing the classic menu to appear.

## 🛡️ Safety Features

- **Automatic Backup**: Both scripts create timestamped registry backups before making changes
- **Error Checking**: Validate each operation and provide clear error messages
- **Graceful Handling**: Properly manage Explorer restart with appropriate delays
- **User Confirmation**: Require user consent before making any changes
- **Detection Logic**: Modern script checks if classic modification exists before proceeding
- **Detailed Logging**: Show exactly what each script is doing at each step

## 🔄 Switching Between Menus

You can easily switch back and forth between context menu styles:

### From Classic to Modern:
- Run `Win11-Restore-Modern-ContextMenu.bat`
- This removes the registry modification and restores the simplified menu

### From Modern to Classic:  
- Run `Win11-Classic-ContextMenu-Restore.bat`
- This adds the registry modification to show the full classic menu

### Manual Method (Alternative):
1. Press `Win + R`, type `regedit`, and press Enter
2. Navigate to: `HKEY_CURRENT_USER\Software\Classes\CLSID\`
3. **For Modern Menu**: Delete the folder `{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}`
4. **For Classic Menu**: Use the classic script to recreate the modification
5. Restart Windows Explorer or reboot your computer

## 🔍 Troubleshooting

### Common Issues

**Q: The script doesn't seem to work**
- A: Make sure you're running it with administrator privileges and restart any open applications

**Q: I get an "Access Denied" error**
- A: Ensure Windows UAC is enabled and click "Yes" when prompted for administrator access

**Q: My taskbar disappeared after running the script**
- A: This is normal during Explorer restart. Wait 10-15 seconds, and it should reappear

**Q: The context menu still shows the simplified version**
- A: Try logging out and back in, or restart your computer

**Q: I want to undo the changes but lost the backup file**
- A: Use Method 1 or 3 from the "Reverting Changes" section above

### Getting Help

If you encounter issues:
1. Check the error messages displayed by the script
2. Ensure you have administrator privileges
3. Try running the script again
4. Restart your computer and test the context menu

## 🔧 Technical Details

### How It Works

The script exploits a Windows registry mechanism where setting an empty value for a COM object's `InprocServer32` key effectively disables that component. The CLSID `{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}` corresponds to the Windows 11 context menu handler.

### Files Created
- **Registry Backup**: `%temp%\context_menu_backup_YYYY_MM_DD.reg`
- **Temporary UAC Script**: `%temp%\getadmin.vbs` (automatically deleted)

### Registry Changes
```
[HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32]
@=""
```

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the issues page or submit a pull request.

### To Contribute:
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📚 References

- [Original Admin Privilege Code](https://stackoverflow.com/questions/1894967/how-to-request-administrator-access-inside-a-batch-file)
- [Windows 11 Context Menu Fix](https://windowsreport.com/windows-11-right-click-show-all-options/)
- [Microsoft Registry Documentation](https://docs.microsoft.com/en-us/windows/win32/sysinfo/registry)

##

⭐ **Like this script?** Give it a star and share it with others who might find it useful!

💡 **Have suggestions?** Open an issue or submit a pull request!
