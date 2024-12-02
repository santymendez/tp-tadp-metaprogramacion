require_relative 'aserciones'
require_relative 'deberia'
require_relative 'resultados'
require_relative 'errores'
require_relative 'mocks'
require_relative 'spies'

module Cambios
  #Guardo los mocks que voy creando
  def self.guardar(metodo)
    @mocks ||= []
    @mocks << metodo
  end

  #Revierto los mocks que use
  def self.revertir
    @mocks ||= []
    @mocks.each { |mock| mock.__revertir__ }
    @mocks = []
  end
end

module TADsPec
  class << self
    private def es_test?(suite, metodo)
      metodo.to_s.start_with? "testear_que_" and suite.instance_method(metodo).arity == 0
    end

    private def es_suite?(klass)
      klass.is_a? Class and klass.instance_methods.any? do
      |m|
        es_test? klass, m
      end
    end

    private def encontrar_suites
      ObjectSpace.each_object(Class).select do |klass|
        es_suite? klass
      end
    end

    private def obtener_tests(suite)
      suite.instance_methods.select do
      |m|
        es_test? suite, m
      end
    end

        
    private def testear_suite(suite, *tests_elegidos)
      instancia_suite = suite.new
      # le asignamos la lista a la instancia de la suite para poder irle agregando las aserciones

      instancia_suite.extend(Espiador)
      instancia_suite.extend(Aserciones)

      # Decision de poner uniq por si le pasas varias veces el mismo test, podria sacarse o tirar excepcion
      # comparando con el uniq.length

      tests_elegidos = tests_elegidos.empty? ? obtener_tests(suite) : tests_elegidos.uniq

      resultado_suite = ResultadoSuite.new(suite)

      tests_elegidos.each do |test|

        unless es_test?(suite, test)
          raise "Error: el test \"#{test.to_s}\" no cumple con la definición de test"
        end

        resultado_test = ResultadoTest.new(test)

        # este metodo hace muchas cosas, como por ejemplo agregar el test al resultado de la suite
        # y definirle el singleton method a la instancia para generar un punto de comuniacion entre las aserciones
        # y el resultado test
        resultado_test.correr_test(instancia_suite, resultado_suite)

        Cambios.revertir
      end
      resultado_suite
    end

    def testear(suite = nil, *args)
      resultados_tests_suites = []
      begin
        Object.define_method(:deberia, ProveedorDeberia.otorgar_deberia)
        Module.define_method(:mockear, Mockeador.instance_method(:mockear))
        if suite.nil?
          suites = encontrar_suites
          suites.each do |s|
            resultados_tests_suites << (testear_suite s)
          end
        else
          raise "Error #{suite.to_s} no es un suite valido" unless es_suite? suite
          resultados_tests_suites << (testear_suite(suite, *args))
        end
      ensure
        Object.remove_method(:deberia)
        Module.remove_method(:mockear)
      end
      # al crear esta clase se calculan la cantidad total de test pasados fallidos etc
      resultado_total = ResultadoEjecucion.new(resultados_tests_suites)
      resultado_total.imprimir_resultados
      resultado_total
    end
  end
end
