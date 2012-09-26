def input
  print "Gib ein Verb ein: "
  gets.strip.downcase
end

def analyze_input
  splitted_input = input.split
  @pr_stem = splitted_input[0]

  case
  when @pr_stem == "quit"
    return false
  when @pr_stem == "store"
    print "#{@store}\n\n"
    return true
  when @pr_stem == "save"
    save_to_store
    return true
  end

  @conj = splitted_input[1]
  @verb_stems = [@conj, @pr_stem]

  if splitted_input.length == 2 
    @verb_stems << @pr_stem + "v" << @pr_stem + "t" if @conj.match(/[14]/)
    @verb_stems << @pr_stem.chop + "u" << @pr_stem.chop + "it" if @conj.match("2")
  else 
    @verb_stems << splitted_input[2] << splitted_input[3]
  end 

  write_to_store
  print "#{@store[@pr_stem + @conj]}\n\n" 
  return true
end

def write_to_store
  @store[@pr_stem + @conj] = @verb_stems
end

def save_to_store
  require 'yaml'
  File.open("verbs_db.yaml", "a") { |file| file.puts(@store.to_yaml)}

  print "\t#{@store.length} verbs saved.\n\t#{@store.keys.join(", ")}\n\n"
  @store.clear
end

@store = {} 
while analyze_input
end

#print @store 
