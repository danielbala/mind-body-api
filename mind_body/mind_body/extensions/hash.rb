class Hash
  def method_missing(method)
    sym = "#{method}".intern
    if self.key?(sym)
      self[sym]
    else
      super
    end
  end
end