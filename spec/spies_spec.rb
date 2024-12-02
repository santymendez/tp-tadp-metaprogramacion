require_relative 'spec_helper'

class Persona
  attr_accessor :edad
  def initialize(edad)
    self.edad = edad
  end
  def viejo?
    self.edad > 29
  end

  def algo(uno=nil, dos=nil)
    puts uno
    puts dos
  end

  def method_missing(name, *args)
    if name.to_s.start_with? 'metodo_faltante_'
      puts args
    else
      super
    end
  end

  def respond_to_missing?(name, include_private = false)
    name.to_s.start_with? 'metodo_faltante_'
  end
end

describe '#spies' do
  class PersonaTest
    def initialize
      @lean = Persona.new(22)
      @pato = Persona.new(23)
    end

    def testear_que_se_use_la_edad
      pato_espia = espiar(@pato)
      pato_espia.viejo?
      pato_espia.deberia haber_recibido(:edad)
      # pasa: edad se llama durante la ejecución de viejo?
    end

    def testear_que_no_se_use_la_edad
      pato_espia = espiar(@pato)
      pato_espia.deberia haber_recibido(:edad).veces(5)
      # falla: edad no se llama xq no se llama a viejo?
    end

    def testear_que_se_use_la_edad_1_vez
      pato_espia = espiar(@pato)
      pato_espia.viejo?
      pato_espia.deberia haber_recibido(:edad).veces(1)
      # pasa: edad se recibió exactamente 1 vez.
    end

    def testear_que_se_use_la_edad_no_se_usa_n_veces
      pato_espia = espiar(@pato)
      pato_espia.viejo?
      pato_espia.deberia haber_recibido(:edad).veces(5)
      # falla: edad sólo se recibió una vez.
    end

    def testear_que_se_llama_con_arg
      pato_espia = espiar(@pato)
      pato_espia.viejo?
      pato_espia.deberia haber_recibido(:viejo?).con_argumentos
      # pasa, recibió el mensaje sin argumentos.
    end

    def testear_que_no_se_llama_con_arg
      pato_espia = espiar(@pato)
      pato_espia.viejo?
      pato_espia.deberia haber_recibido(:viejo?).con_argumentos(19, "hola")
      # falla, recibió el mensaje, pero sin esos argumentos.
    end

    def testear_que_se_imprimen_bien_los_args
      pato_espia = espiar(@pato)
      pato_espia.algo("Sin argumentos",11)
      pato_espia.algo(123,@pato)
      pato_espia.deberia haber_recibido(:algo).con_argumentos
      # falla, recibió el mensaje, pero sin esos argumentos.
    end

    def testear_que_no_es_espiado
      @lean.viejo?
      @lean.deberia haber_recibido(:edad)
      # falla: lean no fue espiado!
    end

    def testear_que_funciona_con_method_missing
      lean_espia = espiar(@lean)
      lean_espia.metodo_faltante_algo "Este metodo esta en method missing"
      lean_espia.deberia haber_recibido :metodo_faltante_algo
      lean_espia.deberia haber_recibido(:method_missing).con_argumentos(:metodo_faltante_algo,"Este metodo esta en method missing")
      # pasa, recibe el mensaje por method missing
    end

    def testear_que_veces_o
      lean_espia = espiar(@lean)
      lean_espia.metodo_faltante_algo "Este metodo esta en method missing"
      lean_espia.deberia haber_recibido(:viejo?).veces(0)
    end

    def testear_que_lo_atrapa_antes_de_con_args
      lean_espia = espiar(@lean)
      lean_espia.metodo_faltante_algo "Este metodo esta en method missing"
      lean_espia.deberia haber_recibido(:viejo?).con_argumentos(0,0,0)
    end


    def testear_que_espia_singleton_methods
      @lean.define_singleton_method(:un_metodo) do
        puts "Soy un metodo"
      end
      lean_espia = espiar(@lean)
      lean_espia.un_metodo
      lean_espia.deberia haber_recibido :un_metodo
      # pasa, recibe el mensaje por method missing
    end


    def testear_que_combineta
      Persona.mockear(:viejo?) do  "saludos" end
      jorge = Persona.new(20)
      x = espiar(jorge)
      x.viejo?
      x.deberia haber_recibido(:viejo?).veces(1)
      #Pasa, se llama al metodo mockeado
    end
  end

  ## Es correcto que ninguno explote?
  it "Testeo todo el espia, pasados 6, fallados 5, ninguno explota" do
    resultado = TADsPec.testear PersonaTest
    expect(resultado.cantidad_pasados).to be(7)
    expect(resultado.cantidad_fallados).to be(6)
    expect(resultado.cantidad_explotados).to be(0)
  end
end