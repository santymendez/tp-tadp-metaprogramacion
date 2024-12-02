module Espiador
  def espiar(objeto_espiado)
    spy = Spy.new(objeto_espiado)
    spy.__configurar_objeto__(objeto_espiado)
    Cambios.guardar(spy)
    spy
  end
end

class MensajeRecibido
  attr_accessor :mensaje, :args

  def initialize(mensaje, args)
    @mensaje = mensaje
    @args = args
  end
end

class Spy

  attr_reader :mensajes_recibidos

  def initialize(objeto_espiado)
    @mensajes_recibidos = []
    @metodos_originales = {}
    objeto_espiado.methods.each do |simbolo|
      @metodos_originales[simbolo] = objeto_espiado.method(simbolo)
    end
  end

  def __configurar_objeto__ (objeto_espiado)
    spy = self
    objeto_espiado.methods.each do |simbolo|
      if se_puede_espiar(simbolo)
        objeto_espiado.define_singleton_method(simbolo) do |*args, &bloque|
          spy.enviar_mensaje(simbolo, *args, &bloque)
        end
      end
    end
  end

  def method_missing(mensaje, *args, &bloque)
    @metodos_originales[:send].call(mensaje, *args, &bloque)
  end

  def respond_to_missing?(mensaje, include_private = false)
    @metodos_originales[:respond_to_missing?].call(mensaje, include_private)
  end

  private def agregar_mensaje_recibido(metodo, args)
    @mensajes_recibidos.push(MensajeRecibido.new(metodo, args))
  end

  def enviar_mensaje(mensaje, *args, &bloque)
    self.agregar_mensaje_recibido(mensaje, args)
    if mensaje == :method_missing
      nombre_mensaje, *argumentos = args # hace head (el nombre con el que entro al method missing), *tail (el resto de los argumentos)
      self.agregar_mensaje_recibido(nombre_mensaje, argumentos)
    end
    @metodos_originales[mensaje].call(*args, &bloque)
  end

  def recibio?(mensaje)
    @mensajes_recibidos.any? { |m| m.mensaje == mensaje }
  end

  def recibio_n_veces?(mensaje, veces)
    cuantas_veces_recibio(mensaje) == veces
  end

  def cuantas_veces_recibio(mensaje)
    @mensajes_recibidos.count { |m| m.mensaje == mensaje }
  end

  def recibio_con_argumentos?(mensaje, *args)
    @mensajes_recibidos.any? { |m| m.mensaje == mensaje && m.args == args }
  end

  def __revertir__
    @metodos_originales.each do |simbolo, metodo|
      if se_puede_espiar(simbolo)
        # Verifica si el método fue definido en la singleton_class del objeto
        singleton_class = @metodos_originales[:singleton_class].call
        if singleton_class.instance_methods(false).include?(simbolo)
          singleton_class.remove_method(simbolo)
        end
        if metodo.owner == singleton_class
          # si el metodo era de la singleton_class le redefino el comportamiento original :)
          singleton_class.define_method(simbolo, metodo)
        end
      end
    end
  end

  private def se_puede_espiar(simbolo)
    simbolo != :object_id && simbolo != :__send__
  end

end