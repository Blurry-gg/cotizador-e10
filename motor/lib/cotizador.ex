defmodule Cotizador do
  @moduledoc """
  Motor de cálculo del cotizador de cruce fronterizo de carga.

  Es puro: recibe el embarque y las reglas como datos y regresa un resultado.
  Ningún número de la variante vive aquí; todo sale de `reglas`.
  """

  @tipos [:general, :refrigerada, :peligrosa, :sobredimensionada]

  @doc """
  Cotiza un embarque con las reglas dadas.

  Regresa `{:ok, cotizacion}` o `{:error, motivo}` con el primer motivo de rechazo.
  """
  def cotizar(embarque, reglas) do
    with :ok <- validar(embarque, reglas) do
      {:ok, calcular(embarque, reglas)}
    end
  end

  # Una cláusula por motivo, en el orden del enunciado: la primera que encaja, gana.
  defp validar(%{peso_kg: p}, _reglas) when p <= 0, do: {:error, :peso_invalido}
  defp validar(%{distancia_km: d}, _reglas) when d <= 0, do: {:error, :distancia_invalida}
  defp validar(%{tipo: t}, _reglas) when t not in @tipos, do: {:error, :tipo_desconocido}

  defp validar(%{puente: p}, %{cuota_puente: cuotas}) when not is_map_key(cuotas, p) do
    {:error, :puente_desconocido}
  end

  defp validar(%{tipo: :peligrosa, numero_un: nil}, _reglas), do: {:error, :falta_numero_un}
  defp validar(%{tipo: :sobredimensionada, permiso: nil}, _reglas), do: {:error, :falta_permiso}

  # La sobredimensionada no tiene peso máximo: si llegó aquí ya trae permiso y está bien.
  # Tiene que ir antes de la del peso máximo, o también la rechazaría.
  defp validar(%{tipo: :sobredimensionada}, _reglas), do: :ok

  defp validar(%{peso_kg: p}, %{peso_maximo_kg: max}) when p > max do
    {:error, :excede_peso_maximo}
  end

  defp validar(_embarque, _reglas), do: :ok

  # Flete bruto, descuento, flete, cuota del puente, recargo y ajuste al mínimo.
  defp calcular(embarque, reglas) do
    flete_bruto = reglas.tarifa_km * embarque.distancia_km
    descuento = descuento(embarque.peso_kg, flete_bruto, reglas.descuento)
    flete = flete_bruto - descuento
    # El ! es a propósito: validar ya rechazó los puentes que no existen.
    cuota_puente = Map.fetch!(reglas.cuota_puente, embarque.puente)
    # Igual con el tipo: validar ya rechazó los tipos que no existen.
    %{pct: p, fija: fija} = Map.fetch!(reglas.recargo, embarque.tipo)
    recargo = pct(base_recargo(reglas.base_recargo, flete, cuota_puente), p) + fija
    sin_minimo = flete + cuota_puente + recargo
    total = max(sin_minimo, reglas.minimo)

    %{
      flete_bruto: flete_bruto,
      descuento: descuento,
      flete: flete,
      cuota_puente: cuota_puente,
      recargo: recargo,
      ajuste_minimo: total - sin_minimo,
      total: total
    }
  end

  # Sobre qué monto se cobra el porcentaje del recargo: una cláusula por base.
  defp base_recargo(:flete, flete, _cuota_puente), do: flete
  defp base_recargo(:subtotal, flete, cuota_puente), do: flete + cuota_puente

  # El criterio decide si el peso exacto del umbral lleva descuento: una cláusula por criterio.
  defp descuento(peso, flete_bruto, %{criterio: :a_partir_de, umbral_kg: u, pct: p})
       when peso >= u,
       do: pct(flete_bruto, p)

  defp descuento(peso, flete_bruto, %{criterio: :mas_de, umbral_kg: u, pct: p}) when peso > u,
    do: pct(flete_bruto, p)

  defp descuento(_peso, _flete_bruto, _descuento), do: 0

  # Un porcentaje, redondeado al centavo, las mitades hacia arriba.
  defp pct(monto, p), do: div(monto * p + 50, 100)
end
