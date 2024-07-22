# hello_world.rb
class HelloWorld
  def self.hello(name = nil)
    if name.nil?
      'Hello, World!'
    else
      "Hello, #{name}!"
    end
  end
end
