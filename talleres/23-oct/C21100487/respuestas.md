# Taller 4 · De condicionales a despacho

Nombre: Israel De la Vega Hernandez
Número de control: C21100487
Equipo: 10

Copia este archivo a `talleres/23-oct/<tu número de control>/respuestas.md` en el repositorio de tu
equipo, junto con tu `despacho.ts`. Entrega: viernes 23 de octubre, 23:59.

## Paso 1 · La versión con switch

**a)** Antes de tocar nada: ¿cuántos lugares de `condicionales.ts` hay que cambiar para agregar
`perecedera`?

Pense que 3, uno por cada switch. Se me olvido contar el tipo de arriba, en realidad son 4.

**b)** Después de agregar `'perecedera'` solo al tipo: ¿qué dijo `tsc`, y qué imprimió la
demostración para perecedera?

`tsc` no dijo nada, compilo sin errores. La demostracion imprimio `perecedera  0 null General`.

**c)** ¿Por qué el compilador no te avisó? (una línea)

Porque los tres switch tienen `default`, entonces perecedera cae ahi y para el compilador todo esta cubierto.

## Paso 3 · La versión con tabla

**d)** Después de agregar `'perecedera'` al tipo: ¿qué dijo `tsc`? Copia el mensaje.

```
src/despacho.ts(16,14): error TS2741: Property 'perecedera' is missing in type '{ general: { pct: number; fija: number; documento: null; etiqueta: string; }; refrigerada: { pct: number; fija: number; documento: null; etiqueta: string; }; peligrosa: { pct: number; fija: number; documento: "numeroUn"; etiqueta: string; }; sobredimensionada: { ...; }; }' but required in type 'Record<Tipo, Politica>'.
```

**e)** ¿Cuántos lugares cambiaste en `despacho.ts` para agregar perecedera?

Uno nada mas, la entrada en `POLITICAS` (ademas del tipo). Las tres funciones no se tocaron.

## Los dos lenguajes

**f)** En su motor de Elixir, ¿qué pasa si llega un tipo de carga para el que no hay cláusula? ¿Y en
`despacho.ts`, si a la tabla le falta un tipo? ¿Cuál de los dos te avisa antes, y cuándo? (dos líneas)

En nuestro motor si el tipo no esta en la lista `validar` lo rechaza con `:tipo_desconocido`, y si falta en las reglas el `Map.fetch!` truena con `KeyError`, pero eso es hasta que se ejecuta.
En TypeScript con `Record<Tipo, Politica>` ni compila, asi que te avisa antes, al compilar.
