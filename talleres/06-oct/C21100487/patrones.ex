defmodule Patrones do
  @moduledoc """
  Miercoles 30 · Coincidencia de patrones.

  Regla del dia: ni un solo `if`, `cond` ni `case` sobre el tipo. Cada decision es una
  clausula de funcion. Puedes escribir cuantas clausulas quieras de cada funcion.

      mix test test/patrones_test.exs
  """

  # 1 · Una clausula por tipo. La peligrosa saca su numero UN del mismo patron.
  def descripcion(%{tipo: :general}), do: "Carga general"
  def descripcion(%{tipo: :refrigerada}), do: "Carga refrigerada"
  def descripcion(%{tipo: :peligrosa, numero_un: un}), do: "Carga peligrosa (#{un})"
  def descripcion(%{tipo: :sobredimensionada}), do: "Carga sobredimensionada"

  # 2 · Primero los casos incompletos; la ultima clausula dice que todo lo demas esta bien.
  def documentos_completos?(%{tipo: :peligrosa, numero_un: nil}), do: false
  def documentos_completos?(%{tipo: :sobredimensionada, permiso: nil}), do: false
  def documentos_completos?(_embarque), do: true

  # 3 · Guardas con las fronteras exactas: 1000 ya es medio y 10_000 ya es pesado.
  def clasificar_peso(kg) when kg <= 0, do: :invalido
  def clasificar_peso(kg) when kg < 1000, do: :ligero
  def clasificar_peso(kg) when kg < 10_000, do: :medio
  def clasificar_peso(_kg), do: :pesado

  # 4 · La tupla se descompone en la cabeza de la funcion.
  def mensaje({:ok, total}), do: "Total: #{total}"
  def mensaje({:error, motivo}), do: "Rechazado: #{motivo}"

  # 5 · Lista vacia o cabeza y cola; de la cabeza solo interesa el id.
  def primer_id([]), do: :vacio
  def primer_id([%{id: id} | _resto]), do: id
end
