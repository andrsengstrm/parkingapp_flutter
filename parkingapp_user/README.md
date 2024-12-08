# Parkingapp_user

Mobilapp för att hantera parkeringar. 

## Beskrivning
Det första man måste göra är att skapa en ny användare eller logga in som befintlig användare. Om man skapar en ny användare så anger man email, namn och personnummer. Då skapas en ny Person i applikationen och avändaren loggas in.
Om man redan har registrerat sig så använder man email och lösenord för att logga in, endast email (ej lösenord) verifieras mot användardatabasen. Det är alltså en väldigt simpel autentisering.

Applikation har en view, main_view.dart, som innehåller NavigationBar och en Expanded-widget. Även Login View hanteras via main_view. 
När man navigerar mellan views i appen så ändrar jag view i Expanded-widgeten baserat på index i NavigationBar. Jag skickar även med objeket Person till varje view så att jag enkelt kan hämta användarens data från servern.

### Views
Parking_view innehåller alla funktioner för att starta och avsluta parkeringar, och man kan även se statisk om parkeringar. 
När man startar en ny parkering så väljer man sitt fordon och vilken parkeringsplats som ska användas, endast lediga parkeringsplatser kan väljas.

Vehicle_view innehåller alla fordon som man registrerat. Man kan se information om fordon och lägga till och ta bort fordon.

Account_view innehåller användares data: email, namn och personnr. Man kan redigera datan.

Utloggning sker genom att varibeln isLoggedIn sätts till false.

### Repos
Samma repos används som från tidigare inlämningar, och jag har lagt till en funktioner för att hämta person, fordon och parkeringar baserat på fordonets ägares email. 
Jag hade problem med att få kontakt med servern när jag använde localhost som uri, så jag fick använda "http://10.0.2.2:8080" istället. Tydligen special när man använder Android-simulatorn, tack Google för fixen. :-)

