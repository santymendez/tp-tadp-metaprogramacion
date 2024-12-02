describe "#tener" do

  class TenerSuite

    def initialize
      @jorge = Docente.new(30)
    end

    def testear_que_jorge_tiene_edad_30
      @jorge.deberia tener_edad 30
    end

    def testear_que_jorge_tiene_edad_20
      @jorge.deberia tener_edad 20
    end

    def testear_que_jorge_tiene_edad_mayor_a
      @jorge.deberia tener_edad mayor_a 20
    end

    def testear_que_jorge_tiene_edad_uno_de_estos
      @jorge.deberia tener_edad uno_de_estos true, "no", 30
    end

    def testear_que_jorge_tiene_energia_48
      @jorge.deberia tener_energia 48
    end

    def testear_que_jorge_tiene_energia_nil
      @jorge.deberia tener_energia nil
    end

  end

  it "comprobar resultados, 4 test pasan, 2 fallan, 0 explotan " do
    resultado = TADsPec.testear TenerSuite
    expect(resultado.cantidad_pasados).to be(4)
    expect(resultado.cantidad_fallados).to be(2)
    expect(resultado.cantidad_explotados).to be(0)
  end

end