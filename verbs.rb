class Verbs #class name upper case!!
end

def input
  print "Gib ein verb ein:"
  @input = gets.downcase.strip
  run_it
  
  require 'benchmark'
  puts "Benchmark: #{Benchmark.realtime { "a"*1_000_000 }} sec"
  return true 
end

def run_it
  @input_wo_ending = create_stem
  found_verbs = iterate_db_search
  check_form(found_verbs)
  print_analyzed_input
end

def create_stem
  @ending = find_ending
  stem = @input.clone
  stem.slice!(@ending)
  stem
end

def find_ending # endings sollten vielleicht sogar in einer priorit�tenreihenfolge angeordnet sein. also t und nt zuerst...
  @endings = [
             [ /[om]$/,              #act endings[0] $ = \b
               /(?<=[aei])s$/, # does not match mittis! r-stems= sero needs exception?
               /(?<=[aei])t$/,    #alles au�er n davor?
               /mus$/,
               /(?<=[aei])tis$/, #s-problem!!!!
               /(?<=[^(er)][aeiu])nt$/, #dont match perf3rdpl
               /re$/
            ],
             
             [ "#{/(?<=[^t])/}i#{/\b/}",             #perf. act. perf-stem end on t?
               "isti#{/\b/}",                         #endings[2]
               "it#{/\b/}",
               "imus#{/\b/}",
               "istis#{/\b/}",
               "erunt#{/\b/}",
               "isse#{/\b/}"
              ],
             
             [ "#{/(?<=[aeo])/}r#{/\b/}",             #passiv endings[3]
               "#{/(?<=[aei])/}ris#{/\b/}",
               "#{/(?<=[aei])/}tur#{/\b/}",
               "mur#{/\b/}",
               "mini#{/\b/}",
               "ntur#{/\b/}",
               "ri#{/\b/}",
               "#{/(?<=[a-mo-z])/}i#{/\b/}"                #alles au�er n-vor i. gibt es einen n-stamm?
              ]
            ]  
            
  personal_ending = @endings[0].reverse
  ending = personal_ending.select { |x| @input.match(x) }
  ending[0]
end

def iterate_db_search
  found_verbs = {}
  stem = @input_wo_ending.clone
  
  case
  when @input_wo_ending.match(/e$/)
    found_verbs[stem] = look_up_stem(stem)
    stem.chop! << "a"
  when @input_wo_ending.match(/[^aeiou]$/)
    stem << "a"
  end

  until stem == ""
    found_verbs[stem] = look_up_stem(stem) #interessantes zum clone verhalten hier.
    stem.chop! 
  end
  found_verbs.delete_if {|key, val| val == {} }
end

def look_up_stem(stem)
  require 'yaml'
  db = File.open("verbs_db.yaml", "r") do |file|
    YAML.load(file)
  end

  db.select { |key, val| val.include? (stem) }
end

def check_form(found_verbs) # hier erst tempuszeichen checken?
  @found_stem = found_verbs.keys[0]
  signs = @input_wo_ending[@found_stem.length..-1]
  conj = found_verbs[@found_stem].values[0][0]   # almost a hack! check doc why 
  check_for_signs(signs, conj)
end

def check_for_signs(signs, conj)
  case 
  when conj.match(/[35]$/) && signs.match(/^i/)
    @binding_voc = "i" 
  end
end

def print_analyzed_input
  analyzed_input = [@found_stem, @binding_voc, @tempus_sign, @ending]
  analyzed_input.reject {|x| x == nil}.join(" - ")
end

if __FILE__ == $PROGRAM_NAME
  while input
  end
end
