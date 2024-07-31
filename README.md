# TicketLogGPT

A quick and dirty macOS app that uses a provided git repo folder data and files to fetch a list of what you've worked on in the last month and then uses OpenAI function calling APIs to get readable, pretty formatted information for each day, ready to copy and paste into some work logging service of your choice.

Please note this is, as of now, built with a specific issue-#/urls format. May generalize it later. Also the formatted result is only readable in console output after having built the app. Also please always check twice for the output provided by GPT, it might be drunk from time to time.

## Usage

- You need to provide your own OpenAI API key, they will be stored in the keychain.
  - With the app open, open the settings either trough menu or via the shortcut `cmd+,`
  - Fill in information: select repo folder, paste API key, etc
- Click `Get Log`
- Wait for gpt response, hope it doesn't mess something up
- Get the result in console
- Profit

## To-do

- Move result to UI as a list of days and automate more stuff
- Integrate some logging service (toggl, harvest, etc?) API
- Add UI to select days and edit logs before sending to logging services
