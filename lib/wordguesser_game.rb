class WordGuesserGame
  attr_accessor :word, :guesses, :wrong_guesses
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.
  
  # Get a word from remote "random word" service
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end
  def guess(letter)
    if letter.nil? || letter !~ /\A[a-zA-Z]\Z/i # match single letter,ignoring case
      raise ArgumentError
    end
    letter = letter[0].downcase
    if  @word.include?(letter) && !@guesses.include?(letter)
      @guesses += letter
    elsif !@word.include?(letter) && !@wrong_guesses.include?(letter)
      @wrong_guesses += letter
    else
      false
    end
  end

  def word_with_guesses
    @word.gsub(/./)  { |letter| @guesses.include?(letter) ? letter : '-' }
    display = ''
    @word.chars do |char|
      display += @guesses.include?(char) ? char : '-'
    end
    display
  end

  def check_win_or_lose
    return :play if @word.blank?

    if word_with_guesses == @word
      :win
    elsif @wrong_guesses.length > 6
      :lose
    else
      :play
    end
    return :win if word_with_guesses == @word
    return :lose if @wrong_guesses.length >= 6
    :play
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end
end