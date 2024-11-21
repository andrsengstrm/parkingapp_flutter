# Parkeringsapp server
Server-delen av en cli-baserad dart-app för att hantera parkeringar.

## Beskrivning
Server som hanterar parkeringar från klienten i projektet "cli-parking-app-client". På servern används ObjectBox för persistent lagring av data på servern. Alla anrop routas till sin respektive handler, som i sin tur använder repot för att hantera data i ObjectBox. S

