require 'spec_helper'

describe ConfigVolumizer do
  let(:key) { 'ex' }
  let(:result) { described_class.parse(input, key) }

  describe "1 level hash" do
    let(:input) { { "ex" => "1a" } }
    let(:expected_result) { { 'ex' => '1a' } }

    example do
      expect(result).to eq(expected_result)
    end
  end

  describe "2 level hash" do
    let(:key) { 'ex1' }
    let(:input) do
      {
        "ex1.bar" => "1a",
        "ex1.bar2" => "2a",
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
    let(:key) { 'ex3' }
    let(:input) do
      {
        "ex3.one.two" => "1a",
        "ex3.one.three" => "2a",
        "ex3.two.three" => "3a",
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
    let(:input) do
      {
        "ex.one[0]" => "1a",
        "ex.one[1]" => "2a",
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
    let(:input) do
      {
        "ex[0]" => "1a",
        "ex[1]" => "2a",
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
    let(:input) do
      {
        "ex[0].foo" => "1a",
        "ex[0].bar" => "2a",
        "ex[1].foo" => "3a",
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
    let(:key) { 'ex2' }
    let(:input) do
      {
        "ex2.one[0].foo" => "1a",
        "ex2.one[0].bar" => "2a",
        "ex2.one[1].foo" => "3a",
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
    let(:input) { { "ex" => "{}", } }
    let(:expected_result) { { 'ex' => {} } }

    example do
      expect(result).to eq(expected_result)
    end
  end

  describe "empty array value" do
    let(:input) { { "ex" => "[]", } }
    let(:expected_result) { { 'ex' => [] } }

    example do
      expect(result).to eq(expected_result)
    end
  end

  describe "2d arrays" do
    let(:input) do
      {
        "ex[0][0]" => "1a",
        "ex[0][1]" => "2a",
        "ex[1][0]" => "3a",
        "ex[1][1]" => "4a",
      }
    end
    let(:expected_result) do
      {
        'ex' => [
          ['1a', '2a'],
          ['3a', '4a']
        ]
      }
    end

    example do
      expect(result).to eq(expected_result)
    end
  end

  describe "3d arrays" do
    let(:input) do
      {
        'ex[0][0][1]' => "1a",
        'ex[0][1][0]' => "2a",
        'ex[1][0][1]' => "3a",
        'ex[1][1][0]' => "4a",
      }
    end
    let(:expected_result) do
      {
        'ex' => [
          [
            [nil, '1a'],
            ['2a'],
          ],
          [
            [nil, '3a'],
            ['4a'],
          ]
        ]
      }
    end

    example do
      expect(result).to eq(expected_result)
    end
  end

end
