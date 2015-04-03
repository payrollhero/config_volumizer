require 'spec_helper'

describe ConfigVolumizer do
  describe '.generate' do
    example do
      data = {
        "one" => "two",
        "three" => {
          "four" => "five",
          "six" => [
            "seven",
            "eight",
          ]
        }
      }
      expected_data = {
        "one" => "two",
        "three.four" => "five",
        "three.six[0]" => "seven",
        "three.six[1]" => "eight",
      }
      expect(described_class.generate(data)).to eq(expected_data)
    end
  end
end
