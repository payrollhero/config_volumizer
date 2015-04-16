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
      expected_env_data = {
        "one" => "two",
        "three_four" => "five",
        "three_six_0" => "seven",
        "three_six_1" => "eight",
      }
      expected_mapping_data = {
        "one" => :value,
        "three" => {
          "four" => :value,
          "six" => [:value]
        }
      }
      result = described_class.generate(data)
      expect(result.env_hash).to eq(expected_env_data)
      expect(result.mapping_hash).to eq(expected_mapping_data)
    end
  end
end
