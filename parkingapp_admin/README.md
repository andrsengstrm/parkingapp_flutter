# Parkingapp_admin

Windowsapp för att hantera parkeringar. 

## Beskrivning
En windows-app för att hantera parkeringar och parkeringsplatser i systemet

Applikation har en view, main_view.dart, som innehåller NavigationRail och en Expanded-widget.
När man navigerar mellan views i appen så ändrar jag view i Expanded-widgeten baserat på index i NavigationRail.

### Views
Dashboard_view är en enkel dashboard där man kan se aktiva och avslutade parkeringar, lediga och totalt antal parkeringsplatser samt en ihopräknad summa intjänade pengar från alla aktiva och avslutade parkeringar.

Parkings_view innehållar alla aktiva och avslutade parkeringar. 

Parking_spaces_view innehåller alla parkeringsplatser i systemet. Här man man lägga till, redigera och ta bort parkeringsplatser.

### Repos
Samma repos används som från tidigare inlämningar.
