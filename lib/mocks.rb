module Mockeador
  def mockear(nombre_metodo, &bloque)
    Cambios.guardar(Mock.new(self, nombre_metodo))
    self.define_method(nombre_metodo, &bloque)
  end
end

class Mock
  def initialize(clase, mensaje)
    @clase = clase
    @metodo_original = clase.instance_method(mensaje)
  end

  def __revertir__
    @clase.define_method(@metodo_original.name, @metodo_original)
  end
end