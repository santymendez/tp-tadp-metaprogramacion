class ObjectPrinterHelper
  def self.print_object(obj)
    "#<#{obj.class}:#{format('%x', obj.object_id)}>"
  end
end