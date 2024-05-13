# AutoWhisperWatcher

AutoWhisperWatcher is a tool designed to monitor a directory on macOS for new audio files and automatically open them with [MacWhisper](https://goodsnooze.gumroad.com/l/macwhisper). When a new file is detected, the script automatically opens MacWhisper and transcribes the file using the application's default settings, making it perfect for quick audio processing without manual intervention. It utilizes [fswatch](https://github.com/emcrisostomo/fswatch) to watch for file changes and the terminal multiplexer `screen` to manage the script's execution in the background seamlessly.

## Installation

### Prerequisites

- **Homebrew**: Ensure that [Homebrew](https://brew.sh) is installed on your system. If it's not installed, you can install it by running:
  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```
- **MacWhisper**: Ensure that [MacWhisper](https://goodsnooze.gumroad.com/l/macwhisper) is installed on your system.
- **GNU Screen**: Ensure that Screen is installed on your system. If it's not installed, you can install it with Homebrew by running:
  ```bash
  brew install screen
  ```

### Step 1: Install fswatch

Install [fswatch](https://github.com/emcrisostomo/fswatch) using Homebrew:

```bash
brew install fswatch
```

## Setup

### Step 2: Create the Monitoring Script

1. Open your terminal.
2. Navigate to a directory where you want to save your monitoring script and create it:
   ```bash
   cd $HOME
   nano monitor.sh
   ```
3. Paste the following script into the editor:
   ```bash
   #!/bin/bash

   FOLDER_PATH="/path/to/folder/to/watch/"

   open_with_macwhisper() {
       osascript -e "tell application \"MacWhisper\" to open \"$1\""
   }

   export -f open_with_macwhisper

   fswatch -o "$FOLDER_PATH" | while read f
   do
     find "$FOLDER_PATH" -type f -print0 | xargs -0 -I {} bash -c 'open_with_macwhisper "$@"' _ {}
   done
   ```
4. Save and exit by pressing `CTRL+X`, then `Y` to confirm, and `Enter` to save.

5. Make the script executable:
   ```bash
   chmod +x monitor.sh
   ```

## Usage

### Starting the Monitoring Script

To start monitoring in a `screen` session:

```bash
screen -S AutoWhisperWatcher
./monitor.sh
```

Detach from the screen session by pressing `CTRL+A` followed by `D`.

### Stopping the Monitoring Script

To stop the script:

1. Reattach to the screen session:
   ```bash
   screen -r AutoWhisperWatcher
   ```
2. Terminate the script by pressing `CTRL+C`.
3. Exit the screen session:
   ```bash
   exit
   ```

## Automation

### Configure to Run at Startup

1. Open crontab editor:
   ```bash
   crontab -e
   ```
2. Add the following line to run the script at reboot:
   ```bash
   @reboot screen -dmS AutoWhisperWatcher $HOME/monitor.sh
   ```

## Conclusion

AutoWhisperWatcher provides an automated solution to monitor a specific directory for new files and open them using MacWhisper without manual intervention.
