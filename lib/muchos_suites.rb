require_relative 'tadspec'
require_relative 'docente'

class MiSuiteDeTests
  def testear_que_pasa_algo
    7.deberia ser mayor_a 2
    :hola.deberia entender :to_s
  end

  def otro_metodo_que_no_es_un_test
    7.deberia 7
  end
end

class OtroSuite
  def testear_que_algo_pasa
    7.deberia ser mayor_a 2
    :hola.deberia entender :bailar
  end

  def testear_que_este_quieroo
    7.deberia tener_suenio nil
  end

  def testear_que_este_no_es_test(algo = 0)
    puts algo
    puts 7.deberia tener_suenio nil
  end

  def otro_metodo_que_no_es_un_test
    7.deberia 7
  end
end

class SuiteSoloSer
  # def testear_que_anda_el_ser
  #   (5 + 2).deberia ser 7
  #   7.deberia ser 8
  #   20.deberia ser 9
  # end

  def testear_que_anda_ser_igual
    5.deberia ser_igual 5.0
    "jorge".deberia ser_igual "jorge"
  end

  def testear_que_anda_ser_igual_un_test
    juan = Docente.new(33)
    juan.deberia tener_edad 39
  end
end

class SuiteParaResultados
  attr_accessor :prueba

  def testear_que_pasan_todos
    20.deberia ser 20
    7.deberia ser menor_a 8
  end

  def testear_que_se_imprimen_bien_los_resultados
    en { 20 / 0 }.deberia explotar_con ZeroDivisionError
    20.deberia ser 28
    7.deberia ser_igual 8
    self.deberia entender :metodoInentendible
    7.deberia ser menor_a 5
    7.deberia ser mayor_a 8
    true.deberia ser uno_de_estos 7, "s", false
    en { 7 / 0 }.deberia explotar_con NoMethodError
    en { 7 / 7 }.deberia explotar_con NoMethodError
    @prueba = 22
    self.deberia tener_prueba 23
    # TODO fijense que les parece como se imprime
    self.deberia tener_prueba mayor_a 23
  end

  def testear_que_explota
    7.deberia ser jajajajjjajjajaajajajajja
  end

  def testear_que_uri
    jorge = Docente.new(22)
    # jorge.deberia ser_viejo
    jorge.deberia tener_edad uno_de_estos 10, 10, 10
  end

  def testear_que_anda_refactor
    7.deberia ser 7
    [1, 2, 3].deberia ser [1, 2, 3]
  end

  def testear_que_jajajajajaj
    "hola"
  end
end

# begin
#   TADsPec.testear SuiteParaResultados, :jorge
# rescue => error
#   puts error
#   7.deberia
# end
TADsPec.testear SuiteParaResultados, :testear_que_anda_refactor, :testear_que_uri, :testear_que_uri
