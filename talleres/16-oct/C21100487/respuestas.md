# Taller 3 · La mutación escondida

Nombre: Israel De la Vega Hernandez
Número de control: C21100487
Equipo: 10

Copia este archivo a `talleres/16-oct/<tu número de control>/respuestas.md` en el repositorio de tu
equipo, junto con tu `escondida.ex`. Entrega: viernes 16 de octubre, 23:59.

## 1 · Antes y después de ejecutar

Llena "Predigo" **antes** de correr `npx tsx escondida.ts`. No borres las predicciones que fallaron.

| Línea | Predigo | Salió |
|---|---|---|
| 1 · | A,B false | B,A true |
| 2 · | 10 true | 10 true |
| 3 · | 1 false | 2 true |
| 4 · | null false | SCT-77 false |
| 5 · | 12 15 | 15 15 |

## 2 · Qué se muta y quién se entera

| # | Función | ¿Qué línea muta, y qué cambia? | ¿Quién más se entera del cambio? |
|---|---|---|---|
| 1 | ordenarPorPeso | el `sort`, porque ordena el mismo arreglo en vez de hacer otro | el `lote`, quedo ordenado aunque yo no lo toque |
| 2 | conDescuento | `reglas.descuentoPct = pct`, le cambia el descuento al objeto que le pasas | `base`, se fue de 5 a 10 |
| 3 | registrar | el `push` a `vistos` que es global | todos los que llamen registrar, primera y segunda terminan siendo lo mismo |
| 4 | conPermiso | `copia.documentos.permiso = permiso`, documentos no se copio | el original, tambien le quedo el permiso |
| 5 | fechaDeEntrega | el `setDate`, mueve la fecha que le pasas | `salida`, ahora dice 15 en vez de 12 |

## 3 · Tres preguntas cortas

**a)** En la línea 4 salió `false` en `original === conP`, y aun así el original cambió. ¿Cómo es
posible? (dos líneas)

Porque el `{ ...e }` si hace otro objeto pero nada mas por fuera, lo de adentro (documentos) sigue
siendo el mismo para los dos. Entonces si lo cambias en la copia tambien cambia en el original.

**b)** ¿Por qué `registrar` no es una función pura? (una línea)

Porque usa y cambia `vistos` que esta afuera, y aunque le pases lo mismo no siempre te regresa lo mismo.

**c)** En tus pruebas de Elixir, la última aserción de cada una revisa que el original sigue igual.
¿Por qué en Elixir esa aserción no puede fallar? (dos líneas)

Porque en Elixir los datos no se pueden modificar una vez que existen (son inmutables).
Las funciones siempre regresan algo nuevo y el original se queda como estaba.
