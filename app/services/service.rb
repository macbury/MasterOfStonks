class Service
  extend Usable

  def self.call(*args, **kwargs, &block)
    new(*args, **kwargs).call(&block)
  end

  private

  def info(msg)
    Rails.logger.info "[#{self.class.name}] #{msg}"
  end

  def error(msg)
    Rails.logger.error "[#{self.class.name}] #{msg}"
  end
end