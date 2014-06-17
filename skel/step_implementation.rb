
step 'Say <greeting> to <name>' do |x, y|
  puts "#{x} #{y}"
end

step 'Step that takes a table <table>' do |x|
end

step 'A context step which gets executed before every scenario' do
end
