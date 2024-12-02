class ResultadoSuite
  attr_reader :tests_propios, :suite

  def initialize(_suite)
    @suite = _suite
    @tests_propios = []
  end

  def agregar_test(resultado_test)
    @tests_propios << resultado_test
  end

  def total_tests_en_estado(estado)
    @tests_propios.count { |test| test.resultado == estado }
  end
end

class ResultadoTest
  attr_accessor :nombre_test, :resultado, :resultados_aserciones, :excepcion, :stack

  def initialize(_nombre_test)
    @nombre_test = _nombre_test
    @resultados_aserciones = []
  end

  def imprimir
    puts @resultado.mensaje(self)
  end

  def correr_test(instancia_suite, resultado_suite)
    aserciones = @resultados_aserciones
    instancia_suite.define_singleton_method(:agregar_asercion) { |asercion| aserciones << asercion }
    resultado_suite.agregar_test(self) # esto es para guardar el resultado y dsps poder contar tod0

    begin
      instancia_suite.send(@nombre_test)
    rescue => error
      if error.is_a? FalloTestError
        @resultado = FALLO
      else
        @resultado = EXPLOTO
        @stack = error.backtrace
        @excepcion = error.message
      end
    else
      @resultado = PASO
    end
  end

end

class ResultadoAsercion
  attr_accessor :resultado_asercion, :resultado_esperado, :resultado_obtenido, :texto_asercion

  def initialize(_resultado_asercion, esperado, _obtenido, texto = "")
    @resultado_esperado = esperado
    @texto_asercion = texto
    @resultado_asercion = _resultado_asercion
    @resultado_obtenido = _obtenido
  end

  def mensaje_asercion
    "\t\t\t\e[33mResultado esperado: #{@texto_asercion}#{@resultado_esperado.to_s}\n\t\t\tResultado obtenido: #{@resultado_obtenido.nil? ? "nil" : @resultado_obtenido.to_s}\n\e[0m"
  end
end

class ResultadoEjecucion
  attr_accessor :cantidad_pasados, :cantidad_fallados, :cantidad_explotados, :lista_tests

  def initialize (_lista_tests)
    @lista_tests = _lista_tests
    @cantidad_pasados = total_tests_en_estado(PASO)
    @cantidad_fallados = total_tests_en_estado(FALLO)
    @cantidad_explotados = total_tests_en_estado(EXPLOTO)
  end

  def imprimir_resultados
    puts "Total pasados: #{@cantidad_pasados}"
    puts "Total fallados: #{@cantidad_fallados}"
    puts "Total explotados: #{@cantidad_explotados}\n\n"
    lista_tests.each do |t|
      puts "Suite: #{t.suite} =>\n"
      t.tests_propios.each { |tp| tp.imprimir }
    end
  end

  private def total_tests_en_estado(estado)
    @lista_tests.sum { |test_suite| test_suite.total_tests_en_estado(estado) }
  end
end

class Paso
  def mensaje(resultado_test)
    "\t\e[32mNombre del test: #{resultado_test.nombre_test.to_s}\n\t\tResultado: Pasó\e[0m\n\n"
  end
end

class Fallo
  def mensaje(resultado_test)
    asercion_fallida = resultado_test.resultados_aserciones.find { |r| !r.resultado_asercion }
    total = "\t\e[33mNombre del test: #{resultado_test.nombre_test.to_s}\n\t\tResultado: Falló\n\t\tMotivo:\e[0m\n"
    unless asercion_fallida.nil?
      total += asercion_fallida.mensaje_asercion
    end
    total
  end
end

class Exploto
  def mensaje(resultado_test)
    "\t\e[31mNombre del test: #{resultado_test.nombre_test.to_s}\n\t\tResultado: Explotó\n\t\t\t#{resultado_test.stack[0]}\e[0m: #{resultado_test.excepcion}\n\t\t\t\e[31m#{resultado_test.stack.drop(1).join("\n\t\t\t")}\e[0m\n\n"
  end
end

PASO = Paso.new
FALLO = Fallo.new
EXPLOTO = Exploto.new
