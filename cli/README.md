# Parkeringsapp klient
Klienten för en cli-baserade dart-app för att hantera parkeringar.

## Beskrivning
Appen har följande komponenter:

- Models för person, fordon, parkeringsplats och parkering. Dessa models har olika värden beroende på vad som behövs, t.ex. namn och personnr för Ägare, Pris per timme för Pakeringsplatser o.s.v. Alla objekt i dessa olika models får ett unikt id (int) när de skapas. En model kan ingå i en annan model, t.ex. alla Fordon har en Ägare som är objektet Person, en Parkering har objekten Fordon och Parkeringsplats. Dessa refereras med faktiska värden när de skapas. Man skulle kunna referera dessa via en referens istället (id för objeketet), då skulle alla objekt där referensen finns automatiskt uppdateras när man uppdaterar objektet självt. Det kan vara en fördel i vissa fall och en nackdel i andra fall.
Det finns även funktioner för att serialsera och deserialisera JSON i varje Model. I Model för Parkeringar så finns också en funktion för att räkna ut aktuell kostnad för varje parkering.
Models finns i projektet "cli-parking-app-shared", och används av både klient och server.

- Repositories: Alla models har en egen repository som implementerar interfacet för repository (finns i projektet "cli-parking-app-shared"). Interfacet innehåller CRUD för anonyma objekt som ärvs till varje repo. Alla repos kommunicerar med servern där data hanteras.

- Menu: Menyn för av varje del i applikationen. Ägare, Fordon, Parkeringsplatser och Parkeringar. Felhantering är implementerad för att ta hand om inmatningsfel, och viss validering av val där man väljer objekt från ett index.


