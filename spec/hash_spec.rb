require_relative '../credit_card'
require 'minitest/autorun'

# Feel free to replace the contents of cards with data from your own yaml file
card_details = [
  { num: '4916603231464963',
    exp: 'Mar-30-2020',
    name: 'Soumya Ray',
    net: 'Visa' },
  { num: '6011580789725897',
    exp: 'Sep-30-2020',
    name: 'Nick Danks',
    net: 'Visa' },
  { num: '5423661657234057',
    exp: 'Feb-30-2020',
    name: 'Lee Chen',
    net: 'Mastercard' }
]

cards = card_details.map do |c|
  CreditCard.new(c[:num], c[:exp], c[:name], c[:net])
end

describe 'Test hashing requirements' do
  describe 'Test regular hashing' do
    describe 'Check hashes are consistently produced' do
      # TODO: Check that each card produces the same hash if hashed repeatedly
      it 'should produce the same hash if hashed repeatedly' do
        hashes = cards.map { |card| card.hash }
        hashes_repeat = cards.map { |card| card.hash }
        hashes.select { |hash| hash.nil? }.length.must_equal 0
        hashes.must_equal hashes_repeat
      end
    end

    describe 'Check for unique hashes' do
      # TODO: Check that each card produces a different hash than other cards
      it 'should produce different hashes between different cards' do
        hashes = cards.map { |card| card.hash }
        hashes.uniq.length.must_equal hashes.length
      end
    end
  end

  describe 'Test cryptographic hashing' do
    describe 'Check hashes are consistently produced' do
      # TODO: Check that each card produces the same hash if hashed repeatedly
      it 'should produce the same hash if hashed repeatedly' do
        hashes = cards.map { |card| card.hash_secure }
        hashes_repeat = cards.map { |card| card.hash_secure }
        hashes.select { |hash| hash.nil? }.length.must_equal 0
        hashes.must_equal hashes_repeat
      end
    end

    describe 'Check for unique hashes' do
      # TODO: Check that each card produces a different hash than other cards
      it 'should produce different hashes between different cards' do
        hashes = cards.map { |card| card.hash_secure }
        hashes.uniq.length.must_equal hashes.length
      end
    end

    describe 'Check regular hash not same as cryptographic hash' do
      # TODO: Check that each card's hash is different from its hash_secure
      it 'should produce different hashes using different hash methods' do
        hashes = cards.map { |card| card.hash }
        hashes_secure = cards.map { |card| card.hash_secure }
        hashes.length.times.with_index { |i| hashes[i].wont_equal hashes_secure[i] }
      end
    end
  end
end
