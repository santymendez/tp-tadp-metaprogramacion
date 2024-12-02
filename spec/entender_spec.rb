describe '#entender' do

  class EntenderSuite

    def initialize
      @jorge = Docente.new(30)
    end

    def testear_que_jorge_entiende_viejo
      @jorge.deberia entender :viejo?
    end

    def testear_que_jorge_entiende_joven
      @jorge.deberia entender :joven?
    end

    def testear_que_jorge_no_entiende_mayor
      @jorge.deberia entender :mayor?
    end

    def testear_que_jorge_entiende_class_y_singleton_class
      @jorge.deberia entender :class
      @jorge.deberia entender :singleton_class
    end

  end

  it "comprobar resultados, 3 test pasan, 1 falla " do
    resultado = TADsPec.testear EntenderSuite
    expect(resultado.cantidad_pasados).to be(3)
    expect(resultado.cantidad_fallados).to be(1)
    expect(resultado.cantidad_explotados).to be(0)
  end

end