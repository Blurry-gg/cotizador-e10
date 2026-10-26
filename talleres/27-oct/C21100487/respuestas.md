# Taller 5 · Composición o herencia

Nombre: Israel De la Vega Hernandez
Número de control: C21100487
Equipo: 10

Copia este archivo a `talleres/27-oct/<tu número de control>/respuestas.md` en el repositorio de tu
equipo, junto con tu `composicion.ts`. Entrega: martes 27 de octubre, 23:59.

## Paso 1 · La herencia

**a)** ¿En qué dos clases está escrito el cálculo del seguro? ¿Por qué no se pudo escribir una sola
vez?

En `ConSeguro` y en `RefrigeradaConSeguro`. `RefrigeradaConSeguro` ya hereda de `Refrigerada` para tener el frio,
y en TypeScript una clase solo puede heredar de una, entonces no puede heredar tambien de `ConSeguro` y el 2 % se tiene que volver a escribir.

**b)** Con un tercer extra (express), ¿cuántas clases hacen falta para todas las combinaciones?
¿Cuántas son nuevas? Muestra la cuenta.

Cada extra se lleva o no: 2 × 2 × 2 = 8 clases. Ya hay 4, entonces son 4 nuevas: express solo,
frio + express, seguro + express y los tres.

## Paso 2 · La composición

**c)** Para agregar express a `composicion.ts`, ¿qué agregaste? ¿Cambió `cotizar`?

Solo una funcion de una linea, `express = (monto) => monto + 50000`. `cotizar` no cambio nada, nada mas
se pone `express` en la lista cuando la cotizacion lo lleva.

## Paso 3 · El orden

| Llamada | Predigo | Salió |
|---|---|---|
| `cotizar(100, 1000, [express, seguro])` | 152000 | 153000 |
| `cotizar(100, 1000, [seguro, express])` | 152000 | 152000 |

**d)** ¿Por qué salen distintos? (dos líneas)

Pense que daba igual el orden pero no. Con express primero el seguro cobra su 2 % sobre 150000 (ya con los $500),
y con el seguro primero solo cobra sobre los 100000 y luego se suman los 500.

## Paso 4 · Sostén la decisión

**e)** En su modelo del proyecto, ¿cómo están escritos los pasos del cálculo: con herencia o con
composición? Cita el archivo y la función.

Todavia no tenemos el modelo en el repositorio: le tocaba a mi compañero, pero no ha podido trabajar por problemas con su laptop y su cuenta de GitHub, asi que lo voy a hacer yo. Lo que si tenemos
es el motor en Elixir, `motor/lib/cotizador.ex`, y ahi `calcular/2` esta hecho con funciones chiquitas
(`descuento/3`, `base_recargo/3`, `pct/2`) que se van aplicando una tras otra, sin herencia. El modelo lo vamos a hacer igual, con composicion.

**f)** Da **un** caso, en su proyecto o fuera de él, donde sí usarías herencia, y di por qué ahí no
hay explosión de combinaciones. (tres líneas)

Un `class EmbarqueRechazado extends Error` para cuando el modelo rechaza un embarque.
Un embarque rechazado es un error y siempre lo va a ser, y se aprovecha el mensaje y la pila que ya trae `Error`.
Solo hay una cosa que varia (el motivo, que es un dato), no hay extras que se combinen, asi que no salen mas clases.
