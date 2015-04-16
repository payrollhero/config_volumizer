require 'spec_helper'

describe ConfigVolumizer do
  describe '.parse' do
    let(:result) { described_class.parse(input, mapping) }

    describe "1 level hash" do
      let(:input) { { "ex" => "1a" } }
      let(:mapping) { { "ex" => :value }}
      let(:expected_result) { { 'ex' => '1a' } }

      example do
        expect(result).to eq(expected_result)
      end
    end

    describe "2 level hash" do
      let(:mapping) {
        {
          "ex1" => {
            "bar" => :value,
            "bar2" => :value,
          }
        }
      }
      let(:input) do
        {
          "ex1_bar" => "1a",
          "ex1_bar2" => "2a",
        }
      end
      let(:expected_result) do
        {
          'ex1' => {
            'bar' => '1a',
            'bar2' => '2a',
          },
        }
      end

      example do
        expect(result).to eq(expected_result)
      end
    end

    describe "3 level hash" do
      let(:mapping) do
        {
          "ex3" => {
            "one" => {
              "two" => :value,
              "three" => :value,
            },
            "two" => {
              "three" => :value,
            }
          }
        }
      end
      let(:input) do
        {
          "ex3_one_two" => "1a",
          "ex3_one_three" => "2a",
          "ex3_two_three" => "3a",
        }
      end
      let(:expected_result) do
        {
          'ex3' => {
            'one' => {
              'two' => '1a',
              'three' => '2a',
            },
            'two' => {
              'three' => '3a',
            },
          },
        }
      end

      example do
        expect(result).to eq(expected_result)
      end
    end

    describe "array of values in hash" do
      let(:mapping) do
        {
          "ex" => {
            "one" => [:value]
          }
        }
      end
      let(:input) do
        {
          "ex_one" => "1a,2a",
        }
      end
      let(:expected_result) do
        {
          'ex' => { 'one' => ['1a', '2a'] }
        }
      end

      example do
        expect(result).to eq(expected_result)
      end
    end

    describe "just array of values" do
      let(:mapping) do
        {
          "ex" => [:value],
        }
      end
      let(:input) do
        {
          "ex" => "1a,2a",
        }
      end
      let(:expected_result) do
        {
          'ex' => ['1a', '2a']
        }
      end

      example do
        expect(result).to eq(expected_result)
      end
    end

    describe "array of hashes" do
      let(:mapping) do
        {
          "ex" => [{
                     "foo" => :value,
                     "bar" => :value,
                   }],
        }
      end
      let(:input) do
        {
          "ex_0_foo" => "1a",
          "ex_0_bar" => "2a",
          "ex_1_foo" => "3a",
        }
      end
      let(:expected_result) do
        {
          'ex' => [
            { 'foo' => '1a', 'bar' => '2a' },
            { 'foo' => '3a' },
          ]
        }
      end

      example do
        expect(result).to eq(expected_result)
      end
    end

    describe "array of hash in hash" do
      let(:mapping) do
        {
          "ex2" => {
            "one" => [
              {
                "foo" => :value,
                "bar" => :value,
              }
            ]
          },
        }
      end
      let(:input) do
        {
          "ex2_one_0_foo" => "1a",
          "ex2_one_0_bar" => "2a",
          "ex2_one_1_foo" => "3a",
        }
      end
      let(:expected_result) do
        {
          'ex2' => {
            'one' => [
              {
                "foo" => '1a',
                "bar" => '2a',
              },
              {
                "foo" => '3a',
              }
            ],
          },
        }
      end

      example do
        expect(result).to eq(expected_result)
      end
    end

    describe "empty hash value" do
      let(:mapping) {
        {
          "ex" => {}
        }
      }
      let(:input) { { "ex" => "{}", } }
      let(:expected_result) { { 'ex' => {} } }

      example do
        expect(result).to eq(expected_result)
      end
    end

    describe "empty array value" do
      let(:mapping) {
        {
          "ex" => []
        }
      }
      let(:input) { { "ex" => "[]", } }
      let(:expected_result) { { 'ex' => [] } }

      example do
        expect(result).to eq(expected_result)
      end
    end

    describe "hash values" do
      context "at root" do
        let(:mapping) do
          {
            "ex" => :hash
          }
        end
        let(:input) do
          {
            'ex_one' => "1a",
            'ex_two' => "2a",
            'ex_three' => "3a",
          }
        end
        let(:expected_result) do
          {
            'ex' => {
              "one" => "1a",
              "two" => "2a",
              "three" => "3a",
            }
          }
        end

        example do
          expect(result).to eq(expected_result)
        end
      end

      context "in a hash" do
        let(:mapping) do
          {
            "ex" => {
              "ex2" => :hash
            }
          }
        end
        let(:input) do
          {
            'ex_ex2_one' => "1a",
            'ex_ex2_two' => "2a",
            'ex_ex2_three' => "3a",
          }
        end
        let(:expected_result) do
          {
            'ex' => {
              'ex2' => {
                "one" => "1a",
                "two" => "2a",
                "three" => "3a",
              }
            }
          }
        end

        example do
          expect(result).to eq(expected_result)
        end
      end

      context "in an array" do
        let(:mapping) do
          {
            "ex" => [:hash]
          }
        end
        let(:input) do
          {
            'ex_0_one' => "1a",
            'ex_0_two' => "2a",
            'ex_0_three' => "3a",
            'ex_1_two' => "4a",
          }
        end
        let(:expected_result) do
          {
            'ex' => [
              {
                "one" => "1a",
                "two" => "2a",
                "three" => "3a",
              },
              {
                "two" => "4a",
              }
            ]
          }
        end

        example do
          expect(result).to eq(expected_result)
        end
      end
    end

  end
end
