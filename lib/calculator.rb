# frozen_string_literal: true

# calculator program
class Calculator
  def initialize(input: $stdin)
    @input = input
    @message
  end

  def start
    while @input != 'exit'
      @message = ''
      program
      puts @message
    end
  end

  def program
    puts "Asking for calculations (write 'exit' to exit):"
    raw = @input.gets.strip.gsub(/\s+/, ' ').downcase
    # It's a workaround so we can easily tests with different inputs
    if raw == 'exit'
      @input = 'exit'
      return @message = 'Exiting...'
    end

    parts = raw.split(' ')
    # Check if there is a [+ - * /] surrounded by whitespace.
    unless parts.length == 3 && %w[+ - * /].include?(parts[1])
      return @message = 'Operator is missing or wrong format around it'
    end
    @message = 'First operand is in the wrong format' unless valid_operand?(parts[0])
    @message = 'Second operand is in the wrong format' unless valid_operand?(parts[2])
    return @message if @message != ''

    operator = parts[1]
    operands = []
    operands << convert_to_f(parts[0])
    operands << convert_to_f(parts[2])
    if operands.last == 0
      @message = 'Whoaa, you almost destroyed the galaxy with that division by 0'
    end
    return @message if @message != ''

    float = calculate(operator, operands)
    return @message if @message != ''

    @message = convert_to_s(float)
  end

  # Checking if the operand is in the right format ex: 2&3/4
  def valid_operand?(string)
    # Sadly I had to add two seperate regex because I'm not that good with it yet :(
    return true if !!(string =~ /^-?\d+\/\d+$/)
    return !!(string =~ /^-?\d+(\&-?\d+\/\d+)?$/)
  end

  def convert_to_f(raw_num)
    parts = raw_num.split(/&|\//)
    # If the number is a whole number we don't need to convert
    return parts[0].to_f if parts.length == 1

    whole = raw_num.include?('&') ? parts[0].to_i : 0
    numerator = parts[-2].to_f
    denominator = parts[-1].to_f
    if denominator == 0
      return @message = 'Whoaa, you almost destroyed the galaxy with that division by 0'
    end

    return whole + (numerator / denominator)
  end

  def convert_to_s(float)
    # If the answer is a whole number we don't need to convert
    return float.to_i.to_s if float == float.to_i

    whole = float.to_i
    fractional = float - whole

    # To get the greatest common divisor we need integer
    numerator = (fractional * 1000000).round
    denominator = 1000000

    gcd = numerator.gcd(denominator)
    numerator /= gcd
    denominator /= gcd

    return "#{whole}&#{numerator}/#{denominator}"
  end

  def calculate(operator, operands)
    case operator
    when '+'
      operands[0] + operands[1]
    when '-'
      operands[0] - operands[1]
    when '*'
      operands[0] * operands[1]
    when '/'
      operands[0] / operands[1]
    else
      @message = 'Not recognize the operator'
    end
  end
end

Calculator.new.program
