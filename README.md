# QueenBee Mobile

Application mobile Flutter offline-first de gestion apicole pour
l'association BeeAfrica.

Ce dépôt contient le squelette de l'application mobile QueenBee. Il permet
de découvrir les principaux parcours utilisateur avant la connexion au
backend Spring Boot et à la base PostgreSQL.

## Fonctionnalités disponibles

- écran de connexion simulée ;
- liste des ruches avec score de santé et niveau de risque ;
- fonctionnement de démonstration hors connexion ;
- détail d'une ruche ;
- création d'une inspection locale ;
- déclaration d'une récolte locale ;
- consultation des alertes ;
- historique des récoltes ;
- affichage de la file d'opérations en attente ;
- synchronisation simulée ;
- tests widget Flutter.

> **Important :** l'authentification, Drift/SQLCipher, l'API REST, les
> notifications, le scanner QR et les photos ne sont pas encore connectés.
> Les données affichées proviennent de
> `lib/src/data/fake_queenbee_repository.dart`.

## Prérequis

Installez les outils suivants avant de cloner le projet :

- [Git](https://git-scm.com/downloads) ;
- [Visual Studio Code](https://code.visualstudio.com/) ;
- [Flutter](https://docs.flutter.dev/get-started/install) sur le canal
  `stable` ;
- [Android Studio](https://developer.android.com/studio) pour développer et
  tester sur Android.

Pour Android, Android Studio doit inclure les composants suivants dans
**SDK Manager > SDK Tools** :

- Android SDK Command-line Tools (latest) ;
- Android SDK Platform-Tools ;
- Android SDK Build-Tools ;
- Android Emulator.

Créez également un émulateur Android dans **Device Manager**. Un appareil
physique Android peut être utilisé à la place, avec le débogage USB activé.

## Vérifier l'installation

Ouvrez un nouveau terminal après l'installation de Flutter, puis exécutez :

```powershell
flutter --version
flutter doctor -v
flutter devices
```

Pour Android, toutes les licences doivent être acceptées :

```powershell
flutter doctor --android-licenses
```

Répondez `y` aux questions, puis relancez :

```powershell
flutter doctor
```

L'absence de Visual Studio n'empêche pas le développement Android. Visual
Studio est uniquement nécessaire pour compiler une application Flutter
Windows.

## Récupérer le projet

```powershell
git clone https://github.com/PouletDesMers/QueenBee.git
Set-Location QueenBee
```

Si vous travaillez sur une autre branche, adaptez la commande de changement
de branche :

```powershell
git checkout feature/mobile
```

## Installer les dépendances

Depuis la racine du projet :

```powershell
flutter pub get
```

## Vérifier le code avant de lancer l'application

Analyse statique :

```powershell
flutter analyze
```

Tests automatisés :

```powershell
flutter test
```

Les deux commandes doivent se terminer sans erreur.

## Lancer l'émulateur Android

Listez les émulateurs disponibles :

```powershell
flutter emulators
```

Démarrez ensuite votre émulateur, par exemple :

```powershell
flutter emulators --launch Pixel_8_Pro
```

Attendez que l'écran Android soit complètement démarré, puis vérifiez sa
détection :

```powershell
flutter devices
```

L'émulateur doit apparaître comme appareil `android`.

## Lancer QueenBee

Pour lancer l'application sur l'appareil Android détecté :

```powershell
flutter run
```

Pour sélectionner explicitement un appareil :

```powershell
flutter run -d emulator-5554
```

L'application démarre sur l'écran de connexion. Comme la connexion est
simulée, toute adresse email et tout mot de passe non vides fonctionnent,
par exemple :

```text
Email : apiculteur@beeafrica.org
Mot de passe : test123
```

## Parcours de démonstration

1. Connectez-vous avec des valeurs non vides.
2. Ouvrez **Mes ruches** et sélectionnez une ruche.
3. Dans le détail, créez une **Nouvelle inspection**.
4. Enregistrez-la hors ligne et vérifiez l'augmentation de la file d'attente.
5. Déclarez une récolte avec une quantité positive.
6. Consultez les onglets **Alertes** et **Récoltes**.
7. Ouvrez **Profil**, puis cliquez sur **Synchroniser**.
8. Vérifiez que le nombre d'opérations en attente revient à zéro.

## Rechargement à chaud

Quand `flutter run` est actif :

- `r` : hot reload ;
- `R` : hot restart ;
- `q` : arrêter l'application.

Le hot reload permet de voir rapidement les modifications Dart sans
redémarrer complètement l'application.

## Générer un APK de test

```powershell
flutter build apk --debug
```

L'APK est généré dans :

```text
build\app\outputs\flutter-apk\app-debug.apk
```

Pour l'installer sur un émulateur ou un appareil connecté :

```powershell
adb install -r "build\app\outputs\flutter-apk\app-debug.apk"
```

## Structure du projet

```text
lib/
├── main.dart
└── src/
    ├── app.dart
    ├── core/                  # thème et éléments transverses
    ├── data/                  # repository de démonstration
    ├── domain/                # modèles et contrats métier
    └── features/              # écrans organisés par fonctionnalité
test/
└── widget_test.dart
android/                       # configuration Android Flutter
```

## Dépendances

Les dépendances déjà déclarées dans `pubspec.yaml` comprennent notamment :

- `drift` pour préparer la base locale ;
- `dio` pour préparer l'API REST ;
- `go_router` pour la navigation ;
- `connectivity_plus` pour la connectivité ;
- `mobile_scanner` pour les QR codes ;
- `image_picker` pour les photos ;
- `local_auth` pour la biométrie ;
- `flutter_secure_storage` pour les secrets locaux ;
- `uuid` et `intl` pour les identifiants et les dates.

Certaines intégrations du dossier de conception restent à ajouter ou à
brancher, notamment SQLCipher, Riverpod, Workmanager, la compression des
photos et les notifications Firebase.

## Dépannage

### `flutter` n'est pas reconnu

Vérifiez que le dossier `bin` du SDK Flutter est dans le `PATH`, par exemple :

```text
C:\src\flutter\bin
```

Fermez puis rouvrez le terminal et VS Code après toute modification du
`PATH`.

### Aucun appareil Android n'est détecté

Vérifiez les points suivants :

1. l'émulateur est démarré et a terminé son démarrage ;
2. `flutter devices` affiche l'appareil ;
3. `adb devices` affiche l'appareil avec le statut `device` et non `offline` ;
4. Android SDK Platform-Tools est installé ;
5. les licences Android sont acceptées avec
   `flutter doctor --android-licenses`.

Si un émulateur reste `offline`, redémarrez-le puis exécutez :

```powershell
adb kill-server
adb start-server
flutter devices
```

### `flutter doctor` signale Visual Studio

Ce message concerne uniquement la cible Windows. Il peut être ignoré si vous
testez QueenBee sur Android, Chrome ou Edge.

### La première compilation est longue

C'est normal. Gradle peut télécharger le NDK, les plugins Android et les
artefacts nécessaires à la première compilation. Les compilations suivantes
seront généralement plus rapides.

## Prochaines étapes

Les prochaines intégrations prévues sont :

1. remplacer `FakeQueenBeeRepository` par Drift/SQLCipher ;
2. connecter l'authentification JWT + MFA ;
3. connecter les endpoints `/api/v1/sync/push` et
   `/api/v1/sync/pull` ;
4. ajouter la synchronisation offline-first réelle ;
5. connecter les photos, le QR code et les notifications ;
6. ajouter les écrans coordinateur.

## Contribution

Avant de proposer une pull request, exécutez au minimum :

```powershell
flutter pub get
flutter analyze
flutter test
```

Décrivez dans la pull request :

- le besoin traité ;
- les écrans concernés ;
- les tests exécutés ;
- les éventuelles limites connues.

## Licence

Projet pédagogique INGETIS / ITIS pour l'association BeeAfrica.
