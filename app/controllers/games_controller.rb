require 'net/http'

CORRECT = 'The word is valid according to the grid and is an English word'
NOT_ENGLISH = 'The word is valid according to the grid,
              but is not a valid English word'
NOT_CORRECT = "The word can't be built out of the original grid"
URL = "https://wagon-dictionary.herokuapp.com/"

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    letters = params[:letters].split(//)
    @word = params[:word]
    @response = verify_word(letters, @word.split(//))
  end

  def verify_word(letters, word)
    letters_hash = Hash.new(0)
    word_hash = Hash.new(0)

    letters.each { |letter| letters_hash[letter] += 1 }
    word.each { |letter| word_hash[letter] += 1 }

    compare_hashes(letters_hash, word_hash, word)
  end

  def compare_hashes(letters_hash, word_hash, word)
    valid = true
    word_hash.each { |k, v| valid = false unless v <= letters_hash[k] }
    valid ? english_word?(word) : NOT_CORRECT
  end

  def english_word?(word)
    response = JSON.parse(Net::HTTP.get(URI("#{URL}#{word.join.downcase}")))
    response['found'] ? CORRECT : NOT_ENGLISH
  end
end
