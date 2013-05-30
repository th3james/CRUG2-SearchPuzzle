require "minitest/autorun"
require "./search_suggest.rb"

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

main
