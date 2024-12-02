describe '#deberia' do
  class SuitePrueba

    def initialize
      @jorge = Docente.new(30)
    end

    def testear_que_paraaaa_gonzaaaa

    end

    def esto_no_es_un_test
      @jorge.deberia
    end

    def puedo_mockear?
      Docente.mockear(:viejo?) do
        "dafdasfdsa"
      end
    end

    def puedo_espiar?
      x = espiar(@jorge)
    end

  end

  it 'comprobar que los objetos no entienden deberia fuera de los tests' do
    expect { 7.deberia }.to raise_error NoMethodError
  end

  let(:suite) { SuitePrueba.new }
  it 'comprobar que los objetos no entienden deberia fuera de los tests con una suite' do
    expect { suite.esto_no_es_un_test }.to raise_error NoMethodError
  end

  it 'comprobar que las clases no entienden mockear fuera de los tests' do
    expect { suite.puedo_mockear? }.to raise_error NoMethodError
  end

  it 'comprobar que la suite no entiende espiar fuera de los tests' do
    expect { suite.puedo_espiar? }.to raise_error NoMethodError
  end

end
