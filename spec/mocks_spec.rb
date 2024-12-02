require_relative 'spec_helper'

describe '#mocks' do
  class PersonaHome
    def todas_las_personas
      [] # Este método consume un servicio web que consulta una base de datos
    end

    def personas_viejas
      self.todas_las_personas.select{|p| p.viejo?}
    end
  end

  class PersonaHomeTests
    def testear_que_personas_viejas_trae_solo_a_los_viejos
      nico = Docente.new(30)
      axel = Docente.new(30)
      lean = Docente.new(22)

      # Mockeo el mensaje para no consumir el servicio y simplificar el test
      PersonaHome.mockear(:todas_las_personas) do
        [nico, axel, lean]
      end

      viejos = PersonaHome.new.personas_viejas

      viejos.deberia ser_igual [nico, axel]
    end
  end

  it "Se mockea godines" do
    resultado = TADsPec.testear PersonaHomeTests
    expect(resultado.cantidad_pasados).to be(1)
    expect(resultado.cantidad_fallados).to be(0)
    expect(resultado.cantidad_explotados).to be(0)

  end

end