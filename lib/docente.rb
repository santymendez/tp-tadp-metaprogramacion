
class Docente
  attr_accessor :edad

  def initialize(edad)
    self.edad = edad
  end

  def viejo?
    @edad > 29
  end

  # Para probar
  def method_missing(method_name, *args)
    if method_name.to_s == "joven?"
      !viejo?
    else
      super
    end
  end

  def respond_to_missing?(method_name, *args)
    method_name.to_s == "joven?" || super
  end
end