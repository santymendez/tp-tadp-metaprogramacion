class Asercion
  attr_accessor :bloque
  attr_reader :instancia_suite

  def initialize(_instancia_suite, _bloque)
    @bloque = _bloque
    @instancia_suite = _instancia_suite
  end

  def asertar(obj)
    resultado = bloque.call(obj)
    instancia_suite.agregar_asercion resultado
    unless resultado.resultado_asercion
      raise FalloTestError
    end
  end
end

class AsercionSecundaria
  attr_reader :asercion

  def initialize(_asercion)
    @asercion = _asercion
  end

  def llamar_asercion_evaluada_en(obj)
    asercion.call(obj)
  end
end

class AsercionSobreSpy < Asercion
  def initialize(_instancia_suite, mensaje, _asercion)
    @mensaje = mensaje
    super(_instancia_suite, _asercion)
  end

  private def evaluar_primera_asercion (resultado_primera_asercion)
    if resultado_primera_asercion.resultado_asercion
      yield
    else
      resultado_primera_asercion
    end
  end

  def veces(numero_de_veces)
    self.bloque = proc do |obj_espiado|
      resultado = obj_espiado.recibio_n_veces?(@mensaje, numero_de_veces)
      veces_reales = obj_espiado.cuantas_veces_recibio(@mensaje)
      ResultadoAsercion.new(
        resultado,
        numero_de_veces,
        veces_reales,
        "Recibió #{@mensaje} x"
      )
    end
    self
  end

  def con_argumentos(*args)
    primer_bloque = @bloque
    self.bloque = proc do |espia_obtenido|
      resultado_primera_asercion = primer_bloque.call(espia_obtenido)
      evaluar_primera_asercion(resultado_primera_asercion) do
        resultado = espia_obtenido.recibio_con_argumentos?(@mensaje, *args)

        filtro = espia_obtenido.mensajes_recibidos.select do |mensaje_recibido|
          mensaje_recibido.mensaje == @mensaje
        end

        obtenido = filtro.inject([]) do |sum, mensaje_recibido|
          sum << mensaje_recibido.args
        end

        ResultadoAsercion.new(
          resultado,
          args,
          obtenido,
          !resultado ? "Recibir #{@mensaje} con argumentos " : ""
        )
      end
    end
    self
  end

  def asertar(obj)
    unless obj.is_a?(Spy)
      instancia_suite.agregar_asercion ResultadoAsercion.new(
        false, Spy, obj.class, "Que el objeto sea un "
      )
      raise FalloTestError
    end
    super
  end

end