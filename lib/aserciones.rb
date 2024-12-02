require_relative 'errores'
require_relative 'object_printer_helper'
require_relative 'asercion'

module Aserciones

  # Cada metodo debe devolver algo asi: obtener_asercion, proc { ResultadoAsercion.new cond_booleana, esperado, obtenido, texto_opcional }

  def obtener_asercion (bloque)
    Asercion.new self, bloque
  end

  def obtener_asercion_spy(mensaje, bloque)
    AsercionSobreSpy.new self, mensaje, bloque
  end

  def ser(valor_o_aser_sec)
    if valor_o_aser_sec.is_a? AsercionSecundaria
      bloque = valor_o_aser_sec.asercion
    else
      bloque = proc {
        |obj|
        iguales_por_valor = obj == valor_o_aser_sec
        if iguales_por_valor
          ResultadoAsercion.new (obj.equal? valor_o_aser_sec), ObjectPrinterHelper.print_object(valor_o_aser_sec), ObjectPrinterHelper.print_object(obj)
        else
          ResultadoAsercion.new iguales_por_valor, valor_o_aser_sec, obj
        end
      }
    end
    obtener_asercion(bloque)
  end

  def ser_igual(valor)
    bloque = proc {
      |obj| ResultadoAsercion.new obj == valor, valor, obj, "Es igual a "
    }
    obtener_asercion(bloque)
  end

  def tener_meta(atributo, valor_o_aser_sec)
    if valor_o_aser_sec.is_a? AsercionSecundaria
      bloque = proc { |obj| valor_o_aser_sec.llamar_asercion_evaluada_en(obj.instance_variable_get(atributo)) }
    else
      bloque = proc {
        |obj|
        valor_atributo = obj.instance_variable_get(atributo)
        texto_asercion = "#{obj} tiene #{atributo.to_s} = "
        ResultadoAsercion.new valor_atributo == valor_o_aser_sec, valor_o_aser_sec, valor_atributo, texto_asercion
      }
    end
    obtener_asercion(bloque)
  end

  def entender(simbolo)
    bloque = proc { |obj|
      resultado = obj.respond_to? simbolo
      ResultadoAsercion.new resultado, simbolo, !resultado ? "No entiende" : "", "Entiende "
    }

    obtener_asercion(bloque)
  end

  def explotar_con(error)
    bloque = proc { |obj|
      begin
        obj.call
      rescue => fallo
        ResultadoAsercion.new (fallo.is_a? error), error, fallo.class
      else
        ResultadoAsercion.new false, error, "No explota"
      end
    }

    obtener_asercion(bloque)
  end

  def en(&bloque)
    bloque
  end

  def menor_a(valor)
    AsercionSecundaria.new proc { |obj| ResultadoAsercion.new obj < valor, valor, obj, "Es menor a" }
  end

  def mayor_a(valor)
    AsercionSecundaria.new proc { |obj| ResultadoAsercion.new obj > valor, valor, obj, "Es mayor a" }
  end

  def uno_de_estos(*valor)
    AsercionSecundaria.new proc { |obj| ResultadoAsercion.new (valor.include? obj), valor, obj, "Es uno de estos " }
  end

  def haber_recibido(mensaje)
    bloque = proc do |obj|
      resultado = obj.recibio?(mensaje)
      ResultadoAsercion.new(resultado, mensaje, !resultado ? "No recibió el mensaje #{mensaje}" : "", "Recibir el mensaje ")
    end

    obtener_asercion_spy(mensaje, bloque)
  end

  def method_missing(method_name, *args)
    if method_name.to_s.start_with?("ser_")
      metodo = method_name.to_s.gsub("ser_", "") + "?"
      ser_meta(metodo)
    elsif method_name.to_s.start_with?("tener_")
      atributo = method_name.to_s.gsub('tener_', '')
      tener_meta("@#{atributo}".to_sym, *args)
    else
      super
    end
  end

  def respond_to_missing?(method_name, *args)
    method_name.to_s.start_with?("ser_") || method_name.to_s.start_with?("tener_") || super
  end

  def ser_meta(metodo)
    bloque = proc do |obj|
      resultado = obj.send(metodo)
      texto = "Es " + metodo.to_s + " "
      ResultadoAsercion.new resultado, obj, resultado, texto
    end

    obtener_asercion(bloque)
  end

end