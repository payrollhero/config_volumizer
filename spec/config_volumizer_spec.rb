require 'spec_helper'

describe ConfigVolumizer do
  describe '.parse' do
    let(:result) { described_class.parse(input, mapping) }

    describe "1 level hash" do
      let(:input) { { "ex" => "1a" } }
      let(:mapping) { { "ex" => :value } }
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

  describe "fetch" do
    let(:key_name) { "some_gem_settings" }
    let(:result) { ConfigVolumizer.fetch(env, key_name, mapping) }

    context "basic example" do
      let(:env) do
        {
          "some_gem_settings_one" => "hello",
          "some_gem_settings_two" => "world",
          "some_gem_settings_three" => "yay",
        }
      end
      let(:mapping) { :hash }
      let(:expected) do
        {
          "one" => "hello",
          "two" => "world",
          "three" => "yay",
        }
      end

      example { expect(result).to eq(expected) }
    end

    context "complex example" do
      let(:env) do
        {
          "some_gem_settings_key1_one" => "hello1",
          "some_gem_settings_key1_two" => "hello2",
          "some_gem_settings_key2" => "hello,world",
          "some_gem_settings_key3_0_foo_one" => "1",
          "some_gem_settings_key3_0_foo_two" => "2",
          "some_gem_settings_key3_1_foo_one" => "3",
          "some_gem_settings_key3_1_foo_two" => "4",
          "some_gem_settings_key3_2_foo_one" => "5",
          "some_gem_settings_key3_2_foo_two" => "6",
        }
      end
      let(:mapping) do
        {
          "key1" => :hash,
          "key2" => [:value],
          "key3" => [
            {
              "foo" => :hash,
            }
          ],
        }
      end
      let(:expected) do
        {
          "key1" => { "one" => "hello1", "two" => "hello2" },
          "key2" => ["hello", "world"],
          "key3" => [{ "foo" => { "one" => 1, "two" => 2 } },
                     { "foo" => { "one" => 3, "two" => 4 } },
                     { "foo" => { "one" => 5, "two" => 6 } }]
        }
      end

      example { expect(result).to eq(expected) }
    end

    context "key not found" do
      let(:key_name) { "not_found" }
      let(:env) do
        {
          "some_gem_settings_one" => "hello",
          "some_gem_settings_two" => "world",
          "some_gem_settings_three" => "yay",
        }
      end
      let(:mapping) { :hash }

      context "not specifying a default" do
        let(:result) { ConfigVolumizer.fetch(env, key_name, mapping) }

        example do
          expect { result }.to raise_exception(KeyError)
        end
      end

      context "specifying a default value" do
        let(:result) { ConfigVolumizer.fetch(env, key_name, mapping, "default_value") }
        let(:expected) { "default_value" }

        example { expect(result).to eq(expected) }
      end

      context "specifying a default block" do
        let(:result) { ConfigVolumizer.fetch(env, key_name, mapping) { |key| "default_#{key}" } }
        let(:expected) { "default_not_found" }

        example { expect(result).to eq(expected) }
      end

    end
  end

end
