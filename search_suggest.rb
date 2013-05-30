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
