defmodule Escondida do
  # Taller 3 · La mutación escondida, en Elixir.
  # Las mismas cinco funciones de escondida.ts, pero aquí no hay nada que esconder:
  # cada una regresa un valor NUEVO y no puede tocar lo que recibió.

  # 1 · Del más ligero al más pesado.
  def ordenar_por_peso(embarques), do: Enum.sort_by(embarques, & &1.peso_kg)

  # 2 · Las mismas reglas con otro descuento_pct.
  def con_descuento(reglas, pct), do: %{reglas | descuento_pct: pct}

  # 3 · La lista ENTRA como argumento y sale una lista nueva con el id al final.
  def registrar(vistos, id), do: vistos ++ [id]

  # 4 · Un mapa nuevo en los dos niveles: el embarque y sus documentos.
  def con_permiso(embarque, permiso),
    do: %{embarque | documentos: %{embarque.documentos | permiso: permiso}}

  # 5 · La fecha de salida más unos días.
  def fecha_de_entrega(salida, dias), do: Date.add(salida, dias)
end
