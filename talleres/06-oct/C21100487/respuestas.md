# Taller · coincidencia de patrones

Nombre: Israel De la Vega Hernandez
Número de control: C21100487
Equipo: 10

Copia este archivo a `talleres/06-oct/<tu número de control>/respuestas.md` en el repositorio de tu pareja,
junto con tu `patrones.ex`. Entrega: el mismo día del taller, antes de las 23:59.

## 1. ¿Por qué importa el orden de las cláusulas?

Explícalo con un ejemplo de TU `patrones.ex`: qué pasaría si cambias de lugar dos cláusulas.

Porque Elixir prueba las clausulas de arriba hacia abajo y se queda con la primera que encaja. En
`clasificar_peso` si pongo la de `_kg -> :pesado` hasta arriba, todo sale `:pesado`, hasta el 0 y el 999,
porque `_kg` encaja con cualquier numero y las de abajo ya nunca se usan (Elixir avisa que no pueden coincidir).
Lo mismo en `documentos_completos?`: si la de `_embarque -> true` va primero, una peligrosa sin numero UN saldria completa.

## 2. ¿Qué pasa cuando ninguna cláusula coincide?

¿Qué error da Elixir, y por qué es mejor que regresar un valor por omisión en silencio?

Da `** (FunctionClauseError) no function clause matching in Patrones.descripcion/1`, por ejemplo si le paso
`%{tipo: :granel}`. Es mejor porque truena en ese momento y te dice en que funcion fue, en vez de regresar
algo como "Carga general" y que el error se pase sin que nadie se de cuenta.

## 3. Escribiste `documentos_completos?` sin un solo `if`. ¿Cuántas cláusulas usaste y en qué orden?

Tres. Primero la peligrosa con `numero_un: nil` (false), luego la sobredimensionada con `permiso: nil` (false),
y al final una que acepta cualquier embarque y regresa true. La general cae en la ultima, igual que las que si traen su documento.
