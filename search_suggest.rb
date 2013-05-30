def main
  ARGV.each do |filename|
    FileParser.read_input(filename).each do |set|
      misspelled = set[0]
      suggestion1 = set[1]
      suggestion2 = set[2]
      puts SearchSuggester.best_suggestion misspelled, suggestion1, suggestion2
    end
  end
end

class FileParser
  def self.read_input(filename)
    result = []
    f = File.new(filename)
    misspelled = suggestion1 = suggestion2 = nil
    f.each_line do |line|
      next if f.lineno == 1 # skip (assume file is of correct format, so we don't bother counting
      case (f.lineno - 2) % 4
      when 0
        # skip
      when 1
        misspelled = line.strip
      when 2
        suggestion1 = line.strip
      when 3
        suggestion2 = line.strip
        result.push([misspelled, suggestion1, suggestion2])
      end
    end
    return result
  end
end

class SearchSuggester
  def initialize 
    @remembered = {}
  end

  def find_longest_common_substring s1, s2
    key = [s1,s2]
    if @remembered[key].nil?
      @remembered[key] = _find_longest_common_substring s1, s2
    end
    return @remembered[key]
  end

  def _find_longest_common_substring s1, s2
    return 0 if s1.length == 0 || s2.length == 0
    head1 = s1[0]
    head2 = s2[0]
    tail1 = s1[1..s1.length]
    tail2 = s2[1..s2.length]

    if head1 == head2
      return 1 + find_longest_common_substring(tail1, tail2)
    else
      return [find_longest_common_substring(s1, tail2),
              find_longest_common_substring(tail1, s2)].max
    end
  end

  def self.best_suggestion query, suggestion1, suggestion2
    suggester = SearchSuggester.new
    length1 = suggester.find_longest_common_substring query, suggestion1
    length2 = suggester.find_longest_common_substring query, suggestion2
    return suggestion1 if length1 > length2
    return suggestion2
  end
end

main
