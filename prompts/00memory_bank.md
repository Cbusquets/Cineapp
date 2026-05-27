# CineApp — Memory Bank
> Última actualización: Mayo 2026

---

## Contexto general

Proyecto universitario de la materia **Desarrollo de Aplicaciones Móviles**.
Equipo de **3 integrantes**. Repositorio: `github.com/Cbusquets/PelispediaApp`

El repo se llama PelispediaApp pero la app se llama **CineApp** (hubo un cambio de nombre a mitad del proyecto que luego se revirtió).

---

## La app

**CineApp** es un buscador de películas que consume la **TMDB API** (The Movie Database).

### Funcionalidades implementadas
- Pantalla Home con películas en tendencia
- Búsqueda en tiempo real por texto
- Filtros por género (chips) — funciona solo o combinado con texto
- Detalle de película: rating, sinopsis, fecha, trailer (abre YouTube)
- Favoritos con persistencia local (Hive) — funciona offline
- Navegación con 4 rutas y paso de parámetros entre pantallas

### Stack técnico
| Tecnología | Uso |
|-----------|-----|
| Flutter + Dart | Framework principal |
| BLoC + Equatable | Manejo de estado |
| GoRouter | Navegación |
| Dio | Cliente HTTP |
| Hive | Base de datos local (favoritos) |
| SharedPreferences | Preferencias de usuario |
| cached_network_image | Caché de imágenes |
| flutter_dotenv | Variables de entorno (API Key) |
| url_launcher | Abrir trailer en YouTube |
| Fastlane | CI/CD automatizado |
| flutter_test | Tests unitarios |

### API Key TMDB
- Guardada en `.env` dentro de `cineapp/`
- El `.env` está en `.gitignore` — nunca se sube a GitHub
- Variables: `TMDB_API_KEY`, `TMDB_BASE_URL`, `TMDB_IMAGE_URL`

---

## Arquitectura

**Arquitectura limpia** con patrón **BLoC** dividida en 3 capas:

```
presentation/   → pantallas + BLoCs (UI y lógica de UI)
domain/         → entidades + casos de uso + contratos (lógica pura)
data/           → repositorios + datasources + modelos (acceso a datos)
core/           → constantes + cliente HTTP (compartido)
```

### Flujo de datos
```
Pantalla → BLoC → UseCase → Repository → Datasource (API / Hive)
```

### BLoCs implementados
- `MovieBloc` — tendencias (HomeScreen)
- `SearchBloc` — búsqueda + filtros por género (SearchScreen)
- `FavoriteBloc` — favoritos (DetailScreen + FavoritesScreen)

### Casos de uso
- `GetTrending` — películas en tendencia
- `SearchMovies` — búsqueda con filtro opcional de género
- `GetFavorites` — leer favoritos de Hive
- `ToggleFavorite` — agregar o quitar favorito

### Datasources
- `MovieRemoteDatasourceImpl` — llama a TMDB API (trending, search, detail, genres, videos)
- `MovieLocalDatasourceImpl` — CRUD de favoritos en Hive

---

## Estructura de carpetas

