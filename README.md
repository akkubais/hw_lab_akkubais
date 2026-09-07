# TempConverter — SwiftUI Lab

TempConverter is an iOS SwiftUI app that converts temperatures between Celsius and Fahrenheit. Its main screen follows the layout and light-blue styling shown in the lab handout.

## Lab requirements covered

- Numeric temperature input
- Empty and invalid input validation
- Celsius-to-Fahrenheit conversion
- Fahrenheit-to-Celsius conversion
- Native toggle switch for selecting the conversion direction
- Separate info page presented through `NavigationView`

## Run the app

1. Open `TempConverter.xcodeproj` in Xcode.
2. Select an iPhone simulator from the run-destination menu.
3. Press **Run** (`⌘R`).
4. If Xcode asks for signing, select your team under **TempConverter → Signing & Capabilities**. Simulator builds normally do not require a team.

The deployment target is iOS 17.0.

## Suggested screenshots

Capture these states so the submission demonstrates every significant output:

1. The initial converter screen.
2. Celsius → Fahrenheit: enter `100`, tap **Convert Temperature**, and capture the `212 °F` result.
3. Fahrenheit → Celsius: switch direction, enter `32`, tap **Convert Temperature**, and capture the `0 °C` result.
4. Input validation: clear the field and tap **Convert Temperature** to capture the error message.
5. Tap the info icon and capture the **Info** page.

## Tests

In Xcode, press `⌘U` to run the included unit tests. They cover both conversion formulas, negative/decimal input, comma decimal input, and invalid/empty values.

## GitHub submission

Replace `YOUR_ANDREW_ID` with your actual Andrew ID:

```sh
git init
git checkout -b hw_lab1_TempConverter
git add .
git commit -m "Complete TempConverter lab"
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/hw_lab_YOUR_ANDREW_ID.git
git push -u origin hw_lab1_TempConverter
```

Create the GitHub repository with the exact name `hw_lab_<your_andrewid>`, share it with your assigned CA, and submit the repository link plus screenshots through Canvas.
