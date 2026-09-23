# Cotizador — repositorio del proyecto

## Antes de empezar

```bash
npm install
npm run verificar
```

**La verificación va a fallar.** Es a propósito: hay una prueba en rojo.
Tu primer pull request del curso es ponerla en verde.

## Reglas del repositorio

1. **Nunca se hace push directo a `main`.** Se trabaja en una rama corta y se abre un PR.
2. **Cada PR debe pasar CI en verde** para poder integrarse.
3. **Cada PR se liga a un issue.**
4. **Los mensajes de commit siguen Conventional Commits**, y describen el PROPÓSITO
   del cambio, no su mecánica.

| Mal | Bien |
|---|---|
| `fix: cambios` | `fix: aplica el descuento por volumen exactamente en 1000 kg` |
| `update codigo` | `test: cubre el límite inferior del descuento por volumen` |
| `wip` | `refactor: extrae la tabla de recargos del cálculo` |

> El mensaje de commit es la evidencia de que entendiste lo que hiciste.
> Si no puedes describir el propósito en una línea, probablemente no lo entendiste.

## Comandos

| Comando | Qué hace |
|---|---|
| `npm run verificar` | Tipos, análisis estático y pruebas. Es lo mismo que corre CI |
| `npm test` | Solo pruebas |
| `npm run lint` | Solo análisis estático |
