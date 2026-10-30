# Taller 3 · La mutación escondida

Nombre: Vanessa Cadena
Número de control: 22100261
Equipo: 10

Copia este archivo a `talleres/16-oct/<tu número de control>/respuestas.md` en el repositorio de tu
equipo, junto con tu `escondida.ex`.

## 1 · Antes y después de ejecutar

Llena "Predigo" **antes** de correr `npx tsx escondida.ts`. No borres las predicciones que fallaron.

| Línea | Predigo | Salió |
|---|---|---|
| 1 · | A,B true | B,A true |
| 2 · | 5 false | 10 true |
| 3 · | 1 true | 2 true |
| 4 · | null true | SCT-77 false |
| 5 · | 12 12 | 15 15 |

## 2 · Qué se muta y quién se entera

| # | Función | ¿Qué línea muta, y qué cambia? | ¿Quién más se entera del cambio? |
|---|---|---|---|
| 1 | ordenarPorPeso | el `sort` sobre `lote`: no hace otro arreglo, reordena ese | quien siga usando `lote`, porque ya quedó B y luego A |
| 2 | conDescuento | `reglas.descuentoPct = pct` le pisa el porcentaje al objeto recibido | `base`, que es ese mismo objeto, pasa de 5 a 10 |
| 3 | registrar | `vistos.push(id)` mete el id en la lista de afuera | la siguiente llamada: ya no empieza vacía, por eso la segunda ve 2 |
| 4 | conPermiso | después del `{ ...e }`, `copia.documentos.permiso = permiso` escribe en el objeto de adentro, que no se copió | el embarque original, que también muestra el permiso |
| 5 | fechaDeEntrega | `setDate` le suma los días a la fecha que le pasaron | `salida`, que ya no dice 12 |

## 3 · Tres preguntas cortas

**a)** En la línea 4 salió `false` en `original === conP`, y aun así el original cambió. ¿Cómo es
posible? (dos líneas)

`===` pregunta si es el mismo objeto. `{ ...e }` sí crea otro por fuera, por eso da `false`. Lo que
no copió fue `documentos`: los dos embarques usan ese mismo mapa, y al ponerle el permiso se ve en
los dos.

**b)** ¿Por qué `registrar` no es una función pura? (una línea)

Porque además de los argumentos usa `vistos`, que vive afuera, y cada llamada lo deja más largo.

**c)** En tus pruebas de Elixir, la última aserción de cada una revisa que el original sigue igual.
¿Por qué en Elixir esa aserción no puede fallar? (dos líneas)

Porque lo que recibo no se puede reescribir. Si quiero otro orden, otro descuento o otra fecha,
tengo que regresar un valor nuevo. La variable de antes se queda con lo que tenía.
