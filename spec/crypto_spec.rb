# frozen_string_literal: true

require_relative '../credit_card'
require_relative '../substitution_cipher'
require_relative '../double_trans_cipher'
require_relative '../sk_cipher'
require 'minitest/autorun'

describe 'Test card info encryption' do
  before do
    @cc = CreditCard.new('4916603231464963', 'Mar-30-2020',
                         'Soumya Ray', 'Visa')
    @key = 3
  end

  # TODO: Add tests for double transposition and modern symmetric key ciphers
  #       Can you DRY out the tests using metaprogramming? (see lecture slide)
  ciphers = {
    "Caesar" => SubstitutionCipher::Caesar,
    "Permutation" => SubstitutionCipher::Permutation,
    "DoubleTransposition" => DoubleTranspositionCipher,
  }
  
  ciphers.keys.each { |name|
    cipher = ciphers[name]
      
    describe "Using #{name} cipher" do
      it 'should encrypt card information' do
        enc = cipher.encrypt(@cc.to_s, @key)
        enc.wont_equal @cc.to_s
        enc.wont_be_nil
      end
    
      it 'should decrypt text' do
        enc = cipher.encrypt(@cc.to_s, @key)
        dec = cipher.decrypt(enc, @key)
        dec.must_equal @cc.to_s
      end
    end
  }
  
  describe 'Using Modern Symmetric Cipher' do
    it 'should generate new Base64 keys' do
      key = ModernSymmetricCipher.generate_new_key
      key.wont_be_nil
    end

    it 'should generate different keys each time' do
      key1 = ModernSymmetricCipher.generate_new_key
      key2 = ModernSymmetricCipher.generate_new_key
      key1.wont_equal key2
    end
    
    it 'should encrypt card information' do
      key = ModernSymmetricCipher.generate_new_key
      enc = ModernSymmetricCipher.encrypt(@cc.to_s, key)
      enc.wont_be_nil
      enc.wont_equal @cc.to_s
    end
    
    it 'should decrypt encrypted card information' do
      key = ModernSymmetricCipher.generate_new_key
      enc = ModernSymmetricCipher.encrypt(@cc.to_s, key)
      dec = ModernSymmetricCipher.decrypt(enc, key)
      dec.must_equal @cc.to_s
    end
    
    it 'should encrypted the text using different nonces each time' do
      key  = ModernSymmetricCipher.generate_new_key
      enc1 = ModernSymmetricCipher.encrypt(@cc.to_s, key)
      enc2 = ModernSymmetricCipher.encrypt(@cc.to_s, key)
      enc1.wont_equal enc2
    end
    
    it 'should recover the same text from ciphertexts with different nonces' do
      key  = ModernSymmetricCipher.generate_new_key
      enc1 = ModernSymmetricCipher.encrypt(@cc.to_s, key)
      enc2 = ModernSymmetricCipher.encrypt(@cc.to_s, key)
      dec1 = ModernSymmetricCipher.decrypt(enc1, key)
      dec2 = ModernSymmetricCipher.decrypt(enc2, key)
      dec1.must_equal dec2
    end
  end
end
