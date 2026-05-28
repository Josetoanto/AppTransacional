# AppTransaccional

Proyecto Flutter organizado con Screaming Architecture + Vertical Slicing.

## Estructura

```
lib/
	main.dart
	app.dart
	core/
		di/
		errors/
		network/
		extensions/
	shared/
		widgets/
		theme/
		constants/
	features/
		auth/
			data/
			domain/
			presentation/
		hilos/
			data/
			domain/
			presentation/
```

## Convenciones

- Archivos en snake_case.
- Clases en PascalCase.
- Cada feature vive en su slice independiente bajo lib/features.

## Comandos

Ejecuta desde la raiz del proyecto:

```bash
flutter pub get
flutter analyze
flutter run -d <simulator>
```

## Configuracion de baseUrl

La inyeccion manual se inicializa en [lib/main.dart](lib/main.dart#L1) usando:

```dart
await AppInjector.init(baseUrl: 'https://essentia.fun');
```

Opcionalmente puedes enviar tokenSecret y parametros de red (timeout/retries) desde AppInjector.init.
Las rutas por defecto ya apuntan a `/auth/login`, `/auth/register` y `/hilos`.

## Health Check HTTP

Script de infraestructura para validar cliente HTTP central:

```bash
dart run tool/health_check.dart
```

El script llama GET /health sobre https://essentia.fun y valida que exista message en el JSON.
