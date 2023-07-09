# StudIPadawan

## Weitere Abgaben
Die weiteren Abgaben wie Projektreport, Videos, Screenshots, etc. können über folgenden Link eingesehen / heruntergeladen werden:  
https://www.dropbox.com/sh/6021pdbwvk5mpix/AAB77v6MDkzKX0r64GxQmJX1a?dl=0

## Setup
### Flutter installieren
**Hinweis**: Die folgenden Schritte beziehen sich auf das Setup für macOS in Kombination mit der Ausführung von Flutter Apps im iOS Simulator. Die entsprechende Dokumentation sowie die Beschreibung für andere Betriebssysteme kann unter https://docs.flutter.dev/get-started/install eingesehen werden.
1. Zunächst muss Flutter heruntergeladen und entpackt werden:
https://docs.flutter.dev/get-started/install/macos#get-sdk
2. Anschließend sollte Flutter als Path Variable hinzugefügt werden:
https://docs.flutter.dev/get-started/install/macos#update-your-path
3. Um Flutter Apps im iOS Simulator ausführen zu können, ist Xcode erforderlich. Xcode kann über den normalen macOS App Store installiert werden. Es sollten anschließend die hier beschriebenen Schritte ausgeführt werden:
https://docs.flutter.dev/get-started/install/macos#install-xcode
4. Zusätzlich ist die Installation von Cocoapods nötig. Diese kann am einfachsten mittels [Homebrew](https://brew.sh/) über ein Terminal durchgeführt werden:  
`brew install cocoapods`
5. Bei der Ausführung von `flutter doctor` sollte jetzt ein grüner Haken neben "Xcode - develop for iOS and macOS (Xcode [version])" sichtbar sein.

### Projekt starten
- `git clone https://gitlab.hs-flensburg.de/projekt-6.-semester/studipadawan.git`
- `flutter pub get`
- `cd packages/studip_api_client/`
- `dart run build_runner build -d` (Codegenerierung für die Modelklassen im Zusammenhang mit [json_serializable](https://pub.dev/packages/json_serializable))
- `cd ../..`
- `open -a Simulator` (für einen iOS Simulator, für einen Android Emulator siehe [Doku](https://developer.android.com/studio/run/emulator-commandline))
- `flutter run`

### Flutter Entwicklungsumgebung
Flutter Apps können in verschiedenen Entwicklungsumgebungen wie z.B. [Android Studio](https://developer.android.com/studio) oder [Visual Studio Code](https://code.visualstudio.com) entwickelt werden.  
Am einfachsten ist die Verwendung von Visual Studio Code. Hier genügt es, die [Flutter Extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter) hinzuzufügen, um so u.a. den Debugger verwenden zu können. Zudem kann die [Flutter Widget Snippets](https://marketplace.visualstudio.com/items?itemName=alexisvt.flutter-snippets) Extension installiert werden, um die Entwicklungsarbeit zusätzlich zu erleichtern.