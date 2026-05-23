# 🎬 CineApp

Aplicación móvil desarrollada con Flutter para buscar películas, ver detalles, trailers y guardar favoritos localmente. Consume la API pública de TMDB (The Movie Database).

---

## 📱 Capturas de pantalla

> Ver carpeta `/diagrams` para mockups y flujo de navegación.

---

## 🏗️ Arquitectura

CineApp utiliza **arquitectura limpia** con el patrón **BLoC** (Business Logic Component), dividida en 4 capas:

```
lib/
├── core/                        # Configuración global
│   ├── constants/               # Constantes de API
│   └── network/                 # Cliente HTTP (Dio)
├── data/                        # Capa de datos
│   ├── datasources/
│   │   ├── local/               # Base de datos Hive
│   │   └── remote/              # TMDB API
│   ├── models/                  # Modelos con serialización JSON
│   └── repositories/            # Implementación de repositorios
├── domain/                      # Capa de dominio (lógica pura)
│   ├── entities/                # Entidades del negocio
│   ├── repositories/            # Contratos (interfaces)
│   └── usecases/                # Casos de uso
└── presentation/                # Capa de presentación
    ├── blocs/                   # BLoCs (estados y eventos)
    │   ├── movie/
    │   ├── search/
    │   └── favorite/
    ├── screens/                 # Pantallas de la app
    └── widgets/                 # Widgets reutilizables
```

### Flujo de datos

```
Pantalla → BLoC → UseCase → Repository → Datasource (API / Hive)
```

---

## 📂 Clases principales

### Domain
| Clase | Descripción |
|-------|-------------|
| `Movie` | Entidad principal con id, título, sinopsis, poster, rating |
| `MovieRepository` | Contrato con todas las operaciones disponibles |
| `GetTrending` | Caso de uso: obtener películas en tendencia |
| `SearchMovies` | Caso de uso: buscar películas por texto y género |
| `GetFavorites` | Caso de uso: obtener favoritos locales |
| `ToggleFavorite` | Caso de uso: agregar o quitar un favorito |

### Data
| Clase | Descripción |
|-------|-------------|
| `MovieModel` | Modelo con serialización JSON y adaptador Hive |
| `GenreModel` | Modelo de género cinematográfico |
| `MovieRemoteDatasourceImpl` | Llamadas a la TMDB API con Dio |
| `MovieLocalDatasourceImpl` | Operaciones CRUD sobre Hive |
| `MovieRepositoryImpl` | Implementación del repositorio |

### Presentation
| Clase | Descripción |
|-------|-------------|
| `MovieBloc` | Maneja el estado de películas en tendencia |
| `SearchBloc` | Maneja búsqueda y filtros por género |
| `FavoriteBloc` | Maneja el estado de favoritos |
| `HomeScreen` | Pantalla principal con tendencias |
| `SearchScreen` | Pantalla de búsqueda con filtros |
| `DetailScreen` | Detalle de película con trailer y favorito |
| `FavoritesScreen` | Lista de películas guardadas localmente |
| `MovieCard` | Widget reutilizable de tarjeta de película |

### Android (Kotlin)
| Clase | Tipo | Descripción |
|-------|------|-------------|
| `MainActivity` | Activity | Punto de entrada de la app |
| `FavoriteSyncService` | Service | Sincronización de favoritos en background |
| `NetworkReceiver` | BroadcastReceiver | Detecta cambios de conectividad |
| `FavoriteProvider` | ContentProvider | Expone favoritos a otras apps |

---

## ⚙️ Requisitos previos

- Flutter SDK 3.x o superior
- Dart 3.x o superior
- Android Studio o VS Code
- Android SDK
- API Key de TMDB (gratuita en [themoviedb.org](https://www.themoviedb.org))

---

## 🚀 Pasos para compilar y ejecutar

### 1. Clonar el repositorio

```bash
git clone https://github.com/Cbusquets/PelispediaApp.git
cd PelispediaApp/cineapp
```

### 2. Crear el archivo de variables de entorno

Crear un archivo `.env` en la raíz de la carpeta `cineapp/`:

```
TMDB_API_KEY=tu_api_key_aqui
TMDB_BASE_URL=https://api.themoviedb.org/3
TMDB_IMAGE_URL=https://image.tmdb.org/t/p/w500
```

> ⚠️ El archivo `.env` está en `.gitignore` y no se sube al repositorio por seguridad.

### 3. Instalar dependencias

```bash
flutter pub get
```

### 4. Generar adaptadores de Hive

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 5. Ejecutar la app

```bash
flutter run
```

Para ejecutar en un dispositivo específico:

```bash
flutter run -d android   # Emulador o dispositivo Android
flutter run -d chrome    # Navegador web
```

### 6. Compilar APK de release

```bash
flutter build apk --release
```

El APK se genera en `build/app/outputs/flutter-apk/app-release.apk`

---

## 📖 Manual de usuario

### Pantalla principal (Home)
- Al abrir la app se muestran las películas en tendencia de la semana
- Tocá cualquier película para ver su detalle
- Usá el ícono de búsqueda (🔍) o la tab inferior para ir a buscar

### Búsqueda
- Escribí el nombre de una película en la barra de búsqueda
- Usá los chips de género (Acción, Drama, Comedia, etc.) para filtrar
- Podés combinar texto y género al mismo tiempo
- Tocá una película para ver su detalle

### Detalle de película
- Muestra título, rating, fecha de estreno y sinopsis
- Botón **Ver trailer** — abre el trailer oficial en YouTube
- Botón **Agregar a favoritos** — guarda la película localmente
- El botón cambia a **Quitar de favoritos** si ya está guardada

### Favoritos
- Muestra todas las películas guardadas localmente
- Funciona sin conexión a internet
- Tocá una película para ver su detalle
- Desde el detalle podés quitarla de favoritos

---

## 🔧 Dependencias principales

| Paquete | Versión | Uso |
|---------|---------|-----|
| `flutter_bloc` | ^9.0.0 | Manejo de estado |
| `go_router` | ^14.0.0 | Navegación |
| `dio` | ^5.4.0 | Cliente HTTP |
| `hive_flutter` | ^1.1.0 | Base de datos local |
| `shared_preferences` | ^2.2.3 | Preferencias de usuario |
| `cached_network_image` | ^3.3.1 | Caché de imágenes |
| `flutter_dotenv` | ^5.1.0 | Variables de entorno |
| `url_launcher` | ^6.2.6 | Abrir URLs externas |
| `equatable` | ^2.0.5 | Comparación de estados |

---

## 🧪 Tests

```bash
flutter test --reporter expanded
```

---

## 🔒 Seguridad

- La API Key se almacena en `.env` y nunca se sube al repositorio
- El archivo `.env` está incluido en `.gitignore`
- Se utiliza `flutter_secure_storage` para datos sensibles
- Ver carpeta `/reports` para informes de seguridad (SAST y Dependency Check)

---

## 📋 CI/CD

El proyecto utiliza **Fastlane** para automatizar el proceso de build y tests.

```bash
fastlane build    # Corre tests y genera APK
fastlane test     # Solo corre los tests
```

Ver configuración en `/fastlane/Fastfile`.

---

## 📁 Estructura del repositorio

```
PelispediaApp/
├── cineapp/          # Proyecto Flutter
├── diagrams/         # Mockups y diagramas de arquitectura
├── reports/          # Informes de seguridad y calidad
└── README.md
```

---
