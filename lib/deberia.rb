module ProveedorDeberia
  def deberia(asercion)
    asercion.asertar(self)
  end

  def self.otorgar_deberia
    instance_method(:deberia)
  end
end
