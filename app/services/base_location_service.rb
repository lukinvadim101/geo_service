class BaseLocationService
  def call(search_param)
    raise NotImplementedError, 'Subclasses must implement #call method'
  end
end
