# frozen_string_literal: true

require_relative "../lib/calculator"
require 'stringio'

# Unit tests for Calculator model
# Because we start the program in the end of calculator file
# the test always asking for one input
RSpec.describe Calculator do
	describe '#valid_operand?' do
		it 'Checking if the operand is in the right format' do
			expect(Calculator.new.valid_operand?('5')).to eq(true)
			expect(Calculator.new.valid_operand?('-5')).to eq(true)
			expect(Calculator.new.valid_operand?('5.5')).to eq(false)
			expect(Calculator.new.valid_operand?('5&1/2')).to eq(true)
      expect(Calculator.new.valid_operand?('5 & 1/2')).to eq(false)
      expect(Calculator.new.valid_operand?('5&&1/2')).to eq(false)
      expect(Calculator.new.valid_operand?('-5&-1/2')).to eq(true)
      expect(Calculator.new.valid_operand?('5&1/2&5')).to eq(false)
      expect(Calculator.new.valid_operand?('5&1/2&1/2')).to eq(false)
      expect(Calculator.new.valid_operand?('3/4')).to eq(true)
		end
	end

  describe '#convert_to_f' do
		it 'Convert input string operand part to a float' do
			expect(Calculator.new.convert_to_f('5')).to eq(5.0)
			expect(Calculator.new.convert_to_f('-5')).to eq(-5.0)
			expect(Calculator.new.convert_to_f('5&1/2')).to eq(5.5)
      expect(Calculator.new.convert_to_f('-5&-1/2')).to eq(-5.5)
      expect(Calculator.new.convert_to_f('0&1/2')).to eq(0.5)
      expect(Calculator.new.convert_to_f('0&-1/2')).to eq(-0.5)
      expect(Calculator.new.convert_to_f('3/4')).to eq(0.75)
		end
	end

  describe '#calculate' do
    it 'Calculate equation' do
      expect(Calculator.new.calculate('+', [5, 5])).to eq(10)
      expect(Calculator.new.calculate('*', [0.5, 5])).to eq(2.5)
      expect(Calculator.new.calculate('/', [2.5, 5])).to eq(0.5)
    end
  end

  describe '#program' do
    it 'With good input format we got the right answer' do
      input = StringIO.new('1/2 * 3&3/4' + "\n")
      cal = Calculator.new(input: input)
      expect(cal.program).to eq(nil)
    end
    it 'With bad input format we got an error message' do
      input = StringIO.new('1/2*3&3/4' + "\n")
      cal = Calculator.new(input: input)
      expect(cal.program).to eq('Operator is missing or wrong format around it')
      input = StringIO.new('1//2 * 3&3/4' + "\n")
      cal = Calculator.new(input: input)
      expect(cal.program).to eq('First operand is in the wrong format')
      input = StringIO.new('1/2 * 3&&3/4' + "\n")
      cal = Calculator.new(input: input)
      expect(cal.program).to eq('Second operand is in the wrong format')
    end
    it "If the input is 'exit' we got a message" do
      input = StringIO.new('exit' + "\n")
      cal = Calculator.new(input: input)
      expect(cal.program).to eq('Exiting...')
    end
  end
end
