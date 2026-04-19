@echo off
setlocal

set "CMAKE_EXE="

where cmake >nul 2>&1
if not errorlevel 1 set "CMAKE_EXE=cmake"

if not defined CMAKE_EXE (
  for %%V in (2022 2019) do (
    for %%E in (BuildTools Community Professional Enterprise) do (
      if not defined CMAKE_EXE if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\%%V\%%E\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" (
        set "CMAKE_EXE=%ProgramFiles(x86)%\Microsoft Visual Studio\%%V\%%E\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe"
      )
    )
  )
)

if not defined CMAKE_EXE (
  echo CMake was not found on PATH or in a supported Visual Studio installation.
  echo Install Visual Studio 2022 Build Tools with Desktop development with C++ or add cmake to PATH.
  exit /b 1
)

"%CMAKE_EXE%" %*