```
PelispediaApp/
├── cineapp/                          ← proyecto Flutter
│   ├── android/
│   │   └── app/src/main/kotlin/com/example/cineapp/
│   │       ├── MainActivity.kt       ← Activity
│   │       ├── FavoriteSyncService.kt ← Service
│   │       ├── NetworkReceiver.kt    ← BroadcastReceiver
│   │       └── FavoriteProvider.kt   ← ContentProvider
│   ├── fastlane/
│   │   └── Fastfile                  ← lanes: test, build_debug, build_release, build
│   ├── lib/
│   │   ├── core/
│   │   │   ├── constants/api_constants.dart
│   │   │   └── network/dio_client.dart
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── local/movie_local_datasource.dart
│   │   │   │   └── remote/movie_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── movie_model.dart
│   │   │   │   ├── movie_model.g.dart  ← generado por build_runner
│   │   │   │   └── genre_model.dart
│   │   │   └── repositories/movie_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/movie.dart
│   │   │   ├── repositories/movie_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_trending.dart
│   │   │       ├── search_movies.dart
│   │   │       ├── get_favorites.dart
│   │   │       └── toggle_favorite.dart
│   │   ├── presentation/
│   │   │   ├── blocs/
│   │   │   │   ├── movie/   (movie_bloc, movie_event, movie_state)
│   │   │   │   ├── search/  (search_bloc, search_event, search_state)
│   │   │   │   └── favorite/ (favorite_bloc, favorite_event, favorite_state)
│   │   │   ├── screens/
│   │   │   │   ├── home_screen.dart
│   │   │   │   ├── search_screen.dart
│   │   │   │   ├── detail_screen.dart
│   │   │   │   └── favorites_screen.dart
│   │   │   └── widgets/movie_card.dart
│   │   └── main.dart
│   ├── test/widget_test.dart          ← 8 tests unitarios
│   ├── .env                           ← NO está en git
│   ├── pubspec.yaml
│   ├── Gemfile                        ← dependencias Fastlane
│   └── README.md
├── diagrams/                          ← mockups + diagramas de arquitectura
└── README.md
```

---

## Componentes Android implementados

| Tipo | Clase | Función |
|------|-------|---------|
| Activity | MainActivity | Punto de entrada de la app |
| Service | FavoriteSyncService | Sincroniza favoritos en background |
| BroadcastReceiver | NetworkReceiver | Detecta cambios de conectividad |
| ContentProvider | FavoriteProvider | Expone favoritos a otras apps |
| Intent | AndroidManifest.xml | Compartir películas + abrir YouTube |

---

## Fastlane

Instalado con Ruby. Lanes disponibles:
```ruby
fastlane test          # corre flutter test --reporter expanded
fastlane build_debug   # compila APK debug con Gradle
fastlane build_release # compila APK release
fastlane build         # test + build_debug juntos
```

APK debug generado en: `cineapp/build/app/outputs/flutter-apk/app-debug.apk`

---

## Tests unitarios

8 tests en `test/widget_test.dart` usando `flutter_test`.
Todos pasando. Usan un `MockMovieRepository` que no toca Hive ni la API.

Grupos:
- `GetTrending` — verifica que retorna lista
- `SearchMovies` — busca por título, retorna vacío si no hay
- `Favoritos` — agregar, quitar, isFavorite true/false
- `Movie entity` — crea entidad correctamente

Correr tests: `flutter test` o `fastlane test`

---

## Entregables completados

- [x] Mockups y flujo de navegación (en `/diagrams`)
- [x] Diagrama de arquitectura conceptual (en `/diagrams`)
- [x] Diagrama BLoC por capas (en `/diagrams`)
- [x] Código Flutter completo en GitHub
- [x] README detallado con arquitectura, clases, pasos y manual
- [x] Componentes Android (5 tipos)
- [x] Fastlane CI/CD configurado y funcionando
- [x] Tests unitarios (8 passing)
- [x] PPT de presentación (5 diapositivas, estilo oscuro)
- [x] Guión de presentación (~5 minutos)
- [x] Archivo de prompts para auditoría de IA


---

## Decisiones técnicas importantes

- **Hive sobre SQLite** — suficiente para lista de favoritos, más simple, no requiere SQL
- **BLoC sobre Provider/Riverpod** — más explícito, mejor para proyectos con múltiples estados complejos
- **GoRouter** — navegación declarativa con paso de parámetros via `extra`
- **flutter_dotenv** — protege la API Key del repositorio
- **Arquitectura limpia** — permite testear casos de uso sin tocar UI ni API

---

## Notas varias

- El proyecto usa **Windows** (PowerShell)
- Ruby 3.2.x instalado para Fastlane
- El search_screen usa `discoverByGenre` cuando no hay texto y hay género seleccionado
- El detail_screen carga el trailer asincrónicamente con `_loadTrailer()` en `initState`
- El `MovieRepository` está registrado como `RepositoryProvider` en `main.dart` para que `DetailScreen` pueda accederlo con `context.read<MovieRepository>()`
