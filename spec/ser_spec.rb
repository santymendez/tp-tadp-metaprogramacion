describe '#ser' do
  class SerSuite

    def initialize
      @jorge = Docente.new(30)
      @falso_jorge = Docente.new(30)
    end

    #pasa
    def testear_que_jorge_es_jorge
      @jorge.deberia ser @jorge
    end

    #falla
    def testear_que_falso_jorge_no_es_jorge
      @falso_jorge.deberia ser @jorge
    end

    #pasa
    def testear_que_7_es_menor_a_9
      7.deberia ser menor_a 9
    end

    #pasa
    def testear_que_7_es_uno_de_estos
      7.deberia ser uno_de_estos 7, 231, 34
    end

    #pasa
    def testear_que_los_procs_son_iguales
      mi_proc = proc {"hola"}
      mi_proc.deberia ser mi_proc
    end

    #pasa
    def testear_que_jorge_es_viejo
      @jorge.deberia ser_viejo
    end
    #
    # #falla
    def testear_que_jorge_es_joven
      @jorge.deberia ser_joven
    end

    #explota
    def testear_que_jorge_explota_con_ser_divertido
      @jorge.deberia ser_divertido
    end

    def esto_no_es_un_test
      puts "no me imprime nadie ni nada"
    end

    def testear_que_7_es_igual_a_hola
      7.deberia ser_igual "hola"
    end

    def testear_que_hola
      [1,2,3,4].deberia ser_igual [1,2,3,4]
    end

    def testear_que_hola_1
      "hola".deberia ser "hola"
    end

  end

  it 'comprobar resultados 6 pasados 4 fallados 1 explotados ' do
    resultado = TADsPec.testear SerSuite
    expect(resultado.cantidad_pasados).to be(6)
    expect(resultado.cantidad_fallados).to be(4)
    expect(resultado.cantidad_explotados).to be(1)
  end

end