require "minitest/autorun"

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

describe SearchSuggester do
  describe '#find_longest_common_substring' do
    before do
      @suggester = SearchSuggester.new
    end
    it 'gets right answer for trivial example' do
      assert_equal 0, @suggester.find_longest_common_substring('', '')
    end
    it 'gets the right answer for a more interesting example' do
      assert_equal 2, @suggester.find_longest_common_substring('nomm', 'num')
    end
    it 'gets 8 given remimance, remembrance' do
      assert_equal 8, @suggester.find_longest_common_substring('remimance', 'remembrance')
    end
    it 'gets 5 given imance, embrance' do
      assert_equal 5, @suggester.find_longest_common_substring('imance', 'embrance')
    end
  end

  describe '#best_suggestion' do
    describe 'given remimance with suggestions remembrance and reminiscence' do
      before do
        @result = SearchSuggester.best_suggestion 'remimance', 'remembrance', 'reminiscence'
      end
      it 'returns remembrance' do
        assert_equal 'remembrance', @result
      end
    end
  end
end

describe FileParser do
  describe '#read_input' do
    describe 'given a SAMPLE input file' do
      before do
        @result = FileParser.read_input('SAMPLE_INPUT.txt') 
      end

      it 'returns an array' do
        assert @result.class == Array
      end
      it 'returns an array with two elements' do
        assert @result.length == 2
      end

      it 'returns returns the correct first search term' do
        assert_equal 'remimance', @result.first[0] 
      end
      it 'returns returns the correct first suggestion1' do
        assert_equal 'remembrance', @result.first[1] 
      end
      it 'returns returns the correct first suggestion 2' do
        assert_equal 'reminiscence', @result.first[2] 
      end
    end
  end
end
