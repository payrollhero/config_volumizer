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
          ],
        },
        "nine" => [
          "one",
          "two",
          {
            "one" => 1,
            "two" => 2,
          }
        ],
      }
      expected_env_data = {
        "one" => "two",
        "three_four" => "five",
        "three_six_0" => "seven",
        "three_six_1" => "eight",
        "nine_0" => "one",
        "nine_1" => "two",
        "nine_2_one" => 1,
        "nine_2_two" => 2,
      }
      expected_mapping_data = {
        "one" => :value,
        "three" => {
          "four" => :value,
          "six" => [:value]
        },
        "nine" => [:varied],
      }
      result = described_class.generate(data)
      expect(result.env_hash).to eq(expected_env_data)
      expect(result.mapping_hash).to eq(expected_mapping_data)
    end
  end
end
