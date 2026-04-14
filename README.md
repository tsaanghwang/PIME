# PIME

[![Build status](https://ci.appveyor.com/api/projects/status/ju8c225nt9qgxeee?svg=true)](https://ci.appveyor.com/project/EasyIME/PIME)
[![GitHub release](https://img.shields.io/github/release/EasyIME/PIME.svg)](https://github.com/EasyIME/PIME/releases)

Implement input methods easily for Windows via Text Services Framework:
*   LibIME contains a library which aims to be a simple wrapper for Windows Text Service Framework (TSF).
*   PIMETextService contains an backbone implementation of Windows text service for using libIME.
*   The python server part requires python 3.x and pywin32 package.

All parts are licensed under GNU LGPL v2.1 license.

# Development

開發說明 / Development Notes

## Tool Requirements
*   `Windows 10/11` / Windows 10 或 11
*   [Visual Studio 2022 Build Tools](https://visualstudio.microsoft.com/vs) or Visual Studio 2022 with the Desktop development with C++ workload / 已安裝 Desktop development with C++ 工作負載的 Visual Studio 2022 或 Visual Studio 2022 Build Tools
*   `MSVC x86/x64 build tools` and a Windows SDK / `MSVC x86/x64` 編譯工具與 Windows SDK
*   [CMake](http://www.cmake.org/) >= 3.5, either on PATH or the copy bundled with VS2022 / `CMake >= 3.5`，可使用 PATH 中的版本或 VS2022 內建版本
*   [git](http://windows.github.com/) / `git`
*   `Python 3` with `pywin32` / 已安裝 `pywin32` 的 `Python 3`
*   `Node.js` and `npm` / `Node.js` 與 `npm`

## How to Build
手動建置 / Manual build

*   Get source from GitHub / 從 GitHub 取得原始碼

        git clone https://github.com/EasyIME/PIME.git
        cd PIME
        git submodule update --init

*   Generate Visual Studio 2022 projects with CMake / 用 CMake 產生 Visual Studio 2022 專案

        cmake -S . -B build -G "Visual Studio 17 2022" -A Win32 -DCMAKE_POLICY_VERSION_MINIMUM=3.5
        cmake --build build --config Release

        cmake -S . -B build64 -G "Visual Studio 17 2022" -A x64 -DCMAKE_POLICY_VERSION_MINIMUM=3.5
        cmake --build build64 --config Release --target PIMETextService

*   ARM64 is optional / ARM64 為可選項

        cmake -S . -B build_arm64 -G "Visual Studio 17 2022" -A ARM64 -DCMAKE_POLICY_VERSION_MINIMUM=3.5
        cmake --build build_arm64 --config Release --target PIMETextService

*   The ARM64 build requires VS2022 ARM64 C++ tools. If those components are not installed, skip the ARM64 step / ARM64 需要 VS2022 的 ARM64 C++ 工具；如果未安裝，可以略過 ARM64 步驟

*   Build McBopomofo for the PIME Node backend / 建置給 PIME Node 後端使用的 McBopomofo

        cd McBopomofoWeb
        npm install
        npm run build:pime
        cd ..

*   Copy the generated McBopomofo files into `node\input_methods\McBopomofo` if needed / 如需要，將產生出的 McBopomofo 檔案複製到 `node\input_methods\McBopomofo`

已驗證流程 / Verified workflow

*   This repository also includes `build.bat`, which has been verified to work with Visual Studio 2022 Build Tools in this workspace / 本倉庫也提供 `build.bat`，且已在此工作區用 Visual Studio 2022 Build Tools 驗證可用
*   `build.bat` automatically detects `cmake`, falls back to the VS2022 bundled CMake when needed, builds Win32 and x64, optionally builds ARM64, and then runs `npm install` and `npm run build:pime` for McBopomofo / `build.bat` 會自動偵測 `cmake`，必要時退回使用 VS2022 內建的 CMake，建置 Win32 與 x64，必要時再建置 ARM64，最後執行 `npm install` 與 `npm run build:pime` 建置 McBopomofo

        build.bat

## TSF References
TSF 參考資料 / TSF references

*   [Text Services Framework](http://msdn.microsoft.com/en-us/library/windows/desktop/ms629032%28v=vs.85%29.aspx)
*   [Guidelines and checklist for IME development (Windows Store apps)](http://msdn.microsoft.com/en-us/library/windows/apps/hh967425.aspx)
*   [Input Method Editors (Windows Store apps)](http://msdn.microsoft.com/en-us/library/windows/apps/hh967426.aspx)
*   [Third-party input method editors](http://msdn.microsoft.com/en-us/library/windows/desktop/hh848069%28v=vs.85%29.aspx)
*   [Strategies for App Communication between Windows 8 UI and Windows 8 Desktop](http://software.intel.com/en-us/articles/strategies-for-app-communication-between-windows-8-ui-and-windows-8-desktop)
*   [TSF Aware, Dictation, Windows Speech Recognition, and Text Services Framework. (blog)](http://blogs.msdn.com/b/tsfaware/?Redirected=true)
*   [Win32 and COM for Windows Store apps](http://msdn.microsoft.com/en-us/library/windows/apps/br205757.aspx)
*   [Input Method Editor (IME) sample supporting Windows 8](http://code.msdn.microsoft.com/windowsdesktop/Input-Method-Editor-IME-b1610980)

## Windows ACL (Access Control List) references
Windows ACL 參考資料 / Windows ACL references

*   [The Windows Access Control Model Part 1](http://www.codeproject.com/Articles/10042/The-Windows-Access-Control-Model-Part-1#SID)
*   [The Windows Access Control Model: Part 2](http://www.codeproject.com/Articles/10200/The-Windows-Access-Control-Model-Part-2#SidFun)
*   [Windows 8 App Container Security Notes - Part 1](http://recxltd.blogspot.tw/2012/03/windows-8-app-container-security-notes.html)
*   [How AccessCheck Works](http://msdn.microsoft.com/en-us/library/windows/apps/aa446683.aspx)
*   [GetAppContainerNamedObjectPath function (enable accessing object outside app containers using ACL)](http://msdn.microsoft.com/en-us/library/windows/desktop/hh448493)
*   [Creating a DACL](http://msdn.microsoft.com/en-us/library/windows/apps/ms717798.aspx)

# Install
安裝說明 / Installation

*   Create `C:\Program Files (X86)\PIME\`, `C:\Program Files (X86)\PIME\x86\`, and `C:\Program Files (X86)\PIME\x64\` / 建立 `C:\Program Files (X86)\PIME\`、`C:\Program Files (X86)\PIME\x86\` 與 `C:\Program Files (X86)\PIME\x64\`
*   Copy `PIMETextService.dll` to `C:\Program Files (X86)\PIME\x86\` / 將 `PIMETextService.dll` 複製到 `C:\Program Files (X86)\PIME\x86\`
*   Copy `PIMETextService.dll` to `C:\Program Files (X86)\PIME\x64\` / 將 `PIMETextService.dll` 複製到 `C:\Program Files (X86)\PIME\x64\`
*   Copy `version.txt`, `backends.json`, and `PIMELauncher.exe` to `C:\Program Files (X86)\PIME\` / 將 `version.txt`、`backends.json` 與 `PIMELauncher.exe` 複製到 `C:\Program Files (X86)\PIME\`
*   Copy the folder `python` to `C:\Program Files (X86)\PIME\` / 將 `python` 目錄複製到 `C:\Program Files (X86)\PIME\`
*   Copy the folder `node` to `C:\Program Files (X86)\PIME\` if you want to use Node-based input methods / 如果需要使用 Node 架構輸入法，再將 `node` 目錄複製到 `C:\Program Files (X86)\PIME\`
*   If you deploy the Rime backend manually, you also need to copy its schema and OpenCC runtime data. The installer does this automatically, but a plain copy of the `python` folder is not enough / 如果手動部署 Rime 後端，還必須額外複製 schema 與 OpenCC 執行期資料。安裝器會自動處理，但只複製 `python` 目錄並不夠

        Copy python\input_methods\rime\brise\*.txt to C:\Program Files (X86)\PIME\python\input_methods\rime\data\
        Copy python\input_methods\rime\brise\*.yaml to C:\Program Files (X86)\PIME\python\input_methods\rime\data\
        Copy python\input_methods\rime\brise\preset\*.yaml to C:\Program Files (X86)\PIME\python\input_methods\rime\data\
        Copy python\input_methods\rime\brise\supplement\*.yaml to C:\Program Files (X86)\PIME\python\input_methods\rime\data\
        Copy python\input_methods\rime\brise\extra\*.yaml to C:\Program Files (X86)\PIME\python\input_methods\rime\data\
        Copy python\opencc\*.json to C:\Program Files (X86)\PIME\python\input_methods\rime\data\opencc\
        Copy python\opencc\*.ocd to C:\Program Files (X86)\PIME\python\input_methods\rime\data\opencc\

*   If the Rime data above is missing, the IME may register successfully but fall back to the `.default` schema, which means raw keyboard input is passed through and no candidate window appears / 如果缺少上述 Rime 資料，輸入法可能仍會註冊成功，但會退回 `.default` schema，造成鍵盤輸入被直接透傳且不會出現候選窗
*   Use `regsvr32` to register `PIMETextService.dll`. 64-bit systems need to register both 32-bit and 64-bit `PIMETextService.dll` / 使用 `regsvr32` 註冊 `PIMETextService.dll`。在 64 位元系統上，需要同時註冊 32 位元與 64 位元版本

        regsvr32 "C:\Program Files (X86)\PIME\x86\PIMETextService.dll" (run as administrator)
        regsvr32 "C:\Program Files (X86)\PIME\x64\PIMETextService.dll" (run as administrator)

*   Start `PIMELauncher.exe` after deployment. The installer also adds it to `HKLM\Software\Microsoft\Windows\CurrentVersion\Run` so it starts automatically after sign-in / 部署完成後請啟動 `PIMELauncher.exe`。安裝器也會將它加入 `HKLM\Software\Microsoft\Windows\CurrentVersion\Run`，讓它在登入後自動啟動
*   NOTICE: the `regsvr32` command needs to be run as Administrator. Otherwise you'll get access denied error / 注意：`regsvr32` 必須以系統管理員身分執行，否則會出現 access denied
*   In Windows 8, if you put the dlls in places other than `C:\Windows` or `C:\Program Files`, they will not be accessible in metro apps / 在 Windows 8 上，如果 DLL 不放在 `C:\Windows` 或 `C:\Program Files`，Metro app 將無法存取它們

# Uninstall
解除安裝 / Uninstall

*   Use `regsvr32` to unregister `PIMETextService.dll`. 64-bit systems need to unregister both 32-bit and 64-bit `PIMETextService.dll` / 使用 `regsvr32` 解除註冊 `PIMETextService.dll`。在 64 位元系統上，需要同時解除註冊 32 位元與 64 位元版本

        regsvr32 /u "C:\Program Files (X86)\PIME\x86\PIMETextService.dll" (run as administrator)
        regsvr32 /u "C:\Program Files (X86)\PIME\x64\PIMETextService.dll" (run as administrator)
*   Remove `C:\Program Files (X86)\PIME` / 刪除 `C:\Program Files (X86)\PIME`

*   NOTICE: the `regsvr32` command needs to be run as Administrator. Otherwise you'll get access denied error / 注意：`regsvr32` 必須以系統管理員身分執行，否則會出現 access denied

# Bug Report
問題回報 / Bug report

Please report any issue to [here](https://github.com/EasyIME/PIME/issues) / 如有問題，請在 [這裡](https://github.com/EasyIME/PIME/issues) 回報。
