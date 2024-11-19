require 'open-uri'
require 'json'
# my actions controllers
class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def score
    @word = params[:word].upcase
    @grid = params[:letters].split("")
    @message = compute_score(@word, @grid)
  end

  private

  def compute_score(word, grid)
    if !in_grid?(word, grid)
      "Sorry, but #{word} can't be built out of #{grid.join(', ')}."
    elsif !valid_english_word?(word)
      "Sorry, but #{word} is not a valid English word."
    else
      "Congratulations! #{word} is a valid English word and matches the grid!"
    end
  end

  def in_grid?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def valid_english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
