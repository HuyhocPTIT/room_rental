@echo off
REM Script to run Room Rental Application
REM ========================================

echo.
echo =====================================
echo   Room Rental - Application Launcher
echo =====================================
echo.

REM Check if Maven wrapper exists
if not exist mvnw.cmd (
    echo ERROR: mvnw.cmd not found!
    echo Please ensure you are in the project root directory
    pause
    exit /b 1
)

echo [INFO] Starting Room Rental Application...
echo [INFO] Project: room_rental
echo [INFO] Port: 8082
echo [INFO] Database: room_rental_db (MySQL)
echo.
echo [STEP 1] Cleaning project...
call mvnw.cmd clean 2>&1 | findstr /V "Downloading"

if errorlevel 1 (
    echo [ERROR] Clean failed
    pause
    exit /b 1
)

echo.
echo [STEP 2] Compiling project...
call mvnw.cmd compile 2>&1 | findstr /V "Downloading"

if errorlevel 1 (
    echo [ERROR] Compilation failed!
    echo Please check:
    echo   1. Java 17+ installed (java -version)
    echo   2. MySQL running (port 3306)
    echo   3. MySQL password correct (should be 1234)
    pause
    exit /b 1
)

echo.
echo [STEP 3] Starting application...
echo [INFO] Waiting for Tomcat to start...
echo [INFO] This may take 30-60 seconds...
echo.
echo Open browser and go to: http://localhost:8082/
echo.
call mvnw.cmd spring-boot:run

pause
