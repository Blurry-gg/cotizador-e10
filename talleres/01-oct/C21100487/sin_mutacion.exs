defmodule SinMutacion do
  @moduledoc """
  Las cinco funciones de partida, reescritas sin mutación.

  Cada función recibe datos y DEVUELVE datos nuevos. Nunca modifica
  lo que le prestaron: el caller conserva su valor original intacto.
  """

  @type embarque :: %{
          id: String.t(),
          peso_kg: number(),
          distancia_km: number(),
          tipo: String.t(),
          urgente: boolean()
        }

  # ─────────────────────────────────────────────────────────────
  # 1 · total_pesos/1
  # Acumulador que cambia en cada vuelta → Enum.reduce/3
  # ─────────────────────────────────────────────────────────────
  @spec total_pesos([embarque()]) :: number()
  def total_pesos(embarques) do
    Enum.reduce(embarques, 0, fn e, total -> total + e.peso_kg end)
  end

  # Alternativa idiomática (sin acumulador explícito):
  # def total_pesos(embarques), do: Enum.sum_by(embarques, & &1.peso_kg)

  # ─────────────────────────────────────────────────────────────
  # 2 · marcar_urgentes/1
  # En TS modificaba los objetos del caller. Aquí devolvemos
  # mapas NUEVOS: el caller conserva los suyos intactos.
  # ─────────────────────────────────────────────────────────────
  @spec marcar_urgentes([embarque()]) :: [embarque()]
  def marcar_urgentes(embarques) do
    Enum.map(embarques, fn e ->
      %{e | urgente: e.distancia_km > 500}
    end)
  end

  # ─────────────────────────────────────────────────────────────
  # 3 · aplicar_descuento/2
  # En TS reescribía el array in-place. Aquí producimos una
  # lista NUEVA; la original del caller queda intacta.
  #
  # Descuento = precio - floor((precio * pct + 50) / 100)
  # ─────────────────────────────────────────────────────────────
  @spec aplicar_descuento([number()], number()) :: [number()]
  def aplicar_descuento(precios, pct) do
    Enum.map(precios, fn precio ->
      precio - div(precio * pct + 50, 100)
    end)
  end

  # ─────────────────────────────────────────────────────────────
  # 4 · contar_por_tipo/1
  # Objeto contador que crece → Enum.reduce/3 construyendo
  # un mapa nuevo en cada paso.
  # ─────────────────────────────────────────────────────────────
  @spec contar_por_tipo([embarque()]) :: %{String.t() => non_neg_integer()}
  def contar_por_tipo(embarques) do
    Enum.reduce(embarques, %{}, fn e, conteo ->
      Map.update(conteo, e.tipo, 1, &(&1 + 1))
    end)
  end

  # Alternativa de una línea:
  # def contar_por_tipo(embarques), do: Enum.frequencies_by(embarques, & &1.tipo)

  # ─────────────────────────────────────────────────────────────
  # 5 · sin_duplicados/1
  # Dos estructuras que crecen a la vez → Enum.reduce/3 con
  # una tupla {vistos, resultado} como acumulador.
  # ─────────────────────────────────────────────────────────────
  @spec sin_duplicados([String.t()]) :: [String.t()]
  def sin_duplicados(ids) do
    {_vistos, resultado} =
      Enum.reduce(ids, {MapSet.new(), []}, fn id, {vistos, acc} ->
        if MapSet.member?(vistos, id) do
          {vistos, acc}
        else
          {MapSet.put(vistos, id), [id | acc]}
        end
      end)

    Enum.reverse(resultado)
  end

  # Alternativa más corta usando Enum.uniq/1 (ya preserva orden):
  # def sin_duplicados(ids), do: Enum.uniq(ids)


end
# ─── Bloque de prueba  ───
if __ENV__.file == Path.expand(__ENV__.file) do
  embarques = [
    %{id: "A", peso_kg: 10, distancia_km: 600, tipo: "mar",    urgente: false},
    %{id: "B", peso_kg: 5,  distancia_km: 100, tipo: "tierra", urgente: false},
    %{id: "C", peso_kg: 7,  distancia_km: 800, tipo: "mar",    urgente: false}
  ]

  IO.puts("== 1 · total_pesos ==")
  IO.inspect(SinMutacion.total_pesos(embarques))

  IO.puts("== 2 · marcar_urgentes ==")
  IO.inspect(SinMutacion.marcar_urgentes(embarques))
  IO.puts("   original intacto:")
  IO.inspect(Enum.map(embarques, & &1.urgente))

  IO.puts("== 3 · aplicar_descuento ==")
  precios = [1000, 500, 250]
  IO.inspect(SinMutacion.aplicar_descuento(precios, 10))
  IO.puts("   original intacto:")
  IO.inspect(precios)

  IO.puts("== 4 · contar_por_tipo ==")
  IO.inspect(SinMutacion.contar_por_tipo(embarques))

  IO.puts("== 5 · sin_duplicados ==")
  IO.inspect(SinMutacion.sin_duplicados(["a", "b", "a", "c", "b", "d"]))
end
