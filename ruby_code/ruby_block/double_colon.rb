class DoubleColon
  Bar = "hello"
  bar = "hello"

  # DoubleColon.Bar      #Exception:undefined method `Bar'
  # DoubleColon.bar      #Excpetion:undefined method `bar'
  puts DoubleColon::Bar  # hello
  # DoubleColon::bar     #Excpetion:undefined method `bar'
end