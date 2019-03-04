#include "number.hpp"
#include <random>
#include <chrono>
#include <string>
#include <algorithm>

namespace  {

unsigned getSeed() {
    return static_cast<unsigned>( std::chrono::system_clock::now().time_since_epoch().count() );
}

static std::minstd_rand rand_generator( getSeed() );

}

std::vector<char> getDigits(const uint8_t &number_of_digits) {

    std::string symbols = "0123456789";

    std::shuffle(symbols.begin(), symbols.end(), rand_generator);

    return std::vector<char> (symbols.begin(), symbols.begin() + number_of_digits);
}

SecretNumber::SecretNumber(const uint8_t &number_of_digits) {

    if (number_of_digits > 10)
        throw std::logic_error("Secret Number can't hold more than 10 digits");

    digits = getDigits(number_of_digits);
}

size_t SecretNumber::size() const noexcept { return digits.size(); }

char& SecretNumber::operator [](const unsigned& index) {

    if ( index >= digits.size() ) throw std::out_of_range("invalid index");

    return digits[index];
}

void SecretNumber::reset() {

    digits = getDigits( static_cast<uint8_t> (digits.size()) );
}

auto SecretNumber::begin()       noexcept { return digits.begin(); }
auto SecretNumber::end()         noexcept { return digits.end(); }
auto SecretNumber::begin() const noexcept { return digits.begin(); }
auto SecretNumber::end()   const noexcept { return digits.end(); }
