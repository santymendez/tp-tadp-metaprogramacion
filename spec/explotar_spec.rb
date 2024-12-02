describe '#entender' do

  class ExplotarSuite
    def initialize
      @jorge = Docente.new(30)
    end

    # pasa
    def testear_que_explota_con_zero_division_error
      en { 7 / 0 }.deberia explotar_con ZeroDivisionError
    end

    # falla
    def testear_que_no_explota_con_zero_division_error
      en { 7 / 7 }.deberia explotar_con ZeroDivisionError
    end

    # falla
    def testear_que_jorge_viejo_no_explota_con_no_method_error
      en { @jorge.viejo? }.deberia explotar_con NoMethodError
    end

    # pasa
    def testear_que_jorge_nombre_explota_con_no_method_error
      en { @jorge.nombre }.deberia explotar_con NoMethodError
    end

    # falla
    def testear_que_no_explota_con_no_method_error
      en { 7 / 0 }.deberia explotar_con NoMethodError
    end

    # pasa
    def testear_que_heredan_errores
      en { @jorge.nombre }.deberia explotar_con StandardError
    end

  end

  it 'comprobar resultados 3 pasados 3 fallados 0 explotados ' do
    resultado = TADsPec.testear ExplotarSuite
    expect(resultado.cantidad_pasados).to be(3)
    expect(resultado.cantidad_fallados).to be(3)
    expect(resultado.cantidad_explotados).to be(0)
  end
end