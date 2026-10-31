defmodule Escondida do
  # Las mismas cinco del archivo de TypeScript.
  # Aquí no se puede cambiar lo que llega: cada función arma otro valor.

  # 1. Del más ligero al más pesado. sort_by deja el arreglo original quieto.
  def ordenar_por_peso(embarques) do
    Enum.sort_by(embarques, fn embarque -> embarque.peso_kg end)
  end

  # 2. Otro descuento, en un mapa nuevo.
  def con_descuento(reglas, pct) do
    Map.put(reglas, :descuento_pct, pct)
  end

  # 3. La lista me la pasan. Regreso otra con el id al final.
  def registrar(vistos, id) do
    vistos ++ [id]
  end

  # 4. Copio el embarque y también sus documentos, si no el permiso se comparte.
  def con_permiso(embarque, permiso) do
    documentos = Map.put(embarque.documentos, :permiso, permiso)
    Map.put(embarque, :documentos, documentos)
  end

  # 5. Una fecha nueva, tantos días después.
  def fecha_de_entrega(salida, dias) do
    Date.add(salida, dias)
  end
end
