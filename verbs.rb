=begin
latin_verbs: analyse latin verbforms
building construction (ut homo linguam latinam discens faciat//as a latin learning "human being" should do)
1) input
2) define stem (pres or perf by reducing by ending and some other vowels if necessary)
   a) verb = stem + something + ending
      first goal: find matching ending (key: very good regexp), though watch out for same letters (tis, ris, s) => backward loop? amatis, itas, seris, sereris (special! more r-stems?), mittis
      stat: for loop
   b) second: ending should be removed from input, so that stem+something remains
        problem: that "something" may not be easy to be defined:              
          Present with vowels                                                 am|o; mone|o; audi|o; audi|u|nt; leg|o; leg|i|s; fac|i|o
          -ba- (Imperfect)                                                    lauda|ba|t; mone|ba|t; leg|e|ba|t; audi|e|ba|t; cap|i|e|ba|t
          -b/[eiu]/- (A,E; Future; first pers sg-o is removed by 2a-second,)  ambula|bi|mus; mone|bi|tis
          == /b[aui]|b(?=o)/ regexp for both above
          
          -/[ae]/- (3.; Future)                                               leg|a|m; mitt|e|s
          -/i[ae]/- (I,5. Future)                                             audi|a|m; audi|e|s; cap|i|e|nt
        
          -e- (A; Konj.pres)                                                  laud|e|m where's the a?
          -a- (2-5. Konj.pres)                                                mone|a|m; leg|a|m; leg|a|t; audi|a|m; cap|i|a|m
            == /[ae]/ => regexp for (3.; Future, Konj.pres)
            == (?<=[^r])[ae]\b
       
          -/re/- (Konj.imperf.)                                               lauda|re|t; mone|re|t; leg|e|re|t; audi|re|t; cap|e|re|t
            == /re|ere/  
         
          -isse- (Konj.Plu)
          
          -era- (Pluperf)                                                  all from perf stem
          -eri- (Konj.Perf)
          -er- (Fut.ex 1.st)
          -eri- (Fut.ex.rest)
              -/er[ai]/- and -er- == /er[ai]|er(?=o)/ => regexp for (pluperf, konj.perf, fut ex)
           
          monster regexp for all these:
          b[aui]\b|b\b|(?<=[^r])[ae]\b|re\b|ere\b|isse\b|er[ai]\b|er\b === simplier?
          == (b[aui]|b|(?<=[^r])[ae]|re|ere|isse|er[ai]|er)\b === simplier?
          == (b[aui]|b|(?<=[^r])[ae]|(r|er|iss)e|er[ai]|er)\b === simplier?
              
       stat: chop! a lot   
   c) possible solution: after removing ending; search db (i.c.o. audi|o: will find audi = ok;), then check tense und conj marker and remove them,
          search db (i.c.o mone|ba|t, remove t, remove ba, search mone = ok!), if nothing is found, repeat (i.c.o. audi|e|ba|t, after removing ba audie
          won't be found, so then remove a letter once more, find audi = ok, i.c.o. capiebant one more repeat is necessary, run max. twice?!!) recursive loop?
            Problem: dicat => could be from dicare or dicere, will find dica at first, though, dicat is more frequent; create exception?
             possible solution: chop dica once more and search, will find dic => create double output; i.c.o. lauda, will find lauda, but not laud!
             appello 1./3.; appareo 2./apparo 1.
          simple letters can be chopped, multiple letters could be removed by partition: Caution: Don't change input variable, so use .clone!
           problem laudem: having removed ending and suffix, laud should be found in db! possible, if entry is lauda? concerns all a-stems!!!
           same with laudo; problem dic|o; dic and dica stem exist, should find both!
   d) database: is needed! will contain arrays holding stem info, present and perfect stem and PPP e.g. ary = {a, ambula, ambulav, ambulat}; Deponentia???
        Incohativa? ardeo 2./ardesco 3. both in perf arsi; double output!
        search command in regex?: at the beginning of the word #{created_stem} plus only one char? am? should find ama;
        must find perf stem as well! complete array must be the output of search operation (i.c.o. ambulavit; remove ending it, ambulav should be found)
         Problem(?): leg is present and perf stem, so legit should produce a double output; solution: every stem must be compared to its perf stem, if true => double output
       stat: txt file
         would be nice: composita are found by its simplex (e.g. conficio, efficio etc -ficio), so create a compositum function (a,ab,e,ex,ef,de,con,prae,ad,af,ap,am...)
          but watch for similar sounding verbs: educo 1./e-duco 3. this could be managed by database input...
3) match form (stem+some syl+ending)
   if stem is found tense and modus marker should be analysed (getting infos from 2b?);
   input = dicaret (<= dico1.)
   input =~ stem+re+ending
   can only derive from dico 1., because dico 3. would delive dicret => does not exist!
   if dico 3. delivers nil, whole procedure must be repeatet with dica; database might put out 2 stems; both must be testet.
   check?
4) output
   create output
=end
class Verbs #class name upper case!!
end
@endings = [
             [ /[om]$/,              #act endings[0] $ = \b
               /(?<=[aei])s$/, # does not match mittis! r-stems= sero needs exception?
               /(?<=[aei])t$/,    #alles außer n davor?
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
               "#{/(?<=[a-mo-z])/}i#{/\b/}"                #alles außer n-vor i. gibt es einen n-stamm?
              ]
            ]  
            
def input
  print "Gib ein verb ein:"
  @input = gets.downcase.strip
  create_stem
  print @stem
  return true 
end


def create_stem
  @ending = find_ending
  @stem = @input.clone
  @stem.slice!(@ending)
end

def find_ending
  personal_ending = @endings[0]
  ending = personal_ending.select { |x| @input.match(x) }
  ending[0]
end


if __FILE__ == $PROGRAM_NAME
  while input
  end
end
